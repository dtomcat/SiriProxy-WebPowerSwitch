require 'cora'
require 'siri_objects'
require 'json'
require 'open-uri'
require 'timeout'
require 'pp'

class SiriProxy::Plugin::WebPowerSwitch < SiriProxy::Plugin
	attr_accessor :php_url

	def initialize(config = {})
	self.php_url = config["php_url"]
	end

	$Cmd = nil
	$Outlet = nil

	#Check Outlet Status
	listen_for(/What's the status of outlet (?:number)? (one|two|three|four|five|six|seven|eight)/i) do |qOutlet|
		command_wps("STATUS",word_to_num(qOutlet))
	end
	listen_for(/What is the status of outlet (?:number)? (one|two|three|four|five|six|seven|eight)/i) do |qOutlet|
		command_wps("STATUS",word_to_num(qOutlet))
	end
	
	
	
	#Turn On/Off an Outlet
	listen_for(/Turn (on|off) outlet (?:number)? (one|two|three|four|five|six|seven|eight)/i) do |qCmd, qOutlet|
		command_wps(qCmd,word_to_num(qOutlet))
	end
	listen_for(/Turn Outlet (?:number)? (one|two|three|four|five|six|seven|eight) (on|off)/i) do |qOutlet, qCmd|
		command_wps(qCmd,word_to_num(qOutlet))
	end
	
	
	
	#Cycle an Outlet
	listen_for(/Cycle (?:the power of)? outlet (?:number)? (one|two|three|four|five|six|seven|eight)/i) do |qOutlet|
		command_wps("CCL",word_to_num(qOutlet))
	end
	
	
	
	def word_to_num(wOutlet)
		wordNum = Hash.new(10)
		wordNum={"one" => 1,"two" => 2,"three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8}
		numC = wordNum[wOutlet.downcase]
		return numC
	end
	
	def command_wps(s_Cmd,s_Outlet)
		sCmd=s_Cmd.upcase
		if(sCmd=="STATUS")
			r = open(URI("#{self.php_url}?Cmd=#{sCmd}&Outlet=#{s_Outlet}")).read
			puts "[INFO - WebPowerSwitch] Status: Outlet #{s_Outlet} is #{r}!"
			say "Outlet #{s_Outlet} is currently #{r}!"
			request_completed
		elsif(sCmd=="ON" || sCmd=="OFF")
			r = open(URI("#{self.php_url}?Cmd=#{sCmd}&Outlet=#{s_Outlet}")).read
			if(r=="200")
				say "#{sCmd} Sent!"
				r = open(URI("#{self.php_url}?Cmd=STATUS&Outlet=#{s_Outlet}")).read
				say "Outlet #{s_Outlet} is currently #{r}!"
				puts "[Info - WebPowerSwitch] Outlet #{s_Outlet} Turned #{sCmd}."
				request_completed
			else
				puts "[Warning - WebPowerSwitch] ERROR: #{r}"
				say "Error communicating with Web Power Switch, please try again later!"
				request_completed
			end
		elsif(sCmd=="CCL")
			r = open(URI("#{self.php_url}?Cmd=STATUS&Outlet=#{s_Outlet}")).read
			ra = r.split
			if (ra[0]=="On")
				r = open(URI("#{self.php_url}?Cmd=CCL&Outlet=#{s_Outlet}")).read
				if(r=="200")
					say "Command sent! Outlet #{s_Outlet} should be rebooting at this time."
					puts "[Info - WebPowerSwitch] Cycle command sent to Outlet #{s_Outlet}!"
					request_completed
				else
					puts "[Warning - WebPowerSwitch] ERROR: #{r}"
					say "Error communicating with Web Power Switch, Please try again later!"
					request_completed
				end
			else
				response = ask "Outlet #{s_Outlet} appears to be off and cannot be cycled.  Would you like to turn it on instead?"
				if(response =~ /yes/i)
					command_wps("ON", s_Outlet)
					request_completed
				else
					say "OK, I'll just leave it off!"
					request_completed
				end
			end
		else
			say "I'm sorry, I don't know what to with that command!"
		end
	end
end
