debug 10
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
action (work) goto Retry when \.\.\.wait|type ahead
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
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if !contains("$lefthandnoun", "$MC.order.noun") then send swap
		pause 1
		goto work
	}

first.carve:	
	##If the provided item name is in the ArrowheadMats list make arrowheads instead
	if matchre("$MC.order.noun", "%ArrowheadMats") then goto arrowheads
	if matchre("$MC.order.noun", "shaft") then goto shaft
	if $needmechanisms > 0 then 
		{
		gosub PRESS
		put get my lumber from my $MC_ENGINEERING.STORAGE
		pause 0.5
		put swap
		pause 0.5
		}

	##Enhancements start with clamp.
	if ("%enhance" = "ON") then
	{
		var MarkIt NO
		var Action clamp
		if contains("$righthandnoun", "bow") then send swap		
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
			
			pause 1
			send get my shafts
			pause 2
			
			if contains("$righthandnoun", "shafts") then send swap
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
			if contains("$righthandnoun", "lumber") then send swap
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
	 send get %excessmats
	 wait
	 send put my %excessmats in my $MC_ENGINEERING.STORAGE
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
	
restudy:
	send stow drawknife
	pause 0.5
	put get tinkering book from my $MC_ENGINEERING.STORAGE
	pause 0.2
	put study my book
	pause 0.5
	pause 0.5
	send put my book in my $MC_ENGINEERING.STORAGE
	send get my drawknife
	goto WORK

ToolStow:
	pause .5
	if "%BELTTOOLS" = "YES" then send tie my $righthandnoun to my belt
	else send put my $righthandnoun in my $MC_ENGINEERING.STORAGE
	###Reset BELTTOOLS for a new Tool
	var BELTTOOLS NO
	return

ToolGet:
	pause .5
	###Action var will contain the tool to be used next
	send get my %Action
		match Untie You pull at it
		match ToolGot You get
	matchwait 1
	put #echo You have no %Action, get some and try again!
	exit
	
Untie:
	pause .5
	var BELTTOOLS YES
	send untie my %Action
	
ToolGot:
	pause .5
	return
	
press:
	pause 1
	if $Engineering.Ranks < 100 then var pressset 1
	if matchre("$Engineering.Ranks", "(\d)\d\d" then var pressset $1
	if matchre("$righthandnoun|$lefthandnoun", "lumber") then send put my lumber in my $MC_ENGINEERING.STORAGE
	if !matchre("$righthandnoun|$lefthandnoun", "ingot") then send get my ingot
	pause 0.5
	if !match("$lefthandnoun", "ingot") then send swap
	pause 0.5
	send turn press to %pressset
	waitfor You dial

pressaction:
	if "%Action" = "done" then goto mechcombine
	else gosub %Action
	goto pressaction

mechcombine:
	gosub ToolStow
mechcombine_1:
	match presscount What were you referring to
	match mechcombine_2 You get
	send get my mech from my $MC_ENGINEERING.STORAGE
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
	send put my mech in my $MC_ENGINEERING.STORAGE
	if %mechnumber >= $totalmechanisms then 
		{
		put #var needmechanisms 0
		return
		}
	goto press

shovel:
	save shovel
	if !contains("$righthandnoun", "shovel") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send push fuel with my shovel
	 pause 1
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
	if !contains("$righthandnoun", "pliers") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	var Action Plierspress
	 match return The unfinished mechanism
	 match toosmall You need at least 5 volume of metal for the press
	 send push my ingot with press
	 matchwait 1
	return
	
	return:
	return
	
toosmall:
	put put ingot in buck
	pause 0.5
	send get my ingot
	goto %Action

pull:
	if (%pressoff) then
		{
		var Action shovel
		gosub shovel
		var Action pull
		}
		send pull mechanism with press
		pause 1
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

tools:
	if !contains("$righthandnoun", "tools") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send adjust my $MC.order.noun with my tools
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
	
pliers:
	if !contains("$righthandnoun", "pliers") then
	{
	 gosub ToolStow
	 gosub ToolGet
	}
	 send pull my $MC.order.noun with my pliers
	 pause 1
	return

assemble:
	if !matchre("$righthandnoun", "%assemble") then
	{
	 pause 1
	 gosub ToolStow
	 send get my %assemble
	 waitforre ^You get
	}
	 ###send assemble my $MC.order.noun with my %assemble
	 send assemble my %assemble with my $MC.order.noun
	 pause 1
	 if matchre("%assemble", "mechanism") then gosub assemblemech
	 if matchre("$righthandnoun", "%assemble") then send put my %assemble in my $MC_ENGINEERING.STORAGE
	 pause 0.5
	 send analyze my $MC.order.noun
	 pause 1
	return
	
assemblemech:
	matchre return The (\S+) mechanisms (?:is|are) not required to continue|What were you
	match assemblemech You place your
	send assemble my %assemble with my $MC.order.noun
	matchwait

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
	if !matchre("$righthand|$lefthand", "lumber") then send get my lumber
	pause 0.5
	send get my shaper
	pause 0.5
	shapeshaft:
	pause 0.5
	put shape my lumber into bolt shaft
	pause 0.5
	pause 0.5
	put put my shafts in my $MC_ENGINEERING.STORAGE
	repeat:
	match done What were you referring to
	matchre shapeshaft You get|You pickup
	send get lumber
	matchwait
	
arrowheads:
	send get my %ArrowheadTool
	
arrowhead_material:
	pause 0.5
	send get my %1
		match arrowhead_make You get
		match done What were you
	matchwait

arrowhead_make:
	send shape %1 into bolthead
	pause 5
	send put my bolth in my $MC_ENGINEERING.STORAGE
	pause 1
	goto arrowhead_material

new.tool:
	if !contains("$scriptlist", "mastercraft.cmd") then return
	 var temp.room $roomid
	 gosub check.location
	if %stain.gone = 1 then
		{
		 gosub automove %tool.room
		 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my $MC.order.noun in my $MC_ENGINEERING.STORAGE
		 action (order) on
		 send order
		 pause .5
		 action (order) off
		 gosub purchase order %stain.order
		 send put my stain in my $MC_ENGINEERING.STORAGE
		 waitforre ^You put
		 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then send get my $MC.order.noun from my $MC_ENGINEERING.STORAGE
		 var stain.gone 0
		}
	if %glue.gone = 1 then
		{
		 gosub automove %tool.room
		 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my $MC.order.noun in my $MC_ENGINEERING.STORAGE
		 action (order) on
		 send order
		 pause .5
		 action (order) off
		 gosub purchase order %glue.order
		 send put my glue in my $MC_ENGINEERING.STORAGE
		 waitforre ^You put
		 if ("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") then send get my $MC.order.noun from my $MC_ENGINEERING.STORAGE
		 var glue.gone 0
		}
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
	gosub clear
	goto work

return:
	return

done:
	if %stain.gone = 1 then gosub new.tool
	if %glue.gone = 1 then gosub new.tool
	 gosub ToolStow
	 wait
	if "$lefthandnoun" = "$MC.order.noun" then send swap
	pause 1
	if ("%MarkIt" = "YES") then gosub mark
	 put #parse TINKERING DONE
	exit
