#Moon Mage training script. - Genie3 v6.04
#Script Author: Azarael
##Change log:
## v1.0 : Initial release
## v1.x : Archived v1.1 - v1.6
## v2.x : Archived v2.0 - v2.8
## v3.x : Archived v3.0 - v3.16
## v4.x : Archived v4.0 - v4.10
## v5.x : Archived v5.0 - v5.31
## v6.0 : New version due to major script updates.
##        Observable object lists updated and optimized.
##        Script conversion to utilize Javascript array handling
##        for better performance and exception handling.
##        Added more documentation to better denote script sections.
##        Fixed Pouchsort action for new messaging.
##        Removed Prediction interpreter - may rebuild and add in later.
##        Relocated all action definitions to the top of the script for
##        consistency.
## v6.01  Fixed an issue with the obs.count variable not getting the correct value.
## v6.02  Fixed an issue with certain descriptions not showing. Also automated toggle
##        for Time Tracker Plugin and removed option for the Prediciton Interpreter.
## v6.03  Removed Mech Lore training (as it doesn't exist anymore).
## v6.04  Added in triggers and variables for Aura Sight spell along with menu options
##        and added a warning for when the MM_WAIT_MODE global is not set properly.
## v6.05  Fixed pouchsort action Regex due to Simu change in output.
##

include js_arrays.js

#####Credits####
##Hervean
## :Power Perception routine
## :Divination Bowl data
##
##DrtyPrior
## :Debugging help.
################

#debug 10

##Guild Verification
GuildCheck:
	action (guild) var guild $1 when Guild: (\w+|\w+\s+\w+)$
	action var circle $1 when Circle: (\d+)
	action (guild) on
	send info
	waitfor Debt
	action (guild) off
	if !(%guild = Moon Mage) then 
		{
		echo You're not a Moon Mage. You can't use this script.
		exit
		}

##First-run check
if !def("MM_IS_SETUP") then goto Setup

if_1 then
	{
	var mode %1
	eval mode toupper("%mode")
	if matchre("%mode", "SET") then goto Setup
	echo Valid command line is '.mm_train setup'
	echo Script terminating.
	exit
	}
goto ScriptStart

#######################
##      Includes     ##
#######################
# This section is for future add-ons that expand optional functions of the code
# which do not affect the operation of the code itself.


#############################
##  Variables and Actions  ##
#############################

