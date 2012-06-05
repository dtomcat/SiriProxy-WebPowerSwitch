require 'cora'
require 'siri_objects'
require 'json'
require 'open-uri'
require 'timeout'
require 'pp'

class SiriProxy::Plugin::Sports < SiriProxy::Plugin
	attr_accessor :nba_url
	attr_accessor :nfl_url

	def initialize(config = {})
	self.nba_url = config["nba_url"]
	self.nfl_url = config["nfl_url"]
	end

	$status = nil
	$sTeam = nil

	#NBA Scores
	listen_for(/What's the (.*) basketball score/i) do |qTeam|
		get_NBA_score(qTeam)
	end
	listen_for(/What is the (.*) basketball score/i) do |qTeam|
		get_NBA_score(qTeam)
	end
	
	#NFL Scores
	listen_for(/What's the (.*) football score/i) do |qTeam|
		get_NFL_score(qTeam,"reg")
	end
	listen_for(/What is the (.*) football score/i) do |qTeam|
		get_NFL_score(qTeam,"reg")
	end
	#NFL Postseason
        listen_for(/What's the (.*) postseason score/i) do |qTeam|
		get_NFL_score(qTeam,"post")
	end
	listen_for(/What is the (.*) postseason score/i) do |qTeam|
		get_NFL_score(qTeam,"post")
	end
	
	def get_NFL_score(s_Team,s_season)
		$sTeam = case s_Team.downcase
			when "cowboys" then "DAL"
			when "giants" then "NYG"
			when "colts" then "IND"
			when "bears" then "CHI"
			when "eagles" then "PHI"
			when "browns" then "CLE"
			when "rams" then "STL"
			when "lions" then "DET"
			when "dolphins" then "MIA"
			when "texans" then "HOU"
			when "falcons" then "ATL"
			when "chiefs" then "KC"
			when "jaguars" then "JAC"
			when "vikings" then "MIN"
			when "redskins" then "WAS"
			when "saints" then "NO"
			when "bills" then "BUF"
			when "jets" then "NYJ"
			when "patriots" then "NE"
			when "titans" then "TEN"
			when "seahawks" then "SEA"
			when "cardinals" then "ARI"
			when "49ers" then "SF"
			when "packers" then "GB"
			when "panthers" then "CAR"
			when "buccaneers" then "TB"
			when "steelers" then "PIT"
			when "broncos" then "DEN"
			when "bengals" then "CIN"
			when "ravens" then "BAL"
			when "chargers" then "SD"
			when "raiders" then "OAK"
			else "Unknown"
		end
		if($sTeam=="Unknown")
			puts "[WARNING - Sports (NFL)] #{s_Team} is not an NFL Team!"
			say "I'm sorry, but the #{s_Team} doesn't appear to be an NFL Team!"
			request_completed
		else
			puts "[Info - Sports (NFL)] Getting Score/Game info for #{s_Team} (#{$sTeam})."
			if(s_season=="reg")
                               r = open(URI("#{self.nfl_url}?Team=#{$sTeam}")).read
                        else
                               r = open(URI("#{self.nfl_url}?Team=#{$sTeam}&Season=post")).read
                        end
			say r
	            request_completed
		end
	end

	def get_NBA_score(s_Team)
		$sTeam = case s_Team.downcase
			when "celtics" then "BOS"
			when "nets" then "NJN"
			when "new york knicks" then "NYK"
			when "76ers" then "PHI"
			when "raptors" then "TOR"
			when "mavericks" then "DAL"
			when "rockets" then "HOU"
			when "grizzlies" then "MEM"
			when "hornets" then "NOH"
			when "spurs" then "SAS"
			when "hawks" then "ATL"
			when "nuggets" then "DEN"
			when "bobcats" then "CHA"
			when "bulls" then "CHI"
			when "cavaliers" then "CLE"
			when "pistons" then "DET"
			when "warriors" then "GSW"
			when "pacers" then "IND"
			when "clippers" then "LAC"
			when "lakers" then "LAL"
			when "heat" then "MIA"
			when "bucks" then "MIL"
			when "timberwolves" then "MIN"
			when "jazz" then "UTA"
			when "wizards" then "WAS"
			when "suns" then "PHX"
			when "magic" then "ORL"
			when "thunder" then "OKC"
			when "trailblazers" then "POR"
			when "kings" then "SAC"
			else "Unknown"
		end
		if($sTeam=="Unknown")
			puts "[WARNING - Sports (NBA)] #{s_Team} is not an NBA Team!"
			say "I'm sorry, but the #{s_Team} doesn't appear to be an NBA Team!"
			request_completed
		else
			puts "[Info - Sports (NBA)] Getting Score/Game info for #{s_Team} (#{$sTeam})."
			r = open(URI("#{self.nba_url}?Team=#{$sTeam}")).read
			say r
	            request_completed
		end
	end 
end