# cli-nbadraft2019
CLI for reading NBA Draft Prospects

Description:

This CLI app/gem allows the user to access information from Sports Illustrated's
Top 100 prospect list for the 2019 NBA Draft (https://www.si.com/nba/2019/nba-draft-big-board-top-100-player-rankings").  

The user is given the option to (1) List the Top 100 players; (2) Get more in-depth information
about a player by number on the list; (3) Get more in-depth information about a player
by name; (4)  Find all players by position; (5) Find all players by school/Club.  The app
does scrape other data (e.g. class year) and stores them in the appropriate classes.

Installation Instructions:

To install this app, make sure the three .rb files are in ./lib:  cli_nbadraft19, player.rb
scraper.rb.  Nokogiri and open-uri need to be installed as gems.

The files should be available for download at https://github.com/kane7890/cli-nbadraft2019

Contributors Guide
  Based on nokogiri and open-uri

License:
  https://opensource.org/licenses/MIT