ScriptStart:
	##Script variables
	##Do NOT change these!!!
	var script.room $roomid
	var interp.action.once 0
	var is.recepticle 0
	var tool.broken 0
	var pouch.num first|second|third|fourth|fifth|sixth
	var magic.skip 1
	var juggle.skip 1
	var need.tele 0
	var no.tele 0
	var gem.pouch 0
	var gemempty 0
	var pouchplace 0
	var cambstow 0
	var forage.ct 0
	var pg.known 0
	var pg.active 0
	var cv.known 0
	var cv.active 0
	var aus.known 0
	var aus.active 0
	var clear.sky 0
	var foragect 0
	var fullprep 0
	var toPower xibar|planets|trans|yavash|perc|katamba|moonl man|enlightened|psychic
	var totalPower 8
	var pp.counter 0
	var pouch.count 0
	var skip.forage 0
	var prep.override 0
	var need.moon 0
	var tool.check 0
	var offense Archer|Boar|Cat|Centaur|Er\'qutra|Estrilda|Mongoose|Panther|Scorpion|Shark|Spider|Szeldia|Triquetra|Viper|Wolverine
	var defense Albatross|Dawgolesh|Dove|Giant|Jackal|Katamba|Lion|Magpie|Merewalda|Penhetia|Raccoon|Vulture|Welkin
	var lore Amlothi|Brigantine|Cobra|Donkey|Hare|King Snake|Phoenix|Raven|Scales|Shardstar|Verena|Weasel|Xibar
	var magic Adder|Amlothi|Coyote|Durgaulda|Ismenia|Nightingale|Owl|Phoenix|Shrew|Toad|Wolf|Wren|Yavash
	var survival Cow|Dolphin|Goshawk|Heart|Heron|Morleena|Ox|Ram|Shark|Shrike|Sun|Unicorn|Yoakena
	var levels.spring 0|0|0|0|1|3|4|7|10|11|12|15|17|20|25|26|28|32|34|39|40|42|43|44|45|48|51|54|59|64|69|74|79|84|89
	var obs.spring Xibar|Yavash|Katamba|Heart|Wolf|Raven|Unicorn|Cobra|Wren|Cat|Ram|Wolverine|Magpie|Viper|Dove|Phoenix|Mongoose|Raccoon|Adder|Spider|Giant|Verena|Toad|Archer|Estrilda|Durgaulda|Yoakena|Penhetia|Szeldia|Merewalda|Ismenia|Morleena|Amlothi|Dawgolesh|Er\'qutra
	var levels.summer 0|0|0|0|1|3|5|8|11|12|14|15|17|19|20|26|27|30|32|33|34|36|38|39|40|41|42|43|45|47|48|49|51|54|59|64|69|74|79|84|89
	var obs.summer Xibar|Yavash|Katamba|Heart|Wolf|Raven|Boar|Ox|Cat|Ram|Shardstar|Centaur|Magpie|King Snake|Viper|Phoenix|Heron|Owl|Raccoon|Cow|Adder|Shrew|Jackal|Spider|Giant|Hare|Verena|Toad|Estrilda|Scales|Durgaulda|Triquetra|Yoakena|Penhetia|Szeldia|Merewalda|Ismenia|Morleena|Amlothi|Dawgolesh||Er\'qutra
	var levels.fall 0|0|0|0|1|2|3|6|8|11|14|15|17|18|19|20|23|26|30|31|35|36|37|39|40|42|43|45|47|48|51|54|59|64|69|74|79|84|89
	var obs.fall Xibar|Yavash|Katamba|Heart|Wolf|Lion|Raven|Panther|Ox|Cat|Nightingale|Centaur|Magpie|Weasel|King Snake|Viper|Donkey|Phoenix|Owl|Welkin|Vulture|Shrew|Shrike|Spider|Giant|Verena|Toad|Estrilda|Scales|Durgaulda|Yoakena|Penhetia|Szeldia|Merewalda|Ismenia|Morleena|Amlothi|Dawgolesh||Er\'qutra
	var levels.winter 0|0|0|0|1|3|4|11|13|14|14|17|18|20|21|22|24|26|29|31|37|39|40|42|43|45|46|48|51|54|59|64|69|74|79|84|89
	var obs.winter Xibar|Yavash|Katamba|Heart|Wolf|Raven|Unicorn|Cat|Dolphin|Nightingale|Wolverine|Magpie|Weasel|Viper|Albatross|Shark|Coyote|Phoenix|Goshawk|Welkin|Shrike|Spider|Giant|Verena|Toad|Estrilda|Brigantine||Durgaulda|Yoakena|Penhetia|Szeldia|Merewalda|Ismenia|Morleena|Amlothi|Dawgolesh|Er\'qutra
	var levels.day 0|0|0|0|42|45|48|51|54|59|64|69|74|79|84|89
	var obs.day Sun|Xibar|Yavash|Katamba|Verena|Estrilda|Durgaulda|Yoakena|Penhetia|Szeldia|Merewalda|Ismenia|Morleena|Amlothi|Dawgolesh||Er\'qutra
	var disposals bucket|bucket of viscous gloop|large stone turtle|disposal bin|waste bin|firewood bin|tree hollow|oak crate|ivory urn|pit|trash receptacle
	var disposal.extra trash |large stone |waste |firewood |tree |oak |ivory | of viscous gloop
	var dump.recepticle 0
	
	put #var MM_DIVINATION_TOOL {#eval tolower("$MM_DIVINATION_TOOL")}
	
	##Script Actions
	action send get prism when As the sapphire prism swings to a halt you lose your grip
	action send get my $MM_CAMBRINTH when Remove what?
	action var cambstow $2 when from inside your (\S+|\S+\s+\w+)\.$
	action send put my $MM_CAMBRINTH in my %cambstow when You can't wear that\!$
	action var clear.sky 1 when clear sky|sky is clear
	action var clear.sky 1 when open sky
	action send 2 $lastcommand when ^\.\.\.wait|^Sorry, you may only type
	action var season $1 when It is currently (\w+)
	action var season $1 when It's currently (\w+)
	action (time) var time day when dawn|morning|noon|afternoon|midday
	action (time) var time night when sunrise|dusk|night|midnight|late night|sunset|evening
	action (spells) var pg.known 1 when Piercing Gaze
	action (spells) var cv.known 1 when Clear Vision
	action (spells) var aus.known 1 when Aura Sight
	action remove You strain
	action remove You have to strain
	action remove You strain, but
	action var cv.active 0 when You feel less aware of your environment\.$
	action var pg.active 0 when The world around you returns to its mundane appearance\.$
	action var aus.active 0 when Your color vision returns to normal, causing the auras you see to dim and vanish\.$
	action var hand.armor $1 when Your efforts are hindered by your \w+ (\w+)
	action var hand.armor $1 when Your efforts are hindered by your \w+ \w+ (\w+)
	action (pouchcheck) js doPush("pouchname","$1") when Your*.(\S+) pouch
	action (gemcheck) var gemempty 1 when There is nothing in there.
	action (tool.check) tool.broken = 1;echo Divination tool broken! when referring
	action (new.tool) var tool.broken 0 when ^You tap
	action (new.tool) var $MM_DIVINATION_TOOL 0 when referring.
	action (warding) var prep.override 0;var need.moon 1 when ^@Update Moons
	action var need.moon 1 when You must specify one of the three|on the wrong side of Elanthia and is not visible
	action var PREDICT_WAIT OFF when sufficiently pondered
	action var fullprep 1 when You feel fully prepared
	action (tele.get) var telestow $1 when from inside your (\S+|\S+\s+\w+)\.$
	action (jugglecheck) var jugglestow $1 when $MM_JUGGLIE.* from inside your (\S+|\S+\s+\w+)\.$
	action (divin.get) var divinstow $1 when $MM_DIVINATION_TOOL.* from inside your (\S+|\S+\s+\w+)\.$
	action (checktied) var is_tied 1 when You tap a .* atop your
	action (checktied) var tied_to $1 when You remove a .* from your (.+)\.
	
	action (pouchcheck) off
	action (gemcheck) off
	action (jugglecheck) off
	action (divin.get) off
	action (tool.check) off
	action (new.tool) off
	action (time) off
	action (spells) off
	action (warding) off
	action (tele.get) off
	action (checktied) off

#############################
##    Main Script Body     ##
#############################

##Initial Script Checks
HandsEmptyChk:
	if $righthand = Empty then
		{
		if $lefthand = Empty then goto checks
		}
	echo ********************************************
	echo * Please empty hands and run script again. *
	echo ********************************************
	exit

