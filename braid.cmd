var forage grass
var trash log
var loop 0

action goto EXIT when ^You survey the area and realize that any foraging efforts would be futile\.

if ("$righthand" != "Empty") then send stow right
if ("$lefthand" != "Empty") then send stow left
pause 0.1
pause 0.2

LOOP:
     math loop add 1 
     if (%loop > 20) then goto DONE
     if ($Mechanical_Lore.LearningRate) > 31 then goto DONE
     if contains("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then GOSUB KICK.PILE
     if contains("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then GOSUB KICK.PILE
     pause 0.1
     if ("$righthandnoun" = "%forage") && ("$lefthandnoun" = "%forage") then goto BRAID
     if ("$righthand" != "Empty") then send empty right
     if ("$lefthand" != "Empty") then send empty left
     if ("$zoneid" = "150" && "$roomid" != "45") then gosub automove 45
     put forage %forage
     pause 2
     pause

FORAGE:
     if ("$lefthand" = "braided vines") then put swap
     if ("$lefthand" = "braided grass") then put swap
     pause 0.2
     if ("$charactername" = "Shroom") && ("$zoneid" = "150") then goto FEEDBAG
     pause 0.001
     if ("%forage" = "grass") then
          {
          if contains("$roomobjs","some grass") then 
               {
               put get grass
               pause 0.5
               goto BRAID
               }
          }
     if ("%forage" = "vine") then
          {
          if contains("$roomobjs","a vine") then 
               {
               put get vine
               pause 0.5
               goto BRAID
               }
          }
     put forage %forage
     pause 2
     pause
     if ("$righthand" != "Empty") && ("$lefthand" != "Empty") then goto BRAID
     goto FORAGE
     
FEEDBAG:
     pause 0.2
     if ("$righthand" != "Empty") && ("$lefthand" != "Empty") then goto BRAID
     matchre FEEDBAG ^You get
     matchre EMPTYBAG ^What were|^I could not
     put get grass from my feedb
     matchwait
HUM:
send stop hum
pause 0.2
BRAID:
     pause 0.1
     if ("$lefthand" = "braided vines") then put swap
     if ("$lefthand" = "braided grass") then put swap
     if ($Mechanical_Lore.LearningRate) > 31 then goto DONE
     pause 0.3
     if ("$lefthand" = "Empty") then goto FORAGE
     matchre HUM ^But that would give away your hiding
     matchre FORAGE ^You need to have more material
     matchre DUMP ^You need both hands to do that|nothing more than wasted effort
     matchre PULL ^You fumble around trying|^You are certain that you have made a|is already as long
     matchre BRAID Roundtime|^\.\.\.wait|^Sorry
     send braid my %forage
     matchwait

PULL:
     pause .5
     put pull my %forage
     pause

DUMP:
     pause 0.2
     pause 0.1
     if matchre("$roomobjs", "a small hole") then var trash hole
     if matchre("$roomobjs", "a small mud puddle") then var trash puddle
     if matchre("$roomobjs", "a marble statue ") then var trash statue
     if matchre("$roomobjs", "a bucket of viscous gloop|a waste bucket|a bucket|metal bucket|iron bucket") then var trash bucket
     if matchre("$roomobjs", "a large stone turtle") then var trash turtle
     if matchre("$roomobjs", "a tree hollow|darken hollow") then var trash hollow
     if matchre("$roomobjs", "an oak crate") then var trash crate
     if matchre("$roomobjs", "a driftwood log") then var trash log
     if matchre("$roomobjs", "a disposal bin|a waste bin|firewood bin") then var trash bin
     if matchre("$roomobjs", "ivory urn") then var trash urn
     if matchre("$roomobjs", "a waste basket") then var trash basket
     if matchre("$roomobjs", "a bottomless pit") then var trash pit
     if matchre("$roomobjs", "trash receptacle") then var trash receptacle
     if matchre("$roomname", "^\[Garden Rooftop, Medical Pavilion\]") then var trash gutter   
     pause 0.3
     if matchre("$righthand","(grass|vine|rope)") then put put my $1 in %trash
     if matchre("$lefthand","(grass|vine|rope)") then put put my $1 in %trash
     pause 0.5
     pause 0.2
     if matchre("$righthand","(grass|vine|rope)") then put drop my $righthand
     if matchre("$lefthand","(grass|vine|rope)") then put drop my $lefthand
     pause 0.4
     pause 0.5
     if ("$righthand" != "Empty") then send empty right
     if ("$lefthand" != "Empty") then send empty left
     pause 0.5
     if ("$righthand" != "Empty") then put stow right
     if ("$lefthand" != "Empty") then put stow left
     pause 0.2
     send dump junk
     pause .1
     goto LOOP
     
EMPTYBAG:
     echo **** FEEDBAG IS EMPTY! ATTEMPTING TO REFILL!!
     put put grass in my feed
     pause 0.5
     if ("$zoneid" = "150") && ("$roomid" != "44") then gosub automove 44
     # if ("$zoneid" = "150") && ("$roomid" = "85") then put go portal
     # pause
	# pause 0.5
     # if ("$zoneid" = "66") then gosub automove campfire
FEEDBAG.COLLECT:
     pause 0.5
     put collect grass
     pause 2
     pause 
     if !contains("$roomobjs","pile of grass") then goto FEEDBAG.COLLECT
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto FEEDBAG.COLLECT
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.1
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto FEEDBAG.COLLECT
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto FEEDBAG.COLLECT
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto FEEDBAG.COLLECT
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto LOOP
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto LOOP
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto LOOP
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto LOOP
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     if !contains("$roomobjs","pile of grass") then goto LOOP
     put get grass
     pause 0.5
     put put grass in my feedbag
     pause 0.3
     pause 0.3
     gosub automove 45
     goto LOOP
     
DONE:
pause 0.1
pause 0.1
EXIT:
     if matchre("$roomobjs", "trash receptacle") then var trash receptacle
     if matchre("$roomobjs", "a small hole") then var trash hole
     if matchre("$roomobjs", "a small mud puddle") then var trash puddle
     if matchre("$roomobjs", "a marble statue ") then var trash statue
     if matchre("$roomobjs", "a bucket of viscous gloop|a waste bucket|a bucket|metal bucket") then var trash bucket
     if matchre("$roomobjs", "a large stone turtle") then var trash turtle
     if matchre("$roomobjs", "a tree hollow|darken hollow") then var trash hollow
     if matchre("$roomobjs", "an oak crate") then var trash crate
     if matchre("$roomobjs", "a driftwood log") then var trash log
     if matchre("$roomobjs", "a disposal bin|a waste bin|firewood bin") then var trash bin
     if matchre("$roomobjs", "ivory urn") then var trash urn
     if matchre("$roomobjs", "a bottomless pit") then var trash pit
     if matchre("$roomname", "^\[Garden Rooftop, Medical Pavilion\]") then var trash gutter
     pause 0.3
     if matchre("$righthand","(grass|vine|rope)") then put put my $1 in %trash
     if matchre("$lefthand","(grass|vine|rope)") then put put my $1 in %trash
     pause 0.5
     pause 0.2
     if contains("$righthand","(grass|vine|rope)") then put drop my $righthand
     if contains("$lefthand","(grass|vine|rope)") then put drop my $lefthand
     pause 0.4
     pause 0.5
if "$righthand" != "Empty" then put empty right
if "$lefthand" != "Empty" then put empty left
pause 0.5
put #parse DONE BRAIDING
put #parse BRAIDING DONE
put #parse BRAIDING DONE
exit

KICK.PILE:
pause 0.1
if !matchre("$roomobjs","(pile of coins|pile of coin|pile of rocks|pile of grass)") then RETURN
matchre RETURN ^I could not|^What were you
matchre KICK.PILE foot smashing down
matchre STAND ^You can't do that from your position
match DELAY footing at the last moment
put kick pile
matchwait 20
goto FORAGE.EXP

STAND:
put stand
goto KICK.PILE

DELAY:
pause 11
put stand
goto KICK.PILE

####################################################################################
AUTOMOVE:
     delay 0.0001
     var Destination $0
     var automovefailCounter 0
     if (!$standing) then gosub AUTOMOVE_STAND
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     delay 0.0001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     put #goto %Destination
     matchwait
AUTOMOVE_STAND:
     pause 0.1
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry\,
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing\.
     send stand
     matchwait
AUTOMOVE_FAILED:
     evalmath automovefailCounter (automovefailCounter + 1)
     if (%automovefailCounter > 5) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.5
     pause 0.1
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     put #echo
     put #echo >$Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >$Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
     exit
AUTOMOVE_RETURN:
     return