debug 10
var mix.repeat 0
var current.lore ALCHEMY
if_3 var herb1 %3
if_4 var herb2 %4
if_2 var mix.repeat %2
if_1 put #var MC.order.noun %1
var tool mix
var alcohol.gone 0
var water.gone 0
var catalyst.gone 0
var special NULL
#include mc_include.cmd

action var tool mix when appears free of defects that would
action var tool mix when You do not see anything that would prevent
action var tool mix when composition looks accurate
action var tool mix when ^You realize the(.*) is not required to continue 
action var tool mix when ^That tool does not seem
action var tool turn when Clumps of material stick to the sides
action var tool turn when ^Once finished you notice clumps of material
action var tool smell when As you finish, the mixture begins to transition colors
action var tool smell when takes on an odd hue
action var tool sieve when ^Upon completion you see (?:some )?particulate clouding up the mixture
action var tool sieve when ^A thick froth coats
action var special water when ^You need another splash of water to continue crafting
action var special alcohol when  ^You need another splash of alcohol to continue crafting
action var special catalyst when ^You need another catalyst material to
action var special add.herb when You need another prepared herb to
action var tool done when ^Applying the final touches, you complete working
action (work) goto Retry when \.\.\.wait|type ahead
action (work) off
var alchemy.storage $MC_ALCHEMY.STORAGE

action (order) var water.order $1 when (\d+)\)\..*10 splashes of water.*(Lirums|Kronars|Dokoras)
action (order) var alcohol.order $1 when (\d+)\)\..*10 splashes of grain alcohol.*(Lirums|Kronars|Dokoras)
action (order) var catalyst.order $1 when (\d+)\)\..*a massive coal nugget.*(Lirums|Kronars|Dokoras)

var liquid tonic|wash|potion|elixir|draught
var solid cream|salve|balm|poultices|ungent|ointment

if matchre("$MC.order.noun", "%liquid") then
		{
		var mixer mixing stick
		var bowl bowl
		var tool.mix mix
		var water alcohol
		}
if matchre("$MC.order.noun", "%solid") then
		{
		var mixer pestle
		var bowl mortar
		var tool.mix crush
		var water water
		}
		
unfinished:
	if !matchre("$righthand|$lefthand", "%bowl") then 
		{
		gosub verb get my %bowl
		if matchre("$lefthand", "%bowl") then gosub verb swap
		}
	send look in my %bowl
	waitforre (^In the (.*)\.$|^I could not find|^There is nothing in there)
	pause 1
	if contains("$0", "unfinished") then
	{
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if !contains("$righthandnoun", "%bowl") then send swap
		pause 1
		goto work
	}

first.mix:
	if !matchre("%bowl", "($righthand|$lefthand)") then
		{
		gosub verb put $1 in %alchemy.storage
		gosub verb get my %bowl
		if matchre("$lefthand", "%bowl") then gosub verb swap
		}
	if !matchre("%herb1", "($righthand|$lefthand)") then
		{
		gosub verb put $1 in %alchemy.storage
		gosub verb get my %herb1
		}
	gosub verb put my %herb1 in my %bowl
	pause 0.5
	if "$lefthand" != "Empty" then gosub verb put $lefthandnoun in %alchemy.storage
	pause 0.5
	gosub verb get my %mixer
	pause 0.5
	if "%tool.mix" = "crush" then send %tool.mix my %herb1 in my %bowl with my %mixer
	else send %tool.mix my %bowl with my %mixer
	pause 5
	goto work


work:
	action (work) on
	save %tool
	if "%tool" = "done" then goto done
	gosub %tool
	goto work


mix:
	gosub specialcheck
	if !contains("$lefthandnoun", "%mixer") then
	{
		if "$lefthandnoun" != "" then gosub verb put my $lefthandnoun in my %alchemy.storage
		gosub verb get my %mixer
	}
	if "%tool.mix" = "crush" then send %tool.mix my $MC.order.noun in my %bowl with my %mixer
	else send %tool.mix my %bowl with my %mixer
	pause 5
	return
	

sieve:
	gosub specialcheck
	if !contains("$lefthandnoun", "sieve") then
	{
		if "$lefthandnoun" != "" then gosub verb put my $lefthandnoun in my %alchemy.storage
		gosub verb get my sieve
	}
	send push my $MC.order.noun with my sieve
	pause 5
	return
	
smell:
	gosub specialcheck
	send smell my $MC.order.noun
	pause 5
	return
	
turn:
	gosub specialcheck
	send turn my %bowl
	pause 5
	return
	
