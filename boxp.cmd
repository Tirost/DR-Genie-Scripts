## Disarming script by Warneck
#debug 10
## Character specific variables
var container1 $BOXP_CONTAINER1
var container2 $BOXP_CONTAINER2
var armor.stow $BOXP_ARMOR_STOW
var armor.stow2 $BOXP_ARMOR_STOW2
var componentcontainer $BOXP_COMPONENT
var pickstorage $BOXP_PICKSTORE
var use.ring $BOXP_USERING
var gem.container $GEM_POUCH
var armor.types (handwraps|hand claws|footwraps|aegis|buckler|\bheater|pavise|scutum|shield|sipar|targe|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|coat|cowl|cuirass|fauld|gauntlet|gloves|greaves|hauberk|helm|\bhood\b|jerkin|leathers|lorica|mantle|mask|morion|pants|(?<=(field|fluted|full|half) )\bplate\b|handguards|robe|sallet|shirt|sleeves|tabard|tasset|thorakes|vambraces|vest|collar|coif|mitt|armor)
var Rare.MetalList (animite|audrualm|damite|darkstone|electrum|glaes|gold|haralun|kertig|lumium|niniam|platinum) (\w+)
var disposals bucket|bucket of viscous gloop|large stone turtle|disposal bin|waste bin|firewood bin|tree hollow|oak crate|ivory urn|pit\b|trash receptacle|wooden barrel
var disposal.extra trash |large stone |waste |firewood |tree |oak |ivory |wooden | of viscous gloop
var dump.recepticle 0

if matchre("$roomobjs",("%disposals")) then
	{
	var dump.recepticle $0
  eval dump.recepticle replacere("%dump.recepticle", "%disposal.extra", "")
	}
	
if_1 then var pop.type %1
else var pop.type 0

var popper %2
if %pop.type = donate then goto main
if %pop.type = service then goto main

if %1 = h then
	{
	echo ****************Syntax****************
	echo ********".boxp" for normal disarm*********
	echo *****".boxp wait" to receive and return*****
	echo ****".boxp greed" to receive and keep*****
	echo ****".boxp service <playername>" to give boxes to return***
	echo ****To use service the target player must be in wait mode!****
	echo ************************************
	exit
	}	

## Script actions
action var multi_trap ON when is not yet fully disarmed|more to torment you with
action var multi_lock ON when discover another lock protecting
action (waiting) var player $1 ; var disarmit $2 when (\w+) offers you a .* (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|box)
action (waiting) goto armor_check1 when ~finish
action send 2 $lastcommand when ^\.\.\.wait|^Sorry, you may only type
action var rare.present 1; rare.type %0 when %Rare.MetalList
action var waketime $1 when will be awake in (\d+) seconds 
action var guild $1;eval guild replacere("%guild", " ", "");eval guild tolower("%guild") when Guild: (\w+|\w+\s+\w+)$
action var use.ring 0 when that was the last one

put exp survival 0
waitfor Overall state of mind
if ($Locksmithing.Ranks >= 15) then
{
	action var mode quick when is a trivially constructed|is a laughable matter|An aged grandmother could|will be a simple matter for you to
	action var mode normal when should not take long with your skills|is precisely at your skill level|with only minor troubles|got a good shot at
	action var mode careful when some chance of being able|with persistence you believe you could|would be a longshot|minimal chance|You really don't have any chance
	action var mode toss when Prayer would be a good start|You could just jump off a cliff|same shot as a snowball|pitiful snowball encased in the Flames
	var mode
} else
{
	var mode careful
}

## Scripts variables
var component_list tube|needle|seal\b|bladder|studs|blade|\brune\b|spring|hammer|disc|dart|reservoir|face|\bpin\b|vial|striker|cube|sphere|leg|crystal|circle|clay
var multi_trap ON
var multi_lock ON
var thief_hide NO
var harvest NO

top:
	if $hidden = 1 then put shiver
	var LAST top
		matchre stowStuff right|left
		match guild_Check empty hands.
	put glance
	matchwait

stowStuff:
	var LAST stowStuff
		matchre guild_Check You|Stow
	put stow right;stow left
	matchwait

guild_Check:
	put info
	pause 0.5
	goto %guild
 
barbarian:
	var dismantle bash
	goto armor_Check

bard:
	var dismantle shriek
	goto armor_Check
	
cleric:
	var dismantle pray
	goto armor_Check

moonmage:
	var dismantle focus
	goto armor_Check
	
ranger:
	action var dismantle  when yourself hopping up and down in pain
	var dismantle whistle
	goto armor_Check

