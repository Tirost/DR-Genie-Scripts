####
#### UTILITY SUBS
####
#### 26 April, 2015
 
#### EMPTY HANDS SUB
EMPTY_HANDS:
     pause 0.0001
     if ("$righthand" != "Empty") then gosub STOW $righthandnoun
     if ("$lefthand" != "Empty") then gosub STOW $lefthandnoun
     return
 
leaveportal:
	gosub automove portal
	move portal
	return
	
enterportal:
	move portal
	gosub automove 45
	return
	
### ORDERING SUB, FOR SHOPS
ORDER:
     var Order $0
     var LOCATION ORDER_1
     ORDER_1:
     pause 0.1
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre ORDER_1 ^The attendant says\,\s*\"You can purchase .*\.\s*Just order it again and we'll see it done\!\"
     matchre RETURN ^The attendant takes some coins from you and hands you .*\.
     send order %Order
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN ORDER! (utility.inc) ***
     put #echo >$Log Crimson $datetime Order = %Order
     put #log $datetime MISSING MATCH IN ORDER! (utility.inc)
     return
 
#### PUT SUB
PUT:
     var Command $0
     var LOCATION PUT_1
     pause 0.0001
     PUT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre PUT_STOW ^You need a free hand
     matchre WAIT ^\[Enter your command again if you want to\.\]
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^You sit down
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^Please rephrase that command\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^.* what\?
     matchre RETURN ^You find a hole
     matchre RETURN ^You (?:hand|touch|push|move|put|tap|drop|place|toss|set|add) .*(?:\.|\!|\?)
     matchre RETURN ^Your .*\.
     matchre RETURN ^You don't have a .* coin on you\!\s*The .* spider looks at you in forlorn disappointment\.
     matchre RETURN ^The .* spider turns away\, looking like it's not hungry for what you're offering\.
     matchre RETURN ^Brother Durantine nods slowly\.
     matchre RETURN ^Durantine waves a small censer over a neatly-wrapped package and intones a short prayer before he hands it to you\.
     matchre RETURN ^After a moment\, .*\.
     matchre RETURN ^Quietly touching your lips with the tips of your fingers as you kneel\, you make the Cleric's sign with your hand\.
     matchre RETURN ^Maybe you should stand up\.
     matchre RETURN ^You sense a successful empathic link has been forged|^Touch what|^I could not find
     matchre RETURN ^The clerk counts out .*\.
     matchre RETURN ^The .* is not damaged enough to warrant repair\.
     matchre RETURN ^There is no more room in .*\.
     matchre RETURN ^There is nothing in there\.
     matchre RETURN ^In the .* you see .*\.
     matchre RETURN ^This spell cannot be targeted\.
     matchre RETURN ^You cannot figure out how to do that\.
     matchre RETURN ^You will now store .* in your .*\.
     matchre RETURN ^You.*analyze
	 matchre RETURN ^You lay your hand upon
     matchre RETURN ^You glance down .*\.
     matchre RETURN ^You glance heavenward
     matchre RETURN ^You turn .*\.
     matchre RETURN ^You chatter away\.\.\.
     matchre RETURN ^You are now
     matchre RETURN ^You search
	 matchre RETURN ^You get
     matchre RETURN ^You have nothing to 
     matchre RETURN ^That tool does not seem suitable for that task\.
     matchre RETURN ^There isn't any more room in .* for that\.
     matchre RETURN ^You are already focusing your appraisal on a subject\.
     matchre RETURN ^You are already under the effects of an appraisal focus\.
     matchre RETURN ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
     matchre RETURN ^You can't seem to focus on that\.\s*Perhaps you're too mentally tired from researching similar principles recently\.
     matchre RETURN ^\s*LINK ALL CANCEL\s*\- Breaks all links
     # matchre RETURN ^
     matchre RETURN ^\s*Encumbrance\s*\:
     send %Command
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT! (utility.inc) ***
     put #echo >$Log Crimson $datetime Command = %Command
     put #log $datetime MISSING MATCH IN PUT (utility.inc)
     return

fold:
var fold $0
var LOCATION fold
pause
matchre WAIT ^\.\.\.wait|^Sorry\,
match fold but it doesn't come out quite
match fold make another fold
match fold a fold
match RETURN the final fold
put fold %fold
matchwait

CLEAN:
	put hold zills
	put get cloth
	pause 0.5
	put clean my zills with my cloth
	pause 0.5
	pause 0.5
	gosub STOW cloth
	put wear zills
	return
 
#### GET SUB
GET:
     var Get $0
     var LOCATION GET_1
     pause 0.0001
     GET_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre HOLD_1 ^But that is already in your inventory\.
     matchre RETURN ^You get .*\.
     matchre RETURN ^You pick up .*\.
     matchre RETURN ^You carefully remove .* from the bundle\.
     matchre RETURN ^You are already holding that\.
     matchre RETURN ^Get what\?
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^You grab .*(?:\.|\!|\?)
     matchre RETURN ^As best it can\, .* moves in your direction\.
     send get %Get
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN GET! (utility.inc) ***
     put #echo >$Log Crimson $datetime Get = %Get
     put #log $datetime MISSING MATCH IN GET (utility.inc)
     return
 
#### HOLD SUB
HOLD:
     var Get $0
     var LOCATION HOLD_1
     pause 0.0001
     HOLD_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^You sling .*\.
     matchre RETURN ^You get .*\.
     matchre RETURN ^You take .*\.
     matchre RETURN ^You pull .*\.
	 matchre RETURN ^You remove .*\.
	 matchre RETURN ^You loosen .*\.
     matchre RETURN ^You remove .* from your belt\.
     matchre RETURN ^You are already holding that\.
     matchre RETURN ^Get what\?
	 matchre RETURN ^Hold hands with whom
	 matchre RETURN ^You work your way out of
	 matchre RETURN ^You aren't
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?
     send hold %Get
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN HOLD! (utility.inc) ***
     put #echo >$Log Crimson $datetime Get = %Get
     put #log $datetime MISSING MATCH IN HOLD (utility.inc)
     return
 
