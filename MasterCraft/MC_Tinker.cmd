#debug 10
###
# Tinkering by Dasffion
# Based off Shpaing by Arvedui Iorlas
#
# Script Usage: .Tinker <item>					--shapes the item
# Item can be any tinkering item
#
# Also handles enhancements to run an enhancement have the finished short/long/bow 
# in hand and use .shape <item> YES
#
# To create arrowheads
# .shape <arrowhead material>
# Can be tooth, fang, horn, claw or tusk
#
# For arrows you need to have the shafts and arrowheads already prepared
# .shape arrows
#

var BELTTOOLS OFF
var enhance OFF
var MarkIt YES
var ArrowheadTool drawknife
var ArrowheadMats (tooth|fang|horn|claw|tusk)

include mc_include.cmd
if_1 put #var MC.order.noun %1
if_2 var enhance ON

var Action drawknife
var stain.gone 0
var glue.gone 0

action put #queue clear;var Action carving.knife when carved with a carving knife|with a knife|trimmed with a carving knife|knife carving
action put #queue clear;var Action rasp when unless rubbed out with a rasp|rubbing them out with a rasp
action put #queue clear;var Action shaper when Shaping with a wood shaper is needed|Using slow strokes you scrape away some rough edges on the bolts|with a wood shaper
action put #queue clear;var Action clamp when place by pushing it with clamps or a vise\.|with clamps or a vise to hold it in place|ready to be clamped together|compressed with clamps
action put #queue clear;var Action stain when ready for the application of stain|wood stain should be applied
action put #queue clear;var Action glue when Glue should now be applied|glue applied to them|application of wood glue|application of glue
action put #queue clear;var Action pliers when The mechanisms must be affixed into the stock by pulling the.* with pliers|pulling them into place with pliers
action put #queue clear;goto fouledup when That tool does not seem suitable for that task.
action put #queue clear;var Action tools when Additional adjusting with some tinker's tools is now required|The wood is ready to be adjusted with a set of tinker's tools
action var pressoff 1 when ^The gear press shuts off with a loud rattle as the furnace fire dwindles
action var pressoff 0;var Action plierspress when ^The gear press shakes back to life|You add (\S+) shovel-full|With a scattering of coal|You pack the furnace|You slam your shovel into the pile of coal and fill the empty furnace resting beneath the press.  After a few pumps of the bellows it roars to life and is ready for operation
action var Action shovel when ^You dial the device to
action var Action pull when ^The unfinished mechanism
action var Action done when ^The metal quickly cools
action var mechs $1 when ^There are (\S+) parts left of the (?:\S+) mechanism(?:s)?

action var assemble $1 when another finished bow (string)
action var assemble mechanism when You need another finished mechanism to continue crafting
action var assemble backer when You need another bone, wood or horn backing material|ready to be reinforced with some backer
action var assemble $1.bolthead when You need another (.*) boltheads to continue crafting
action var assemble flights when You need another bolt flights
action var assemble strips when You need another finished leather strips|strengthened with some leather strips
action var assemble $1 $2 when another finished (long|short) leather (cord)
action var assemble $1 $2 when another finished (long|short) wooden (pole)
action var assemble lenses when You need another lenses to continue crafting

action var Action assemble when ^\[Ingredients can|You must assemble|appears ready to be reinforced|appears ready to be strengthened
#action (work) goto Retry when \.\.\.wait|type ahead
action goto done when ^Applying the final touches
action goto restudy when ^You cannot figure out how to do that

action (order) var stain.order $1 when (\d+)\)\..*some wood stain.*(Lirums|Kronars|Dokoras)
action var stain.gone 1 when ^The stain is all used up, so you toss it away.

action (order) var glue.order $1 when (\d+)\)\..*some wood glue.*(Lirums|Kronars|Dokoras)
action var glue.gone 1 when ^The glue is all used up, so you toss it away.
var count zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eightteen|nineteen|twenty|twenty-one|twenty-two|twenty-three|twenty-four|twenty-five|twenty-six|twenty-seven|twenty-eight|twenty-nine|thirty



unfinished:
	send glance
	waitforre ^You glance down (.*)\.$
	pause 2
	if contains("$0", "unfinished") then
	{
		gosub Action analyze my $MC.order.noun
		if !contains("$lefthandnoun", "$MC.order.noun") then gosub PUT swap
		goto work
	}

