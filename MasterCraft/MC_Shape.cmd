###debug 10
# Shaping by Arvedui Iorlas
# Based off Mastercraft Carving script
#
# Script Usage: .shape <item>					--shapes the item
# Item can be any shaping item
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
var ArrowheadTool Katar
var ArrowheadMats (tooth|fang|horn|claw|tusk)

include mc_include.cmd
if_1 put #var MC.order.noun %1
if_2 var shape.repeat %2
if_3 var enhance ON

var Action drawknife
var stain.gone 0
var glue.gone 0

action put #queue clear;var Action carving.knife when carved with a carving knife|with a knife|trimmed with a carving knife|knife carving
action put #queue clear;var Action rasp when unless rubbed out with a rasp|rubbing them out with a rasp
action put #queue clear;var Action shaper when Shaping with a wood shaper is needed|Using slow strokes you scrape away some rough edges on the arrows|with a wood shaper
action put #queue clear;var Action clamp when place by pushing it with clamps or a vise\.|with clamps or a vise to hold it in place|ready to be clamped together|compressed with clamps
action put #queue clear;var Action stain when ready for the application of stain|wood stain should be applied
action put #queue clear;var Action glue when Glue should now be applied|glue applied to them|application of wood glue|application of glue
action put #queue clear;goto fouledup when That tool does not seem suitable for that task.

action var assemble $1 when another finished bow (string)
action var assemble backer when You need another bone, wood or horn backing material|ready to be reinforced with some backer
action var assemble $1.arrowhead when You need another (.*) arrowheads to continue crafting
action var assemble flights when You need another arrow flights
action var assemble strips when You need another finished leather strips|strengthened with some leather strips
action var assemble $1 $2 when another finished (long|short) leather (cord)
action var assemble $1 $2 when another finished (long|short) wooden (pole)
 
action var Action assemble when ^\[Ingredients can|You must assemble|appears ready to be reinforced|appears ready to be strengthened
#action (work) goto Retry when \.\.\.wait|type ahead
action goto done when ^Applying the final touches|You cannot figure out how to do that

action (order) var stain.order $1 when (\d+)\)\..*some wood stain.*(Lirums|Kronars|Dokoras)
action var stain.gone 1 when ^The stain is all used up, so you toss it away.

action (order) var glue.order $1 when (\d+)\)\..*some wood glue.*(Lirums|Kronars|Dokoras)
action var glue.gone 1 when ^The glue is all used up, so you toss it away.


unfinished:
	send glance
	waitforre ^You glance down (.*)\.$
	pause 2
	if contains("$0", "unfinished") then
	{
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if !contains("$lefthandnoun", "$MC.order.noun") then gosub PUT swap
		pause 1
		goto work
	}