#### STOW SUB
STOW:
     var Stow $0
     var LOCATION STOW_1
     pause 0.0001
     STOW_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre WEAR_CHECK ^.* is too long to fit in .*\.
     matchre RETURN ^You put .*\.
     matchre RETURN already in your inventory
     matchre RETURN ^You open your pouch and put .* inside\, closing it once more\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Stow what\?  Type 'STOW HELP' for details\.
	 matchre STOW_LEFT You need a free hand
     matchre STOW.UNLOAD ^You should unload
     send stow %Stow
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW! (utility.inc) ***
     put #echo >$Log Crimson $datetime Stow = %Stow
     put #log $datetime MISSING MATCH IN STOW (utility.inc)
     return
	 
STOW_LEFT:
	var LOCATION STOW_LEFT
	 matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre WEAR_CHECK ^.* is too long to fit in .*\.
     matchre STOW_LEFT1 ^You put .*\.
     matchre STOW_LEFT1 already in your inventory
     matchre STOW_LEFT1 ^You open your pouch and put .* inside\, closing it once more\.
     matchre STOW_LEFT1 ^What were you referring to\?
     matchre STOW_LEFT1 ^Stow what\?  Type 'STOW HELP' for details\.
     matchre STOW.UNLOAD ^You should unload
     send stow LEFT
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW! (utility.inc) ***
     put #echo >$Log Crimson $datetime Stow = %Stow
     put #log $datetime MISSING MATCH IN STOW (utility.inc)
     goto STOW_LEFT1
	 
STOW_LEFT1:
	var LOCATION STOW_1
	goto STOW_1
	

STOW.UNLOAD:
    pause 0.0001
    gosub UNLOAD
    gosub STOW $righthandnoun
    gosub STOW $lefthandnoun
    return
 
#### WEAR SUB
WEAR_CHECK:
	 	 if matchre("$righthand", "stone quarterstaff|stone lance") then 
		{
		put drop $righthand
		return
		}
		goto WEAR_1
WEAR:
     var Stow $0
     var LOCATION WEAR_1
     pause 0.0001
     WEAR_1:

     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre STOW_1 ^You can't wear that\!
     matchre STOW_1 ^You can't wear any more items like that\.
     matchre STOW_1 ^This .* can't fit over the .* you are already wearing which also covers and protects your .*\.
     matchre RETURN ^You (?:sling|put|slide|slip|attach|work|strap) .*\.
     matchre RETURN ^You are already wearing that\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Wear what\?
     send wear %Stow
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN WEAR! (utility.inc) ***
     put #echo >$Log Crimson $datetime Stow = %Stow
     put #log $datetime MISSING MATCH IN WEAR (utility.inc)
     return
 
#### DOUBLE PUT SUB
PUT_IT:
     var PutIt $0
     var LOCATION PUT_IT_1
     pause 0.0001
     PUT_IT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^You (?:put|drop) .*\.
     matchre RETURN ^Please rephrase that command\.
     matchre RETURN ^.* what\?
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?
     send put %PutIt
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT_IT! (utility.inc) ***
     put #echo >$Log Crimson $datetime PutIt = %PutIt
     put #log $datetime MISSING MATCH IN PUT_IT (utility.inc)
     return
 
#### COMBAT ATTACK SUBS
ATTACK:
     if ($stamina < 85) then waiteval ($stamina >= 95)
     var LOCATION ATTACK_1
     pause 0.0001
     ATTACK_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre ATTACK_1 ^You can not slam with .*\!
	 matchre CALM ^Strangely, you don't feel like fighting right now
     matchre RETURN ^There is nothing else to face
     matchre RETURN ^You aren't close enough to attack
     matchre RETURN ^You turn to face
     matchre RETURN ^You spin around to face
     matchre RETURN ^You stop advancing because
     matchre RETURN ^At what are you trying to .*\?
     send attack
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN ATTACK! (utility.inc) ***
     put #log $datetime MISSING MATCH IN ATTACK (utility.inc)
     goto ATTACK
DRAW:
     var LOCATION DRAW_1
     pause 0.0001
     DRAW_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
	 matchre CALM ^Strangely, you don't feel like fighting right now
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^There is nothing else to face
     matchre RETURN ^You aren't close enough to attack
     matchre RETURN ^You turn to face
     matchre RETURN ^You spin around to face
     matchre RETURN ^You stop advancing because
     matchre RETURN ^At what are you trying to .*\?
     send draw
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN DRAW! (utility.inc) ***
     put #log $datetime MISSING MATCH IN DRAW (utility.inc)
     goto DRAW
FEINT:
     var LOCATION FEINT_1
     pause 0.0001
     FEINT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
	 matchre CALM ^Strangely, you don't feel like fighting right now
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^There is nothing else to face
     matchre RETURN ^You aren't close enough to attack
     matchre RETURN ^You turn to face
     matchre RETURN ^You spin around to face
     matchre RETURN ^You stop advancing because
     matchre RETURN ^At what are you trying to .*\?
     send feint
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN FEINT! (utility.inc) ***
     put #log $datetime MISSING MATCH IN FEINT (utility.inc)
     goto FEINT
GOUGE:
     var LOCATION GOUGE_1
	 var gouge $0
     pause 0.0001
     GOUGE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
	 matchre CALM ^Strangely, you don't feel like fighting right now
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^There is nothing else to face
     matchre RETURN ^You aren't close enough to attack
     matchre RETURN ^You turn to face
     matchre RETURN ^You spin around to face
     matchre RETURN ^You stop advancing because
     matchre RETURN ^At what are you trying to .*\?
     send gouge %gouge
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN GOUGE! (utility.inc) ***
     put #log $datetime MISSING MATCH IN GOUGE (utility.inc)
     goto GOUGE	 
	 

