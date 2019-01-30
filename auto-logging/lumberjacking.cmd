#debug 10

###Lumberjacking by Arvedui Iorlas
###Based off the original Mining Script
###Global Integration, Volume Tracking and Rare material gathering by Azarael

### User Defined Settings

# Tool adjective?
var tool $LUMBER_TOOL

# Tracking volume?
var volume.track $LUMBER_VOLUME.TRACK

# Which sizes of lumber to deed
var LumberDeed $LUMBER_MAT.DEED

# Where to put the stowed Lumber
var LumberStorage $LUMBER_MAT.STOW
var LargeStorage $LUMBER_LARGE.STOW

# List of materials to keep
###var MaterialKeepList (alder|ash|aspen|balsa|bamboo|birch|cedar|cypress|durian|elm|fir|hemlock|larch|mahogany|mangrove|maple|moabi|oak|pine|rosewood|spruce|teak|walnut|willow) (\w*)
var MaterialKeepList $LUMBER_KEEP.LIST

var RareMaterialList (azurelle|bloodwood|bocote|cherry|copperwood|darkspine|ebony|goldwood|hickory|ironwood|kapok|lelori|mistwood|osage|redwood|rockwood|sandalwood|silverwood|tamarak|yew) (\w+)

############################################################################
###Variable declaration.

var FoundWood 0
var Failure 0
var CarefulDone 0
var MaterialLevel 0
var DeedWorkers 0
var TotalWood 0
var TotalRare 0
var total.volume 0
var have.deeds 0
var warn.once 0
var position |second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth
var sizes (stick|branch|limb|log|thick log)
var volume.found.wood 0
var volume.found.rare 0
var materiallist (alder|ash|aspen|balsa|bamboo|birch|cedar|cypress|durian|elm|fir|hemlock|larch|mahogany|mangrove|maple|moabi|oak|pine|rosewood|spruce|teak|walnut|willow) (\w*)
#Material Keep List with rares added.
eval MaterialKeepList replacere("%MaterialKeepList", "\)", "|azurelle|bloodwood|bocote|cherry|copperwood|darkspine|ebony|goldwood|hickory|ironwood|kapok|lelori|mistwood|osage|redwood|rockwood|sandalwood|silverwood|tamarak|yew)")

############################################################################
##Miner script overrides.

if_1 then 
	{
	var this.mat 0
	var override.mats %1
	var MaterialKeepList
	eval override.count count("%override.mats","|")
	goto Parse.Override
	}
goto Triggers

Parse.Override:
	var MaterialKeepList %MaterialKeepList|%override.mats(%this.mat)
	if %this.mat < %override.count then
		{
		math this.mat add 1
		goto Parse.Override
	  }
	eval MaterialKeepList replacere("%MaterialKeepList","^\|","")
	var MaterialKeepList (%MaterialKeepList|azurelle|bloodwood|bocote|cherry|copperwood|darkspine|ebony|goldwood|hickory|ironwood|kapok|lelori|mistwood|osage|redwood|rockwood|sandalwood|silverwood|tamarak|yew)
############################################################################

###Trigger setup
Triggers:
# If roundtime wasn't up try sending the last command again.
action (Retry) pause, put $lastcommand when ...wait

# Check if we find anything when mining
action (Lumberjacking) %FoundWood = 1;%found.wood = $1;math TotalWood add 1;%this.size.wood = $2 when You roll a freshly-cut %materiallist
action (Lumberjacking) %FoundWood = 1;%found.wood = $1;math TotalWood add 1;%this.size.wood = $1 $3 when You roll a freshly-cut  (\w+) %materiallist
action (Lumberjacking) %FoundWood = 1;%found.rare = $1;math TotalRare add 1;%this.size.rare = $1 when You roll a You roll a freshly-cut %RareMaterialList
action (Lumberjacking) %FoundWood = 1;%found.rare = $1;math TotalRare add 1;%this.size.rare = $1 $3 when You roll a freshly-cut (\w+) %RareMaterialList

# Update the amount of material left in the room when checking.
action (WatchForest) %MaterialLevel = 6 when enormous number remains to be found
action (WatchForest) %MaterialLevel = 5 when substantial number remains to be found.
action (WatchForest) %MaterialLevel = 4 when good number remains to be found.
action (WatchForest) %MaterialLevel = 3 when decent number remains to be found.
action (WatchForest) %MaterialLevel = 2 when small number remains to be found.
action (WatchForest) %MaterialLevel = 1 when scattering of resources remains to be found.
action (WatchForest) %MaterialLevel = 0 when Despite thoroughly exploring the area you fail to find any trees to chop.

