#Auto-logging Script v0.5
#
#Auto-searches rooms to mine for specified resource.
#
#Associated Globals
#LOGGER_ENEMY - OFF/ON (do you want to log in rooms where there may be enemies?)
#LOGGER_SWIM  - OFF/ON (do you want to try to swim to rooms?)
#LOGGER_CLIMB - OFF/ON (do you want to try to climb to rooms?)
#LOGGER_CYCLE - Value of time in second to wait for nodes to cycle if you haven't found what you're looking for.
#
#Movement uses Automapper. This may get you stuck on Swim/Climb rooms if you don't have enough Athletics.
#Mining is done utilizing the 'lumberjacking.cmd' script, you must have this in your script folders in order for this to
#work properly.
#The logger relies on your ability to effectively see what type of material is available in a room. You need
#sufficient skill in Outdoorsmanship and Perception for this to be consistent otherwise the script will skip rooms.
#
#
#Version History
# v0.1 : Initial script release, adaption from AutoMiner script.
#

if !def("PREMIUM") then put #var PREMIUM NO
#debug 10

##Room Lists
#Too add a mine's rooms, use the following format (for zone names that have a space, replace the space with a period).
#If zones don't have a room of a specific type, give that type a value of 'NONE'.
#
#var <zonename>.Rooms -> Basic rooms available to all with no other special conditions.
#var <zonename>.Rooms.Prem -> Rooms available only to Estate Holders (Premium).
#var <zonename>.Rooms.Enemy -> Rooms that have enemies associated with them.
#var <zonename>.Rooms.Swim -> Rooms that need Athetics for swimming to be accessed.
#var <zonename>.Rooms.Climb -> Rooms that need Athletics for climbing to be accessed.
#var <zonename>.Room.Cycle -> Room to wait in while the nodes cycle.
#

##Crossing West Gate##
var Crossing.West.Gate.Rooms NONE
var Crossing.West.Gate.Rooms.Prem NONE
var Crossing.West.Gate.Rooms.Enemy 81|82|83|84|85|86|97|98|99|100|101|102|104|105|106|107|108|109|110|111|112|138|139|247|248|249|250|251|252|254|255|256|257|258|256|260|261|262|263
var Crossing.West.Gate.Rooms.Swim NONE
var Crossing.West.Gate.Rooms.Climb NONE
var Crossing.West.Gate.Room.Cycle 1


##Variables##
var Rare.List azurelle|bloodwood|bocote|cherry|copperwood|darkspine|ebony|goldwood|hickory|ironwood|kapok|lelori|mistwood|osage|redwood|rockwood|sandalwood|silverwood|tamarak|yew
var mat.type %1|%Rare.List
var this.room 0
var is.mat 0
var have.logged 0
var Room.Count 0
var prev.count 0

action (logger) var is.mat 1;var have.logged 1;var found.type $1 when (%mat.type) trees can be harvested 
action send #var PREMIUM ON when Your premium service has been continuous 
action goto Restart when ^MATERIAL CHANGE

if_1 then goto Check.List

echo Usage is: .logger <material type>
exit

##Script Start##
Check.List:
	if !def("PREMIUM") then send premi 10
	eval zonename replacere("$zonename"," ",".")
	var Rooms %%zonename.Rooms
	if ("$PREMIUM" = "YES"  && "%%zonename.Rooms.Prem" != "NONE") then var Rooms %Rooms|%%zonename.Rooms.Prem
	if ("$LOGGER_ENEMY" = "ON" && "%%zonename.Rooms.Enemy" != "NONE") then var Rooms %Rooms|%%zonename.Rooms.Enemy
	if ("$LOGGER_SWIM" = "ON" && "%%zonename.Rooms.Swim" != "NONE") then var Rooms %Rooms|%%zonename.Rooms.Swim
	if ("$LOGGER_CLIMB" = "ON" && "%%zonename.Rooms.Climb" != "NONE") then var Rooms %Rooms.%%zonename.Rooms.Climb
	eval Rooms replacere("%Rooms","NONE|","")
		eval Rooms replacere("%Rooms","^\|","")
	eval Room.Count count("%Rooms","|")
	math Room.Count add 1
	if %Room.Count > %prev.count then goto Check.Room
	goto Cycle.Rooms
	
Check.Room:
	if (%this.room < %Room.Count && %have.logged = 0) then
		{
		gosub Next.Room
		goto Watch
		}
	if (%this.room = %Room.Count && %have.logged = 0) then
		{
		var prev.count %Room.Count
		goto Check.List
		}
	if %have.logged = 1 then goto Check.More

Cycle.Rooms:
	var this.room 0
	put #goto %%zonename.Room.Cycle
	pause $LOGGER_CYCLE
	goto Check.Room
		
Next.Room:
	put #goto %Rooms(%this.room)
	waitforre ^YOU HAVE ARRIVED
	math this.room add 1
	return
	
Watch:
	if "$roomplayers" = "" then
		{
		send watch forest
		pause
		if %is.mat = 1 then goto Log.It
		}
	goto Check.Room

Log.It:
	action (logger) off
	put .lumberjacking %mat.type
	waitforre ^LOGGING FINISHED
	action (logger) on
	goto Check.More

Check.More:
	if matchre("%found.type","%Rare.List") then
		{
		echo This room was a rare tree of type: %found.type. Restarting script.
		goto Restart
		}
	matchre Restart ^You nod\.$
	matchre Done ^You shake your head\.$
	echo Do you want to log more?
	echo Put 'nod' for yes or 'shake head' for no.
	matchwait
	
Restart:
	echo Logging again.
	var this.room 0
	var have.logged 0
	var is.mat 0
	goto Check.Room
	
Done:
	echo Finished logging.
	exit
	
Return:
	return