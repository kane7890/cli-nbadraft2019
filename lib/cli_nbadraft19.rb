require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative "../lib/scraper.rb"
require_relative "../lib/player.rb"

URL = "https://www.si.com/nba/2019/nba-draft-big-board-top-100-player-rankings"

class CLI_NBADraft19
    def run
      playarray=Scraper.scrape_player(URL)
      # binding.pry
      # add players to Player class from playarray  (player array)
      Player.add_players(playarray)

    #  Player.all.each_with_index {|player, i| puts "#{i+1}. #{player.name}"}
      player_menu
    end

    #
    def player_menu
        menu_marquee
      choice = 0

      until (choice == "X" || choice == 'x') do
        puts "Enter choice>"
        choice=gets.chomp

        # case statement highlighting different choices for the menu
        case choice
        when "1"
          Player.all.each_with_index {|player,i| puts "#{i+1} #{player.name}"}
        when "2"
          player_submenu
        when "3"
          player_name_submenu
        when "4"
          puts "Enter player position"
          posn_choice=gets.chomp
          puts "These are the players that play #{posn_choice}"
          (Player.find_by_posn (posn_choice)).each {|player| puts "#{player.name}"}
        when "5"
          puts "Enter the school/club"
          sclub_choice = gets.chomp
          puts "These are the players from school or club: #{sclub_choice}"

          (Player.find_by_sclub (sclub_choice)).each {|player| puts "#{player.name}"}
        when "X","x"
          puts "End"
        else
          menu_marquee
        end
      end

    end

    # method for executing code that asks for a player number
    def player_submenu
        puts "Enter player number >"
        choice=gets.chomp.to_i
        player=Player.all[choice-1]
        player.display_info
    end

    # method for executing code that asks for a player name and returns more detailed info on
    # that player
    def player_name_submenu
        puts "Enter player name >"
        name_choice = gets.chomp
        (Player.find_by_name (name_choice)).display_info
    end

    private
    # clears the screen and displays marquee
    def menu_marquee
      system ("clear")
      puts"---------------------------------------------------"
      puts "Welcome to the 2019 NBA Draft Top 100 Prospect List"
      puts "\t(c) 2019 Sports Illustrated"
      puts "(1) List Top 100 by name"
      puts "(2) Get in-depth data about player by number"
      puts "(3) Search for Name"
      puts "(4) Search for All Players by Position"
      puts "(5) Search for All Players by School/Club"
      puts "X to Exit"
    end

end