first.carve:	
	##If the provided item name is in the ArrowheadMats list make arrowheads instead
	if matchre("$MC.order.noun", "%ArrowheadMats") then goto arrowheads
	if matchre("$MC.order.noun", "shaft") then goto shaft
	if $needmechanisms > 0 then 
		{
		gosub PRESS
		gosub GET my lumber from my $MC_ENGINEERING.STORAGE
		pause 0.5
		gosub PUT swap
		pause 0.5
		}

	##Enhancements start with clamp.
	if ("%enhance" = "ON") then
	{
		var MarkIt NO
		var Action clamp
		if contains("$righthandnoun", "bow") then gosub PUT swap		
		pause 1
		goto work
	}
	else
	{
		##Arrows start with different material than other shaping projects
		if ("$MC.order.noun" = "bolts") then
		{
			var Action shaper
			var excessmats shafts
			var MarkIt NO
			
			gosub GET my shafts
			
			if contains("$righthandnoun", "shafts") then gosub PUT swap
			gosub ToolCheckRight $MC_SHAPER
			 matchre excess You place the excess parts at your feet.
			 matchre work Roundtime: \d+
			 send shape my shaft with my $MC_SHAPER
			matchwait
		}
		else
		{
			var Action drawknife
			var excessmats lumber
			if contains("$righthandnoun", "lumber") then gosub PUT swap
			pause 1
			gosub ToolCheckRight $MC_DRAWKNIFE
			 matchre excess You carefully separate out the excess material and place it on the ground.
			 matchre work Roundtime: \d+
			 send scrape my lumber with my $MC_DRAWKNIFE
			matchwait
		}
	}
	
excess:
	pause
	 gosub STOW_RIGHT
	 wait
	 gosub GET %excessmats
	 wait
	 gosub PUT_IT my %excessmats in my $MC_ENGINEERING.STORAGE
	 wait
	 goto work
	 
work:
	action (work) on
	save %Action
	gosub %Action
	goto work
	
fouledup:
	gosub Action analyze my $MC.order.noun
	goto work
	
restudy:
	gosub EMPTY_HANDS
	gosub GET tinkering book from my $MC_ENGINEERING.STORAGE
	gosub STUDY my book
	gosub PUT_IT my book in my $MC_ENGINEERING.STORAGE
	gosub GET my $MC_DRAWKNIFE
	goto WORK
	
