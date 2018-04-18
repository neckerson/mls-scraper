# mls-scraper
Scrape addresses, home prices, and monthly rents from mlspin.com pages into a spreadsheet for displaying in Google Maps.

# Installation
Requires the Mechanize and YAML gems. Enter the following commands before running the script.

```$ gem install mechanize```
```$ gem install yaml```

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