Checks:
	if matchre("$roomobjs",("%disposals")) then
		{
		var is.recepticle 1
		var dump.recepticle $0
		eval dump.recepticle replacere("%dump.recepticle", "%disposal.extra", "")
		}
	action (spells) on
	pause 1
	send spells
	pause 0.5
	action (spells) off
	send observe weather
	pause 0.5
	goto pouchfind

PouchFind:
	action (pouchcheck) on
	pause 0.5
	put inv search pouch
	waitfor INVENTORY HELP
	action (pouchcheck) off
	if contains("%pouchname", "gem") = 0 then
		{
		Echo No gem pouch. Skipping appraisal.
		if_6 then goto jugglechk
		goto mainloop
		}
	var gem.pouch 1
	jscall pouchplace doXCompare("pouchname","pouch.num","gem")

OpenChk:
	match openpou is closed.
	match jugglechk nothing in
	match JuggleChk gem pouch
	action (gemcheck) on
	pause 1
	put look in my %pouchplace pou
	action (gemcheck) off
	matchwait

OpenPou:
	match jugglechk when has been tied
	match openchk ^You open
	put open my %pouchplace pou
	goto openchk

JuggleChk:
	if %gemempty = 1 then echo Your gem pouch is empty. Skipping appraisal. Get some gems!
	if $MM_TRAIN_JUGGLE = OFF then goto mainloop
	action (jugglecheck) on
	pause 0.5
	send take my $MM_JUGGLIE
	pause 0.5
	action (jugglecheck) off
	pause 3
	send put $MM_JUGGLIE in my %jugglestow

MainLoop:
pause 2
#Magic Training Checks
if $MM_TRAIN_MAGIC = ON then
	{
	if ($Warding.LearningRate < 10 && "$MM_TRAIN_WARDING" = "ON") then gosub Magic.Start Warding
	if ($Augmentation.LearningRate < 10 && "$MM_TRAIN_AUGMENTATION" = "ON") then gosub Magic.Start Augmentation
	if ($Utility.LearningRate < 10 && "$MM_TRAIN_UTILITY" = "ON") then gosub Magic.Start Utility
	if $Attunement.LearningRate < 10 then gosub pp.loop
	}

#Astrology Training Checks
if $MM_TRAIN_ASTROLOGY = ON then
	{
	if %clear.sky = 1 then
		{
		if $Astrology.LearningRate < 10 then gosub astro.begin
		}
	if %clear.sky = 0 then
		{
		if %pg.active = 1 then
			{
			if $Astrology.LearningRate < 10 then gosub astro.begin
			}
		if %pg.active = 0 then
			{
			if $Astrology.LearningRate < 10 then
				{
				if %pg.known = 1 then
					{
					gosub PG
					}
				gosub astro.begin
				}
			}
		}
	}

#Supplementary Training Checks	
if %gem.pouch then
	{
	if %gemempty = 0 then
		{
		if $Appraisal.LearningRate < 34 then gosub appraisal
		}
	}
if $MM_TRAIN_JUGGLE = ON then
	{
	if $Perception.LearningRate < 34 then gosub juggle
	}
if $MM_TRAIN_FORAGE = ON then
	{
	if $Outdoorsmanship.LearningRate < 34 then gosub forage.learn
	}

pause 2
goto mainloop
exit

##Magic section
Magic.Start:
	var EXP_TYPE $1
	var moon
	var prep.override 0
	var need.moon 0
	eval spell.type toupper("%EXP_TYPE")

Prepare:
	gosub manacheck
	if %prep.override = 0 then send prepare $MM_%spell.type_SPELL $MM_%spell.type_PREP
	else send prepare psy $MM_%spell.type_PREP
	if $MM_USE_CAMBRINTH = ON then gosub getcamb
	matchre cast You are already preparing|You feel fully prepared
	match wait You have to strain
	if %fullprep = 1 then
		{
		send #parse You feel fully prepared
		}
	matchwait

GetCamb:
	if $righthand = Empty then send remove my $MM_CAMBRINTH
	pause 0.5
	gosub charge
	return

Charge:
	pause 1
	send charge my $MM_CAMBRINTH $MM_CHARGE
	pause
	pause 1
	send invoke my $MM_CAMBRINTH
	pause .5
	return

Harness:
	if $MM_HARNESS < 1 then return
	pause .5
	match manawait You strain,
	send harness $MM_HARNESS
	matchwait 2
	pause .5
	return

Cast:
	pause .5
	if $MM_USE_HARNESS = ON then gosub harness
	pause .5
	match wait You are unable to harness
	match prepare You don't have a spell
	match magic.exp You gesture
	send cast %moon
	var fullprep 0
	matchwait

Set.Moon:
	if $moonKatamba = Up then
		{
		action (warding) off
		var moon Katamba
		var need.moon 0
		goto cast
		}
	if $moonYavash = Up then
		{
		action (warding) off
		var moon Yavash
		var need.moon 0
		goto cast
		}
	if $moonXibar = Up then 
		{
		action (warding) off
		var moon Xibar
		var need.moon 0
		goto cast
		}
	var prep.override 1
	action (warding) on
	goto prepare

ManaCheck:
	if $mana < 20 then gosub manawait
	return

ManaWait:
	pause .5
	send release
	echo
	echo Waiting for mana.
	echo 
	pause 120
	return

Magic.Exp:
	gosub clear
	if $%EXP_TYPE.LearningRate = 34 then
		{
		send wear my $MM_CAMBRINTH
		wait
		gosub clear
		goto mainloop
		}
	if %need.moon = 1 then goto set.moon
	goto prepare

##Power Perception section
PP.Loop:
	if (%pp.counter > %totalPower) then math pp.counter set 0
	gosub do.Power
	math pp.counter add 1
	if $Attunement.LearningRate = 34 then return
	goto pp.loop

