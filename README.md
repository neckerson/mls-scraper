# mls-scraper
A ruby script for scraping addresses, home prices, and monthly rents from mlspin.com pages into a spreadsheet for displaying in Google Maps.

# Installation
Requires the Mechanize and YAML gems. Run the following commands before using the script.

```
$ gem install mechanize
```
```
$ gem install yaml
```

The script stores your realtor's unique username, password and login URL in
config.yml. All three can be found in the weekly/daily MLS Listings Update
email. Add them to config.yml like so:

```
:mls
  username: "something"
  password: "abcd1234"
  url: "id"
```
The URL "id" is the id parameter below:

```
http://vow.mlspin.com/?id=33333
```
# Notes
This script was created to provide a simple way to plot available properties on
a map. Currently the MLS site does not provide this functionality.

After the script runs, output.csv can be imported into
https://fusiontables.google.com and the type of column one can be converted to
"location". When a map view is generated, Google will geocode the addresses and
plot them on a map.

This script is most useful in a very specific context, however it could be
modified for other purposes as needed.

XPaths used to capture elements on the page were generated using Chrome dev
tools (inspect element, right-click and Copy XPath). All tbody elements must be
removed from the result for this to work properly.

i.e. this...
```
/html/body/center[1]/table/tbody/tr[4]/td[5]/table[3]/tbody/tr/td/table[1]/tbody/tr/td[3]/table[2]/tbody/tr[1]/td[1]/b
```

becomes this...
```
tr[4]/td[5]/table[3]/tr/td/table[1]/tr/td[3]/table[2]/tr[1]/td[1]/b
```

