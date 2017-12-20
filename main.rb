require 'dota'
require 'dotenv'
require 'tty-prompt'

Dotenv.load
Dota.configure do |config|
  config.api_key = ENV['API_KEY']
end

api = Dota.api
matches = api.live_matches

def all_live_matches(matches, tier="Premier")
  live_dict = {}
  matches.each do |match|
    if match.league_tier.eql? tier
      match_teams = "#{match.radiant.name} #{match.radiant.score} - #{match.dire.score} #{match.dire.name}"
      live_dict[match_teams] = match
    end
  end
  live_dict
end

def choose_match(matches)
  prompt = TTY::Prompt.new
  live_matches = all_live_matches(matches)
  unless live_matches.empty? 
    select = prompt.select("Choose match", live_matches)
  end
  select
end

def score(match)
  puts "#{match.radiant.name} #{match.radiant.score} - #{match.dire.score} #{match.dire.name}"
end

select = choose_match(matches)
unless select.nil?
  score(select)
else
  puts "No live matches"
end
