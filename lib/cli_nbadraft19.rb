require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative "../lib/scraper.rb"
require_relative "../lib/player.rb"

# Make URL a class constant
URL = "https://www.si.com/nba/2019/nba-draft-big-board-top-100-player-rankings"

# class for CLI for NBA Draft 19 application
class CLI_NBADraft19
    # run method to first scrape, then put the results into a Player object
    def run
      playarray=Scraper.scrape_player(URL)
      #binding.pry

      # add players to Player class from playarray  (player array)
      Player.add_players(playarray)

      # use the player_menu to give user a CLI
      player_menu
    end

    #  Player menu -- displays a basic menu and asks for a user choice
    def player_menu
        #call menu_marquee
        menu_marquee
        choice = 0

        # keep asking for input until an X or x is received (for Exit)
        until (choice == "X" || choice == 'x') do
          puts "\nEnter choice>"
          choice=gets.chomp

          # case statement highlighting different choices for the menu
          case choice

          when "1"  # choice 1:  lists all players (not paginated)
            Player.all.each_with_index {|player,i| puts "#{i+1} #{player.name}"}
          when "2" # choice 2:  ask for a player name and display more info for that player
            # calls method for player display
            player_submenu
          when "3" # choice 3 calls method for submenu for searching on a player's name and display more info
            # for that player
            player_name_submenu
          when "4"
            # Choice 4 asks for player position to search on and lists all players that play a given position
            puts "Enter player position"
            posn_choice=gets.chomp
            puts "\nThese are all players that play #{posn_choice}"
            (Player.find_by_posn (posn_choice)).each {|player| puts "#{player.name}"}
          when "5"
            # Choice 5 Enter the school or club name
            puts "Enter the school/club name"
            sclub_choice = gets.chomp
            puts "\nThese are the players from school or club: #{sclub_choice} :"
            # calls class method for finding by school or club (sclub)
            (Player.find_by_sclub (sclub_choice)).each {|player| puts "#{player.name}"}
          when "X","x"
            puts "\nExiting the CLI Program"
          else
            # calls method for displaying the menu again...displaying the choices for
            menu_marquee
          end
      end

    end

    # method for executing code that asks for a player number
    def player_submenu
        # Asks for the player number in the Top 100 list
        puts "Enter the number (e.g. 1, 2,...100) of the player>"
        # uses get.chomp to get the player number, convert to integer
        choice=gets.chomp.to_i
        # finds the player
        player=Player.all[choice-1]
        # displays player_info (2 steps for easier debugging)
        player.display_info
    end

    # method for executing code that asks for a player name and returns more detailed info on
    # that player
    def player_name_submenu
        puts "Enter player name (can be only first or last name)>"
        # get user input for name
        name_choice = gets.chomp
        # searches for first occurrence of name, displays player info
        (Player.find_by_name (name_choice)).display_info
    end

    private  #make menu_marquee so that it can't be called by other methods
    # clears the screen and displays the user choices
    def menu_marquee
      system ("clear")
      puts"---------------------------------------------------"
      puts "Welcome to the 2019 NBA Draft Top 100 Prospect List"
      puts "\tData (c) 2019 Sports Illustrated"
      puts "(1) List Top 100 by name"
      puts "(2) Get in-depth info about player by number on list"
      puts "(3) Get in-depth info about player by name"
      puts "(4) Search for All Players by Position"
      puts "(5) Search for All Players by School/Club"
      puts "X to Exit"
    end

end