press:
	pause 1
	if $Engineering.Ranks < 100 then var pressset 1
	if matchre("$Engineering.Ranks", "(\d)\d\d" then var pressset $1
	if matchre("$righthandnoun|$lefthandnoun", "lumber") then gosub PUT_IT my lumber in my $MC_ENGINEERING.STORAGE
	if !matchre("$righthandnoun|$lefthandnoun", "ingot") then gosub GET my ingot
	pause 0.5
	if !match("$lefthandnoun", "ingot") then gosub PUT swap
	pause 0.5
	send turn press to %pressset
	waitfor You dial

pressaction:
	if "%Action" = "done" then goto mechcombine
	else gosub %Action
	goto pressaction

mechcombine:
	gosub STOW_RIGHT
mechcombine_1:
	matchre mechcombine_1 \.\.\.wait|type ahead
	match presscount What were you referring to
	match mechcombine_2 You get
	put get my mech from my $MC_ENGINEERING.STORAGE
	matchwait 1
	goto %lastlabel
	
mechcombine_2:
	send combine mech with other mech
	pause 0.5
	goto mechcombine_1
	
presscount:
	var i 0
	send count my mech
	pause 1
	mechcount:
	if "%count(%i)" = "%mechs" then 
		{
		var mechnumber %i
		goto foundit
		}
	math i add 1
	goto mechcount

foundit:
	gosub PUT_IT my mech in my $MC_ENGINEERING.STORAGE
	if %mechnumber >= $totalmechanisms then 
		{
		put #var needmechanisms 0
		return
		}
	goto press

shovel:
	save shovel
	gosub ToolCheckRight $MC_SHOVEL
	 gosub Action push fuel with my $MC_SHOVEL
	return
	
plierspress:
	save plierspress
	var Action Pliers
	if (%pressoff) then
		{
		var Action shovel
		gosub shovel
		var Action plierspress
		}
	gosub ToolCheckRight $MC_PLIERS
	var Action Plierspress
	plierspress_1:
	 matchre plierspress_1 \.\.\.wait|type ahead
	 match return The unfinished mechanism
	 match toosmall You need at least 5 volume of metal for the press
	 send push my ingot with press
	 matchwait 1
	return
	
	return:
	return
	
toosmall:
	gosub PUT_IT ingot in buck
	pause 0.5
	gosub GET my ingot
	goto %Action

pull:
	if (%pressoff) then
		{
		var Action shovel
		gosub shovel
		var Action pull
		}
		gosub Action pull mechanism with press
		return

drawknife:
	gosub ToolCheckRight $MC_DRAWKNIFE
	 gosub Action scrape my $MC.order.noun with my $MC_DRAWKNIFE
	return

carving.knife:
	gosub ToolCheckRight $MC_CARVINGKNIFE
	var Action drawknife
	 gosub Action carve my $MC.order.noun with my $MC_CARVINGKNIFE
	return

rasp:
	gosub ToolCheckRight $MC_RASP
	var Action drawknife
	 gosub Action scrape my $MC.order.noun with my $MC_RASP
	return

shaper:
	gosub ToolCheckRight $MC_SHAPER
	var Action drawknife
	 gosub Action shape my $MC.order.noun with my $MC_SHAPER
	return

tools:
	gosub ToolCheckRight $MC_TINKERTOOL
	var Action drawknife
	 gosub Action adjust my $MC.order.noun with my $MC_TINKERTOOL
	return
	
clamp:
	gosub ToolCheckRight $MC_CLAMP
	var Action drawknife
	 gosub Action push my $MC.order.noun with my $MC_CLAMP
	return
	
pliers:
	gosub ToolCheckRight $MC_PLIERS
	var Action drawknife
	 gosub Action pull my $MC.order.noun with my $MC_PLIERS
	return

assemble:
	if !matchre("$righthandnoun", "%assemble") then
	{
	 pause 1
	 gosub STOW_RIGHT
	 gosub GET my %assemble
	}
	 ###send assemble my $MC.order.noun with my %assemble
	 if matchre("%assemble", "mechanism") then gosub assemblemech
	 else send assemble my %assemble with my $MC.order.noun
	 pause 1
	 if matchre("$righthandnoun", "%assemble") then gosub PUT_IT my %assemble in my $MC_ENGINEERING.STORAGE
	 pause 0.5
	 gosub Action analyze my $MC.order.noun
	return
	
assemblemech:
	matchre return The (\S+) mechanisms (?:is|are) not required to continue|What were you
	match assemblemech You place your
	send assemble my %assemble with my $MC.order.noun
	matchwait

stain:
	if %stain.gone = 1 then gosub new.tool
	gosub ToolCheckRight stain
	var Action drawknife
	 gosub Action apply my stain to my $MC.order.noun
	return

glue:
	if %glue.gone = 1 then gosub new.tool
	gosub ToolCheckRight glue
	var Action drawknife
	 gosub Action apply my glue to my $MC.order.noun
	return
	
shaft:
	if !matchre("$righthand|$lefthand", "lumber") then gosub GET my lumber
	gosub GET my $MC_SHAPER
	shapeshaft:
	pause 0.5
	gosub Action shape my lumber into bolt shaft
	gosub PUT_IT my shafts in my $MC_ENGINEERING.STORAGE
	repeat:
	matchre repeat \.\.\.wait|type ahead
	match done What were you referring to
	matchre shapeshaft You get|You pickup
	send lumber
	matchwait
	
arrowheads:
	gosub GET my %ArrowheadTool
	
arrowhead_material:
	pause 0.5
	matchre arrowhead_material \.\.\.wait|type ahead
		match arrowhead_make You get
		match done What were you
	send GET my %1
	matchwait

arrowhead_make:
	gosub Action shape %1 into bolthead
	gosub PUT_IT my bolth in my $MC_ENGINEERING.STORAGE
	goto arrowhead_material

new.tool:
	if !contains("$scriptlist", "mastercraft.cmd") then return
	 var temp.room $roomid
	 gosub check.location
	if %stain.gone = 1 then
		{
		 gosub automove %tool.room
		 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then gosub PUT_IT my $MC.order.noun in my $MC_ENGINEERING.STORAGE
		 action (order) on
		 gosub ORDER
		 pause .5
		 action (order) off
		 gosub ORDER %stain.order
		 gosub PUT_IT my stain in my $MC_ENGINEERING.STORAGE
		 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then gosub GET my $MC.order.noun from my $MC_ENGINEERING.STORAGE
		 var stain.gone 0
		}
	if %glue.gone = 1 then
		{
		 gosub automove %tool.room
		 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then gosub PUT_IT my $MC.order.noun in my $MC_ENGINEERING.STORAGE
		 action (order) on
		 gosub ORDER
		 pause .5
		 action (order) off
		 gosub ORDER %glue.order
		 gosub PUT_IT my glue in my $MC_ENGINEERING.STORAGE
		 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then gosub GET my $MC.order.noun from my $MC_ENGINEERING.STORAGE
		 var glue.gone 0
		}
	 gosub automove %temp.room
	 unvar temp.room
	return

Retry:
	pause 1
	gosub clear
	goto work

return:
	return

done:
	if %stain.gone = 1 then gosub new.tool
	if %glue.gone = 1 then gosub new.tool
	 gosub STOW_RIGHT
	 wait
	if "$lefthandnoun" = "$MC.order.noun" then gosub PUT swap
	pause 1
	if ("%MarkIt" = "YES") then gosub mark
	 put #parse TINKERING DONE
	exit
