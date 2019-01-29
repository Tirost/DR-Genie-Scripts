##DEBUG 10


ACTION send research %Research_Topic(%i) 300 when decide to take a break
ACTION send stand when eval $standing = 0


setvar Research_Topic FIELD|UTILITY|WARDING|AUGMENTATION
setvar Topic_Count 3
setvar i 0

ACTION setvar i 0 when about Field Patterns Research.
ACTION setvar i 1 when about Utility Patterns Research.
ACTION setvar i 2 when about Warding Patterns Research.
ACTION setvar i 3 when about Augmentation Patterns Research.

send research status
wait 1

## ***************
RESEARCH_NEW_TOPIC:
 	if (%i > %Topic_Count) then setvar i 0
    pause 0.1
	if ($SpellTimer.GaugeFlow.duration > 5) then {
		GoSub RESEARCH_EXECUTE
		math i add 1
		goto RESEARCH_NEW_TOPIC	
	}
	GOTO GAF_WAIT

RESEARCH_EXECUTE:
	wait .5
		matchre RETURN1 Breakthrough!
		matchre RESEARCH_EXECUTE decide to take a break
		matchre WEBBED You are webbed|You can't do that while entangled in a web.
		matchre RESEARCH_CANCELLED You decide to stop researching|You have abandoned your research|you forget what you were researching
		matchre WEBBED You realize that preparing a spell would interfere with your magical research.|You're unconscious!
	send research %Research_Topic(%i) 300
	matchwait 120
	GOTO RESEARCH_EXECUTE
	
RETURN1:
	RETURN
	
WEBBED:
	wait 20
	GOTO RESEARCH_EXECUTE
	
GAF_WAIT:
	wait 30
	if ($SpellTimer.GaugeFlow.duration < 6) then GOTO GAF_WAIT
	else GOTO RESEARCH_NEW_TOPIC
	
RESEARCH_CANCELLED:
	wait 120
	GOTO RESEARCH_EXECUTE