Do.Power:
	send power %toPower(%pp.counter)
	waitforre ^Roundtime
	return

##Astrology section
Astro.Begin:
	if %cv.active = 0 then
		{
		if %cv.known = 1 then gosub cv
		}
	action (time) on
	send time
	pause 1
	action (time) off
	var obs.night %obs.%season
	var obs.levels %levels.%season
	eval obs.count count("%obs.night","|")
	var astro.count 0
	if ((%tool.check = 0) && !($MM_DIVINATION_TOOL = "visions")) then gosub check.tool
	if $MM_TT_PLUGIN = ON then
		{
		if $Time.isDay = 0 then goto pred.night
		goto pred.day
		}
	goto pred.%time

Pred.Day:
	eval obs.count count("%obs.day","|")
	var obs.levels %levels.day
	if %astro.count > %obs.count then var astro.count 0
	eval this.level element("%obs.levels", "%astro.count")
	if %circle < %this.level then
		{
		var astro.count 0
		goto pred.day
		}
	eval this.obs element("%obs.day", "%astro.count")
	if $MM_TT_PLUGIN = ON then
		{
		if matchre("Xibar|Katamba|Yavash", "%this.obs") then
			{
			if $Time.is%this.obsUp = 0 then
				{
				math astro.count add 1
				goto pred.day
				}
			}
		}
	gosub obs %this.obs
	goto pred.day

Pred.Night:
	if %astro.count > %obs.count then var astro.count 0
	eval this.level element("%obs.levels", "%astro.count")
	if %circle < %this.level then
		{
		var astro.count 0
		goto pred.night
		}
	eval this.obs element("%obs.%season", "%astro.count")
	if $MM_TT_PLUGIN = ON then
		{
		if matchre("Xibar|Katamba|Yavash", "%this.obs") then
			{
			if $Time.is%this.obsUp = 0 then
				{
				math astro.count add 1
				goto pred.night
				}
			}
		}
	if %circle > %this.level then
		{
		if $righthandnoun = telescope then
			{
			var need.tele 0
			send close my tele
			send put my tele in my %telestow
			}
		gosub obs 
		goto pred.night
		}
	var astro.count 0
	goto pred.night

Obs:
	match need.pg Clouds obscure the sky
	match get.tele is too faint for you to pick out with your naked eye.
	matchre predict You learned something useful|predict from your observation|Although you don't gain a complete view of the future|Too many futures cloud your mind - you learn nothing|you still learned from your observation|you still learned
	matchre obs You see nothing regarding the future
	matchre next.obs You learn nothing of the future|too close to the sun
	match astro.begin is foiled by
	matchre return You are unable to make use of this latest observation|fruitless|I could not find what you are referring to|no telescope
	if %need.tele = 1 then
		{
		if %no.tele = 1 then
			{	
			math astro.count add 1
			echo You have no telescope. Skipping.
			return
			}
		else
			{
			action (tele.get) off
			if !%tele.open then send open my tele
			var tele.open 1
			pause 1
			send center my tele on %this.obs
			pause 1
			send peer my tele
			math astro.count add 1
			}
		}
	if %need.tele = 0 then 
	{
	math astro.count add 1
	send obs %this.obs in the sky
	}
	matchwait

Next.Obs:
	math astro.count add 1
	goto pred.%time
	
Need.PG:
	var clear.sky = 0
	if %pg.known = 1 then
		{
		gosub PG
		goto obs
		}
	else
		{
		echo Too cloudy, learn PG!
		goto mainloop
		}

Get.Tele:
	var need.tele 1
	if %no.tele = 0 then
		{
		pause 0.5
		var tele.open 0
		action (tele.get) on
		pause 0.5
		match obs telescope
		match missingtele What were you referring
		send get my tele
		matchwait
		}
	if %no.tele = 1 then
	return

MissingTele:
	var no.tele 1
	return

Predict:
	if %need.tele = 1 then
		{
		send close my tele
		pause 1
		send put tele in my %telestow
		pause 1
		var need.tele 0
		var tele.open 0
		}
	if contains("%offense", "%this.obs") then
		{
		var predict.type offense
		goto predict.do
		}
	if contains("%defense", "%this.obs") then
		{
		var predict.type defense
		goto predict.do
		}
	if contains("%lore", "%this.obs") then
		{
		var predict.type lore
		goto predict.do
		}
	if contains("%magic", "%this.obs") then
		{
		var predict.type magic
		goto predict.do
		}
	if contains("%survival", "%this.obs") then
		{
		var predict.type survival
		goto predict.do
		}

Predict.do:
	if $MM_DIVINATION_TOOL = visions then
		{
		send align %predict.type
		pause 1
		matchre checkstun (After a few moments, the mists of time begin to part|The future, however, remains a dark mystery to you|Suddenly your mind receives a numbing jolt)
		send predict future $charactername %predict.type
		matchwait
		}
	action (tool.check) on
	action (divin.get) on
	pause 1
	if %is_tied then put untie my $MM_DIVINATION_TOOL
	else put get my $MM_DIVINATION_TOOL
	if !%tool.broken then waitforre ^You get
	else gosub new.tool
	pause 1
	action (divin.get) off
	eval predict.type tolower("%predict.type")
	send align %predict.type
	waitforre ^You focus internally
	send kneel
	waitforre ^You kneel
	if matchre("$MM_DIVINATION_TOOL", "bone") then
		{
		send roll bone at $charactername
		}
	if matchre("$MM_DIVINATION_TOOL", "prism") then
		{
		send raise prism
		}
	if matchre("$MM_DIVINATION_TOOL", "bowl|mirror") then
		{
		send gaze my $MM_DIVINATION_TOOL
		}
	if matchre("$MM_DIVINATION_TOOL", "chart") then
		{
		send review my $MM_DIVINATION_TOOL
		}
	if matchre("$MM_DIVINATION_TOOL", "deck") then
		{
		send shuffle my $MM_DIVINATION_TOOL
		waitforre ^Roundtime
		send cut my $MM_DIVINATION_TOOL
		pause 1
		send deal my $MM_DIVINATION_TOOL $MM_DEAL_TIMES
		}
	pause 1
	action (tool.check) off
	send stand
	waitforre ^You stand
	if %is_tied then put tie my $MM_DIVINATION_TOOL to my %tied_to
	else put stow my $MM_DIVINATION_TOOL
	pause 1
	goto checkstun