Tactics:
action (combo) on
var comboreturn 1
var LOCATION Tactics
match WAIT You must be closer
matchre MELEE ^You have just recently completed that attack combination, and cannot repeat it so soon.
#matchre gcombo With a keen eye
#matchre combo.attack by landing a (\S+)
matchre gcombo Balance|A chance|Armor|Increased|You recall|Stronger
matchre gcombo small|good|great|large|massive|exceptional|substantial
match Tactics You fail
match Tactics Roundtime
matchre FACE.ANA Analyze what\?
put ana %analyze
matchwait

FACE.ANA:
gosub FACE_NEXT
goto melee

gcombo:
pause 1
gosub combo
if matchre("$roomobjs", "(that|which) appears dead") then goto dead
goto count

combo:
eval combo replacere("%combo", "(?:\s)?(?:,|and)? an?(?:\s)", "|")
eval combo replacere("%combo", "\|+", "|")
#var combo |%combo|
eval total count("%combo", "|")  
action (combo) off
counter set 0
pause 0.5

Loop:  
	if %comboreturn = 0 then return
     gosub combo.attack %combo(%c)
     if %c > %total then return
     goto Loop
      
combo.attack:
var attack $1
counter add 1
if "%attack" = "" then return
ANA.ATTACK:
	var LOCATION ANA_ATTACK_1
     pause 0.0001
     ANA_ATTACK_1:
	if $spellweave = 1 && "$preparedspell" = "None" then gosub spellcheck
	if $spellweave = 1 then gosub spelltime
     if ($stamina < 85) then waiteval ($stamina >= 95)
     var LOCATION ANA_ATTACK_1
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
	 matchre CALM ^Strangely, you don't feel like fighting right now
	 MATCHRE return ^There is nothing else to face
	 matchre RETURN ^Wouldn't it be better if you used a melee weapon\?
	 matchre WAIT ^You aren't close enough to attack
     match RETURN hit
     match RETURN strike
	 match ANA_ATTACK_1 Roundtime
     send %attack
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN ANA.ATTACK! (utility.inc) Last Command: $lastcommand ***
     put #log $datetime MISSING MATCH IN ATTACK (utility.inc)
     goto ATTACK
	 
#### CALM
CALM:
	match %LOCATION You suddenly feel considerably less calm than you have been.
	matchwait 5
	goto %LOCATION

 
#### FACING SUBS
FACE:
     pause 0.0001
     gosub FACE_NEXT
     goto ASSESS
FACE_NEXT:
     var LOCATION FACE_NEXT_1
     pause 0.0001
     FACE_NEXT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^You turn
     matchre RETURN ^There is nothing else to face\!
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Face what\?
     send face next
     matchwait
 
#### TM SPELL SUBS
TARGET_PREP:
     var TargetPrep $0
     var LOCATION TARGET_PREP_1
     pause 0.0001
     TARGET_PREP_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre TARGET_RELEASE ^There is no need to target a .*\.  It is already dead\.
     matchre TARGET_RELEASE ^I could not find what you were referring to\.
     matchre TARGET_RELEASE ^You are not engaged to anything, so you must specify a target to focus on\!
	 matchre TARGET_RELEASE ^You can't cast that at yourself
     matchre RETURN ^You begin to weave mana lines into a target pattern around .*\.
	 matchre RETURN ^You begin to weave mana lines into a targeting pattern centered around yourself
     matchre RETURN ^You begin chanting a psalm to invoke the .* spell\.
     send target %TargetPrep
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN TARGET_PREP! (utility.inc) ***
     put #log $datetime MISSING MATCH IN TARGET_PREP (utility.inc)
     return
TARGET_WAIT:
     matchre TARGET_RELEASE ^Your concentration slips for a moment, and your spell is lost\.
     matchre TARGET_RELEASE ^Your secondary spell pattern dissipates because your target is dead, but the main spell remains intact\.
     matchre TARGET_CAST ^You feel fully prepared to cast your spell\.
     matchre TARGET_CAST ^Your target pattern has finished forming around the area\.
     matchre TARGET_CAST ^The formation of the target pattern around .* has completed\.
     matchre TARGET_CAST ^Your formation of a targeting pattern around .* has completed\.
     matchwait
TARGET_CAST:
     var LOCATION TARGET_CAST_1
     pause 0.0001
     TARGET_CAST_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre TARGET_RELEASE ^You don't have a spell prepared\!
     matchre TARGET_RELEASE ^.* is already dead, so that's a bit pointless\.
	 matchre TARGET_RELEASE ^Your target pattern dissipates because the.* is dead, but the main spell remains intact\.
     matchre TARGET_RELEASE ^Your secondary spell pattern dissipates because your target is dead, but the main spell remains intact\.
	 matchre RETURN ^You can't cast that at yourself\!
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^Focus the power of justice on whom\?
     matchre RETURN ^You gesture
     send cast
     matchwait
TARGET_RELEASE:
     gosub RELEASE Spell
     return
 
#### HUNT SUB
HUNT:
     var LOCATION HUNT_1
     pause 0.0001
     HUNT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You find yourself unable to hunt in this area\.
     matchre RETURN ^You take note of all the tracks in the area\, so that you can hunt anything nearby down\.
     send hunt
     matchwait
 
##### CRITTER APPRAISAL SUB
APPRAISE_CRITTER:
     pause 0.0001
	 evalmath timeSinceLastAppraise ($gametime-%lastAppraise)
	 if %timeSinceLastAppraise < 120 then return
     var Critter NULL
     if matchre("$monsterlist" , "$KnownMonsters") then var Critter $0
     if ("%Critter" = "NULL") then return
     gosub APPRAISE %Critter quick
     return
 