water:
	if %water.gone = 1 then gosub new.tool
	if !contains("$lefthandnoun", "water") then
	{
		if "$lefthandnoun" != "" then gosub verb put my $lefthandnoun in my %alchemy.storage
		gosub verb get my water from my %alchemy.storage
	}
	var tool mix
	send pour part water in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "water") then var water.gone 1
	return
	
alcohol:
	if %alcohol.gone = 1 then gosub new.tool
	if !contains("$lefthandnoun", "alcohol") then
	{
		if "$lefthandnoun" != "" then gosub verb put my $lefthandnoun in my %alchemy.storage
		gosub verb get my alcohol from my %alchemy.storage
	}
	send pour part alcohol in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "alcohol") then var alcohol.gone 1
	return
	
catalyst:
	if %catalyst.gone = 1 then gosub new.tool
	if !contains("$lefthandnoun", "nugget") then
	{
		if "$lefthandnoun" != "" then gosub verb put my $lefthandnoun in my %alchemy.storage
		gosub verb get my coal nugget from my %alchemy.storage
	}
	send put nugget in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "nugget") then var catalyst.gone 1
	return

add.herb:
	if !contains("$lefthandnoun", "%herb2") then
	{
		if "$lefthandnoun" != "" then gosub verb put my $lefthandnoun in my %alchemy.storage
		gosub verb get my %herb2 from my %alchemy.storage
	}
	send put %herb2 in my %bowl
	pause 0.5
	return
	
analyze:
	send analyze my $MC.order.noun
	waitforre ^You.*analyze
	goto work
	
specialcheck:
	if "%special" != "NULL" then gosub %special
	var special NULL
	return

new.tool:
if contains("$scriptlist", "mastercraft") then
	{
	action (work) off
	var temp.room $roomid
	if %water.gone = 1 then
	{
		gosub automove Alchemy suppl
		if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my %bowl in my %alchemy.storage
		action (order) on
		send order
		waitfor You see the following
		action (order) off
		gosub purchase order %water.order
		send put my water in my %alchemy.storage
		if "$righthandnoun" != "%bowl" && "$lefthandnoun" != "%bowl" then send get my %bowl from my %alchemy.storage
		pause .5
		var water.gone 0
	}
	if %alcohol.gone = 1 then
	{
		gosub automove Alchemy suppl
		if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my %bowl in my %alchemy.storage
		action (order) on
		pause 1
		send order
		waitfor You see the following
		action (order) off
		gosub purchase order %alcohol.order
		send put my alcohol in my %alchemy.storage
		if "$righthandnoun" != "%bowl" && "$lefthandnoun" != "%bowl" then send get my %bowl from my %alchemy.storage
		var alcohol.gone 0
	}
	if %catalyst.gone = 1 then
	{
		gosub automove Forging suppl
		if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my %bowl in my %alchemy.storage
		action (order) on
		pause 1
		send order
		waitfor You see the following
		action (order) off
		gosub purchase order %catalyst.order
		gosub verb put my coal in my %alchemy.storage
		if "$righthandnoun" != "%bowl" && "$lefthandnoun" != "%bowl" then send get my %bowl from my %alchemy.storage
		var catalyst.gone 0
	}
	gosub automove %temp.room
	pause 0.5
	unvar temp.room
	action (work) on
	return
	}
else
{
echo *** Out of Water or Alcohol! Go get more!
put #parse MIX DONE
put #parse ALCHEMY DONE
exit
} 

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
	if "%get.coin" = "off" then goto lack.coin.exit
	action (withdrawl) goto lack.coin.exit when (^The clerk flips through her ledger|^The clerk tells you)
	gosub automove teller
	send withd 5 gold
	waitfor The clerk counts
	gosub automove %temp.room
	var need.coin 0
	action remove (^The clerk flips through her ledger|^The clerk tells you)
	pause 1
	goto %purchaselabel

lack.coin.exit:
	echo You need some startup coin to purchase stuff! Go to the bank and try again!
	put #parse Need coin
	exit

return:
return

Retry:
	pause 1
	goto work
	
	
repeat:
	math mix.repeat subtract 1
	send put my $MC.order.noun in my %alchemy.storage
	waitforre ^You put
	send get my Remedies book
	send study my book
	waitforre Roundtime
	send put my book in my %alchemy.storage
	send get my %material
	waitforre ^You get
	var tool mix
	goto first.cut
	
	
