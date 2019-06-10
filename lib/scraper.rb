require 'nokogiri'
require 'open-uri'
require 'pry'
# require_relative '../lib/player.rb'

NBSP =  160.chr("UTF-8")

class Scraper

  @@all=[]

  # scrape the player data from url / html file
  def self.scrape_player(url)
    newarray=[]
    # I decided to scrape twice because I found too many irregular HTML elements and an irregular number of elements between the headline block and the particular heading-container
    # I was looking to scrape.  Sometimes this included a second heading-container containing a NBSP or other elements.
    # There was no easy way to go from the block containing the name to the correct heading-container block (maybe iterate until you can find the next correct heading-container block.)

    #scrape the name, school, year, etc for all players
    player_id_arr=scrape_page_head(url)
    #scrape the height, weight, scouting report
    player_info_arr=scrape_phys_meas(url)

    # merge the two parts of data -- the player info and some of the additional data
    newarray=(player_id_arr.zip (player_info_arr)).map do |row|
      row[0].merge(row[1])

    end
    newarray
  end

  # the two scraper methods are made Class private so that they cannot be called from outside the Class
  class << self
    private

    # had to scrape the data from the page in two passes because of too many irregularities in the HTML/CSS code
    # first scrape the names
    def scrape_page_head(url)
      i=0
      html = open(url)
      # binding.pry
      playerindex = Nokogiri::HTML(html)

      # initialize array of player info hashes
      playhasharr = []

      # sxcrape to get all the player information headline-blocks (player name, position, school/club)
      pheadarr=playerindex.css ("div.component.headline-block")

      # put the name, position, school/club, year  elements into a hash, then put the hash into an array
      pheadarr.each do |phrow|
        playhashrow={}
        # create playhashrow -- a hash for name, position, school/club, year

        # Get the name from div.head (div tag, class=head).  The split(",").first is to remove a comma
        # in the last name on the list
        playhashrow[:name]=(phrow.css("div.text-block div.head").text).split(",").first

        # schoolclub variable here actually is "position|schoolclub, year"
        schoolclub=phrow.css("div.text-block div.subhead").text
        # get the player's position here in the first part of schoolclub (originally named split1)
        playhashrow[:position]=schoolclub.split(",").first
        # split1=prevexp.split(",").last.split("|").first

        # Get the school / club name from the headline block
        playhashrow[:schoolclub]=schoolclub.split(",").last.split("|").first.strip
        # Get the class year
        class_year = schoolclub.split(",").last.split("|").last.strip
        # The way that the schoolclub variabkle
        if class_year !=playhashrow[:schoolclub]
            playhashrow[:class_year]=class_year

        end
        # put the current rank into the player hash (to avoid having to search later)
        playhashrow[:rank]=i+1
      #   binding.pry
        playhasharr << playhashrow
        # puts ("number #{i+1}")
        i+=1
      end

      playhasharr
    end

    # need to scrape in two passes because of odd extra div nodes /lines in the HTML
      def scrape_phys_meas(url)
        html = open(url)
        playerindex = Nokogiri::HTML(html)
        containarr=playerindex.css ("div.component.heading-container")

        containarr_mod=containarr.select {|prow| (prow.text).include?("Height")}
        containhasharr=[]
        containarr_mod.each do |pmeas_node|
            row_hash={}
            pm_node_text=pmeas_node.text
        #    binding.pry
            htwt = pm_node_text.gsub(NBSP,"").strip
            blurb=pmeas_node.next_element.text

            row_hash[:height]=(htwt.split("|").first).split(":").last.strip
            row_hash[:weight]=(htwt.split("|")[1]).split(":").last.strip
            row_hash[:age]=((htwt.split("|")[2]).split(":").last.strip).to_i
            lastitem=(htwt.split("|")[3])
            if lastitem != nil # this is because most entries with no last rank have "Last Rank: NR" BUT one does not have any entries
              row_hash[:last_rank]=lastitem.split(":").last.strip
            #  binding.pry
            end
            row_hash[:blurb] = blurb
            containhasharr << row_hash
          end
        # binding.pry
        containhasharr
      end
    end

end
