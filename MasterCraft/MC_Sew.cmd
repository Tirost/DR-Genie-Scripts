#debug 10
#MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
#v 0.1.6
#
# Script Usage: .sew <item>						--sews the item
#				.sew <item> <no. of times>		--to sew more than one, assuming you have enough material
#
#   This script is used in conjunction with the mastercraft.cmd script, and is used to produce cloth and leather items. To use it, hold the
#	material to be used, study your instructions, then start the script. Be sure to have all the relevant tailoring tools in your outfitting bag,
#	as well as any parts to be assembled. If you have a Maker's Mark, be sure that it is also on you if your character profile in MC INCLUDE.cmd
#	is toggled to mark items.
#
#	If you are holding an unfinished item instead, this script will try to finish it for you.
#

var sew.repeat 0
var current.lore Outfitting
include mc_include.cmd
if_2 var material %2
if_3 var sew.repeat %3
if_1 put #var MC.order.noun %1
var tool needle
var pins.gone 0
var assemble


action var tool yardstick when could benefit from some remeasuring.*|be benefited by remeasuring
action var tool scissors when Some scissor cuts must be made|now it is time to cut away more of the \S+ with scissors.*|appears ready for further cutting with some scissors.
action var tool pins when could use some pins to.*|is in need of pinning
action var tool slickstone when ^A deep crease develops along the fabric.*|The fabric develops wrinkles from.*|RUB
action var tool awl when needs holes punched.*|requires some holes punched
#action var tool assemble when ASSEMBLE Ingredient1 WITH Ingredient2
action var tool done when Applying the final touches, you complete working
action var excessloc $2 when You carefully cut off the excess material and set it (on the|in your|at your) (\S+).$
action var tool needle when ^measure my \S+ with my yardstick|^rub my \S+ with my slickstone|poke my \S+ with my pins|^poke my \S+ with my awl|^cut my \S+ with my scissors|pushing it with a needle and thread
action GOTO unfinished when That tool does not seem suitable for that task.
action send get $MC.order.noun when ^You must be holding the .* to do that\.
#action (work) goto Retry when \.\.\.wait|type ahead
action (work) off

action (order) var thread.order $1 when (\d+)\)\..*yards of cotton thread.*(Lirums|Kronars|Dokoras)
action (order) var pins.order $1 when (\d+)\)\..*some straight iron pins.*(Lirums|Kronars|Dokoras)
action var pins.gone 1 when ^The pins is all used up, so you toss it away.
action var thread.gone 1 when ^The last of your thread is used up with the sewing.|^The needles need to have thread put on them
action (order) off

action var assemble $1 padding when another finished (small|large) cloth padding 
action var assemble $1 when another finished \S+ shield (handle)
action var assemble $1 $2 when another finished (long|short|small|large) leather (cord|backing)

unfinished:
	send glance
	waitforre ^You glance down (.*)\.$
	pause 1
	if contains("$0", "unfinished") then
	{
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if !contains("$righthandnoun", "$MC.order.noun") then send swap
		pause 1
		goto work
	}

first.cut:
	if (contains("$righthandnoun", "cloth") || contains("$lefthandnoun", "cloth")) then var material cloth
	if (contains("$righthandnoun", "leather") || contains("$lefthandnoun", "leather")) then var material leather
	pause 1
	if !contains("leather|cloth", "$righthandnoun") then send swap
	pause 1
	gosub ToolCheckLeft $MC_SCISSORS
	var tool needle
	matchre excess You carefully cut off the excess material and set it (on the|in your|at your) (\S+).$
	matchre work Roundtime: \d+
	send cut my %material with my $MC_SCISSORS
	matchwait

excess:
	pause 1
	if "$lefthand" != "Empty" then gosub STOW_LEFT
	gosub GET %material
	gosub PUT_IT %material in my $MC_OUTFITTING.STORAGE

work:
	action (work) on
	save %tool
	if "%tool" = "done" then goto done
	gosub %tool
	goto work

needle:
	if "%assemble" != "" then gosub assemble
	if %thread.gone = 1 then gosub new.tool
	gosub ToolCheckLeft $MC_NEEDLES
	gosub Action push my $MC.order.noun with my $MC_NEEDLES
	return

yardstick:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_YARDSTICK
	var tool needle
	gosub Action measure my $MC.order.noun with my $MC_YARDSTICK
	return

slickstone:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_SLICKSTONE
	var tool needle
	gosub Action rub my $MC.order.noun with my $MC_SLICKSTONE
	return

pins:
	if "%assemble" != "" then gosub assemble
	if %pins.gone = 1 then gosub new.tool
	if !contains("$lefthandnoun", "pins") then
	{
	if "$lefthand" != "Empty" then gosub STOW_LEFT
		gosub GET my pins
	}
	var tool needle
	gosub Action poke my $MC.order.noun with my pins
	return
	
scissors:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_SCISSORS
	var tool needle
	gosub Action cut my $MC.order.noun with my $MC_SCISSORS
	return

awl:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_AWL
	var tool needle
	gosub Action poke my $MC.order.noun with my $MC_AWL
	return
	
assemble:
	if "$lefthandnoun" != "%assemble" then
	{
		pause 1
	if "$lefthand" != "Empty" then gosub STOW_LEFT
		gosub GET my %assemble
	}
	send assemble my $MC.order.noun with my %assemble
	pause 1
	var assemble 
	#send analyze my $MC.order.noun
	return

new.tool:
if contains("$scriptlist", "mastercraft.cmd") then
	{
	action (work) off
	var temp.room $roomid
	gosub check.location
	if matchre("$righthand|$lefthand", "$MC.order.noun") then send put my $MC.order.noun in my $MC_OUTFITTING.STORAGE
	if %pins.gone = 1 then
	{
		gosub automove outfitting tool
		action (order) on
		gosub ORDER
		action (order) off
		gosub ORDER %pins.order
		gosub PUT_IT my pins in my $MC_OUTFITTING.STORAGE
		pause .5
		var pins.gone 0
	}
	if %thread.gone = 1 then
	{
		gosub automove outfitting suppl
		action (order) on
		pause 1
		gosub ORDER
		action (order) off
		gosub ORDER %thread.order
		pause 1
		send put my thread on my needles
		waitforre ^You carefully thread
		var thread.gone 0
	}
	gosub automove %temp.room
	if !matchre("$righthand|$lefthand", "$MC.order.noun") then gosub GET my $MC.order.noun from my $MC_OUTFITTING.STORAGE
	pause 0.5
	unvar temp.room
	action (work) on
	return
	}
else
{
echo *** Out of pins or thread! Go get more!
put #parse SEWING DONE
exit
} 


return:
return

Retry:
	pause 1
	goto work
	
repeat:
	math sew.repeat subtract 1
	gosub PUT_IT my $MC.order.noun in my $MC_OUTFITTING.STORAGE
	gosub GET my tailor book
	gosub Study my book
	gosub PUT_IT my book in my $MC_OUTFITTING.STORAGE
	gosub GET my %material
	var tool needle
	goto first.cut


done:
	if %pins.gone = 1 then gosub new.tool
	if %thread.gone = 1 then gosub new.tool
	if "$lefthand" != "Empty" then gosub STOW_LEFT
	gosub mark
	pause 1
	if %sew.repeat > 1 then goto repeat
	put #parse SEWING DONE
	exit