##### APPRAISAL SUB
APPRAISE:
     var Appraise $0
     var LOCATION APPRAISE_1
     pause 0.0001
	 var lastAppraise $gametime
     APPRAISE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^It's dead\!
     matchre RETURN ^Appraise what\?
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^You cannot appraise that when you are in combat\!
     matchre RETURN ^You can't determine anything about this creature\.
     matchre RETURN ^It's hard to appraise the .* when it's inside something\.
     matchre RETURN ^Appraise what\?  Type APPRAISE HELP for more information\.
     matchre RETURN ^You ponder that\, briefly\, but decide to let it go for now\.
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     send appraise %Appraise
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN APPRAISE! (utility.inc) ***
     put #echo >$Log Crimson $datetime Appraise = %Appraise
     put #log $datetime MISSING MATCH IN APPRAISE! (utility.inc)
     return
 
#### STUDYING SUB
STUDY:
     var Study $0
     var LOCATION STUDY_1
     pause 0.0001
     STUDY_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     match STUDY_1 You begin
     match STUDY_1 You continue studying the
     match STUDY_1 You continue to study
     match RETURN You take on a studious look
     match STUDY_END Why do you need to study this chart again?
     matchre STUDY_NEXT (^With|^In) a sudden moment of clarity
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     send study %Study
     matchwait

STUDY_NEXT:
     var LOCATION STUDY_1
     pause 0.0001
     matchre WAIT ^\.\.\.wait|^Sorry\,
     match STUDY_END What
     match STUDY_END I could not
     match STUDY You turn
     send turn %Study
     matchwait

STUDY_END:
     return
 
#### HIDING SUB
HIDE:
     var hideCounter 0
     var LOCATION HIDE_1
     pause 0.0001
     HIDE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre HIDE_INCREMENT ^.* notices your attempt to hide\!
     matchre HIDE_INCREMENT ^.* reveals you, ruining your hiding attempt\!
     matchre HIDE_INCREMENT ^.* discovers you, ruining your hiding place\!
	 matchre RETURN ^You can't hide in all this armor
     matchre RETURN ^You slip into a hiding
     matchre RETURN ^You melt into the background
     matchre RETURN ^Eh\?  But you're already hidden\!
     matchre RETURN ^You blend in with your surroundings
     send hide
     matchwait
HIDE_INCREMENT:

     math hideCounter add 1
     if %hideCounter > 1 then return
     goto HIDE_1

STALK:
     var LOCATION STALK_1
     pause 0.0001
     STALK_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^.* notices your attempt to stalk
     matchre RETURN ^.* reveals you, ruining your stalking attempt\!
     matchre RETURN ^.* discovers you, ruining your hiding place\!
     matchre RETURN ^Stalking is an inherently stealthy endeavor
     matchre RETURN ^You move into position
     matchre RETURN Stalk what?
     matchre RETURN ^You're already stalking
     matchre RETURN ^Eh\?  But you're already hidden\!
     matchre RETURN ^You blend in with your surroundings
     put stalk
     matchwait
 
#### UNHIDING SUB
UNHIDE:
     var LOCATION UNHIDE_1
     pause 0.0001
     UNHIDE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^But you are not hidden\!
     matchre RETURN ^You come out of hiding\.
     send UNHIDE
     matchwait
 
##### STANDING SUB
STAND:
     var LOCATION STAND_1
     pause 0.0001
     STAND_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre WAIT ^The weight of all your possessions prevents you from standing\.
     matchre WAIT ^You are overburdened and cannot manage to stand\.
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre STAND_RETURN ^You stand (?:back )?up\.
     matchre STAND_RETURN ^You are already standing\.
     send stand
     matchwait
     STAND_RETURN:
     pause 0.1
     pause 0.1
     if (!$standing) then goto STAND
     return
 
####  RANGED SUB
UNLOAD:
     var LOCATION UNLOAD_1
     pause 0.0001
     UNLOAD_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
	 matchre UNLOADSTOW ^Your (.*) falls? from your (?:.*)\.
     matchre RETURN ^You unload .*\.
     matchre RETURN ^But your .* isn't loaded\!
     matchre UNLOADLEFTCHECK ^You don't have a ranged weapon to unload\.
     matchre RETURN ^You must be holding the weapon to do that\.
	 matchre WEBBED ^You can't do that while entangled in a web
     send unload
     matchwait
	 
UNLOADSTOW:
	put stow $1
	return
	
UNLOADLEFTCHECK:
	if "$lefthand" != "Empty" then 
		{
		put swap
		goto UNLOAD
		}
	return

LOAD:
     var LOCATION LOAD_1
     pause 0.0001
     LOAD_1:
     matchre WAIT ^\.\.\.wait|^Sorry, you may only type ahead 
     matchre RETURN You reach into your 
     matchre RETURN (Your|A|The|But).*is already loaded with 
     matchre RETRIEVE.CHECK You don't have the (right|proper) ammunition 
     matchre RETRIEVE.CHECK As you try to 
	 matchre WEBBED ^You can't do that while entangled in a web
     matchre LOAD.STOW .*in your(?: left)? hand 
     put LOAD 
     matchwait 3
	 goto LOAD_1
	 
DUAL_LOAD:
     var LOCATION DUAL_LOAD_1
     pause 0.0001
     DUAL_LOAD_1:
     matchre WAIT ^\.\.\.wait|^Sorry, you may only type ahead 
     matchre RETURN You reach into your 
     matchre RETURN (?:Your|A|The|But).*is already loaded with 
	 matchre LOAD ^You focus on the image of an eagle but are unable to draw upon its majesty
     matchre RETRIEVE.CHECK You don't have the (right|proper) ammunition 
     matchre RETRIEVE.CHECK As you try to 
	 matchre WEBBED ^You can't do that while entangled in a web
     matchre LOAD.STOW .*in your(?: left)? hand 
     put LOAD MY ARROWS
     matchwait 

AIM:
var LOCATION AIM_1
     pause 0.0001
	 var aimtime $gametime
AIM_1:
     matchre WAIT ^\.\.\.wait|^Sorry, you may only type ahead 
     matchre RETURN You begin to target 
     matchre RETURN You are already targetting that\! 
     matchre RETURN You shift your target
     matchre RETURN ^There is nothing else to face\! 
     matchre RETURN isn't loaded\.$
	 matchre AIM_STOW You need both hands in order to aim.
	 matchre WEBBED ^You can't do that while entangled in a web
     put AIM 
     matchwait 