New.Tool:
	if %tool.broken = 1 then
		{
		action (new.tool) on
		pause 1
		send tap my $MM_DIVINATION_TOOL
		pause 1
		action (new.tool) off
		}
	goto Check.Tool

Check.Tool:
	action (checktied) on
	pause 0.5
	send tap my $MM_DIVINATION_TOOL
	if %is_tied then put untie my $MM_DIVINATION_TOOL
	else put get my $MM_DIVINATION_TOOL
	action (checktied) off
	match bond.tool inert
	match tool.checked investiture
	put analyze my $MM_DIVINATION_TOOL
	matchwait

Bond.Tool:
	send invoke my $MM_DIVINATION_TOOL
	pause
	pause 1
	var tool.check 1
	if %is_tied then put tie my $MM_DIVINATION_TOOL to my %tied_to
	else put stow my $MM_DIVINATION_TOOL
	return

Tool.Checked:
	var tool.check 1
	if %is_tied then put tie my $MM_DIVINATION_TOOL to my %tied_to
	else put stow my $MM_DIVINATION_TOOL
	return

checkstun:
	if $stunned = yes then gosub stunned
	gosub clear
	if $Astrology.LearningRate > 33 then
		{
		gosub clear
		goto mainloop
		}
	if (%aus.known = 1 && %aus.active = 0) then gosub AUS
	if %tt.plugin = 1 then
		{
		send predict analyze
		pause
		pause 1
		var PREDICT_WAIT ON
		gosub predict_wait
		if $Time.isDay = 0 then goto pred.night
		goto pred.day
		}
	send predict analyze
	pause
	pause 1
	var PREDICT_WAIT ON
	pause 1
	gosub predict_wait
	goto pred.%time

Predict_Wait:
	if %PREDICT_WAIT = OFF then 
		{
		if matchre("$MM_WAIT_MODE", "script") then put #script abort $MM_WAIT_SCRIPT
		if matchre("$righthand", "sigilbook") then put close my sigilbook
		pause 0.5
		send stow my $righthand
		send stow my $lefthand
		return
		}
	if matchre("$MM_WAIT_MODE", "juggle") then
		{
		if $righthand = Empty then send get my $MM_JUGGLIE
		send juggle my $MM_JUGGLIE
		pause
		pause 0.5
		goto Predict_Wait
		}
	if matchre("$MM_WAIT_MODE", "sigil") then
		{
		if $righthand = Empty then send get my sigilbook
		pause 0.5
		match Predict_Wait sigil of some
		matchre Turn_Sigil sigil of the|completely blank
		match Open_Sigil closed
		put read my sigilbook
		matchwait
		}
	if matchre("$MM_WAIT_MODE", "script") then
		{
		send .$MM_WAIT_SCRIPT
		waitforre sufficiently pondered
		goto Predict_Wait
		}

##WAIT MODE ERROR##
echo If you are seeing this message, your `MM_WAIT_MODE` is set incorrectly.
echo Please check that this global is set to 'juggle', 'script' or 'sigil'.
echo The script will now terminate.
exit

Open_Sigil:
	put open my sigilbook
	goto Predict_Wait

Turn_Sigil:
	put turn my sigilbook
	pause 1
	goto Predict_Wait

##PG/CV casting
PG:
	put prep PG $MM_PG_PREP
	waitfor fully prepared
	put cast
	var pg.active 1
	pause 0.5
	return

CV:
	put prep CV $MM_CV_PREP
	waitfor fully prepared
	put cast
	var cv.active 1
	pause 0.5
	return
	
AUS:
	put prep AUS $MM_AUS_PREP
	waitfor fully prepared
	put cast
	var aus.active 1
	pause 0.3
	return

##Supplementary Skills section
##Appraisal secion
Appraisal:
	wait
	pause 1
	send open my %pouchplace pouch
	wait
	pause 1
	send app my %pouchplace pouch
	wait
	pause 1
	send app my %pouchplace pouch
	wait
	pause 1
	send close my %pouchplace pouch
	wait
	pause 1
	return

##Juggle section
Juggle:
	if $righthand = Empty then
		{
		send get my $MM_JUGGLIE
		}
	pause 1
	send juggle my $MM_JUGGLIE
	waitforre ^Roundtime
	pause
	pause 1
	send juggle my $MM_JUGGLIE
	waitforre ^Roundtime
	pause
	pause 1
	send juggle my $MM_JUGGLIE
	waitforre ^Roundtime
	pause
	pause 1
	send put $MM_JUGGLIE in my %jugglestow
	return

