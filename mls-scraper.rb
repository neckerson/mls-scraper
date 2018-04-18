require "rubygems"
require "mechanize"
require "yaml"
require "csv"


# Store passwords, etc outside of the script file! Create a config.yml file
# like so...
#
# :mls
#   username: "something"
#   password: "abcd1234"
#   url: "id"

config = YAML.load_file("config.yml")
password = config["mls"]["password"]
username = config["mls"]["username"]
url = config["mls"]["url"]

links_table_xpath = "//tr[4]/td[5]/table[3]/tr[*]/td[10]/a"
street_xpath = "//table[1]/tr/td[3]/table[2]/tr[1]/td[1]/b"
city_zip_xpath = "//table[1]/tr/td[3]/table[2]/tr[2]/td[1]/b"
price_xpath = "//tr[4]/td[5]/table[3]/tr/td/table[1]/tr/td[3]/table[2]/tr[1]/td[2]/b"
units_xpath = "//tr[4]/td[5]/table[3]/tr/td/table[1]/tr/td[3]/table[2]/tr[5]/td[1]/b"

def mr_selector (tr)
  mr_selector_1 = "//tr[4]/td[5]/table[3]/tr/td/table[9]/tr["
  mr_selector_2 = "]/td[7]/b"
  mr_selector_1 + tr + mr_selector_2
end

headers = [
  "Location",
  "Price",
  "# of Units",
  "Unit 1 Rent",
  "Unit 2 Rent",
  "Unit 4 Rent",
  "Unit 5 Rent",
  "Unit 5 Rent",
  "Monthly Rent"
]

# Create the csv file and write some header rows

CSV.open("output.csv", "w") do |csv|
  csv << headers
end

# Create our Mechanize object

a = Mechanize.new
a.follow_meta_refresh = true

# Get the page using Mechanize

login_page = a.get("http://vow.mlspin.com/?id=#{url}")

# Log into MLS

list_page = login_page.form_with(:name => "signinform") do |form|
  form.user = username
  form.pass = password
end.submit

links_table = list_page.parser.xpath(links_table_xpath)

links_table.each do |link|

  csv_row = []
  rent_arr = []

  listing_page = a.click(link)

  street = listing_page.parser.xpath(street_xpath).text.strip
  city_zip = listing_page.parser.xpath(city_zip_xpath).text.strip
  address = "#{street} #{city_zip}"
  price = listing_page.parser.xpath(price_xpath).text.strip
  units = listing_page.parser.xpath(units_xpath).text.strip

  csv_row.push(address)
  csv_row.push(price)
  csv_row.push(units)

  # scrape the rent. The loop below iterates over the HTML, generating 5 xpath
  # selectors (currently, the MLS pages display 5 units, max)

  2.step(14, 3) do |i|

    monthly_rent = listing_page.parser.xpath(mr_selector(i.to_s)).text.to_i
    rent_arr.push(monthly_rent)
    csv_row.push(monthly_rent)
  end

  # Calculate total monthly rent by adding all rents together. Note that this
  # value may be lower than actual rent, if property has 6+ units.

  csv_row.push(rent_arr.inject(0, :+))

 # writing to a file
  CSV.open("output.csv", "a") do |csv|
    csv << csv_row
  end

  puts "...scraping page #{address.strip}"
end



