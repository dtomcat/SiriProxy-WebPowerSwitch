require 'cora'
require 'siri_objects'
require 'json'
require 'open-uri'
require 'timeout'
require 'pp'

class SiriProxy::Plugin::WebPowerSwitch < SiriProxy::Plugin
	attr_accessor :php_url

	def initialize(config = {})
	self.nba_url = config["php_url"]
	end

	$Cmd = nil
	$Outlet = nil

	#Check Outlet Status
	listen_for(/What's the status of outlet (?:number)? (1|2|3|4|5|6|7|8)/i) do |qOutlet|
		send_command("STATUS",qOutlet)
	end
	listen_for(/What is the status of outlet (?:number)? (1|2|3|4|5|6|7|8)/i) do |qOutlet|
		send_command("STATUS",qOutlet)
	end
	
	#Turn On/Off an Outlet
	listen_for(/Turn (on|off) outlet (?:number)? (1|2|3|4|5|6|7|8)/i) do |qCmd, qOutlet|
		send_command(qCmd,qOutlet)
	end
	listen_for(/Turn Outlet (?:number)? (1|2|3|4|5|6|7|8) (on|off)/i) do |qOutlet, qCmd|
		send_command(qCmd,qOutlet)
	end
	
	#Cycle an Outlet
	listen_for(/Cycle (?:the power of)? outlet (?:number)? (1|2|3|4|5|6|7|8)/i) do |qOutlet|
		send_command("CCL",qOutlet)
	end
	
	def send_command(s_Cmd,s_Outlet)
		sCmd=s_Cmd.upcase
		if(sCmd=="STATUS")
			r = open(URI("#{self.php_url}?Cmd=#{sCmd}&Outlet=#{s_Outlet}")).read
			puts "[INFO - WebPowerSwitch] Status: Outlet #{s_Outlet} is #{r}!"
			say "Outlet #{s_Outlet} is currently #{r}!"
			request_completed
		elsif(sCmd=="ON" || sCmd=="OFF")
			r = open(URI("{self.php_url}?Cmd=#{sCmd}&Outlet=#{s_Outlet}")).read
			if(r=="200")
				say "#{sCmd} Sent!"
				r = 
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