first.carve:	
	##If the provided item name is in the ArrowheadMats list make arrowheads instead
	if matchre("$MC.order.noun", "%ArrowheadMats") then goto arrowheads
	if matchre("$MC.order.noun", "shaft" then goto shaft

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
		if ("$MC.order.noun" = "arrows") then
		{
			var Action shaper
			var excessmats shafts
			var MarkIt NO
			
			pause 1
			gosub GET my shafts
			pause 2
			
			if contains("$righthandnoun", "shafts") then gosub PUT swap
			pause 1
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
			 matchre excess You carefully separate out the excess material and place it (on the ground|at your feet).
			 matchre work Roundtime: \d+
			 send scrape my lumber with $MC_DRAWKNIFE
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
	send analyze my $MC.order.noun
	pause 1
	goto work

drawknife:
	gosub ToolCheckRight $MC_DRAWKNIFE
	 gosub action scrape my $MC.order.noun with my $MC_DRAWKNIFE
	return

carving.knife:
	gosub ToolCheckRight $MC_CARVINGKNIFE
	var Action drawknife
	 gosub action carve my $MC.order.noun with my $MC_CARVINGKNIFE
	return

rasp:
	gosub ToolCheckRight $MC_RASP
	var Action drawknife
	 gosub action scrape my $MC.order.noun with my $MC_RASP
	return

shaper:
	gosub ToolCheckRight $MC_SHAPER
	var Action drawknife
	 gosub action shape my $MC.order.noun with my $MC_SHAPER
	return
	
clamp:
	gosub ToolCheckRight $MC_CLAMPS
	var Action drawknife
	 gosub action push my $MC.order.noun with my $MC_CLAMPS
	return

assemble:
	if "$righthandnoun" != "%assemble" then
	{
	 pause 1
	 gosub STOW_RIGHT
	 gosub GET my %assemble
	}
	 ###send assemble my $MC.order.noun with my %assemble
	 send assemble my %assemble with my $MC.order.noun
	 pause 1
	 gosub action analyze my $MC.order.noun
	 pause 1
	return

stain:
	if %stain.gone = 1 then gosub new.tool
	gosub ToolCheckRight stain
	var Action drawknife
	 gosub action apply my stain to my $MC.order.noun
	 pause 1
	return

glue:
	if %glue.gone = 1 then gosub new.tool
	gosub ToolCheckRight glue
	var Action drawknife
	 gosub action apply my glue to my $MC.order.noun
	return
	
shaft:
	if !matchre("$righthand|$lefthand", "lumber") then gosub GET my lumber
	pause 0.5
	gosub GET my $MC_SHAPER
	pause 0.5
	shapeshaft:
	pause 0.5
	put shape my lumber into bolt shaft
	pause 0.5
	pause 0.5
	gosub PUT_IT my shafts in my $MC_ENGINEERING.STORAGE
	repeat:
	match done What were you referring to
	matchre shapeshaft You get|You pickup
	send get lumber
	matchwait
	
arrowheads:
	gosub GET my %ArrowheadTool
	
arrowhead_material:
	match arrowhead_make You get
	match done What were you
	send get my %1
	matchwait

arrowhead_make:
	send shape %1
	pause 5
	gosub PUT_IT my arrowh in my $MC_ENGINEERING.STORAGE
	pause 1
	goto arrowhead_material

new.tool:
	if !contains("$scriptlist", "mastercraft.cmd") then return
	 var temp.room $roomid
	 gosub check.location
	 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then gosub PUT_IT my $MC.order.noun in my $MC_ENGINEERING.STORAGE
	if %stain.gone = 1 then
		{
		 gosub automove $tool.room
		 action (order) on
		 gosub ORDER
		 pause .5
		 action (order) off
		 gosub ORDER %stain.order
		 gosub PUT_IT my stain in my $MC_ENGINEERING.STORAGE
		 var stain.gone 0
		}
	if %glue.gone = 1 then
		{
		 gosub automove $tool.room
		 action (order) on
		 gosub ORDER
		 pause .5
		 action (order) off
		 gosub ORDER %glue.order
		 gosub PUT_IT my glue in my $MC_ENGINEERING.STORAGE
		 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then gosub GET my $MC.order.noun from my $MC_ENGINEERING.STORAGE
		 var glue.gone 0
		}
	 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then gosub GET my $MC.order.noun from my $MC_ENGINEERING.STORAGE
	 gosub automove %temp.room
	 unvar temp.room
	return

Retry:
	pause 1
	var Action %s
	goto work

return:
	return
	
repeat:
	math shape.repeat subtract 1
	gosub PUT_IT my $MC.order.noun in my $MC_ENGINEERING.STORAGE
	gosub GET my shaping book
	gosub STUDY my book
	gosub PUT_IT my book in my $MC_ENGINEERING.STORAGE
	gosub GET my lumber
	var Action drawknife
	goto first.carve


done:
	if %stain.gone = 1 then gosub new.tool
	if %glue.gone = 1 then gosub new.tool
	 gosub STOW_RIGHT
	if "$lefthandnoun" = "$MC.order.noun" then gosub PUT swap
	pause 1
	if ("%MarkIt" = "YES") then gosub mark
	if %shape.repeat > 1 then goto repeat
	 put #parse SHAPING DONE
	exit