##Foraging Section
Forage.Learn:
	if (%skip.forage = 1 && $roomid = %script.room) then return
	else
		{
		var skip.forage 0
		var script.room $roomid
		}
	pause
	pause 1
	if %forage.ct > 3 then
		{
		echo No $MM_COLLECT_ITEM to forage here. Skipping.
		var skip.forage 1
		return
		}
	match kick manage to collect
	match forage.fail Roundtime:
	send collect $MM_COLLECT_ITEM
	matchwait
	return

Forage.Fail:
	math foragect add 1
	Echo Foraging failed attempt #%foragect
	goto forage.learn

Kick:
	pause
	pause 1
	send kick $MM_COLLECT_ITEM
	return

exit

#############################
##      Setup Section      ##
#############################

Setup:
	if !def("MM_IS_SETUP") then
		{
		echo This is your first time running the Moon Mage Training script.
		echo All training sections are set to ON by default.
		echo Toggle for the Time Tracker Plugin and Prediction Interpretor are OFF by Default.
		echo These may be toggled ON under the Astrology menu.
		echo To toggle a section OFF, click the menu for the section then click the 'Train' link.
		echo Please set values for variables in all sections.
		put #var MM_TRAIN_MAGIC ON
		put #var MM_TRAIN_ASTROLOGY ON
		put #var MM_TRAIN_FORAGE ON
		put #var MM_TRAIN_JUGGLE ON
		put #var MM_USE_HARNESS ON
		put #var MM_USE_CAMBRINTH ON
		if def("Time.isDay") then put #var MM_TT_PLUGIN ON
		else put #var MM_TT_PLUGIN OFF		

		##Moonmage Triggers for Moon states.
		put #trigger {^Katamba is a.+moon and is not visible\.} {#var moonKatamba Down;#parse @Update Moons}
		put #trigger {^Katamba is nowhere to be seen\.} {#var moonKatamba Down;#parse @Update Moons}
		put #trigger {^Katamba sets, slowly dropping below the horizon\.} {#var moonKatamba Down;#parse @Update Moons}
		put #trigger {^Katamba slowly rises above the horizon\.} {#var moonKatamba Up;#parse @Update Moons}
		put #trigger {^Set within the black disc of the.+is the image} {#var moonKatamba Up;#parse @Update Moons}
		put #trigger {^Set within the black disc of the.+is the outline} {#var moonKatamba Down;#parse @Update Moons}
		put #trigger {^Set within the blue disc of the.+is the image} {#var moonXibar Up;#parse @Update Moons}
		put #trigger {^Set within the blue disc of the.+is the outline} {#var moonXibar Down;#parse @Update Moons}
		put #trigger {^Set within the red disc of the.+is the image} {#var moonYavash Up;#parse @Update Moons}
		put #trigger {^Set within the red disc of the.+is the outline} {#var moonYavash Down;#parse @Update Moons}
		put #trigger {^Xibar is a.+moon and is not visible\.} {#var moonXibar Down;#parse @Update Moons}
		put #trigger {^Xibar is nowhere to be seen\.} {#var moonXibar Down;#parse @Update Moons}
		put #trigger {^Xibar sets, slowly dropping below the horizon\.} {#var moonXibar Down;#parse @Update Moons}
		put #trigger {^Xibar slowly rises above the horizon\.} {#var moonXibar Up;#parse @Update Moons}
		put #trigger {^Yavash is a.+moon and is not visible\.} {#var moonYavash Down;#parse @Update Moons}
		put #trigger {^Yavash is nowhere to be seen\.} {#var moonYavash Down;#parse @Update Moons}
		put #trigger {^Yavash sets, slowly dropping below the horizon\.} {#var moonYavash Down;#parse @Update Moons}
		put #trigger {^Yavash slowly rises above the horizon\.} {#var moonYavash Up;#parse @Update Moons}
		put #trigger {^You're certain that Katamba is} {#var moonKatamba Up;#parse @Update Moons}
		put #trigger {^You're certain that Xibar is} {#var moonXibar Up;#parse @Update Moons}
		put #trigger {^You're certain that Yavash is} {#var moonYavash Up;#parse @Update Moons}
		put #trigger {by a miniature luminescent version of the moon Katamba\.} {#var moonKatamba Up;#var moonYavash Down;#var moonXibar Down;#parse @Update Moons}
		put #trigger {by a miniature luminescent version of the moon Xibar\.} {#var moonXibar Up;#var moonKatamba Down;#var moonYavash Down;#parse @Update Moons}
		put #trigger {by a miniature luminescent version of the moon Yavash\.} {#var moonYavash Up;#var moonKatamba Down;#var moonXibar Down;#parse @Update Moons}
		put #trigger {by three miniature luminescent versions of the moons Katamba, xibar, and Yavash\.} {#var moonKatamba Up;#var moonYavash Up;#var moonXibar Up;#parse @Update Moons}
		put #trigger {by three miniature luminescent versions of the moons Katamba, Yavash, and Xibar\.} {#var moonKatamba Up;#var moonYavash Up;#var moonXibar Up;#parse @Update Moons}
		put #trigger {by three miniature luminescent versions of the moons Xibar, Katamba, and Yavash\.} {#var moonKatamba Up;#var moonYavash Up;#var moonXibar Up;#parse @Update Moons}
		put #trigger {by three miniature luminescent versions of the moons Xibar, Yavash, and Katamba\.} {#var moonKatamba Up;#var moonYavash Up;#var moonXibar Up;#parse @Update Moons}
		put #trigger {by three miniature luminescent versions of the moons Yavash, Katamba, and Xibar\.} {#var moonKatamba Up;#var moonYavash Up;#var moonXibar Up;#parse @Update Moons}
		put #trigger {by three miniature luminescent versions of the moons Yavash, Xibar, and Katamba\.} {#var moonKatamba Up;#var moonYavash Up;#var moonXibar Up;#parse @Update Moons}
		put #trigger {by three translucent spheres that seem to drift about without purpose or reason\.} {#var moonKatamba Down;#var moonYavash Down;#var moonXibar Down;#parse @Update Moons}
		put #trigger {by two miniature luminescent versions of the moons Katamba and Xibar\.} {#var moonXibar Up;#var moonKatamba Up;#var moonYavash Down;#parse @Update Moons}
		put #trigger {by two miniature luminescent versions of the moons Katamba and Yavash\.} {#var moonYavash Up;#var moonKatamba Up;#var moonXibar Down;#parse @Update Moons}
		put #trigger {by two miniature luminescent versions of the moons Xibar and Katamba\.} {#var moonXibar Up;#var moonKatamba Up;#var moonYavash Down;#parse @Update Moons}
		put #trigger {by two miniature luminescent versions of the moons Xibar and Yavash\.} {#var moonXibar Up;#var moonYavash Up;#var moonKatamba Down;#parse @Update Moons}
		put #trigger {by two miniature luminescent versions of the moons Yavash and Katamba\.} {#var moonYavash Up;#var moonKatamba Up;#var moonXibar Down;#parse @Update Moons}
		put #trigger {by two miniature luminescent versions of the moons Yavash and Xibar\.} {#var moonXibar Up;#var moonYavash Up;#var moonKatamba Down;#parse @Update Moons}
		}
		
		
		#Menus
		var MAIN Magic|Astrology|Extra|Done
		var ASTROLOGY Train Astrology|CV Prep|PG Prep|AUS Prep|Divination Tool|Deal Times|Wait Mode|Wait Script|Back
		var MAGIC Train Magic|Warding Spell|Warding Prep|Augmentation Spell|Augmentation Prep|Utility Spell|Utility Prep|Harness|Use Harness|Cambrinth|Charge|Use Cambrinth|Back
		var EXTRA Train Forage|Collect Item|Train Juggle|Jugglie|Back
		var TOGGLES TRAIN|USE
		
		#Menu Window
		var MENU_WINDOW Moonmage Training Menu
		
		#Description Variables
		##Magic Variable Descriptions		
		var TRAIN_MAGIC_DESC This toggles whether or not to train Magic skills.
		var WARDING_SPELL_DESC This spell will be used to train Warding. Possible spells are: Psychic Shield [psy], Cage of Light [col]
		var WARDING_PREP_DESC This is the mana amount to prepare the Warding Spell during the Magic section.
		var AUGMENTATION_SPELL_DESC This spell will be used to train Augmentation. Possible spells are: Clear Vision [cv], Piercing Gaze [pg], Aura Sight [aus], Tenebrous Sense [ts], Shadows, Seer's Sense [seer]
		var AUGMENTATION_PREP_DESC This is the mana amount to prepare the Augmentation Spell during the Magic section.
		var UTILITY_SPELL_DESC This spell will be used to train Utility. Possible spells are: Refractive Field [rf], Steps of Vaun [sov], Shadowing, Shadow Servant [ss], Contingency, Seer's Sense [seer]
		var UTILITY_PREP_DESC This is the mana amount to prepare the Utility Spell during the Magic section.
		var HARNESS_DESC This is the mana amount to harness before casting spells during the Magic section.
		var USE_HARNESS_DESC This toggles whether or not to utilize harnessed mana during the Magic section.
		var CAMBRINTH_DESC This is the noun of the cambrinth item you wish to use during the Magic section.
		var CHARGE_DESC This is the amount of mana to charge your cambrith item with during the Magic section.
		var USE_CAMBRINTH_DESC This toggles whether or not to utilize cambrinth during the Magic section.

		##Astrology Variables Descriptions
		var CV_PREP_DESC This is the mana amount to prepare the Clear Vision Spell during the Astrology section.
		var PG_PREP_DESC This is the mana amount to prepare the Piercing Gaze Spell during the Astrology section.
		var AG_PREP_DESC This is the mana amount to prepare the Aura Sight Spell during the Astrology section.
		var DIVINATION_TOOL_DESC This is the method used to make predicitons. The standard form is 'visions'.
		var DEAL_TIMES_DESC This is how many cards to deal from your Tokka Deck for predicitons. Must be between 3 and 6.
		var WAIT_MODE_DESC This sets an option to perform other various tasks during the cooldown on observations. The current options are: juggle (practices with juggling), sigil (studies sigils in sigilbooks- Must have a book with sigils scribed!) and script (must set the 'Wait Script' variable!).
		var WAIT_SCRIPT_DESC This is the name (note the filename ONLY) of the script to run during the observation cooldown.
		
		##Misc Variables Descriptions
		var TRAIN_FORAGE_DESC This toggles whether to train Outdoorsmanship through collecting while other experience drains.
		var COLLECT_ITEM_DESC This is the material collected during Outdoorsmanship training. ie.: rock, branch, vine, etc.
		var TRAIN_JUGGLE_DESC This toggles whether to train Perception through juggline while other experience drains.
		var JUGGLIE_DESC This is the noun of the juggle item you wish to use to train Perception.
		
		put #tvar selection MAIN
		
		pause 1
		echo
		echo ################
		put #echo cyan All typed user input MUST be preceeded by tilde (~) character.
		echo ################

