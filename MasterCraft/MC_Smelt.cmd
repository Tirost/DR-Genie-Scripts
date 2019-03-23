#Metal Smelting
debug 10
include mc_include.cmd
var material %1
var matstow %tool.storage
gosub EMPTY_HANDS


action INSTANT goto finish when ^At last the metal appears to be thoroughly mixed and you pour it into an ingot mold
#goto gettool
if_1 goto SmeltStart
echo Usage is: .smelt <material>

SmeltStart:
	action (settype) on
	action (settype) var mattype $1 when %material (\w+) 
	send look in my $MC_FORGING.STORAGE
	pause 1
	action (settype) off
	match putmat You get
	match end What do you want to get
	match end What were you referring
	send get my %material %mattype
	matchwait

GetMat:
	match putmat You get
	match gettool What do you want to get
	match gettool What were you referring
	send get my %material %mattype
	matchwait

PutMat:
	match toomuch at once would be dangerous
	match getmat You put
	send put %mattype in cruc
	matchwait

TooMuch:
	gosub PUT_IT my %material %mattype in my $MC_FORGING.STORAGE
	goto gettool

GetTool:
	pause 1
	gosub GET my $MC_STIRROD
	goto stir

Stir:
	pause
	pause 1
	match turn crucible's sides
	match fuel needs more fuel
	match bellows stifled coals
	match bellows unable to consume its fuel
	match smeltstart You can only mix a crucible if it has something inside of it.
	match stir Roundtime
	send stir cruc with $MC_STIRROD
	matchwait

Fuel:
	pause
	pause 1
	gosub GET my $MC_SHOVEL
	send push fuel with $MC_SHOVEL
	pause
	pause 1
	gosub STOW_LEFT
	goto stir

Bellows:
	pause
	pause 1
	gosub GET my $MC_BELLOWS
	send push $MC_BELLOWS
	pause
	pause 1
	gosub STOW_LEFT
	goto stir

Turn:
	pause
	pause 1
	send turn cruc
	goto stir

Finish:
	pause
	pause 1
	if matchre("$righthand|$lefthand", "ingot") then gosub PUT_IT ing in my $MC_FORGING.STORAGE
	gosub STOW_RIGHT
	goto end

End:
	put #parse SMELTING DONE
	Echo All material used. Script complete.
	exit
