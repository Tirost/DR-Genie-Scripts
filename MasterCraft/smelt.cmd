#Metal Smelting
debug 10
var material %1
var matstow $MC_FORGING.STORAGE

if "$righthand $lefthand" != "Empty Empty" then 
		{
		put $righthandnoun in my $MC_FORGING.STORAGE
		put $lefthandnoun in my $MC_FORGING.STORAGE
		}


action INSTANT goto finish when ^At last the metal appears to be thoroughly mixed and you pour it into an ingot mold
#goto gettool
if_1 goto SmeltStart
echo Usage is: .smelt <material>

SmeltStart:
	action (settype) on
	action (settype) var mattype $1 when %material (\w+) 
	send look in my %matstow
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
	gosub verb put my %material %mattype in my %matstow
	goto gettool

GetTool:
	pause 1
	gosub verb get my rod
	goto stir

Stir:
	pause
	pause 1
	match turn crucible's sides
	match fuel needs more fuel
	match bellows stifled coals
	match bellows unable to consume its fuel
	mstch smeltstart You can only mix a crucible if it has something inside of it.
	match stir Roundtime
	send stir cruc with rod
	matchwait

Fuel:
	pause
	pause 1
	gosub verb get my shov
	send push fuel with shov
	pause
	pause 1
	gosub verb put $lefthand in my %matstow
	goto stir

Bellows:
	pause
	pause 1
	gosub verb get my bell
	send push bell
	pause
	pause 1
	gosub verb put $lefthand in my %matstow
	goto stir

Turn:
	pause
	pause 1
	send turn cruc
	goto stir

Finish:
	pause
	pause 1
	gosub verb put ing in my %matstow
	gosub verb put $righthand in my %matstow
	goto end

End:
	put #parse SMELTING DONE
	Echo All material used. Script complete.
	exit

include mc_include.cmd