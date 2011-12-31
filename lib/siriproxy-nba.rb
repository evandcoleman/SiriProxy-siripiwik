require 'cora'
require 'siri_objects'
require 'open-uri'
require 'nokogiri'

#############
# This is a plugin for SiriProxy that will allow you to check tonight's NBA scores
# Example usage: "What's the score of the Bulls game?"
#############

class SiriProxy::Plugin::NBA < SiriProxy::Plugin

  @firstTeamName = ""
  @firstTeamScore = ""
  @secondTeamName = ""
  @secondTeamScore = ""
  @timeLeft = ""
  @teamInt = 0	
  @teamInt2 = 0
	def initialize(config)
    #if you have custom configuration options, process them here!
    end
  
  listen_for /NBA (.*)/i do |phrase|
	  team = pickOutTeam(phrase)
	  if team.include? "all games"
	  	allscores(team)
	  else
	  	score(team) #in the function, request_completed will be called when the thread is finished
	  end
	end
	
	def allscores(userTeam)
	  Thread.new {
	    doc = Nokogiri::HTML(open("http://m.espn.go.com/nba/scoreboard"))
      	games = doc.css(".match")
      	games.each {
      		|game|
      		@timeLeft = game.css(".snap-5").first.content.strip
      		firstTeam = game.css(".competitor").first
      		secondTeam = game.css(".competitor").last
      		firstTemp = firstTeam.css("strong").first.content.strip
      		secondTemp = secondTeam.css("strong").first.content.strip
      		
      		firstTemp = nameFromInt(firstTemp)
      		secondTemp = nameFromInt(secondTemp)
      		
      		@firstTeamName = firstTemp
      		@secondTeamName = secondTemp
      		@firstTeamScore = firstTeam.css("td").last.content.strip
      		@secondTeamScore = secondTeam.css("td").last.content.strip
      		
      		if @timeLeft.include? "Final"
        		response = "The Final score for the " + @firstTeamName + " game is: " + @firstTeamName + " (" + @firstTeamScore + "), " + @secondTeamName + " (" + @secondTeamScore + ")."
      		elsif @timeLeft.include? "PM"
        		response = "The " + @firstTeamName + " game is at " + @timeLeft + ". It will be the " + @firstTeamName + " vs " + @secondTeamName + "."
      		else
        		response = "The " + @firstTeamName+ " are still playing. The score is " + @firstTeamName + " (" + @firstTeamScore + "), " + @secondTeamName + " (" + @secondTeamScore + ") with " + @timeLeft + "."
      		end

			say response	
      			
      	} 			
			request_completed
		}
		
	  say "Checking to see all games played today."
	  
	end
	
	def score(userTeam)
	  Thread.new {
	    doc = Nokogiri::HTML(open("http://m.espn.go.com/nba/scoreboard"))
      	games = doc.css(".match")
      	games.each {
      		|game|
      		@timeLeft = game.css(".snap-5").first.content.strip
      		firstTeam = game.css(".competitor").first
      		secondTeam = game.css(".competitor").last
      		firstTemp = firstTeam.css("strong").first.content.strip
      		secondTemp = secondTeam.css("strong").first.content.strip
      		#say "test-" + @teamInt + "-" + firstTemp + "-" + secondTemp + "-"
      		
      		firstTemp = nameFromInt(firstTemp)
      		secondTemp = nameFromInt(secondTemp)
      		
      		if firstTemp.include? userTeam
      			@firstTeamName = firstTemp
      			@secondTeamName = secondTemp
      			@firstTeamScore = firstTeam.css("td").last.content.strip
      			@secondTeamScore = secondTeam.css("td").last.content.strip
      			break
      		elsif secondTemp.include? userTeam
      			@firstTeamName = firstTemp
      			@secondTeamName = secondTemp
      			@firstTeamScore = firstTeam.css("td").last.content.strip
      			@secondTeamScore = secondTeam.css("td").last.content.strip
      			break
      		else
      			@firstTeamName = ""
      			@secondTeamName = ""
      		end
      			
      	} 
      	
      if((@firstTeamName == "") || (@secondTeamName == ""))
        response = "No games involving the " + userTeam + " were found playing tonight"
      elsif @timeLeft.include? "Final"
        	response = "The Final score for the " + userTeam + " game is: " + @firstTeamName + " (" + @firstTeamScore + "), " + @secondTeamName + " (" + @secondTeamScore + ")."
      elsif @timeLeft.include? "PM"
        	response = "The " + userTeam + " game is at " + @timeLeft + ". It will be the " + @firstTeamName + " vs " + @secondTeamName + "."
      else
        	response = "The " + userTeam + " are still playing. The score is " + @firstTeamName + " (" + @firstTeamScore + "), " + @secondTeamName + " (" + @secondTeamScore + ") with " + @timeLeft + "."
      end
	  
			@firstTeamName = ""
			@secondTeamName = ""
			say response
			
			request_completed
		}
		
	  say "Checking to see if the " + userTeam + " played today."
	  
	end

