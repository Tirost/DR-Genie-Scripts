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
include mc_include.cmd

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
#action (work) goto Retry when \.\.\.wait|type ahead
action (work) off
var alchemy.storage $MC_ALCHEMY.STORAGE

action (order) var water.order $1 when (\d+)\)\..*10 splashes of water.*(Lirums|Kronars|Dokoras)
action (order) var alcohol.order $1 when (\d+)\)\..*10 splashes of grain alcohol.*(Lirums|Kronars|Dokoras)
action (order) var catalyst.order $1 when (\d+)\)\..*a massive coal nugget.*(Lirums|Kronars|Dokoras)

var liquid tonic|wash|potion|elixir|draught
var solid cream|salve|balm|poultices|ungent|ointment

if matchre("$MC.order.noun", "%liquid") then
		{
		var mixer $MC_STICK
		var bowl $MC_BOWL
		var tool.mix mix
		var water alcohol
		}
if matchre("$MC.order.noun", "%solid") then
		{
		var mixer $MC_PESTLE
		var bowl $MC_MORTAR
		var tool.mix crush
		var water water
		}
		
unfinished:
	gosub ToolCheckRight %bowl
	if matchre("%bowl", "$lefthand") then gosub PUT swap
	send look in my %bowl
	waitforre (^In the (.*)\.$|^I could not find|^There is nothing in there)
	pause 1
	if contains("$0", "unfinished") then
	{
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if !matchre("%bowl", "$righthand") then gosub PUT swap
		pause 1
		goto work
	}

first.mix:
	gosub ToolCheckRight %bowl
	if matchre("%bowl", "$lefthand") then gosub PUT swap
	gosub ToolCheckLeft %herb1
	gosub PUT_IT my %herb1 in my %bowl
	pause 0.5
	if "$lefthand" != "Empty" then gosub STOW_LEFT
	pause 0.5
	gosub GET my %mixer
	pause 0.5
	if "%tool.mix" = "crush" then gosub Action %tool.mix %herb1 in my %bowl with my %mixer
	else gosub Action %tool.mix my %bowl with my %mixer
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
	gosub ToolCheckLeft %mixer
	if "%tool.mix" = "crush" then gosub Action %tool.mix $MC.order.noun in my %bowl with my %mixer
	else gosub Action %tool.mix my %bowl with my %mixer
	return
	

sieve:
	gosub specialcheck
	gosub ToolCheckLeft $MC_SIEVE
	var tool mix
	gosub Action push my $MC.order.noun with my $MC_SIEVE
	return
	
smell:
	gosub specialcheck
	var tool mix
	gosub Action smell my $MC.order.noun
	return
	
turn:
	gosub specialcheck
	var tool mix
	gosub Action turn my %bowl
	return
	
water:
	if %water.gone = 1 then gosub new.tool
	gosub ToolCheckLeft water
	var tool mix
	send pour part water in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "water") then var water.gone 1
	return
	
alcohol:
	if %alcohol.gone = 1 then gosub new.tool
	gosub ToolCheckLeft alcohol
	var tool mix
	send pour part alcohol in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "alcohol") then var alcohol.gone 1
	return
	
catalyst:
	if %catalyst.gone = 1 then gosub new.tool
	if !contains("$lefthandnoun", "nugget") then
	{
		if "$lefthand" != "Empty" then gosub STOW_LEFT
		gosub GET my coal nugget from my %alchemy.storage
	}
	var tool mix
	send put nugget in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "nugget") then var catalyst.gone 1
	return

add.herb:
	gosub ToolCheckLeft %herb2
	var tool mix
	send put %herb2 in my %bowl
	pause 0.5
	return
	
analyze:
	gosub Action analyze my $MC.order.noun
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
		if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my %bowl in my %tool.storage
		action (order) on
		pause 0.5
		gosub ORDER
		action (order) off
		gosub ORDER %water.order
		gosub PUT_IT my water in my %alchemy.storage
		if "$righthandnoun" != "%bowl" && "$lefthandnoun" != "%bowl" then send get my %bowl from my %tool.storage
		pause .5
		var water.gone 0
	}
	if %alcohol.gone = 1 then
	{
		gosub automove Alchemy suppl
		if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my %bowl in my %tool.storage
		action (order) on
		pause 1
		gosub ORDER
		action (order) off
		gosub ORDER %alcohol.order
		gosub PUT_IT my alcohol in my %alchemy.storage
		if "$righthandnoun" != "%bowl" && "$lefthandnoun" != "%bowl" then send get my %bowl from my %tool.storage
		var alcohol.gone 0
	}
	if %catalyst.gone = 1 then
	{
		gosub automove Forging suppl
		if !("$righthand" = "Empty" || "$lefthand" = "Empty") then send put my %bowl in my %tool.storage
		action (order) on
		pause 1
		gosub ORDER
		action (order) off
		gosub ORDER %catalyst.order
		gosub PUT_IT my coal in my %alchemy.storage
		if "$righthandnoun" != "%bowl" && "$lefthandnoun" != "%bowl" then send get my %bowl from my %tool.storage
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
	gosub PUT_IT my $MC.order.noun in my %alchemy.storage
	gosub GET my Remedies book
	gosub STUDY study my book
	gosub PUT_IT my book in my %alchemy.storage
	gosub GET my %material
	var tool mix
	goto first.cut
	
	
done:
	if %water.gone = 1 then gosub new.tool
	if %catalyst.gone = 1 then gosub new.tool
	if %alcohol.gone = 1 then gosub new.tool
	if "$lefthand" != "Empty" then gosub STOW_LEFT
	gosub GET my $MC.order.noun from my %bowl
	if %mix.repeat > 1 then 
		{
		gosub PUT_IT $MC.order.noun in %alchemy.storage 
		goto repeat
		}
	if "$righthand" != "Empty" then gosub STOW_RIGHT
	gosub countcheck
	put #parse ALCHEMY DONE
	exit
	
countcheck:
if $MC_NOWO then return
action var temprem $1 when ^You count out (\d+) uses remaining\.
gosub PUT count my $MC.order.noun
if %temprem > 5 then 
	{
	gosub PUT mark my $MC.order.noun at 5
	gosub PUT break my $MC.order.noun
	gosub PUT empty left
	gosub PUT swap
	}
return