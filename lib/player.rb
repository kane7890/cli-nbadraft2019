require 'nokogiri'
require 'open-uri'
require 'pry'

#class Player for objects that each represent one player


class Player

  # attr_accessors (macros for setter and getter methods) for different attribues of Player

  attr_accessor :name,:position,:schoolclub,:class_year,:height,:weight,:age,:last_rank,:blurb,:rank
  @@all=[]

  # initialize a new instance of Player...reads in a player hash, creates a new instance
  def initialize(phashrow)

    phashrow.each do |key, val|
      self.send("#{key}=", "#{val}")
    end
    # then shovels the instance into @@all
    @@all << self

  end

  # iterate through an array of player hashes:  for each player, instantiate a new Player instance
  def self.add_players(playerarray)
    playerarray.each do |player_hash|
        self.new(player_hash)
    end
  end

  #return all Player elements
  def self.all
    @@all
  end

#return first player by name
  def self.find_by_name(name)
    playr=@@all.find {|player| player.name.downcase.include?(name.downcase)}
    # binding.pry
    playr
  end

# return an array of all players in the Player Class by school/club
  def self.find_by_sclub(sclub)
    @@all.select {|player| player.schoolclub == sclub}
  end

#return an array of all players in the Player Class  by a given position

  def self.find_by_posn(posn)
    @@all.select {|player| player.position.include?(posn)}
  end
  # displays detailed info for an instance of Player
  def display_info
      
      puts "\nPlayer Name: #{self.name}"
      puts "Current Rank: #{self.rank}"
      puts "Position:  #{self.position}"
      puts "School/Club:  #{self.schoolclub}"
      # binding.pry
      #if there is no class_year, nothing is displayed
        puts "Year:  #{self.class_year}"
      #
      puts "Height/Weight:  #{self.height}, #{self.weight} "
      puts "Age: #{self.age}"
      puts "Last rank:  #{self.last_rank}"
      puts "Scouting Report: #{self.blurb}"
      puts "------------------------------------"
  end

end
