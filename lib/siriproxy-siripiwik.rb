require 'rubygems'
require 'cora'
require 'siri_objects'
require 'piwik'

#############
# This is a plugin for SiriProxy that will allow you to check Piwik stats
# Example usage: "How many people have been to evancoleman.net today?"
#############

class SiriProxy::Plugin::SiriPiwik < SiriProxy::Plugin
  def initialize(config = {})
    @config = config 
  end

  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
  end 

  listen_for /how many people have been to my site today/i do
    set_state :check_visits
	site = Piwik::Site.load(2, @config['url'], @config['apikey'])
	num = site.visits(:day, Date.today)
    say "#{num} people have been to #{@config['sitename']} today."
    
    request_completed
  end

  listen_for /how many times has my site been visited today/i do
    set_state :check_views
	site = Piwik::Site.load(2, @config['url'], @config['apikey'])
	num = site.visits(:day, Date.today)
    say "#{@config['sitename']} was viewed #{num} times today."
    
    request_completed
  end

  listen_for /how many yesterday? yesterday/i, within_state: :check_visits do
    set_state nil
    site = Piwik::Site.load(2, @config['url'], @config['apikey'])
	num = site.visits(:day, Date.yesterday)
    say "#{num} people visisted #{@config['sitename']} yesterday."
    
    request_completed
  end

  listen_for /how many yesterday/i, within_state: :check_views do
    set_state nil
    site = Piwik::Site.load(2, @config['url'], @config['apikey'])
	num = site.visits(:day, Date.yesterday)
    say "#{@config['sitename']} was viewed #{num} times yesterday."
    
    request_completed
  end
end
