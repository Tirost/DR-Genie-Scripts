#Climbing in Shard by Shroom
#debuglevel 5
## USER VARIABLES
## Set weapons to wield for more difficult climbing
var weapon1 sabre
var weapon2 nightstick
## Play Zills while climbing?
var zills yes
## MAX NUMBER OF CLIMBING LOOPS TO DO REGARDLESS OF MINDSTATE
var maxLoops 12
## END USER VARIABLES
########################
var LOOP 0
counter set 0
ECHO
ECHO *** START ANYWHERE INSIDE OR AROUND SHARD
ECHO 
## Add weapons here to make climbing harder for higher ranks
if ($Athletics.Ranks > 700) then send get %weapon1
pause 0.3
pause 0.1
if ($Athletics.Ranks > 750) then send get %weapon2
pause 0.5
pause 0.2
pause 0.1
if ($Athletics.Ranks > 1000) then 
     {
     echo *** OVER 1000 Athletics Ranks! 
     echo *** Going to train climbing outside the west gate on Wyvern Peak 
     goto WESTGATE.TRAINING
     }
if ($Athletics.Ranks <= 700) then
    {
	if !contains("$righthandnoun $lefthandnoun", "rope") then
          {
          pause 0.001
          pause 0.1
		send get my braided rope
          pause 0.2
		send uncoil my braided rope
		pause 0.5
          pause 0.5
          }
	if !contains("$righthandnoun $lefthandnoun", "rope") then
          {
		pause 0.001
          pause 0.1
		send get my heavy rope
          pause 0.2
		send uncoil my heavy rope
		pause 0.5
          pause 0.5
          }
    }
if_1 then goto %1

Start:
var location Undergondola
if $Athletics.LearningRate >= 29 then goto DONE
if %c >= %maxLoops then goto DONE
ECHO
ECHO *** STARTING CLIMBING SESSION %c ***
ECHO
counter add 1
if "$guild" = "Thief" then 
     {
          send khri start focus flight
          pause
          pause 0.5
          pause 0.2
          pause 0.1
     }
if "$guild" = "Moon Mage" then 
     {
          send prep symbiosis explore
          pause 0.5
          pause 0.2
          send prep shadows 5
          pause 2
          send charge my armb 5
          pause 2
          pause 0.5
          send invoke my armb
          pause 14
          send cast
     }
if tounder("%zills" = "yes") then send play $song
pause 0.3
SHARD.TO.UNDER:
if $zoneid = 68 then gosub automove shard
if $zoneid = 69 then gosub automove north
if $zoneid = 67 then gosub automove north
if $zoneid = 66 then gosub automove waterfall
BEGIN:
UNDER.TO.PRACTICE:
if $Athletics.Ranks < 240 then 
     {
     gosub automove 40
     goto BRANCH.CHECK
     }
gosub automove 50
pause 0.2
BRANCH.CHECK:
if $Athletics.Ranks > 450 then goto BRANCH
BACK.TO.START:
gosub automove 26
pause 0.5
if ($Athletics.Ranks < 450) && ($Athletics.Ranks > 190) then 
     {
     ECHO 
     ECHO **** PRACTICING CLIMBING
     ECHO 
     put climb practice wall
     goto PRACTICE.LOOP
     }
goto TO.RESET

ESCAPE:
var LOOP 0
send stop climb
pause 0.1
pause 0.1
send ret;ret
pause 0.2
pause 0.1

TO.RESET:
gosub automove 2
pause 0.5
pause 0.1
if ("$lefthand" != "Empty") 750 then 
     {
     put stow left
     pause 0.5
     }