AIM_STOW:
	send stow left
	pause 0.5
	goto AIM_1

SHOOT:
var LOCATION SHOOT_1
var shoot $0
     pause 0.0001
     if ($stamina < 85) then waiteval ($stamina >= 95)
SHOOT_1:
	match count I could not find what you were 
	match count There is nothing else to face! 
	matchre WAIT ^\.\.\.wait|^Sorry\,
	matchre CALM ^Strangely, you don't feel like fighting right now
	match POACH_CHANGE How can you poach if you are not hidden
	match RETURN you.] 
	match RETURN position.] 
	match RETURN opponent.] 
	match RETURN advantage.]  
	match RETURN balanced] 
	match RETURN balance] 
	match WEBBED You can't do that while entangled in a web
	put %shoot
	matchwait 

POACH_CHANGE:
	var shoot shoot
	goto SHOOT_1

LOAD.STOW:
	pause 0.1
	put stow left
	goto LOAD
 
#### WEAPON MANAGEMENT SUBS
WIELD:
     var Item $0
     var LOCATION WIELD_1
     pause 0.0001
     WIELD_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You draw
     matchre RETURN ^You're already holding .*\!
     matchre RETURN ^Your .* is too injured to draw .*\!
	 matchre RETURN ^You can only wield
     matchre GET_WEAPON_1 ^You find it difficult to 
     matchre GET_WEAPON_1 ^You can't seem to find
     matchre REMOVE_WEAPON_1 ^Wield what\?
     matchre REMOVE_WEAPON_1 ^What were you referring to\?
     matchre REMOVE_WEAPON_1 ^You're wearing a.*\!  You'll need to remove it first\!
     send wield %Item
     matchwait

REMOVE_WEAPON:
     var Item $0
     var LOCATION REMOVE_WEAPON_1
     pause 0.0001
     REMOVE_WEAPON_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre GET_WEAPON_1 ^Remove what\?
     matchre GET_WEAPON_1 ^What were you referring to\?
     matchre RETURN ^You remove .* from your belt\.
     matchre RETURN ^You sling .* off from over your shoulder\.
     matchre RETURN ^You yank your
     send remove %Item
     matchwait

GET_WEAPON:
     var Item $0
     var LOCATION GET_WEAPON_1
     pause 0.0001
     GET_WEAPON_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^Get what\?
     matchre RETURN ^You are already
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^You pick up
     matchre RETURN ^You remove .* from your belt\.
     matchre RETURN ^You sling .* off from over your shoulder\.
     send get %Item
     matchwait
SHEATH:
     var Item $0
     var LOCATION SHEATH_1
     pause 0.0001
     SHEATH_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You slip
     matchre RETURN ^You sheathe
     matchre RETURN ^Sheathe what\?
     matchre RETURN ^Sheathe your.*where\?
     matchre RETURN ^A .* is too long to fit in .*\.
     matchre RETURN ^The .* is too long to fit in .*\.
     send sheath %Item
     matchwait
 
#### BUNDLE COUNTING SUBS
BUNDLE_COUNT:
     var LOCATION BUNDLE_COUNT_1
     pause 0.0001
     BUNDLE_COUNT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre BUNDLE_SET_ZERO ^What were you referring to\?
     matchre BUNDLE_SET_ZERO ^I could not find what you were referring to\.
     matchre BUNDLE_SET ^You flip through .* and find (\d+) skins? in it\.
     send count my bundle
     matchwait
BUNDLE_SET:
     pause 0.0001
     put #tvar bundleFull 0
     put #tvar bundleCount $1
     if ($bundleCount > 199) then put #tvar bundleFull 1
     return
BUNDLE_SET_ZERO:
     pause 0.0001
     put #tvar bundleFull 0
     put #tvar bundleCount 0
     return
 
#### FORAGING SUBS
FORAGE:
     var Forage $0
     var LOCATION FORAGE_1
     pause 0.0001
     FORAGE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre RETURN ^You cannot forage while in combat
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You manage to find .*\.
     matchre RETURN ^The room is too cluttered to find anything here\!
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     send forage %Forage
     matchwait
COLLECT:
     var Collect $0
     var LOCATION COLLECT_1
     pause 0.0001
     COLLECT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
	 matchre STOW_LEFT ^You really need to have at least one hand free 
	 matchre RETURN ^Best not risk disrupting the spell pattern that way.
     matchre RETURN ^You manage to collect a pile of .*\.
     matchre RETURN ^The room is too cluttered to find anything here\!
	 matchre RETURN ^You cannot collect anything while in combat\!
	 matchre RETURN ^You move .*, hoping to find a better foraging spot.|Mindlessly you begin to forage
	 matchre RETURN ^You forage around but are unable to find|You begin to forage around, but|You are certain you could find what you were looking for, if you had a bit more luck\.|You forage around but are unable to find anything
     matchre WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     send collect %Collect
     matchwait
KICKEM:
     if matchre("$roomobjs" , "a pile of \S+") then gosub KICKIT
     if matchre("$roomobjs" , "a pile of \S+") then gosub KICKIT
	 if !($standing) then gosub STAND
     return
KICKIT:
     var LOCATION KICKIT_1
	 if !($standing) then gosub STAND
     pause 0.0001
     KICKIT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^You take a step back and run up to the pile of .*\.
     send kick pile
     matchwait
 
