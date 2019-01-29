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
if_2 var enhance ON

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
action (work) goto Retry when \.\.\.wait|type ahead
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
		if !contains("$lefthandnoun", "$MC.order.noun") then gosub verb swap
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
		if contains("$righthandnoun", "bow") then gosub verb swap		
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
			gosub verb get my shafts
			pause 2
			
			if contains("$righthandnoun", "shafts") then gosub verb swap
			pause 1
			if !contains("$righthandnoun", "shaper") then
			{
			 gosub ToolStow
			 gosub ToolGet
			}
			 matchre excess You place the excess parts at your feet.
			 matchre work Roundtime: \d+
			 send shape my shaft with my shaper
			matchwait
		}
		else
		{
			var Action drawknife
			var excessmats lumber
			if contains("$righthandnoun", "lumber") then gosub verb swap
			pause 1
			if !contains("$righthandnoun", "drawknife") then
			{
			 gosub ToolStow
			 gosub ToolGet
			}
			 matchre excess You carefully separate out the excess material and place it on the ground.
			 matchre work Roundtime: \d+
			 send scrape my lumber with %Action
			matchwait
		}
	}

excess:
	pause
	 gosub ToolStow
	 wait
	 gosub verb get %excessmats
	 wait
	 gosub verb put my %excessmats in my $MC_ENGINEERING.STORAGE
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

ToolStow:
	pause .5
	if "%BELTTOOLS" = "YES" then send tie my $righthandnoun to my belt
	else gosub verb put my $righthandnoun in my $MC_ENGINEERING.STORAGE
	###Reset BELTTOOLS for a new Tool
	var BELTTOOLS NO
	return

ToolGet:
	pause .5
	###Action var will contain the tool to be used next
	put get my %Action
		match Untie You pull at it
		match ToolGot You get
	matchwait
	
Untie:
	pause .5
	var BELTTOOLS YES
	send untie my %Action
	
ToolGot:
	pause .5
	return

drawknife:
	if !contains("$righthandnoun", "drawknife") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send scrape my $MC.order.noun with my drawknife
	 pause 1
	return

carving.knife:
	if !contains("$righthandnoun", "carving.knife") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send carve my $MC.order.noun with my knife
	 pause 1
	return

rasp:
	if !contains("$righthandnoun", "rasp") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 ###send rub my $MC.order.noun with my rasp
	 send scrape my $MC.order.noun with my rasp
	 pause 1
	return

shaper:
	if !contains("$righthandnoun", "shaper") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send shape my $MC.order.noun with my shaper
	 pause 1
	return
	
clamp:
	if !contains("$righthandnoun", "clamps") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send push my $MC.order.noun with my clamps
	 pause 1
	return

assemble:
	if "$righthandnoun" != "%assemble" then
	{
	 pause 1
	 gosub ToolStow
	 gosub verb get my %assemble
	}
	 ###send assemble my $MC.order.noun with my %assemble
	 send assemble my %assemble with my $MC.order.noun
	 pause 1
	 send analyze my $MC.order.noun
	 pause 1
	return

stain:
	if %stain.gone = 1 then gosub new.tool
	if !contains("$righthandnoun", "stain") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send apply my stain to my $MC.order.noun
	 pause 1
	return

glue:
	if %glue.gone = 1 then gosub new.tool
	if !contains("$righthandnoun", "glue") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send apply my glue to my $MC.order.noun
	 pause 1
	return
	
shaft:
	if !matchre("$righthand|$lefthand", "lumber") then gosub verb get my lumber
	pause 0.5
	gosub verb get my shaper
	pause 0.5
	shapeshaft:
	pause 0.5
	put shape my lumber into bolt shaft
	pause 0.5
	pause 0.5
	gosub verb put my shafts in my $MC_ENGINEERING.STORAGE
	repeat:
	match done What were you referring to
	matchre shapeshaft You get|You pickup
	send get lumber
	matchwait
	
arrowheads:
	gosub verb get my %ArrowheadTool
	
arrowhead_material:
		match arrowhead_make You get
		match done What were you
	send get my %1
	matchwait

arrowhead_make:
	send shape %1
	pause 5
	gosub verb put my arrowh in my $MC_ENGINEERING.STORAGE
	pause 1
	goto arrowhead_material

new.tool:
	if !contains("$scriptlist", "mastercraft.cmd") then return
	 var temp.room $roomid
	 gosub check.location
	 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then gosub verb put my $MC.order.noun in my $MC_ENGINEERING.STORAGE
	if %stain.gone = 1 then
		{
		 gosub automove $tool.room
		 action (order) on
		 gosub verb order
		 pause .5
		 action (order) off
		 gosub purchase order %stain.order
		 gosub verb put my stain in my $MC_ENGINEERING.STORAGE
		 var stain.gone 0
		}
	if %glue.gone = 1 then
		{
		 gosub automove $tool.room
		 action (order) on
		 gosub verb order
		 pause .5
		 action (order) off
		 gosub purchase order %glue.order
		 gosub verb put my glue in my $MC_ENGINEERING.STORAGE
		 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then gosub verb get my $MC.order.noun from my $MC_ENGINEERING.STORAGE
		 var glue.gone 0
		}
	 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then gosub verb get my $MC.order.noun from my $MC_ENGINEERING.STORAGE
	 gosub automove %temp.room
	 unvar temp.room
	return

purchase:
     var purchase $0
     goto purchase2
purchase.p:
     pause 0.5
purchase2:
     matchre purchase.p type ahead|...wait|Just order it again
	 matchre lack.coin you don't have enough coins|you don't have that much
     matchre return pay the sales clerk|takes some coins from you
	 put %purchase
    matchwait

lack.coin:
	 if contains("$scriptlist", "mastercraft.cmd") then put #parse LACK COIN
	 else echo *** You need some startup coin to purchase stuff! Go to the bank and try again!
	exit

Retry:
	pause 1
	var Action %s
	goto work

return:
	return

done:
	if %stain.gone = 1 then gosub new.tool
	if %glue.gone = 1 then gosub new.tool
	 gosub ToolStow
	 wait
	if "$lefthandnoun" = "$MC.order.noun" then gosub verb swap
	pause 1
	if ("%MarkIt" = "YES") then gosub mark
	 put #parse SHAPING DONE
	exit