MenuDisplay:
		var last.selection $selection
		counter set 0
		pause 0.3
		gosub Menu.Build "%$selection" "selection" "continue.script" "%MENU_WINDOW"
		waitforre continue.script
		put #var selection {#eval toupper("$selection")}
		if $selection = BACK then
			{
			put #tvar selection MAIN
			goto MenuDisplay
			}
		if $selection = DONE then gosub CheckVars "%MAGIC|%ASTROLOGY|%EXTRA"
		if ($selection = MAGIC || $selection = ASTROLOGY || $selection = EXTRA) then goto MenuDisplay
		if $selection = DIVINATION TOOL then
			{
			send #echo ">%this.window" cyan Possible values for $selection are:
			send #echo ">%this.window" cyan prism, bowl, mirror, deck, bones, chart, visions
			}
		put #var selection {#eval replacere("$selection", " ", "_")}
		gosub GlobalSet "%$selection_DESC"
		
CheckVars:
		var SETTABLES $1
		eval SETTABLES toupper("%SETTABLES")
		eval SETTABLES replacere("%SETTABLES", " ", "_")
		eval SET_AMOUNT count("%SETTABLES", "|")
		var UNSET
	  if %c > %SET_AMOUNT then
	  	{
	  	if (count("%UNSET", "|") > 0) then
	  		{
	  		counter set 0
	  		eval UNSET replacere("%UNSET", "^|", "")
	  		eval UNSET_AMOUNT count("%UNSET", "|")
	  		eval UNSET replacere("%UNSET", "_", " ")
	  		put #echo cyan You are missing the following Globals. Please set them before continuing!
	  		goto Missing.Globals
	  		}
			put #var MM_IS_SETUP 1
			put #window remove "Moonmage Training Menu"
			put #echo cyan Script setup complete. Run default values with the command '.mm_train'
			put #echo cyan To run the setup again, run the command '.mm_train setup'
			if matchre("$scriptlist", "mm_train.cmd") then put #script resume mm_train
			exit
			}
			goto CheckGlobal

