require 'cora'
require 'siri_objects'
require 'json'
require 'open-uri'
require 'timeout'
require 'pp'

class SiriProxy::Plugin::NBA < SiriProxy::Plugin
	attr_accessor :url

	def initialize(config = {})
	self.url = config["url"]
	end

	$status = nil
	$sTeam = nil

	#Group Commands on
	listen_for(/What's the (.*) basketball score/i) do |qTeam|
		get_score(qTeam)
	end
	listen_for(/What is the (.*) basketball score/i) do |qTeam|
		get_score(qTeam)
	end
	

	def get_score(s_Team)
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
		puts $sTeam
		r = open(URI("#{self.url}?Team=#{sTeam}")).read
		puts r
	end 
end