# Does the room have workers to deed stone, or do we have to provide our own?
action (WatchForest) %DeedWorkers = 0 when This area has no workers present to help haul away your items.
action (WatchForest) %DeedWorkers = 1 when Loggers stand ready

#Check if careful was done already
action (Careful) %CarefulDone = 1 when A pile of stones indicates the direction of additional trees still available for lumberjacking.

############################################################################

Main:
	action (Retry) off
	action (Lumberjacking) off
	put get my %tool
	gosub WatchForest

MainLoop:
	gosub Chop
	if %Failure = 4 then gosub WatchForest
	goto MainLoop
	
WatchForest:
	%Failure = 0
	match WatchForestContinue Studying the forest
	match RoomEmpty Roundtime:
	put watch forest
	matchwait

WatchForestContinue:
	action (WatchForest) off
	action (Retry) off
	action (Careful) off
	return

# Perform CHOP action
Chop:
	action (Lumberjacking) on
	action (Retry) on
	%FoundWood = 0
	pause
	put chop tree
	waitfor Roundtime:
	action (Lumberjacking) off
	action (Retry) off
	gosub Danger
	if %FoundWood = 1 then
		{
		%FoundWood = 0
		if (%volume.track && matchre("$roomobjs","%RareMaterialList")) then gosub volume.add rare
		else
			{
			if %volume.track then gosub volume.add wood
			gosub Collect wood
			}
		}
		else math Failure add 1
	return

Collect:
	pause 0.5
	if matchre("$roomobjs", "%MaterialKeepList (\w+)") then
	{
		%result = $1
		if (matchre("%result", ("%LumberDeed")) then gosub Deed %result
		else
		{
			action (Retry) on
			matchre Return You put|wait and see if they will collect it
			matchre Large.Stow That's too heavy to go in there
			put stow %result in %LumberStorage
			matchwait
		}
	}
	return
	
Large.Stow:
	put stow %result in %LargeStorage
	action (Retry) off
	return
	
Deed:
	%item = $0
		action (Retry) on
	if ( %DeedWorkers = 1 ) then
		{
		put push %item
		pause
		put stow deed
		}
	else
		{
		put take packet
		pause
		put push %item with packet
		pause
		put stow packet
		pause
		put stow deed
		}
	action (Retry) off
	return
	
Volume.Add:
	%type = $1
	gosub parse.array "%sizes" "%this.size.%type"
	math array.index add 1
	math volume.found.%type add %array.index
	return

Danger:
	put #queue clear
	pause

DangerFailure:
	action (WatchForest) on
	match DangerFailure Unfortunately, you are unable to find any way to avoid the danger.
	matchre DangerClear you stack a pile of stones as a warning signal|nothing of concern
	put watch forest danger
	matchwait

DangerClear:
	pause
	action (WatchForest) off
	action (Retry) on
	if matchre("$roomobjs", ("%MaterialKeepList")) then goto Collect
	return

RoomEmpty:
	if !%CarefulDone then
		{
		put watch forest careful
		waitfor Roundtime:
		var CarefulDone 1
		goto WatchForest
		}		 
	echo ===Wood type: %found.wood
	echo ===Total metal mined: %TotalWood
	if %volume.track then echo ===Total wood volume: %volume.found.wood
	if %rare.found > 0 then
		{
		echo ===Rare type: %found.rare
		echo ===Total rare: %TotalRare
		IF %volume.track then echo ===Total rare volume: %volume.found.rare
		}
	send #parse LOGGING FINISHED
exit

Return:
	action (Retry) off
	return
	
var array.index

parse.array:
	%this.array = $1
	%search.str = $2
	eval this.array tolower("%this.array")
	eval this.array replacere("%this.array", "\(|\)", "")
	eval search.str tolower("%search.str")
	if !matchre("%this.array", "(.*(?:\||^)%search.str)(?:\||$)") then
		{
		%array.index = Null
		echo String %search.str does not exist in array.
		}
	else
		{
		%substring_element = $1
		eval array.index count("%substring_element","|")
		}
	return