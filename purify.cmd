#Metal Purify

var material %1
var rodtied 0
var shoveltied 0
var bellowstied 0

action INSTANT goto purity.check when ingot mold
action var bellowstied 1 when ^On the .*you see.*bellows
action var shoveltied 1 when ^On the .*you see.*shovel
action var rodtied 1 when ^On the .*you see.*rod

if_1 goto SmeltStart
echo Usage is: .purify <material>

SmeltStart:
	action var matstow $1 when ingot from inside your (\S+|\S+\s+\w+)\.$
	match putmat You get
	match end What do you want to get
	match end What were you referring
	send get my %material ing
	matchwait

GetMat:
	match putmat You get
	match check.ingot What do you want to get	
	match gettool What were you referring
	send get my %material ing
	matchwait

PutMat:
	match toomuch smelting so many metal pieces at once would be dangerous
	match getmat You put
	send put ing in cruc
	matchwait

TooMuch:
	send put my %material nugg in my %matstow
	goto gettool

GetTool:
	pause 0.5
	put look on my forger belt
	pause 1
	if %rodtied then send untie my rod	
	else put get my rod
	send get my flux
	pause 1
	send pour flux in cruc
	match turn crucible's sides
	match fuel needs more fuel
	match bellows stifled coals
	match bellows unable to consume its fuel
	match stir Roundtime
	matchwait
	pause 1

Stir:
	pause
	pause 1
	if $lefthandnoun = flux then send put flux in my haversack
	send stir cruc with rod
	match turn crucible's sides
	match fuel needs more fuel
	match bellows stifled coals
	match bellows unable to consume its fuel
	match stir Roundtime
	matchwait

Fuel:
	pause
	pause 1
	if $lefthandnoun = flux then send put flux in my haversack
	if %shoveltied then send untie my shov
  else
  	{
		action var shovelstow $1 when shovel .*from inside your (\S+|\S+\s+\w+)\.$
		send get my shov
		}
	send push fuel with shov
	pause
	pause 1
	if %shoveltied then send tie my shovel to my forger's belt
	else send put shov in my %shovelstow
	goto stir

Bellows:
	pause
	pause 1
	if $lefthandnoun = flux then send put flux in my haversack
	if %bellowstied then send untie my bell
	else 
		{
		action var bellowstow $1 when from inside your (\S+|\S+\s+\w+)\.$
		send get my bell
		}
	send push bell
	pause
	pause 1
	if %bellowstied then send tie my bell to my forger's belt
	else send put bell in my %bellowstow
	goto stir

Turn:
	pause
	pause 1
	if $lefthandnoun = flux then send put flux in my haversack
	send turn cruc
	goto stir

Purity.Check:
	pause
	pause 1
	match finish has a quality of 99
	match again Roundtime
	send app my ing careful
	matchwait

Again:
	pause
	pause 1
	send put ing in cruc
	goto gettool

Finish:
	pause
	pause 1
	send put ing in my %matstow
	if %rodtied then send tie my rod to my forger's belt
	else send put rod in my %rodstow
	goto end

End:
	Echo All material used. Script complete.
	exit