FORAGING:
pause 0.2
if tounder("%zills" = "yes") then send stop play
pause 0.5
if contains("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
if contains("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
send collect rock
pause 3
pause
if contains("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
pause 0.1
send collect rock
pause 3
pause
if contains("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
pause 0.2
if (($Athletics.Ranks > 750) && ("$lefthand" = "Empty")) then 
     {
          send get %weapon2
          pause 0.5
     }
goto CONTINUE

BRANCH:
var LOOP 0
if $Athletics.Ranks < 500 then 
 	{
          gosub automove 26
		put climb practice wall
          goto PRACTICE.LOOP2
     }
var LOOP 0
if $Athletics.Ranks > 500 then gosub automove 43
if $Athletics.Ranks < 520 then 
	{
		put climb practice ledge
          goto PRACTICE.LOOP3
     }
BRANCH2:
action remove ^You are engaged
var LOOP 0
put stop climb
pause 0.5
pause 0.1
send ret;ret
pause 0.5
if $Athletics.Ranks >= 520 then gosub automove 42
if $Athletics.Ranks < 520 then goto BRANCH.CONT
pause 0.5
if $Athletics.Ranks > 520 then gosub automove 41
pause 0.5
if $Athletics.Ranks <  560 then put app branch
pause 
pause 
if $Athletics.Ranks < 700 then 
	{
		put climb practice branch
		goto PRACTICE.LOOP4
	}
BRANCH.CONT:
action remove ^You are engaged
var LOOP 0
put stop climb
pause 0.5
pause 0.1
send ret;ret
pause 0.5
if $Athletics.Ranks >= 520 then 
	{
		if $zoneid = 65 then gosub automove cross
		if $zoneid = 62 then gosub automove under
	}
gosub automove 23
gosub automove 15
goto TO.RESET

CONTINUE:
CLIMBING.CHECK:
if %c > %maxLoops then goto LEAVE
if $Athletics.LearningRate < 28 then goto START
LEAVE:
pause 0.1
pause 0.1
if "$righthandnoun" = "rope" then
	{
		send coil my rope
		send stow my rope
		pause 0.5
		pause 0.4
	}			
if $zoneid = 65 then gosub automove 1
pause 0.5
if "$righthandnoun" != "Empty" then put stow right
if "$lefthandnoun" != "Empty" then put stow left
pause 0.5
goto DONE

PRACTICE.LOOP:
matchre ESCAPE ^The climb is too difficult|^This climb is too difficult
pause 0.5
math LOOP add 1
if %LOOP > 60 then goto ESCAPE
if $monstercount > 0 then goto ESCAPE
pause 0.5
goto PRACTICE.LOOP

PRACTICE.LOOP2:
action goto BRANCH.CONT when ^You are engaged
action goto BANCH.CONT when ^The climb is too difficult|^This climb is too difficult
pause 0.5
math LOOP add 1
if %LOOP > 60 then goto BRANCH.CONT
if $monstercount > 0 then goto BRANCH.CONT
pause 0.5
goto PRACTICE.LOOP2

PRACTICE.LOOP3:
matchre ESCAPE ^The climb is too difficult|^This climb is too difficult
action goto BRANCH2 when ^You are engaged
pause 0.5
math LOOP add 1
if %LOOP > 60 then goto BRANCH2
if $monstercount > 0 then goto BRANCH2
pause 0.5
goto PRACTICE.LOOP3

PRACTICE.LOOP4:
matchre ESCAPE ^The climb is too difficult|^This climb is too difficult
action goto BRANCH.CONT when ^You are engaged
pause 0.5
math LOOP add 1
if %LOOP > 60 then goto BRANCH.CONT
if $monstercount > 0 then goto BRANCH.CONT
pause 0.5
goto PRACTICE.LOOP4



WESTGATE.TRAINING:
     var location Wyvern Peak
     counter add 1
     # if ("$guild" = "Thief" then 
          # {
          # send khri silence
          # pause 1
          # pause
          # }
     if tounder("%zills" = "yes") then send play $song
     pause 0.3
     if $zoneid = 65 then gosub automove shard
     if $zoneid = 66 then gosub automove east
     if $zoneid = 67 then gosub automove west
     if $zoneid = 69 then gosub automove 464
     if $zoneid = 69 then gosub automove 468
     if $zoneid = 69 then gosub automove 513
     if $zoneid = 69 then gosub automove 509
     if $zoneid = 69 then gosub automove 508
     if $zoneid = 69 then gosub automove 536
WEST.FORAGE:
if ("$lefthand" != "Empty") then 
          {
          put stow left
          pause 0.5
          }
     if tounder("%zills" = "yes") then send stop play
     pause 0.3
     if matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
     if matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
     send collect rock
     pause 3
     pause
     if matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
     if matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
     send collect rock
     pause 3
     pause
     if matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then gosub KICK.PILE
if $Athletics.LearningRate >= 29 then goto DONE
if %c > %maxLoops then goto DONE
goto WESTGATE.TRAINING

KICK.PILE1:
pause
KICK.PILE:
pause 0.1
if !matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then RETURN
matchre RETURN ^I could not|^What were you
matchre KICK.PILE foot smashing down
matchre STAND ^You can't do that from your position
match KICK.PILE1 footing at the last moment
put kick pile
matchwait 20
goto FORAGE.EXP

##################################################

AUTOMOVE:
     pause 0.001
     pause 0.001
	pause 0.001
     var Destination $0
     if ("%guild" = "Necromancer") then gosub EOTB
     if !$standing then gosub STAND
     if $roomid = %Destination then RETURN
AUTOMOVE_GO:
     matchre AUTOMOVE_RETURN ^SHOP CLOSED\!|SHOP CLOSED
     matchre AUTOMOVE_FAILED ^AUTOMAPPER MOVEMENT FAILED|^MOVE FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED
     send #goto %Destination
     matchwait
AUTOMOVE_STAND:
     send STAND
     pause 0.5
     if $standing then RETURN
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     pause 0.5
     pause 0.5
     pause 0.5
     goto AUTOMOVE_GO
AUTOMOVE_RETURN:
     if matchre("%Destination", "teller|exchange|debt|PAWN") then if $invisible = 1 then gosub stopinvis
     pause 0.2
     pause 0.1
	pause 0.1
     RETURN

PAUSE:
     if ($roundtime > 0) then pause $roundtime
     pause 0.5
     pause 0.1
     RETURN
STAND:
     pause 0.2
     matchre STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre STAND ^\.\.\.wait|^Sorry\,
     matchre STAND ^You are so unbalanced you cannot manage to stand\.
     matchre STAND ^The weight of all your possessions prevents you from standing\.
     matchre STAND ^You are overburdened and cannot manage to stand\.
     matchre STAND ^You are still stunned
     matchre STAND ^You try
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You stand back up\.
     matchre RETURN ^You stand up\.
     matchre RETURN ^There doesn't seem to be anything to stand on here
     matchre RETURN ^You swim back up
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You're unconscious
     send STAND
     matchwait

WAIT:
     delay 0.0001
     pause 0.1
     if (!$standing) then gosub STAND
     goto %LOCATION
WEBBED:
     delay 0.0001
     if ($webbed) then waiteval (!$webbed)
     if (!$standing) then gosub STAND
     goto %LOCATION
IMMOBILE:
     delay 0.0001
     if contains("$prompt" , "I") then pause 20
     if (!$standing) then gosub STAND
     goto %LOCATION
STUNNED:
     delay 0.0001
     if ($stunned) then waiteval (!$stunned)
     if (!$standing) then gosub STAND
     goto %LOCATION
#### RETURNS
RETURN_CLEAR:
     delay 0.0001
     put #queue clear
     pause 0.0001
     return
RETURN:
     delay 0.0001
     return

DONE:
put #echo >Log Lime *** %c Climbing loops  of %location to $Athletics.LearningRate / 34  ***
put stow kat
pause 0.5
pause 0.4
put stow scim
pause 0.5
pause 0.5
if $zoneid = 65 then gosub automove shard
if $zoneid = 66 then gosub automove east
if $zoneid = 69 then gosub automove shard
pause 0.1
put exp
pause 0.5
put #parse CLIMBING DONE
put #parse DONE CLIMBING
put #parse CLIMBING LOCKED
exit