def nameFromInt(phrase)
    if(phrase.match(/BOS/i))
    	@teamInt = 1
      return "Celtics"
      end
    if(phrase.match(/NJN/i))
    @teamInt = 2
      return "Nets"
      end
    if(phrase.match(/NYK/i))
    @teamInt = 3
      return "Knicks"
      end
    if(phrase.match(/PHI/i))
    @teamInt = 4
      return "76ers"
      end
    if(phrase.match(/TOR/i))
    @teamInt = 5
      return "Raptors"
      end
    if(phrase.match(/CHI/i))
    @teamInt = 6
      return "Bulls"
      end
    if(phrase.match(/CLE/i))
    @teamInt = 7
      return "Cavaliers"
      end
    if(phrase.match(/DET/i))
    @teamInt = 8
      return "Pistons"
      end
    if(phrase.match(/IND/i))
    @teamInt = 9
      return "Pacers"
      end
    if(phrase.match(/MIL/i))
    @teamInt = 10
      return "Bucks"
      end
    if(phrase.match(/ATL/i) || phrase.match(/hawks/i))
    @teamInt = 11
      return "Hawks"
      end
    if(phrase.match(/CHA/i) || phrase.match(/bobcats/i))
    @teamInt = 12
      return "Bobcats"
      end
    if(phrase.match(/MIA/i) || phrase.match(/heat/i))
    @teamInt = 13
      return "Heat"
      end
    if(phrase.match(/ORL/i) || phrase.match(/magic/i))
    @teamInt = 14
      return "Magic"
      end
    if(phrase.match(/WAS/i) || phrase.match(/wizards/i))
    @teamInt = 15
      return "Wizards"
      end
    if(phrase.match(/GSW/i) || phrase.match(/warriors/i))
    @teamInt = 16
      return "Warriors"
      end
    if(phrase.match(/LAC/i) || phrase.match(/clippers/i))
    @teamInt = 17
      return "Clippers"
      end
    if(phrase.match(/LAL/i) || phrase.match(/lakers/i))
    @teamInt = 18
      return "Lakers"
      end
    if(phrase.match(/PHX/i) || phrase.match(/phoenix/i))
    @teamInt = 19
      return "Suns"
      end
    if(phrase.match(/SAC/i) || phrase.match(/kings/i))
    @teamInt = 20
      return "Kings"
      end
    if(phrase.match(/DAL/i) || phrase.match(/mavericks/i))
    @teamInt = 21
      return "Mavericks"
      end
    if(phrase.match(/HOU/i) || phrase.match(/rockets/i))
    @teamInt = 22
      return "Rockets"
      end
    if(phrase.match(/MEM/i) || phrase.match(/grizzles/i))
    @teamInt = 23
    return "Grizzles"
    end
    if(phrase.match(/NOR/i) || phrase.match(/hornets/i))
    @teamInt = 24
      return "Hornets"
      end
    if(phrase.match(/SAS/i) || phrase.match(/spurs/i))
    @teamInt = 25
      return "Spurs"
      end
    if(phrase.match(/DEN/i) || phrase.match(/nuggets/i))
    @teamInt = 26
      return "Nuggets"
      end
    if(phrase.match(/MIN/i) || phrase.match(/timberwolves/i))
    @teamInt = 27
      return "Timberwolves"
      end
    if(phrase.match(/OKC/i) || phrase.match(/thunder/i))
    @teamInt = 28
      return "Thunder"
      end
    if(phrase.match(/POR/i) || phrase.match(/trailblazers/i))
    @teamInt = 29
      return "Trailblazers"
      end
    if(phrase.match(/UTH/i) || phrase.match(/jazz/i))
    @teamInt = 30
      return "Jazz"
      end
	
		return phrase
	
	end

	
  def pickOutTeam(phrase)
    if(phrase.match(/boston/i) || phrase.match(/celtics/i))
    	@teamInt2 = 1
      return "Celtics"
      end
    if(phrase.match(/new jersy/i) || phrase.match(/nets/i))
    @teamInt2 = 2
      return "Nets"
      end
    if(phrase.match(/new york/i) || phrase.match(/knicks/i))
    @teamInt2 = 3
      return "Knicks"
      end
    if(phrase.match(/philadelphia/i) || phrase.match(/76ers/i))
    @teamInt2 = 4
      return "76ers"
      end
    if(phrase.match(/toronto/i) || phrase.match(/raptors/i))
    @teamInt2 = 5
      return "Raptors"
      end
    if(phrase.match(/chicago/i) || phrase.match(/bulls/i))
    @teamInt2 = 6
      return "Bulls"
      end
    if(phrase.match(/cleveland/i) || phrase.match(/cavaliers/i))
    @teamInt2 = 7
      return "Cavaliers"
      end
    if(phrase.match(/detroit/i) || phrase.match(/pistons/i))
    @teamInt2 = 8
      return "Pistons"
      end
    if(phrase.match(/indiana/i) || phrase.match(/pacers/i))
    @teamInt2 = 9
      return "Pacers"
      end
    if(phrase.match(/milwaukee/i) || phrase.match(/bucks/i))
    @teamInt2 = 10
      return "Bucks"
      end
    if(phrase.match(/atlanta/i) || phrase.match(/hawks/i))
    @teamInt2 = 11
      return "Hawks"
      end
    if(phrase.match(/charlotte/i) || phrase.match(/bobcats/i))
    @teamInt2 = 12
      return "Bobcats"
      end
    if(phrase.match(/miami/i) || phrase.match(/heat/i))
    @teamInt2 = 13
      return "Heat"
      end
    if(phrase.match(/orlando/i) || phrase.match(/magic/i))
    @teamInt2 = 14
      return "Magic"
      end
    if(phrase.match(/washington/i) || phrase.match(/wizards/i))
    @teamInt2 = 15
      return "Wizards"
      end
    if(phrase.match(/golden state/i) || phrase.match(/warriors/i))
    @teamInt2 = 16
      return "Warriors"
      end
    if(phrase.match(/clippers/i) || phrase.match(/clippers/i))
    @teamInt2 = 17
      return "Clippers"
      end
    if(phrase.match(/lakers/i) || phrase.match(/lakers/i))
    @teamInt2 = 18
      return "Lakers"
      end
    if(phrase.match(/phoenix/i) || phrase.match(/phoenix/i))
    @teamInt2 = 19
      return "Suns"
      end
    if(phrase.match(/sacramento/i) || phrase.match(/kings/i))
    @teamInt2 = 20
      return "Kings"
      end
    if(phrase.match(/dallas/i) || phrase.match(/mavericks/i))
    @teamInt2 = 21
      return "Mavericks"
      end
    if(phrase.match(/houston/i) || phrase.match(/rockets/i))
    @teamInt2 = 22
      return "Rockets"
      end
    if(phrase.match(/memphis/i) || phrase.match(/grizzles/i))
    @teamInt2 = 23
    return "Grizzles"
    end
    if(phrase.match(/new orleans/i) || phrase.match(/hornets/i))
    @teamInt2 = 24
      return "Hornets"
      end
    if(phrase.match(/san antonio/i) || phrase.match(/spurs/i))
    @teamInt2 = 25
      return "Spurs"
      end
    if(phrase.match(/denver/i) || phrase.match(/nuggets/i))
    @teamInt2 = 26
      return "Nuggets"
      end
    if(phrase.match(/minnesota/i) || phrase.match(/timberwolves/i))
    @teamInt2 = 27
      return "Timberwolves"
      end
    if(phrase.match(/oklahoma/i) || phrase.match(/thunder/i))
    @teamInt2 = 28
      return "Thunder"
      end
    if(phrase.match(/portland/i) || phrase.match(/trailblazers/i))
    @teamInt2 = 29
      return "Trailblazers"
      end
    if(phrase.match(/utah/i) || phrase.match(/jazz/i))
    @teamInt2 = 30
      return "Jazz"
      end
	
		return phrase
	
	end
end