thief:
	if (toupper("%thief_hide") = NO then
	{
		var dismantle thump
		var harvest YES
	}
	action var mode blind when do it blindfolded 
	goto armor_Check
	
warriormage:
	var dismantle fire
	goto armor_Check
	
armor_Check:
matchre remove_And_Stow_1 \s+%armor.types
matchre main You have nothing of that sort|You are wearing nothing of that sort|wearing anything like|INVENTORY HELP
put inv combat
matchwait
	
remove_And_Stow_1:
	var armor $1
remove_Armor_1:
var LAST remove_Armor_1
		matchre stow_Armor_1 You work|You remove|You pull|You take|You loosen|You sling|You slide
		put remove %armor
		matchwait
stow_Armor_1:
	var LAST stow_Armor_1
	match armor_Check You put your
	matchre stow_Armor_2 any more room in|closed|no matter how you arrange
	put put %armor in my %armor.stow
	matchwait	
	
stow_Armor_2:
	var LAST stow_Armor_2
	match armor_Check You put your
	matchre no_More_Stowing any more room in|closed|no matter how you arrange
	put put %armor in my %armor.stow2
	matchwait
	
no_More_Stowing:
	echo **   No more room for stowing; exiting script   **
	goto Wear_Armor
	goto done
	
main:	
	if ((%pop.type = wait) || (%pop.type = greed)) then gosub container_wait
	else gosub container_check1
	if %pop.type = donate then
		{
		gosub give.box
		waitfor Next box.
		goto main
		}
	if %pop.type = service then
		{
		gosub give.box
		waitfor offers you
		put accept
		goto loot
		}
	if $lefthand = Empty then 
		{
		put swap
		pause 1
		}
	disarm_sub:
		gosub disarm_ID
		if %mode = toss then goto toss_box
		gosub disarm
		if %harvest = YES then gosub analyze
		if %multi_trap = ON then goto disarm_sub
	if %use.ring = 0 then gosub get_Pick
	lock_sub:
		gosub pick_ID	
		pause 0.5
		if %mode = toss then goto toss_box
		pause 0.5
		gosub pick
		if %multi_lock = ON then goto lock_sub
		if %use.ring = 0 then gosub put_Away_Pick
	gosub loot
	if (%pop.type != service && %pop.type != wait) then gosub dismantle
	if %use.ring = 0 then
			{
			if %harvest = YES then gosub fix_Lock
			}
	gosub exp_Check
	goto main

give.box:
	put give $righthand to %popper
	waitfor accepted
	return
	
container_Wait:
	action (waiting) on
	if %pop.type = greed then put whisper %player Next box.
	waitforre offers you a .* (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|\bbox\b)
	pause 1
	send accept
	waitfor now holding
	action (waiting) off
	return
	
container_Check1:
	matchre get_For_Disarm (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|\bbox\b)
	#matchre armor_check1 ^There is nothing in there.
	match container_Check2 Encumbrance
	put look in my %container1;enc
	matchwait

container_Check2:
		matchre get_For_Disarm (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|\bbox\b)
		match armor_Check1 Encumbrance
	put look in my %container2;enc
	matchwait
	
get_For_Disarm:
	var disarmit $1
	get_Box:
		var LAST get_Box
			matchre return You get|You are already
		put get my %disarmit
		matchwait

toss_Box:
	var LAST toss_Box
		match main You
	put drop my %disarmit
	matchwait
	
weapon:
	var LAST weapon
		match stow_Weapon You
    put remove knuckles
	matchwait
	stow_Weapon:
	var LAST stow_Weapon
		match return You
	put stow knuckles
	matchwait
	
disarm_ID:
	var LAST disarm_ID
		match weapon knuckles
		match disarm_ID fails to reveal to you		
		matchre return You guess it is already disarmed|Surely any fool|Even your memory can not be that short|Roundtime|Somebody has already located
		#matchre return coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|box
	put disarm ID
	matchwait	
	
disarm:
	var multi_trap OFF
disarmIt_Cont:
	var LAST disarmIt_Cont
		matchre return You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help
		matchre disarmIt_Cont fumbling fails to disarm|This is not likely to be a good thing|unable to make any progress
	put disarm my %disarmit %mode
	matchwait
	
analyze:
	var LAST analyze
	match return You've already analyzed 
		match wake You can't do that while you are asleep
		match analyze You are unable to
		matchre harvest You already have made an extensive study|You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help
		matchre return fumbling fails to disarm|This is not likely to be a good thing
	put disarm ana
	matchwait

harvest:	
	var LAST harvest
		match return It appears that none of the trap components are accessible
		matchre harvest Your laborious fumbling fails to harvest the trap component|You fumble
		match stow_Component Roundtime	
	put disarm harvest
	matchwait

stow_Component:
	if (matchre("$righthand", "(%component_list)")) then gosub stow_It $0
	if $righthand != Empty then
	{
		put empty right hand
		waitfor You
	}
	goto return

stow_It:
	var component $0
	stow_Comp:
		var LAST stow_Comp
			match return You
		put put %component in my %componentcontainer
		matchwait

get_Pick:
	var LAST get_Pick
		matchre return You get|You are already
		match no_More_Picks what were you referring too
	put get my lockpick
	matchwait
	
no_More_Picks:
	echo
	echo ***  You have no more lockpicks  ***
	echo
	goto armor_Check1

put_Away_Pick:
	var LAST put_Away_Pick
	if %use.ring = 0 then
		{
		if $righthand = Empty then return
	  }
		matchre return You put|What were you
	put put lockpick in my %pickstorage
	matchwait
	
pick_ID:
	if %use.ring = 0 then
		{
		if $righthand = Empty then gosub get_Pick
		}
	var LAST pick_ID
		matchre disarm_ERROR is not fully disarmed
		matchre pick_ID fails to teach you anything about the lock guarding it|just broke
		matchre return Somebody has already|not even locked|Roundtime
	put pick my %disarmit identify
	matchwait
	
pick:
	var LAST pick
	var multi_lock OFF
		matchre pick_Cont Roundtime|has already helpfully been analyzed
	put pick my %disarmit analyze
	matchwait
pick_Cont:
	if %use.ring = 0 then
		{
		if $righthand = Empty then gosub get_Pick
		}
	var LAST pick_Cont
		match pick_cont You are unable to make
		matchre return With a soft click|not even locked|Roundtime
	put pick my %disarmit
	matchwait

loot:
	if %pop.type = wait then
		{
		put swap
		send give %player
		waitforre has accepted
		goto exp_check
		}
	open_Box:
		var LAST open_Box
			match fill_Gem_Pouch open
			match pick_ID It is locked
		put open my %disarmit
		matchwait
	get_Gem_Pouch:
		var LAST get_Gem_Pouch
			matchre fill_Gem_Pouch You get|^But that is
		put get my %gem.container
		matchwait
	fill_Gem_Pouch:
		var LAST fill_Gem_Pouch
			matchre tied_Pouch The gem pouch is too valuable|You'll need to tie it up 
			matchre stow_Pouch You take|any gems|You fill your|You open your gem pouch and quickly fill it|You have to be holding
			matchre full_Pouch anything else|pouch is too full
		put fill my gem pouch with my %disarmit
		matchwait
	tied_Pouch:
		var LAST tied_Pouch
		put tie my gem pouch
		goto fill_Gem_Pouch
	full_Pouch:
		var LAST full_Pouch
		pause 0.5
		put open my %GEMPOUCH.CONTAINER
		put put my %gem.container in my %GEMPOUCH.CONTAINER
		pause 0.5
		pause 0.5
		put close my %GEMPOUCH.CONTAINER
		pause 0.5
		put get my %gem.container
		goto fill_Gem_Pouch

	stow_Pouch:
		var LAST stow_Pouch
			matchre get_Coin You|Stow|^But that is
		put stow my gem pouch
		matchwait
	get_Coin:
		var LAST get_Coin
			matchre get_Coin You pick up
			match RETURN What were you
		put get coin from my %disarmit
		matchwait
	
dismantle:
	var LAST dismantle
		match return Roundtime
		match dismantle next 15 seconds.
		match nodismantle can not dismantle
	put disman my %disarmit %dismantle
	matchwait

nodismantle:
		var LAST nodismantle
		if %guild != warriormage then goto drop
		match return Roundtime
		match drop That is not
		put prep cant flash
		pause 0.1
		put gesture my %disarmit
		matchwait
	
drop:
		if %dump.recepticle != 0 then
			{
			send put my %disarmit in %dump.recepticle
			waitforre ^You
			return
			}
	put drop my %disarmit
	return
	
fix_Lock:
	gosub get_Pick
	fixing:
	var LAST fixing
		matchre go_On Roundtime|look like it
	put fix my lock
	matchwait
	go_On:
	gosub put_Away_Pick	
	return

exp_Check:
	put exp 
	waitfor Overall state of mind
	if $Locksmithing.LearningRate > 34 then goto exp_Pause
	if $righthand != Empty then put stow $JUGGLIE
    return

exp_Pause:
	pause 0.5
	if ($Perception.LearningRate > 34) then
	{
		pause 30
		goto exp_Check
	} elseif $righthand = Empty then 
	if def("JUGGLIE") then put get my $JUGGLIE
	goto exp_pause
	
JUGGLE:
	match exp_Check Roundtime
	put juggle my $JUGGLIE
	matchwait
	
return:
	return
	
armor_Check1:
		matchre wear_Armor %armor.types
		match armor_Check2 Encumbrance
	put look in my %armor.stow;enc
	matchwait
	
armor_Check2:
		matchre wear_Armor %armor.types
		match done Encumbrance
	put look in my %armor.stow2;enc
	matchwait

wear_Armor:
	var armor $1
	get_It:
		var LAST get_It
		matchre wear_It You work|You remove|You pull|You take|You get|But that is|Already holding
		put get my %armor
		matchwait
	wear_It:
		var LAST wear_It
			matchre armor_Check1 You slip|You put|You work|You hang|You pull|You slide|You attach|You sling
		put wear my %armor
		matchwait
	
disarm_ERROR:
	echo
	echo Error while opening box
	echo Something bad happened
	echo
	put #beep
	put stow right
	pause 1
	put stow left
	pause 1
	goto done

wake:
	put wake
	pause 0.5
	pause %waketime
	put stand
	put get my %disarmit
	put swap
	goto %LAST
	
done:
	pause 1
	put glance
	echo ***********************
	echo *******FINISHED********
	echo ***********************
exit