done:
	if %water.gone = 1 then gosub new.tool
	if %catalyst.gone = 1 then gosub new.tool
	if %alcohol.gone = 1 then gosub new.tool
	gosub verb put my $lefthandnoun in my %alchemy.storage
	wait
	pause 1
	gosub verb get my $MC.order.noun from my %bowl
	if %mix.repeat > 1 then 
		{
		gosub verb put $MC.order.noun in %alchemy.storage 
		goto repeat
		}
	gosub verb put my $righthandnoun in my %alchemy.storage
	gosub countcheck
	put #parse ALCHEMY DONE
	exit
	
	include mc_include.cmd
	
countcheck:
action var temprem $1 when ^You count out (\d+) uses remaining\.
gosub verb count my $MC.order.noun
if %temprem > 5 then 
	{
	gosub verb mark my $MC.order.noun at 5
	gosub verb break my $MC.order.noun
	gosub verb empty left
	gosub verb swap
	}
return
	

blister cream 5 red flower, nemoih root, water, catalyst
head salve 5 nemoih root, water, catalyst
head ungent 5 nemoih root, water, catalyst
moisturizing ointment 5 red flower, plovik leaves, alcohol, catalyst
chest salve 5 plovik leaves, water, catalyst
chest ungent 5 plovik leaves, water, catalyst
itch salve 5 red flower, jadice flower, water, catalyst
limb salve 5 jadice flower, water, catalyst
limb ungent 5 jadice flower, water, catalyst
lip balm 5 red flower, nilos grass, water, catalyst
abdominal salve 5 nilos grass, water, catalyst
abdominal ungent 5 nilos grass, water, catalyst
neck salve 5 georin grass, water, catalyst
neck ungent 5 georin grass, water, catalyst
neck potion 5 riolur leaves, water, catalyst
neck tonic 5 riolur leaves, water, catalyst
back potion 5 junliar stem, water, catalyst
back tonic 5 junliar stem, water, catalyst
eye potion 5 aevaes leaves, water, catalyst
eye tonic 5 aevaes leaves, water, catalyst
body ointment 5 genich stem, alcohol, catalyst
body poultices 5 genich stem, alcohol, catalyst
body draught 5 ojhenik root, alcohol, catalyst
body elixir 5 ojhenik root, alcohol, catalyst
chest potion 5 ithor root, water, catalyst
chest tonic 5 ithor root, water, catalyst
face ointment 5 qun pollen, alcohol, catalyst
face poultices 5 qun pollen, alcohol, catalyst


mouth wash 5 blue flower, riolur leaves, water, catalyst
eye wash 5 blue flower, aevaes leaves, water, catalyst
hangover potion 5 blue flower, ojhenik root, water, catalyst

wart salve 5 red flower, sufil sap, water, catalyst
stomach tonic 5 blue flower, muljin sap, water, catalyst
refreshment elixir 5 blue flower, belradi moss, water, catalyst
vigor poultices 5 red flower, diocia sap, water, catalyst
back salve 5 hulnik grass, water, catalyst
eye salve 5 sufil sap, water, catalyst
skin salve 5 aloe leaves, water, catalyst
back ungent 5 hulnik grass, water, catalyst
eye ungent 5 sufil sap, water, catalyst
skin ungent 5 aloe leaves, water, catalyst
abdomen potion 5 muljin sap, water, catalyst
head potion 5 eghmok moss, water, catalyst
skin potion 5 lujeakave root, water, catalyst
limb potion 5 yelith root, water, catalyst
abdominal tonic 5 muljin sap, water, catalyst
head tonic 5 eghmok moss, water, catalyst
skin tonic 5 lujeakave root, water, catalyst
limb tonic 5 yelith root, water, catalyst
limb ointment 5 blocil berries, alcohol, catalyst
skin ointment 5 cebi root, alcohol, catalyst
general purpose ointment 5 diocia sap, alcohol, catalyst
skin poultices 5 cebi root, alcohol, catalyst
limb poultices 5 blocil berries, alcohol, catalyst
general poultices 5 diocia sap, alcohol, catalyst
face draught 5 hulij leaves, alcohol, catalyst
limb draught 5 nuloe stem, alcohol, catalyst
skin draught 5 hisan flower, alcohol, catalyst
general purpose draught 5 belradi moss, alcohol, catalyst
skin elixir 5 hisan flower, alcohol, catalyst
limb elixir 5 nuloe stem, alcohol, catalyst
face elixir 5 hulij leaves, alcohol, catalyst
general elixir 5 belradi moss, alcohol, catalyst 