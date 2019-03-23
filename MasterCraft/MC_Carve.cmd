#MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
#v 0.1.6
#
# Script Usage: .carve <item>					--carves the item from bone
#				.carve <item> <stone size>		--carves the item from the stone size specified (ie pebble, rock, stone, boulder)
#
#   This script is used in conjunction with the mastercraft.cmd script, and is used to carve items from bone and stone.
#
#	To use it with bone, hold the material to be used, study your instructions, then start the script.
#	To use it with stone, have the stone in hand or on the floor, study your instructions, then start the script.
#
#	Due to the dual material nature of carving and the difficulty in managing stone deeds, repeating is not available for CARVE.CMD.
#
#	Be sure to have all the relevant carving tools in your engineering bag, as well as any parts to be assembled. If you have a
#	Maker's Mark, be sure that it is also on you if your character profile in MC INCLUDE.cmd is toggled to mark items.
#
#	If you are holding an unfinished item instead, this script will try to finish it for you.
#
#debug 10
#var rock stack
#var chisel saw
var rock boulder
var chisel chisel
var current.lore Engineering
include mc_include.cmd
if_2 var rock %2
if_1 put #var MC.order.noun %1
var Action carve
var polish.gone 0
var assemble


if "$MC_ENG.PREF" = "bone" then 
	{
    var rock stack
    var chisel $MC_SAW
	var hand my
	}
if "$MC_ENG.PREF" = "stone" then 
	{
    var rock boulder    
    var chisel $MC_CHISEL
	var hand
	}

action var Action riffler when notice several rough, jagged (shards|edges) protruding|rubbing the .* with a riffler set
action var Action rasp when and determine it is no longer level|has developed an uneven texture|uneven|scraping the .* with a rasp
action var Action polish when some discolored areas on|applying some polish to 
action var Action carve when ^carve .* with my %chisel|^scrape .* with my rasp|^rub .* with my riffler|^apply my polish to .*|appears free of defects that would impede further carving|anything that would prevent carving|ready for further carving
#action var Action assemble when ^\[Ingredients can
#action (work) goto Retry when \.\.\.wait|type ahead
action goto done when ^Applying the final touches|You cannot figure out how to do that

action (order) put #tvar polish.order $1 when (\d+)\)\..*jar of surface polish.*(Lirums|Kronars|Dokoras)
action var polish.gone 1 when ^The polish is all used up, so you toss it away.

action var assemble $1 when another finished \S+ shield (handle)
action var assemble $1 when another finished wooden (hilt|haft)
action var assemble $1 $2 when another finished (long|short|small|large) leather (cord|backing)
action var assemble $1 $2 when another finished (small|large) cloth (padding)
action var assemble $1 $2 when another finished (long|short) wooden (pole)

#fix polish ordering, don't leave room with item in it!

unfinished:
	if "%rock" != "stack" then goto first.carve
	send glance
	waitforre ^You glance down (.*)\.$
	pause 1
	if contains("$0", "unfinished") || ("%rock" = "boulder" && matchre("$roomobjs", "unfinished.*$MC.order.noun")) then
	{
	send analyze $MC.order.noun
	waitforre ^You.*analyze
	if !contains("$lefthandnoun", "$MC.order.noun") then gosub PUT swap
	pause 1
	goto work
	}

first.carve:
	if contains("$righthandnoun", "%rock") then gosub PUT swap
	pause 1
	if ((contains("$lefthandnoun", "%rock")) && ("%rock" != "stack")) then gosub PUT drop my $lefthandnoun
	pause 1
	gosub ToolCheckRight %chisel
	 matchre excess and place the excess (.+) off to the side|cut off the excess material
	 matchre work Roundtime: \d+
	 send carve %hand %rock with my %chisel
	matchwait

excess:
	pause
	if "%rock" != "stack" then
	{
	 var extra $0
	 if "%extra" = "pebble" then
	 {
	 gosub GET pebble
	 gosub PUT_IT my pebble in my %engineering.storage
	 goto work
	 }
	 gosub GET packet
	 send push %extra with my packet
	 gosub PUT_IT my packet in my %engineering.storage
	 gosub GET deed
	 gosub PUT_IT my deed in my %engineering.storage
	 goto work
	}
	else
	{
	 gosub PUT_IT my %chisel in my %engineering.storage
	 gosub GET stack
	 gosub PUT_IT my stack in my %engineering.storage
	 goto work
	}
	 
work:
action (work) on
save %Action
gosub %Action
goto work

carve:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckRight %chisel
	 gosub Action carve %hand $MC.order.noun with my %chisel
	return


riffler:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckRight $MC_RIFFLER
	var Action carve
	 gosub Action rub %hand $MC.order.noun with my $MC_RIFFLER
	return

rasp:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckRight $MC_RASP
	var Action carve
	 gosub Action scrape %hand $MC.order.noun with my $MC_RASP
	return

polish:
	if "%assemble" != "" then gosub assemble
	if %polish.gone = 1 then gosub new.tool
	if !contains("$righthandnoun", "polish") then
	{
	 gosub STOW_RIGHT
	 gosub GET my polish
	}
	var Action carve
	 gosub Action apply %hand polish to my $MC.order.noun
	return

assemble:
	if "$righthandnoun" != "%assemble" then
	{
	 pause 1
	 gosub STOW_RIGHT
	 gosub GET my %assemble
	}
	 send assemble %hand $MC.order.noun with my %assemble
	 var assemble
	return

new.tool:
	if !contains("$scriptlist", "mastercraft.cmd") then return
	 var temp.room $roomid
	 gosub check.location
	if %polish.gone = 1 then
		{
		 gosub automove $tool.room
		 if !("$righthand" = "Empty" || "$lefthand" = "Empty") then gosub PUT_IT my $MC.order.noun in my %engineering.storage
		 action (order) on
		 gosub ORDER
		 action (order) off
		 gosub ORDER $polish.order
		 gosub PUT_IT my polish in my %engineering.storage
		 if (("$righthandnoun" != "$MC.order.noun" && "$lefthandnoun" != "$MC.order.noun") && ("%rock" = "stack")) then gosub GET my $MC.order.noun from my %engineering.storage
		 var polish.gone 0
		}
	 gosub automove %temp.room
	 unvar temp.room
	return

Retry:
	pause 1
	var Action %s
	goto work

return:
	return

done:
	if %polish.gone = 1 then gosub new.tool
	gosub STOW_RIGHT
	 wait
	if "$lefthandnoun" = "$MC.order.noun" then gosub PUT swap
	pause 1
	 gosub mark
	 put #parse CARVING DONE
	exit