CheckGlobal:
		if !(def("MM_%SETTABLES(%c)") || (%SETTABLES(%c) = BACK)) then var UNSET %UNSET|%SETTABLES(%c)
		counter add 1
		if %c > %SET_AMOUNT then goto CheckVars
		goto CheckGlobal

Missing.Globals:
		put #echo lime %UNSET(%c)
		counter add 1
		if %c < %UNSET_AMOUNT then goto Missing.Globals
		put #tvar selection MAIN
		goto MenuDisplay
		
exit

Menu.Build:
##Menu Building Routine
##Function - Builds a numbered menu of options in link format that saves option information into a variable.
##pre - First parameter must be an array of the option names/values. Second parameter is the name of the
##	target global variable to store the result of the link click. Third parameyer is a string
##	that will be parsed to continue the script after the menu item has been selected. Fourth parameter is a
##  window name to echo output to (leave out to echo to Game window).
##	Fifth parameter is a string or array of items that are exceptions to be excluded from the menu list.
##	
##post - Value of clicked link is stored in target global variable.

		action (input) var input $1;put #parse input.done when ~(.*)

		if !%c then
				{		
				var this.array $1
				var target.variable $2
				var script.trigger $3
				if $4 != "" then 
						{
						var this.window $4
						put #window add "%this.window"
						put #window open "%this.window"
						put #clear %this.window
						send #echo ">%this.window" cyan $selection Menu
						send #echo ">%this.window"
						}
				else var this.window Game
				if $5 != "" then var exceptions $5
				var this.option 0
				eval array.length count("%this.array","|")
				}
		if %c > %array.length then
				{
				var this.option 0
				counter set 0
				return
				}
		var this.choice %this.array(%c)
		if matchre("%exceptions","%this.choice") then
				{
				counter add 1
				goto menu.build
				}
		counter add 1
		math this.option add 1
		send #link ">%this.window" "%this.option. - %this.choice" "#var %target.variable %this.choice;#parse %script.trigger"
		goto menu.build
		
GlobalSet:
		put #clear "%this.window"
		var extra_message $1
		action (input) on
		if matchre("$selection", "%TOGGLES") then goto TOGGLE
		if !(%extra_message = "") then put #echo ">%this.window" cyan %extra_message
		put #echo ">%this.window" cyan Enter value for $selection:
		waitforre input.done
		put #var MM_$selection %input
		action (input) off
		put #clear "%this.window"
		put #echo ">%this.window" cyan $selection has been set to: %input
		put #echo ">%this.window"
		send #link ">%this.window" "Click to continue..." "#parse %script.trigger"
		waitforre %script.trigger
		put #var selection %last.selection
		goto MenuDisplay
		
Toggle:
		if $MM_$selection = ON then var TOGGLE_TO OFF
		else var TOGGLE_TO ON
		action (input) on
		pause 0.3
		send #clear "%this.window"
		pause 0.3
		if !(%extra_message = "") then put #echo ">%this.window" cyan %extra_message
		send #echo ">%this.window" cyan Variable $selection is currently set to $MM_$selection.
		send #echo ">%this.window" cyan Do you want to change it to %TOGGLE_TO?
		send #echo ">%this.window"
		send #link ">%this.window" "Yes" "#clear >%this.window;#echo $selection has been set to %TOGGLE_TO;#var MM_$selection %TOGGLE_TO;#var selection %last.selection;#parse %script.trigger"
		send #link ">%this.window" "No" "#clear >%this.window;#echo No changes made, returning to menu.;#var selection %last.selection;#parse %script.trigger"
		waitforre %script.trigger
		put #clear "%this.window"
		send #link ">%this.window" "Click to continue..." "#parse %script.trigger" 
		waitforre %script.trigger
		goto MenuDisplay