#### SPELL CASTING
PREPARE:
     var Prepare $0
     var LOCATION PREPARE_1
     pause 0.0001
     PREPARE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
	 matchre SPELL_CAST_RETURN ^But you've already prepared the
     matchre SPELL_CAST_RETURN ^You have already fully prepared
     matchre SPELL_CAST_RETURN ^You are already preparing the .* spell\!
     matchre SPELL_CAST_RETURN ^You begin chanting .* to invoke the .* spell\.
     matchre SPELL_CAST_RETURN ^You mutter .* to yourself while preparing the .* spell\.
     matchre SPELL_CAST_RETURN ^With .* movements you prepare your body for the .* spell\.
     matchre SPELL_CAST_RETURN ^You raise your .* skyward\, chanting the .* of the .* spell\.
     matchre SPELL_CAST_RETURN ^You rock back and forth\, humming tunelessly as you invoke the .* spell\.
     matchre SPELL_CAST_RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
     matchre SPELL_CAST_RETURN ^Your eyes darken to black as a starless night as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^You close your eyes and breathe deeply, gathering energy for the .* spell\.
     matchre SPELL_CAST_RETURN ^You trace an arcane sigil in the air\, shaping the pattern of the .* spell\.
     matchre SPELL_CAST_RETURN ^Your eyes darken to black as a starless night as you prepare the .* spell\.
	 matchre SPELL_CAST_RETURN ^You trace a geometric sigil in the air, shaping the pattern of the .* spell\.
     matchre SPELL_CAST_RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
     matchre SPELL_CAST_RETURN ^A soft breeze surrounds your body as you confidently prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^Tiny tendrils of lightning jolt between your hands as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^Heatless orange flames blaze between your fingertips as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^Entering a trance-like state\, your hands begin to tremble as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^You adeptly sing the incantations for the .* spell\, setting the words to a favorite tune\.
     matchre SPELL_CAST_RETURN ^You bring your hand slowly to your forehead as you begin chanting the words of the .* spell\.
     matchre SPELL_CAST_RETURN ^Icy blue frost crackles up your arms with the ferocity of a blizzard as you begin to prepare the .* spell\!
     matchre SPELL_CAST_RETURN ^You have to strain to harness the energy for this spell, and you aren't sure you can get enough to cast it\.
     matchre SPELL_CAST_RETURN ^You giggle to yourself as you move through the syncopated gestures that accompany the preparations of the .* spell\.
     matchre SPELL_CAST_RETURN ^Darkly gleaming motes of sanguine light swirl briefly about your fingertips as you gesture while uttering the .* spell\.
     matchre SPELL_CAST_RETURN ^As you begin to solemnly intone the .* spell a blue glow swirls about forming a nimbus that surrounds your entire being\.
     matchre SPELL_CAST_RETURN ^Your skin briefly withers and tightens\, becoming gaunt as the energies of the .* spell begin to build up through your body\.
     matchre SPELL_CAST_RETURN ^You trace an intricate rune in the air with your finger\, illusory lines lingering several seconds as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^You begin reciting a solemn incantation\, causing familiar patterns of geometric shapes to circle your hand as the .* spell forms\.
     matchre SPELL_CAST_RETURN ^You take up a handful of dirt in your palm to prepare the .* spell\.  As you whisper arcane words\, you gently blow the dust away and watch as it becomes swirling motes of glittering light that veil your hands in a pale aura\.
     matchre SPELL_CAST_RETURN ^You recall the exact details
     matchre SPELL_CAST_RETURN ^But you've already prepared the Chaos symbiosis
     matchre SPELL_CAST_DONE ^What do you want to prepare\?
     matchre SPELL_CAST_DONE ^That is not a spell you can cast\.
     matchre SPELL_CAST_DONE ^You wouldn't have the first clue how to do that\.
     matchre SPELL_CAST_DONE ^You stop\, convinced that there's no way to control that much mana\.
     matchre SPELL_CAST_FAIL ^You have to strain to harness the energy for this spell, and you aren't sure you can get enough to cast it\.
     send prepare %Prepare
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PREPARE! (utility.inc) ***
     put #echo >$Log Crimson $datetime Prepare = %Prepare
     put #log $datetime MISSING MATCH IN PREPARE! (utility.inc)
     goto SPELL_CAST_RETURN
SPELL_WAIT:
     if ("$preparedspell" = "None") then return
     matchre SPELL_CAST ^You feel fully prepared to cast your spell\.
     matchre SPELL_CAST_FAIL ^Your concentration slips for a moment\, and your spell is lost\.
	 matchre SPELL_CAST_FAIL ^You have lost the spell you were preparing\.
     matchwait
SPELL_CAST:
     var LOCATION SPELL_CAST_1
     pause 0.0001
     SPELL_CAST_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
	 matchre RELEASE_SPELL ^You can't cast that at yourself
     matchre SPELL_CAST_DONE ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre SPELL_CAST_DONE ^You wave your hand\.
     matchre SPELL_CAST_DONE ^You gesture
     matchre SPELL_CAST_DONE ^I don't see anyone bringing any dead out anytime soon 
     matchre SPELL_CAST_DONE ^Focus the power of justice on whom\?
     matchre SPELL_CAST_FAIL ^You don't have a spell prepared\!
     matchre SPELL_CAST_FAIL ^Your concentration slips for a moment\, and your spell is lost\.
	 if "$preparedspell" = "Ignite" then
		{
		send release ignite
		if "$righthand" != "Empty" then put -1 cast $righthandnoun;-2 gesture
		if "$lefthand" != "Empty" then put -1 cast $lefthandnoun;-2 gesture
		}
     else put -cast;-2 gesture
     matchwait
SPELL_WAIT_TARGET:
     if ("$preparedspell" = "None") then return
     matchre RETURN ^You feel fully prepared to cast your spell\.
     matchre RETURN ^Your concentration slips for a moment\, and your spell is lost\.
     matchwait
SPELL_CAST_TARGET:
     var Target $0
     var LOCATION SPELL_CAST_TARGET_1
     pause 0.0001
     SPELL_CAST_TARGET_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre SPELL_CAST_DONE ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre SPELL_CAST_DONE ^You gesture
     matchre SPELL_CAST_DONE ^Focus the power of justice on whom\?
     matchre SPELL_CAST_FAIL ^You don't have a spell prepared\!
     matchre SPELL_CAST_FAIL ^Your concentration slips for a moment\, and your spell is lost\.
     put -cast %Target;-2 gesture
     matchwait
