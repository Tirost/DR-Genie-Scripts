#MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
#v 0.1.6
#
# Script Usage: .pound <item>					--forges the item
#				.pound <item> <no. of times>	--to forge more than one, assuming you have enough material
#
#   This script is used in conjunction with the mastercraft.cmd script, and is used to produce metal items on an anvil. To use it, place the
#	material to be used on the anvil, study your instructions, then start the script. Be sure to have all the relevant forging tools in your
#	forging bag, as well as any parts to be assembled. If you have a Maker's Mark, be sure that it is also on you if your character profile
#	in MC INCLUDE.cmd is toggled to mark items.
#
#	If you place an unfinished item on the anvil, this script will try to finish it for you.
#

debug 10

var pound.repeat 0
if_2 var pound.repeat %2
if_1 put #var MC.order.noun %1
var small.ingot 0
var item.anvil 0
include mc_include.cmd
var swap.tongs 0
var worn.tongs 0
var tongs.adj 0
var tongstied 0
var hammertied 0
var bellowstied 0
var shoveltied 0
var toolbelt 0

action var toolbelt 1 when a rugged forger's belt
action var bellowstied 1 when ^On the .*you see.*bellows
action var shoveltied 1 when ^On the .*you see.*shovel
action var tongstied 1 when ^On the .*you see.*tongs
action var hammertied 1 when ^On the .*you see.*hammer
action var swap.tongs 1 when ^You tap some.*(flat-bladed|articulated).*tongs (in.*|that you are holding|that you are wearing)\.$
action var worn.tongs 1 when ^You tap some.*(segmented|articulated).*tongs that you are wearing\.$
action var tongs.adj 0 when ^With a yank you fold the shovel
action var tongs.adj 1 when ^You lock the tongs into a fully extended position
action var tool bellows when and produces less heat from the stifled coals\.|is unable to consume its fuel\.|PUSH a BELLOWs
action var tool tongs when would benefit from some soft reworking\.|could use some straightening along the horn of the anvil\.|must be drawn into wire on a mandrel and placed in mold sets using tongs\.|^The .+ now looks ready to be turned into wire using a mandrel or mold set\.|TURN it with the tongs to perform these tasks\.$|^The metal must be transfered to plate molds and drawn into wire on a mandrel sets using tongs\.|TURN it with the tongs
action var tool shovel when dies down and appears to need some more fuel|^The fire needs more fuel before you can do that\.|^As you complete working the fire dies down and needs more fuel|PUSH FUEL with a SHOVEL
action var tool tub when ready for a quench hardening in the slack tub\.|^The metal now appears ready for cooling in the slack tub\.|^ You can PUSH the TUB to reposition it and quench the hot metal\.|PUSH the TUB
action var tool oil when some oil to preserve and protect it.$|POUR OIL on .* to complete the forging process\.$
action var tool analyze when ^The .* now appears ready for grinding and polishing on a grinding wheel\.|^Applying the final touches |^That tool does not seem suitable for that task\.
action var tool hammer when ^push my bellows|^turn .* with my tongs|^push fuel with my shovel|^push fuel with my tongs|pull .* with my pliers$|^push tub|looks ready to be pounded with a forging hammer.|You do not see anything that would obstruct pounding of the metal with a forging hammer
action var tool rehammer when ^The .* appears ready for pounding
action var tool assemble when ^\[Ingredients can
action var excessloc $1 when and so you split the ingot and leave the portion you won't be using in your (\S+).$
action var tool done when ^Applying the final touches, you complete|TURN the GRINDSTONE several times
action var item.anvil 1 when ^On the iron anvil you see
action (work) goto Retry when \.\.\.wait|type ahead
action (work) off

action var assemble $1 when another finished \S+ shield (handle)
action var assemble $1 when another finished wooden (hilt|haft)
action var assemble $1 $2 when another finished (long|short|small|large) leather (cord|backing)
action var assemble $1 $2 when another finished (small|large) cloth (padding)
action var assemble $1 $2 when another finished (long|short) wooden (pole)

send inv
waitfor INVENTORY HELP
if %toolbelt then send look on my forger belt
if !%tongstied  then send tap my tong
if $righthandnoun != "" then put stow $righthandnoun
pause .5
if %swap.tongs = 1 then
	{
	 var shovel tongs
	 send analyze my tongs
	 waitforre ^(These tongs are used|This tool is used to shovel)
	 if "$1" = "This tool is used to shovel" then send adjust my tongs
	 var tongs.adj 0
	}
else var shovel shovel
action (tongs) off
pause .5

first.temper:
	 var small.ingot 0
	 var tool hammer
	 gosub tempercheck
	 matchre work ^Roundtime
	 send get my %1
	 send put %1 on forge
	matchwait

 
work:
	pause 1
	action (work) on
	 save %tool
	 if "%tool" = "analyze" then goto analyze
	 if "%tool" = "done" then goto done
	 gosub %tool
	goto work

analyze:
	 pause
	 pause 1
	 send analyze $MC.order.noun
	 pause 1
	goto work

hammer:
	 gosub poundcheck
	 if %tongs.adj then send adjust my tongs
	 pause .5
	 send pound $MC.order.noun on anvil with my hammer
	 pause 1
	return

tempercheck:
	if !contains("$lefthandnoun", "tongs") then
	{
	 if %$lefthandnountied then send tie my $lefthandnoun to my forger belt
	 else send put my $lefthandnoun in my %forging.storage
	 if %worn.tongs then send hold my tongs
	 pause 1
	 if %tongstied then send untie tongs
	 else send get tongs from my %forging.storage
	 waitforre ^You get|^You sling|^You remove|^You untie
	 send swap
	}
	return

shovel:
	pause 1
	if %swap.tongs then
	{
		if !contains("$lefthandnoun", "tongs") then
		{
		 if %$righthandnountied then send tie my $righthandnoun to my forger belt
	 	 else send put my $righthandnoun in my %forging.storage
		 if %shoveltied then send untie %shovel
		 else send get %shovel
		 waitforre ^You get|^You sling|^You remove|^You untie
		 if !%tongs.adj then
		 	{
		 	send adjust tongs
		 	var tongs.adj 1
			}
		}
	}
	else
	{
	 if !contains("$righthandnoun", "shovel") then
		{
	   if %$righthandnountied then send tie my $righthandnoun to my forger belt
	   else send put my $righthandnoun in my %forging.storage
		 if %shoveltied then send untie %shovel
		 else send get my %shovel
		 waitforre ^You get|^You remove|^You untie
		}
	}
	 send push fuel with my %shovel
	 pause .5
	return

bellows:
	if !contains("$righthandnoun", "bellows") then
	{
	 if %$righthandnountied then send tie my $righthandnoun to my forger belt
	 else send put my $righthandnoun in my %forging.storage
	 if %bellowstied = 1 then send untie bellows
	 else send get my bellows
	 waitforre ^You get|^You remove|^You untie
	}
	 send push my bellows
	 pause 1
	return

tongs:
	 gosub poundcheck
	 if %swap.tongs = 1 && %tongs.adj = 1 then send adjust my tongs
	 pause .5
	 send turn $MC.order.noun on anvil with my tongs
	 pause 1
	return

tub:
	 send push tub
	 pause 1
	return

oil:
	if !contains("$righthandnoun", "flask of oil") then
	{
	 if %$righthandnountied then send tie my $righthandnoun to my forger belt
	 else send put my $righthandnoun in my %forging.storage
	 send get my oil from my %forging.storage
	 waitforre ^You get
	}
	send look on anvil
	pause 1
	if "$lefthandnoun" != "" && %item.anvil = 1 then
	{
	 if (("$lefthandnoun" = "tongs") && (%worn.tongs = 1)) then send wear my tongs
	 if %$lefthandnountied then send tie my $lefthandnoun to my forger belt
	 if !($lefthandnoun = "") then send put my $lefthandnoun in my %forging.storage
	 send get $MC.order.noun from anvil
	 waitforre ^You get
	 var item.anvil 0
	}
	if !contains("$lefthandnoun", "$MC.order.noun") then
	{
	 if ("$lefthandnoun" = "tongs" && %worn.tongs = 1) then send wear my tongs
	 if %$lefthandnountied then send tie my $righthandnoun to my forger belt
	 if !($righthandnoun = "") then  send put my $lefthandnoun in my %forging.storage
	 send get my $MC.order.noun from my %forging.storage
	 waitforre ^You get
	}
	 send pour my oil on $MC.order.noun
	 waitforre ^Roundtime
	 send put my oil in my %forging.storage
	 waitforre ^You put|^What were you referring to
	 gosub mark
	return

rehammer:
	 send put my $MC.order.noun on anvil
	 waitforre ^You put
	 var tool hammer
	return

assemble:
	if !contains("$righthandnoun", "%assemble") then
	{
	 if (("$lefthandnoun" = "tongs") && (%worn.tongs = 1)) then send wear my tongs
	 if %$lefthandnountied then send tie my $lefthandnoun to my forger belt
	 if !($lefthandnoun = "") then send put my $lefthandnoun in my %forging.storage
	 send get my %assemble from my %forging.storage
	 waitforre ^You get
	}
	send look on anvil
	pause 1
	if "$lefthandnoun" != "" && %item.anvil = 1 then
	{
	 if (("$lefthandnoun" = "tongs") && (%worn.tongs = 1)) then send wear my tongs
	 if %$lefthandnountied then send tie my $lefthandnoun to my forger belt
	 if !($lefthandnoun = "") then send put my $lefthandnoun in my %forging.storage
	 send get $MC.order.noun from anvil
	 waitforre ^You get
	 var item.anvil 0
	}
	if "$lefthandnoun" != "$MC.order.noun" then
	{
	 if (("$lefthandnoun" = "tongs") && (%worn.tongs = 1)) then send wear my tongs
	 if %$lefthandnountied then send tie my $lefthandnoun to my forger belt
	 if !($lefthandnoun = "") then send put my $lefthandnoun in my %forging.storage
	 send get my $MC.order.noun
	 waitforre ^You get
	}
	 send assemble my $MC.order.noun with my %assemble
	 pause 1
	 var tool analyze
	return

Retry:
	pause 1
	var tool %s
	goto work
	
repeat:
	 math pound.repeat subtract 1
	 send put my $MC.order.noun in my %forging.storage
	 waitforre ^You put
	 send get my book
	 waitforre ^You get
	 send study my book
	 pause 1
	 send get my ingot
	 waitforre ^You get
	 send put ingot on anvil
	 waitforre ^You put
	goto first.pound

done:
	pause .5
	send look on anvil
	if (("$righthandnoun" != "") && (!contains("$righthandnoun", "$MC.order.noun"))) then send put my $righthandnoun in my %forging.storage
	if ("$lefthandnoun" != ""  && !contains("$lefthandnoun", "$MC.order.noun")) then
	{
	 if (("$lefthandnoun" = "tongs") && (%worn.tongs = 1)) then send wear my tongs
	 if %$lefthandnountied then send tie my $lefthandnoun to my forger belt
	 if !($lefthandnoun = "") then send put my $lefthandnoun in my %forging.storage
	 waitforre ^You put|^You sling
	}
	pause 1
	if %item.anvil = 1 then send get $MC.order.noun from anvil
	var item.anvil 0
	 pause 1
	 if %pound.repeat > 1 then goto repeat
	 put #parse POUNDING DONE
	exit