SPELL_CAST_DONE:
     put #queue clear
     pause 0.0001
     return
SPELL_CAST_FAIL:
     gosub RELEASE MANA
SPELL_CAST_RETURN:
     pause 0.0001
     return
RELEASE_MANA:
     pause 0.0001
     gosub RELEASE
     echo *****************************************************
     echo ***** ATTUNEMENT IS LOW.  WAITING TO REGAIN IT. *****
     echo *****************************************************
     if $mana < 80 then waiteval $mana >= 80
CHECK_MANA:
     pause 0.0001
     if $mana < 10 then goto RELEASE_MANA
     return
RELEASE_SPELL:
	var Release spell
	goto RELEASE_1
RELEASE:
     var Release $0
     var LOCATION RELEASE_1
     pause 0.0001
     RELEASE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^\s*Encumbrance\s*\:
     put -release %Release;-encumbrance
     matchwait
HARNESS:
     var Harness $0
     var LOCATION HARNESS_1
     pause 0.0001
     HARNESS_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RELEASE ^You strain, but cannot harness that much power\.
     matchre RETURN ^You tap into the mana from .* of the surrounding streams and
     send harness %Harness
     matchwait

CHARGE_ORB:
     var Charge $0
     var LOCATION CHARGE_ORB_1
     pause 0.0001
CHARGE_ORB_1:
	if $Attunement.Ranks < 600 then
		{
		gosub HARNESS %Charge
		pause 1
		}
  	matchre WAIT ^\.\.\.wait|^Sorry\,
	match CHARGE_ORB_1 as if it hungers for more
	match RETURN having reached its full capacity
	match CHARGE_ORB_1 You strain
	match CHARGE_ORB_1 backfire
	match RETURN You sense that it cannot accept any more power
	match RETURN unable 
	match RETURN A sense of fullness emanates from the 
	match RETURN You don't have a spell prepared
	match cast.orb You do not
	put infuse OM %Charge
	matchwait 15
	return

cast.orb:
pause 0.1
put prep om 20
waitfor fully prepared
put cast orb
pause 2
goto CHARGE_ORB_1
 
#### ARCANA SUBS
CHARGE:
     var Charge $0
     var LOCATION CHARGE_1
     pause 0.0001
     CHARGE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^The .* absorbs .* of the energy\.
     matchre RETURN ^You fail to channel any energy into the .* \.
     matchre RETURN ^You strain, but cannot harness that much power\.
     matchre RETURN ^You fail to channel any of the energy into .*\.
     matchre RETURN ^You strain\, but lack the mental stamina to charge .* this much\.
     matchre RETURN ^The .* is already holding as much power as you could possibly charge it with\.
     matchre RETURN ^The .* resists\, only absorbing part of the energy while the rest dissipates harmlessly\.
     send charge %Charge
     matchwait
INVOKE:
     var Invoke $0
     var LOCATION INVOKE_1
     pause 0.0001
     INVOKE_1:
     pause 0.0001
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^Your link to the .* is intact
     matchre RETURN
     matchre RETURN ^The .* dim\, almost magically null\.  A very faint pattern indicates its readiness to absorb .*energy\.
     matchre RETURN ^The .* pulses .* energy\.  You reach for its center and forge a magical link to it\, readying .* mana for your use\.
     matchre INVOKE_1 ^The .* pulses .* energy\.  You reach for its center\, attempting to forge a magical link\, but fail\.
     send invoke %Invoke
     matchwait
REMOVE_CAMBRINTH:
     var cambrinth $0
     var LOCATION REMOVE_CAMBRINTH_1
     pause 0.0001
     REMOVE_CAMBRINTH_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You slide
     matchre RETURN ^You remove
     matchre RETURN ^You take off
     send remove my %cambrinth
     matchwait
WEAR_CAMBRINTH:
     var cambrinth $0
     var LOCATION WEAR_CAMBRINTH_1
     pause 0.0001
     WEAR_CAMBRINTH_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You hang
     matchre RETURN ^You slide
     matchre RETURN ^You place
     matchre RETURN ^You attach
     matchre RETURN ^You put on
     matchre RETURN ^Wear what\?
     matchre RETURN ^You are already wearing that\.
     send wear my %cambrinth
     matchwait
 
#### FOCUS SUB
FOCUS:
     var focus $0
     var LOCATION FOCUS_1
     pause 0.0001
     FOCUS_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You focus your magical senses on .*\.
     send focus %focus
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN FOCUS! (utility.inc) ***
     put #log $datetime MISSING MATCH IN FOCUS! (utility.inc)
     return
 
#### PERCEIVE POWER SUB
PERCEIVE:
     var LOCATION PERCEIVE_1
     pause 0.0001
     PERCEIVE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^There isn't the slightest trace
     matchre RETURN ^You cannot detect the slightest trace
     matchre RETURN ^You aren't trained in the ways of magic\.
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^You aren't trained in the ways of magic\, but you fake it\.
     send perceive
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PERCEIVE! (utility.inc) ***
     put #log $datetime MISSING MATCH IN PERCEIVE! (utility.inc)
     return
 
#### PERCEIVE HEALTH SUBS
PERCEIVE_HEALTH:
     var LOCATION PERCEIVE_HEALTH_1
     pause 0.0001
     PERCEIVE_HEALTH_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre PERCEIVE_RETURN ^You sense.*
     matchre PERCEIVE_RETURN ^You fail to sense anything\, however\.
     matchre PERCEIVE_PAUSE ^You're not ready to do that again\, yet\.
     send perceive health
     matchwait
PERCEIVE_RETURN:
     pause 0.1
     return
PERCEIVE_PAUSE:
     pause 5
     goto PERCEIVE_HEALTH
 
#### CATCH AND RETRY SUBS
WAIT:
     pause 0.0001
     pause 0.1
     if (!$standing) then gosub STAND
     goto %LOCATION
WEBBED:
     pause 0.0001
     if ($webbed) then waiteval (!$webbed)
     if (!$standing) then gosub STAND
     goto count
IMMOBILE:
     pause 0.0001
     if contains("$prompt" , "I") then pause 20
     if (!$standing) then gosub STAND
     goto %LOCATION
STUNNED:
     pause 0.0001
     if ($stunned) then waiteval (!$stunned)
     if (!$standing) then gosub STAND
     goto %LOCATION

### RETREAT SUBS
RETREAT:
     var LOCATION Retreat
     matchre WAIT ^\.\.\.wait|^Sorry\,
     match RETURN You are already as far
     match RETREAT You retreat
     match RETREAT You stop advancing
     match RETREAT You sneak back out of combat.
	 match RETREAT You can't do that while
     match RETREAT You retreat from combat
     match RETREAT Roundtime
     match RETREAT pole range
     put retreat
     matchwait
 
#### STANCE SUB
####
####  To use STANCE SET, type STANCE SET [EVASION #] [PARRY #] [SHIELD #] {ATTACK #}.
####  Evasion, Parry, and Shield are all required, while Attack is optional.
####
STANCETO:
     eval stance tolower($1)
     delay 0.2
     if ("%stance" != "set") then
          {
               send stance %stance
               return
          }
     if ("$2" != "NULL") then var stance1 $2
     if ("$3" != "NULL") then var stance2 $3
     if ("$4" != "NULL") then var stance3 $4
     if ("$5" != "NULL") then var stance4 $5
     send stance %stance %stance1 %stance2 %stance3 %stance4
     return


convert.to.ordinal:
var ordinal.var.name $1
var ordinal.var.value $2
if %ordinal.var.value = 1 then
{
var %ordinal.var.name first
return
}
if %ordinal.var.value = 2 then
{
var %ordinal.var.name second
return
}
if %ordinal.var.value = 3 then
{
var %ordinal.var.name third
return
}
if %ordinal.var.value = 4 then
{
var %ordinal.var.name fourth
return
}
if %ordinal.var.value = 5 then
{
var %ordinal.var.name fifth
return
}
if %ordinal.var.value = 6 then
{
var %ordinal.var.name sixth
return
}
if %ordinal.var.value = 7 then
{
var %ordinal.var.name seventh
return
}
if %ordinal.var.value = 8 then
{
var %ordinal.var.name eighth
return
}
if %ordinal.var.value = 9 then
{
var %ordinal.var.name ninth
return
}
if %ordinal.var.value = 10 then
{
var %ordinal.var.name tenth
return
}
var %ordinal.var.name eleventh
return

#### Exchange Routine
Exchange:
	if matchre("$zoneid", "1|61|13|112") then var currentcurrency Kronars
	if matchre("$zoneid", "30|41|35|47|34a|90|99|107|106") then var currentcurrency Lirums
	if matchre("$zoneid", "116|127|114|67|123|150|66") then var currentcurrency Dokoras
	var currencies Kronars|Lirums|Dokoras
	eval currencies replace("%currencies", "%currentcurrency", "")
	eval currencies replacere("%currencies", "^\|", "")
	eval currencies replacere("%currencies", "\|$", "")
	put exch all %currencies(0) for %currentcurrency
	put exch all %currencies(1) for %currentcurrency
	return
	
bank:
	setvariable copper 0
	setvariable bronze 0
	setvariable silver 0
	setvariable gold 0
	setvariable plat 0
	if !def(Profit) then put #tvar Profit 0
	action (bank) setvariable plat $1 when (\d+) platinum,
	action (bank) setvariable gold $1 when (\d+) gold,
	action (bank) setvariable silver $1 when (\d+) silver,
	action (bank) setvariable bronze $1 when (\d+) bronze,
	action (bank) setvariable copper $1 when (\d+) copper

	action (bank) on
	put check balance
	pause 1
	evalmath pre.dep %copper + (%bronze*10) + (%silver*100) + (%gold*1000) + (%plat*10000)


	put dep all
	pause 1

	put check balance
	pause 1
	if !def(Profit) then put #tvar Profit 0
	evalmath Profit $Profit+((%copper + (%bronze*10) + (%silver*100) + (%gold*1000) + (%plat*10000))-%pre.dep)
	put #tvar Profit %Profit
	action (bank) off

	evalmath plat floor(%Profit/10000)
	evalmath gold floor((%Profit-(%plat*10000))/1000)
	evalmath silver floor((%Profit-(%plat*10000)-(%gold*1000))/100)
	evalmath bronze floor((%Profit-(%plat*10000)-(%gold*1000)-(%silver*100))/10)
	evalmath copper floor((%Profit-(%plat*10000)-(%gold*1000)-(%silver*100)-(%bronze*10))/1)

	pause 0.5
	put #statusbar 2 Total Profit: %plat Plat, %gold Gold, %silver Silver, %bronze Bronze and %copper Copper
	return
	
### ARMOR REMOVAL AND WEARING
removecheck:
var armor
action (armor) var armor %armor|$1 when ^\s+.* (\S+)$

action (armor) on
put inv armor
waitfor All of your armor
action (armor) off
eval armor replacere("%armor", "^\|", "")
eval armor replacere("%armor", "\|$", "")
eval armorcount count("%armor", "|")
return

removearmor:
var armornumber 0
removearmor1:
if %armornumber <= %armorcount then
	{
	gosub HOLD %armor(%armornumber)
	gosub stow %armor(%armornumber)
	math armornumber add 1
	goto removearmor1
	}
return

weararmor:
var armornumber 0
weararmor1:
if %armornumber <= %armorcount then
	{
	gosub get %armor(%armornumber)
	gosub wear %armor(%armornumber)
	math armornumber add 1
	goto weararmor1
	}
return
 
#### RETURNS
RETURN_CLEAR:
     pause 0.0001
     put #queue clear
     pause 0.0001
     return
RETURN:
     pause 0.0001
     return


#### END OF FILE

include hum2.cmd