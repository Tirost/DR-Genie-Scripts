#################################################
#Genie Pro Trader Script version 3.0
#Written by Mike
#Hacked...Revised, by Stephinrothdr
#Revised and Converted to Genie 3 by Dasffion 
#Last revision 10/15/09
#################################################
#Tips and Tricks#
#################
# To return to crossing guild from almost anywhere in the script, use "return" as %1.  I.E: .trader return
#
# You can start the script from the clerk in any outpost, The crossing bank, the ferry, Crossing NE gate,
#   outside the caravan stables in crossing, or almost anywhere on the NTR or STR
#
# Currently, the script is only set up to work on Mech stones, Juggling, and appraising.  to add or change the skills that
#   the script will work on, find the skills1 section of the script...it should be pretty self explanitory.
#
# Script will keep track of: How many contracts you have delivered to each outpost
#          Current destination
#     Bank balance when script started, and current Bank balance
#    Total profit since script was started
#
#
# Don't forget to edit the variables below to suit your needs.
#
#################################################
# Initialization #
##################

TraderInit:
#***User defined variables***
setvariable container backpack
setvariable lethcontainer sack
setvariable app1 pouch
setvariable app2 brooch
setvariable app3 bow
setvariable app4 circlet
setvariable app5 earcuff
setvariable app6 hip
setvariable mechstone sjatmal
setvariable jugglies stars
setvariable origami.inst instructions
setvariable origami.fold bird
setvariable lethcontracts 0

ScriptInit:
########################################
#Script defined variables...dont touch!#
########################################
put #statusbar 1
put #statusbar 2
put #statusbar 3
put #statusbar 4 $time, $date
setvariable return no
if "%1" = "return" then setvariable return yes
setvariable location null
setvariable destination null
setvariable Total 0
setvariable ToArthe 0
setvariable ToStone 0
setvariable ToDirge 0
setvariable ToCrossing 0
setvariable ToTiger 0
setvariable ToWolf 0
setvariable ToLeth 0
setvariable dues 0
setvariable payments 0
setvariable profit 0
setvariable firstrun yes
setvariable finishup off
setvariable OpeningBalance 0
setvariable deadcontract 0
Action setvariable finishup on when ^@finishup/i
setvariable follow no
Action setvariable follow no when You pass on the order to wait to your driver
Action setvariable follow yes when You pass on the order to follow to your driver
Action setvariable caravan $1 when who makes sure your (.*) caravan does your bidding
Action setvariable location OnFerry when \["Kertigen's Honor|\["Hodierna's Grace
Action setvariable location Crossing when Traders' Guild, Shipment Center
Action setvariable location Arthe when Swotting Hall, Trader's Center
Action setvariable location CrossingToArthe1 when Valley, Village Gate
Action setvariable location Stone when Stone Clan, Trader's Guild Outpost
Action setvariable location Dirge when Darkstone Inn, Stables
Action setvariable location Tiger when Tiger Clan, Trader's Guild Outpost
Action setvariable location Wolf when Wolf Clan Trader Outpost
Action setvariable location Leth when Eshar's Trading Post, Main Room
Action setvariable location LethToCrossingFerry when The Crossing, Alfren's Ferry
Action setvariable location NTR when ^\[Northern Trade Road
Action setvariable location NTR when ^\[Northwest Road
Action setvariable location STR when ^\[Southern Trade Route
Action setvariable location Bank1 when Provincial Bank, Teller
Action setvariable location Bank2 when First Provincial Bank, Lobby
Action setvariable location Bank3 when The Crossing, Hodierna Way
Action setvariable location NEGate when Northeast Wilds, Outside Northeast Gate
Action setvariable location barn when a huge mound of manure
Action setvariable destination $1 when The guild office at (Leth|Crossing|Arthe|Stone|Dirge|Tiger|Wolf)
Action setvariable To_Crossing yes when for The Crossing
Action setvariable To_Wolf yes when for Wolf Clan
Action setvariable To_Tiger yes when for Tiger Clan
Action setvariable To_Arthe yes when for Arthe Dale
Action setvariable To_Stone yes when for Stone Clan
Action setvariable To_Dirge yes when for Dirge
Action setvariable To_Leth yes when for Leth Deriel
Action setvariable From_Crossing yes when from The Crossing
Action setvariable From_Wolf yes when from Wolf Clan
Action setvariable From_Tiger yes when from Tiger Clan
Action setvariable From_Arthe yes when from Arthe Dale
Action setvariable From_Stone yes when from Stone Clan
Action setvariable From_Dirge yes when from Dirge
Action setvariable From_Leth yes when from Leth Deriel
Action send get feed;send give cara;send stow feed when These animals will need to be fed soon
Action put stand;put ret when eval $standing = 0
action var balance $1 when it looks like your current balance is(.*) (Kronars|Lirum|Dokoras)
Action math dues add $1 when for a total of (\d+)\.
Action math dues add $1 when total fee for transportation additions is (\d+) copper
Action math dues add $1 when All right, that's a (\d+) Kronars fee
Action math payments add $1 when handing you your payment of (\d+) Kronars
Action goto exit when \[You're in death's grasp
Action goto exit when \[You're dying
Action goto exit when You feel yourself falling
Action goto exit when You feel like you're dying
Action goto exit when \[You're near death
Action goto exit when You're unconscious
Action goto exit WHEN DEAD>
action goto exit when eval $dead = 1
action put quit;put #script abort when fire at you
action put quit;put #script abort when target you
action put quit;put #script abort when someone snipes at you
Action goto exit when \[You're in very bad shape
Action goto exit when \[You're in extremely bad shape
Action goto exit when \[You're smashed up
Action goto exit when \[You're terribly wounded
action goto exit when ^You are a ghost
action goto exit when ^You are dead
Action goto leave when \[You're very beat up
Action goto leave when \[You're extremely beat up
Action goto leave when \[You're badly hurt
Action goto leave when \[You're in bad shape
Action goto ReturnCaravan when Perhaps you should check with one of the stables to locate it.
action setvariable rish ready when Rishlu nods to you
goto start

Start:
if "%return" = "yes" then shift
if_1 goto %1
start1:
gosub put look
gosub ContractMenu
pause
if "%location" = "Crossing" then gosub bankrun
if "%location" = "Crossing" then goto CheckContracts
if "%location" = "Arthe" then goto CheckContracts
if "%location" = "Stone" then goto CheckContracts
if "%location" = "Dirge" then goto CheckContracts
if "%location" = "Tiger" then goto CheckContracts
if "%location" = "Wolf" then goto CheckContracts
if "%location" = "Leth" then goto CheckContracts
if "%location" = "NTR" then goto NTR
if "%location" = "STR" then goto STR
if "%location" != "(Crossing|Arthe|Stone|Dirge|Tiger|Wolf|Leth|null)" then goto %location

start2:
matchre start2 \.\.\.wait|Sorry, you may only
matchre start3 You pass on the order to lead to your driver
matchre start4 We are currently not located on or near the caravan route
put tell cara to lead to crossing
matchwait

Null:
Start4:
echo
echo ************************************************************************
echo You are lost, Start this script at a clerk, or inside the Crossing bank
echo ************************************************************************
echo
put quit
put #script pause

CheckContracts:
gosub hide
if "%location" = "Crossing" then gosub returncheck
gosub put pay clerk
pause
Matchre CheckContracts \.\.\.wait|Sorry, you may only
Matchre PayClerk What were you referring to
Matchre GiveToClerk You get a
Matchre DropContract You are already holding that
put get my %location Contract
matchwait

returncheck:
if %return != yes then return
echo
echo **************************************************
echo You have returned to the Crossing.  Exiting script
echo **************************************************
echo
exit

GiveToClerk:
matchre GiveToClerk \.\.\.wait|Sorry, you may only|Don't be silly
matchre DropContract He smiles up at you and hands the contract back|A shipment clerk ignores your offer|What have you done with the goods|We needed this days ago
matchre AddContracts handing you your payment of
put give %location contract to clerk
matchwait

AddContracts:
math To%location add 1
math Total add 1
goto CheckContracts

DropContract:
gosub put drop contract
goto CheckContracts

PayClerk:
gosub put pay clerk
goto GetNewContract

GetNewContract:
put speculate fin
pause 0.5
if "%finishup" = "on" then goto DoneContract
if "%location" = "Crossing" then gosub move east
if "%location" = "Dirge" then gosub move climb stair
if "$lefthand" != "Empty" then gosub put stow left
if "$righthand" != "Empty" then gosub put stow right
matchre GetNewContract \.\.\.wait|Sorry, you may only
matchre GotNewContract The minister plucks a contract from the hands of a passing clerk and hands it to you
matchre OutstandingContract You still have another contract we issued for you that needs to be completed
put ask mini for contract
matchwait 5

OutstandingContract:
put speculate fin stop
pause 0.5
if "%location" = "Crossing" then gosub move west
if "%location" = "Dirge" then gosub move climb stair
goto checkoutstandingcontracts

OutstandingContract1:
gosub put rent Caravan
goto DoneContract

CheckOutstandingContracts:
put close my %lethcontainer
setvariable needtovalidate no
Action setvariable needtovalidate yes when This contract has yet to be presented to the %location
counter set 7

CheckOutstandingContracts1:
if %c = 7 then setvariable ContractNumber seventh
if %c = 6 then setvariable ContractNumber sixth
if %c = 5 then setvariable ContractNumber fifth
if %c = 4 then setvariable ContractNumber fourth
if %c = 3 then setvariable ContractNumber third
if %c = 2 then setvariable ContractNumber second
if %c = 1 then setvariable ContractNumber first
if %c = 0 then goto OutstandingContract1
goto CheckOutstandingContracts2

CheckOutstandingContracts2:
gosub put read my %ContractNumber contract
pause
if %needtovalidate = yes then goto CheckOutstandingContracts3
counter subtract 1
goto CheckOutstandingContracts1

CheckOutstandingContracts3:
gosub put get my %ContractNumber contract
goto ValidateContract

GotNewContract:
put speculate fin stop
if "%location" = "Crossing" then gosub move west
if "%location" = "Dirge" then gosub move climb stair
gosub put rent Caravan
goto ValidateContract

ValidateContract:
matchre ValidateContract \.\.\.wait|Sorry, you may only|Don't be silly
matchre DoneContract Good luck!" the clerk says, grinning, and goes back to work
put give my cont to clerk
matchwait

DoneContract:
put open my %lethcontainer
action math lethcontracts add 1 when The guild office at Leth Deriel
gosub put pay clerk
if "$righthand" != "Empty" then gosub put read my contract
action remove The guild office at Leth Deriel
gosub contractmenu
pause 1
if "$righthand" = "Leth Deriel contract" then if %lethcontracts < 3 then gosub put put my contract in my %lethcontainer
if "$righthand" != "Empty" then gosub put put my contract in my %container
goto Travel
#################################################
# Travel Checks #
#################
Travel:
setvariable destination null
counter set 7
goto TravelCheck

TravelCheck:
if %c = 7 then setvariable ContractNumber seventh
if %c = 6 then setvariable ContractNumber sixth
if %c = 5 then setvariable ContractNumber fifth
if %c = 4 then setvariable ContractNumber fourth
if %c = 3 then setvariable ContractNumber third
if %c = 2 then setvariable ContractNumber second
if %c = 1 then setvariable ContractNumber first
if %c = 0 && "%finishup" = "on" then goto end
if %c = 0 then setvariable destination Crossing
if %c = 0 then goto TravelMove
goto read

Read:
counter subtract 1
matchre Read \.\.\.wait|Sorry, you may only
matchre TravelMove in the form of the local currency
matchre DropCont The contract is now useless since it has expired\.
matchre TravelCheck I could not find|What were you referring to
put read my %ContractNumber Contract in my %container
matchwait

DropCont:
counter add 1
math deadcontract add 1
gosub put get my %ContractNumber Contract
gosub put drop my Contract
goto Read

TravelMove:
pause .5
goto %location

Crossing:
if "%destination" = "Arthe" then goto CrossingToArthe
if "%destination" = "Stone" then goto CrossingToArthe
if "%destination" = "Dirge" then goto CrossingToArthe
if "%destination" = "Tiger" then goto CrossingToTiger
if "%destination" = "Wolf" then goto CrossingToTiger
if "%destination" = "Leth" then goto CrossingToLeth
if "%lastdestination" != "Arthe" then goto CrossingToArthe
goto CrossingToTiger

Arthe:
if "%destination" = "Stone" then goto ArtheToStone
if "%destination" = "Dirge" then goto ArtheToStone
if "%destination" = "Crossing" then goto ArtheToCrossing
if "%destination" = "Tiger" then goto ArtheToCrossing
if "%destination" = "Wolf" then goto ArtheToCrossing
if "%destination" = "Leth" then goto ArtheToCrossing
if "%lastdestination" != "Stone" then goto ArthetoStone
goto ArtheToCrossing

Stone:
if "%destination" = "Arthe" then goto StoneToArthe
if "%destination" = "Crossing" then goto StoneToArthe
if "%destination" = "Tiger" then goto StoneToArthe
if "%destination" = "Wolf" then goto StoneToArthe
if "%destination" = "Leth" then goto StoneToArthe
if "%destination" = "Dirge" then goto StoneToDirge
if "%lastdestination" != "Dirge" then goto StonetoDirge
goto StoneToArthe

Dirge:
if "%destination" = "Arthe" then goto DirgeToStone
if "%destination" = "Stone" then goto DirgeToStone
if "%destination" = "Crossing" then goto DirgeToStone
if "%destination" = "Tiger" then goto DirgeToStone
if "%destination" = "Wolf" then goto DirgeToStone
if "%destination" = "Leth" then goto DirgeToStone
goto DirgetoStone

Tiger:
if "%destination" = "Arthe" then goto TigerToCrossing
if "%destination" = "Stone" then goto TigerToCrossing
if "%destination" = "Dirge" then goto TigerToCrossing
if "%destination" = "Crossing" then goto TigerToCrossing
if "%destination" = "Leth" then goto TigerToCrossing
if "%destination" = "Wolf" then goto TigerToWolf
if "%lastdestination" != "Wolf" then goto TigerToWolf
goto TigerToCrossing

Wolf:
if "%destination" = "Arthe" then goto WolfToTiger
if "%destination" = "Stone" then goto WolfToTiger
if "%destination" = "Dirge" then goto WolfToTiger
if "%destination" = "Tiger" then goto WolfToTiger
if "%destination" = "Crossing" then goto WolfToTiger
if "%destination" = "Leth"  then goto WolfToTiger
Goto WolftoTiger

Leth:
if "%destination" = "Arthe" then goto LethToCrossing
if "%destination" = "Stone" then goto LethToCrossing
if "%destination" = "Dirge" then goto LethToCrossing
if "%destination" = "Tiger" then goto LethToCrossing
if "%destination" = "Wolf" then goto LethToCrossing
if "%destination" = "Crossing" then goto LethToCrossing
goto LethtoCrossing

STR:
if "%destination" = "Arthe" then goto LethToCrossing2
if "%destination" = "Stone" then goto LethToCrossing2
if "%destination" = "Dirge" then goto LethToCrossing2
if "%destination" = "Tiger" then goto LethToCrossing2
if "%destination" = "Wolf" then goto LethToCrossing2
if "%destination" = "Crossing" then goto LethToCrossing2
if "%destination" = "Leth" then goto CrossingToLeth
goto LethtoCrossing2

#################################################
# Skills #
##########

Skills:
put lean Rishlu
goto skills1

Skills1:
echo Starting Skills section
Action goto XSkills when %caravan caravan stops and waits, having arrived at its destination|reaches the dock|pulls into|pulls up|!resume
gosub grass
gosub app
gosub chart
gosub stones
gosub juggle
gosub juggle
goto Skills1

App:
if $Appraisal.LearningRate > 30 then return
if "$righthand" != "Empty" then gosub put stow right
if "$lefthand" != "Empty" then gosub put stow left
if "%app1" != "null" then gosub put app $charactername
if "%app1" != "null" then gosub put app my %app1
if "%app2" != "null" then gosub put app my %app2
if "%app3" != "null" then gosub put app my %app3
if "%app4" != "null" then gosub put app my %app4
if "%app5" != "null" then gosub put app my %app5
if "%app6" != "null" then gosub put app my %app6
return

Origami:
paper:
if $Mechanical_Lore.LearningRate > 10 then return
pause 0.5
put get my paper
match envelope What were you
match studyx You are already holding
match studyx You get
matchwait

envelope:
pause 0.5
put pull my envelope
match studyx You get a
match newenv The envelope is empty.
matchwait

newenv:
pause 0.5
put hold my envelope
put poke my envelope
pause 0.5
put get my envelope
match wear.env You get an
match locked What were you
matchwait

wear.env:
put wear my envelope
pause
goto envelope

studyx:
pause 0.5
put get my %origami.inst
pause 0.5
goto studyprimer

studyprimer:
pause 0.5
put study my %origami.fold instruction
pause 5
goto foldx

foldx:
pause 0.5
put fold my paper
match foldx but it doesn't come out quite
match foldx make another fold
match foldx a fold
match nextx the final fold
matchwait

nextx:
pause
put exhale my %origami.fold
pause
put stow %origami.inst
return

Stones:
if $Mechanical_Lore.LearningRate > 30 then return
if "$righthand" != "Empty" then gosub put stow right
if "$lefthand" != "Empty" then gosub put stow left
gosub put get %mechstone stone from my %container
gosub put get %mechstone stone from my %container
pause .1
gosub put remove 1 stone
pause .1
gosub put combine stone
pause .1
gosub put remove 1 stone
pause .1
gosub put combine stone
pause .1
gosub put remove 1 stone
pause .1
gosub put combine stone
pause .1
gosub put remove 1 stone
pause .1
gosub put combine stone
pause .1
gosub put remove 1 stone
pause .1
gosub put combine stone
pause .1
if "$righthand" != "Empty" then gosub put stow right
if "$lefthand" != "Empty" then gosub put stow left
return

Chart:
put get leather com
pause
goto exp.chart1

exp.chart1:
if $Scholarship.LearningRate > 30 then goto nextcharts
goto chart.study

chart.study:
pause
put study leather com
match next1 With a sudden moment of clarity,
match next1 In a sudden moment of clarity
match notready Why do you need to study this chart again?
match notready almost impossible to do
match exp.chart1 You begin studying the
match next1 You begin to study
match exp.chart1 You continue studying the
matchwait

notready:
pause
put stow leather com
pause
goto return

next1:
pause
put turn leather com
pause
goto exp.chart2

exp.chart2:
if $Scholarship.LearningRate > 30 then goto nextcharts
goto charts2

charts2:
pause
put study leather com
match next1 With a sudden moment of clarity,
match next1 In a sudden moment of clarity
match nextcharts Why do you need to study this chart again?
match nextcharts almost impossible to do
match exp.chart2 You begin studying the
match exp.chart2 You continue studying the
matchwait

nextcharts:
put stow leather comp
pause
goto return

Juggle:
if $Perception.LearningRate > 30 then return
if "$righthand" != "Empty" then gosub put stow right
if "$lefthand" != "Empty" then gosub put stow left
gosub put get my %jugglies
pause .1
gosub put juggle my %jugglies
pause .1
gosub put juggle my %jugglies
pause .1
gosub put juggle my %jugglies
pause .1
gosub put juggle my %jugglies
pause .1
gosub put stow my %jugglies
pause .1
return

Forage:
if $Foraging.LearningRate > 30 then return
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put forage dirt careful
pause .1
gosub put drop my dirt
gosub put get my dirt
gosub put drop my dirt
gosub put get my dirt
gosub put drop my dirt
gosub put get my dirt
gosub put drop my dirt
return

Xskills:
Action remove %caravan caravan stops and waits, having arrived at its destination|reaches the dock|pulls into|pulls up|!resume
gosub put look
pause 2
if contains("$roomplayers", "Rishlu") then gosub xskills4
if contains("$lefthand", "instructions") then goto Xskills3
if contains("$righthand", "instructions") then goto Xskills3
if contains("$lefthand", "stone") then goto XSkills1
if contains("$righthand", "stone") then goto XSkills1
goto Xskills2

Xskills1:
pause .5
gosub put combine stone
pause .5
gosub put stow stone
goto XSkills2

Xskills3:
pause 0.5
gosub put stow right
pause 0.5
gosub put stow left
goto Xskills2

Xskills2:
setvariable rish notready
goto location.check
goto %return

location.check:
match %return [Northeast Wilds, Outside Northeast Gate
match %return [Valley, Village Gate
match %return Sparse grass, weeds and a few hardy shrubs
match %return [Lairocott Brach, Entrance
match %return [Southern Trade Route, Segoltha South Bank
match %return [Southern Trade Route, Outside Leth Deriel
match %return [North Roads Caravansary]
match %return [The Crossing, Alfren's Ferry
match %return ["Kertigen's Honor
match %return ["Hodierna's Grace
match skills Obvious paths:
match skills Obvious exits:
put look
matchwait

xskills4:
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
if %rish = ready then return
pause 10
return
########################
# Climb Arthe #
###############

ClimbArthe:
gosub put tell cara to wait
put #var caravan 0
pause 0.5
gosub automove 13
if $Climbing.LearningRate > 20 then goto ClimbArthe_
gosub ClimbArthe2
ClimbArthe_:
gosub put dive hole
gosub SwimArthe
gosub cli embank
gosub automove 10
return

ClimbArthe2:
gosub put dive hole
gosub cli embank
gosub cli tree
gosub move go ramp
gosub put dive hole
gosub cli emb
gosub exp climb
if $Climbing.LearningRate > 20 then return
pause 10
goto ClimbArthe2

Cli:
pause
setvariable move $0
action setvariable cli yes when Obvious paths|Obvious exits|What were you referring to
setvariable cli no
Cli_:
if $standing = 0 then put stand
pause 0.5
put climb %move
pause 2
if %cli = yes then action remove Obvious paths|Obvious exits|What were you referring to
if %cli = yes then return
goto Cli_

########################
# Swim Arthe #
##############

SwimArthe:
if $Swimming.LearningRate > 20 then return
gosub move s
gosub move w
gosub move n
gosub move e
goto SwimArthe


#################################################
# Gosubs #
##########

stow:
setvariable label stow
if "$righthand" = "%LONGBOW" then gosub put wear %LONGBOW
if "$lefthand" = "%LONGBOW" then gosub put wear %LONGBOW
if "$righthand" = "lumpy bundle" then gosub Stowbundle
if "$lefthand" = "lumpy bundle" then gosub Stowbundle
if "$righthand" != "Empty" then gosub Stow1 Right
if "$lefthand" != "Empty" then gosub Stow1 Left
return

Stow1:
setvariable stow $0
Stow2:
matchre Stow2 \.\.\.wait|Sorry, you may only|You don't seem to be able to move to do that|You can't do that while entangled in a web
matchre StowStopPlay You should stop playing before you do that|You are a bit too busy performing to do that
matchre return You put|What were you wanting to STOW|You should be holding that first|stow help
matchre Wear_bow is too long to fit|You should unload the
put stow %stow
matchwait

StowStopPlay:
gosub put stop play
goto Stow2

Stowbundle:
pause .5
matchre StowBundle \.\.\.wait|Sorry, you may only|You don't seem to be able to move to do that|entangled in a web
matchre return You sling|You drape|You put a|You attach a|already wearing that|Wear what?
matchre pull_bundle You can't wear
put wear my bund
matchwait

Pull_bundle:
put pull bund
pause .5
goto Stowbundle

Wear_bow:
gosub put unl
gosub put put arrows in my %Container
gosub put wear my longbow
goto stow

########################

Hide:
if $hidden = 1 then return
if "%huntspot" = "westie" then gosub put ret
gosub put hide
#if $hidden = 0 then gosub put ret
#if $hidden = 0 then goto hide
return

Inv:
setvariable To_Crossing no
setvariable To_Wolf no
setvariable To_Tiger no
setvariable To_Arthe no
setvariable To_Stone no
setvariable To_Dirge no
setvariable To_Leth no
setvariable From_Crossing no
setvariable From_Wolf no
setvariable From_Tiger no
setvariable From_Arthe no
setvariable From_Stone no
setvariable From_Dirge no
setvariable From_Leth no
gosub put look caravan
pause 2
return

put:
setvariable put $0
put1:
pause .5
matchre put1 \.\.\.wait|Sorry, you may only|You are still stunned
matchre return You|Please rephrase that|The clerk|FACE HELP|EXP HELP|STOW HELP|Roundtime|Obvious paths|Obvious exits|Encumbrance:|Skin what|It's not dead yet|Remove what?|already been tied off|with what?|The contract|I could not find what you were referring to|are already in ownership|Our records show you already have a 
put %put
matchwait

return:
return


automove:
var movement $0
eval mcount count("%movement", "|")
var ccount 0
#if contains("Cleric|Warrior Mage|Moon Mage|Bard|Empath|Paladin", "$Guild") then put #var powerwalk 1

automove_1:
pause 1
if matchre("%movement(%ccount)", "travel") then goto autotravelmove
match automove_1 YOU HAVE FAILED
match automove_1 You can't go there
match automove_1 MOVE FAILED
matchre autoreturn YOU HAVE ARRIVED
else put #goto %movement(%ccount)
matchwait 200
put #mapper reset
goto automove_1

autotravelmove:
put %movement(%ccount)
waitfor REACHED YOUR DESTINATION
goto autoreturn

autoreturn:
if %ccount = %mcount then return
math ccount add 1
goto automove_1

Move:
setvariable move $0
if "%follow" = "no" then goto Move1
else goto Move2
Move1:
pause .1
if $standing = 0 then put stand
matchre Move1 \.\.\.wait|Sorry, you may only
matchre ret You are engaged|while in combat|You'll have better luck if you first retreat
matchre lost Please rephrase that|What were you referring to|You can't go there
matchre MoveStow Free up your hands first
Matchre Move1 unharmed but feel foolish.
Matchre Move1 Struck by vertigo
Matchre Move1 but the steepness
Matchre Move1 but reach a point where your footing
matchre return Obvious exits|Obvious paths
put %move
matchwait

Move2:
matchre Move2 \.\.\.wait|Sorry, you may only
matchre ret You are engaged|while in combat|You'll have better luck if you first retreat
matchre lost Please rephrase that|What were you referring to|You can't go there
matchre MoveStow Free up your hands first
Matchre Move1 unharmed but feel foolish.
Matchre Move1 Struck by vertigo
Matchre Move1 but the steepness
Matchre Move1 but reach a point where your footing
matchre return following you|!resume
put %move
matchwait

MoveStow:
if "$righthand" != "Empty" then gosub put stow right
if "$lefthand" != "Empty" then gosub put stow left
goto Move1

ret:
pause .5
matchre ret \.\.\.wait|Sorry, you may only|You don't seem to be able to move to do that|back to pole range|Roundtime|entangled in a web|You try to back away
matchre move1 You sneak back out|You retreat from combat|farther away|But you aren't in combat|far away as you can get|You stop advancing
put retreat
matchwait

dance:
if $standing = 0 then put stand
return

stand:
if $standing = 0 then put stand
return

Lost:
echo You are lost!
put exit
exit

Grass:
if "$lefthand" != Empty then gosub put stow left
if "$righthand" != Empty then gosub put stow right
matchre Grass \.\.\.wait|Sorry, you may only
matchre ForaRet You cannot forage while in combat
matchre GiveCara grass
matchre return Roundtime|The room is too cluttered to find anything here
put forage grass
matchwait

ForaRet:
gosub put ret
gosub put ret
goto Grass

GiveCara:
matchre GiveCara \.\.\.wait|Sorry, you may only
matchre Grass They seem less hungry now
matchre return They seem full now|The animals are well fed now|What shall I feed them
put give cara
matchwait

ContractMenu:
setvariable profit 0
math profit add %payments
math profit subtract %dues
put #echo >Log  _______________________________
put #echo >Log |COMPLETED CONTRACTS____________|
put #echo >Log |
put #echo >Log |To Arthe Dale---: %ToArthe
put #echo >Log |To Stone Clan---: %ToStone
put #echo >Log |To Dirge--------: %ToDirge
put #echo >Log |To Crossing-----: %ToCrossing
put #echo >Log |To Tiger Clan---: %ToTiger
put #echo >Log |To Wolf Clan----: %ToWolf
put #echo >Log |To Leth Deriel--: %ToLeth
put #echo >Log |
put #echo >Log |For a total of %Total Contracts
put #echo >Log |and %profit Kronars in Profit
put #echo >Log |_______________________________
return

Exit:
Combat:
echo
echo You are in combat, exiting game to prevent you from dying
echo
gosub put exit
exit

statusbar:
setvariable profit %balance
math profit subtract %OpeningBalance
pause 0.5
put #statusbar 1 Current Balance = %balance *** Starting Balance = %OpeningBalance *** Profit: %profit
put #statusbar 2 $0
return
#################################################
# Traveling #
#############

ReturnCaravan:
if "%location" != "Crossing" then echo YOU NEED TO BE IN THE CROSSING GUILD TO GET YOUR CARAVAN BACK.
gosub automove CARAVAN STABLE
gosub put return caravan
put #var caravan 1
gosub put tell cara to follow
gosub automove 86
gosub put tell cara to wait
gosub move go door
goto CheckContracts

ArtheToStone:
gosub statusbar ***Arthe Dale to Stone Clan***
ECHO -> TRAVEL - ARTHE DALE TO STONE CLAN
gosub move go door
gosub move out
#gosub climbArthe
gosub put exp
gosub grass
gosub put tell caravan lead to Stone clan
gosub put tell caravan to go faster
setvariable return ArtheToStone1
goto skills
ArtheToStone1:
gosub put tell caravan follow
gosub put tell caravan to go faster
gosub move d
gosub stow
gosub move climb trail
gosub put tell cara to wait
gosub move go outpost
goto CheckContracts

ArtheToCrossing:
gosub statusbar ***Arthe Dale to Crossing***
ECHO -> TRAVEL - ARTHE DALE TO CROSSING
gosub move go door
gosub move out
#gosub ClimbArthe
NTR:
gosub grass
gosub put tell caravan to lead to crossing
gosub put tell caravan to go faster
setvariable return ArtheToCrossing1
goto skills
NEGate:
ArtheToCrossing1:
put #var caravan 1
gosub put tell cara follow
gosub put tell caravan to go faster
gosub move go gate
gosub automove 86
put #var caravan 0
pause 0.5
gosub put tell cara to wait
gosub move go door
setvariable lastdestination Arthe
goto CheckContracts

CrossingToArthe:
gosub lethcheck
if "%emergencyleth" = "yes" then goto CrossingToLeth
gosub bankrun
gosub statusbar ***Crossing to Arthe Dale***
ECHO -> TRAVEL - CROSSING TO ARTHE DALE
gosub move out
gosub put tell caravan to lead to Arthe dale
gosub put tell caravan to go faster
setvariable return CrossingToArthe1
goto skills
CrossingToArthe1:
gosub grass
put #var caravan 1
gosub put tell cara foll
gosub put tell caravan to go faster
gosub automove 543
put #var caravan 0
pause 0.5
gosub put tell cara to wait
gosub move go build
gosub move go door
setvariable lastdestination Crossing
goto CheckContracts

CrossingToTiger:
gosub lethcheck
if "%emergencyleth" = "yes" then goto CrossingToLeth
gosub bankrun
gosub statusbar ***Crossing to Tiger Clan***
echo -> TRAVEL - CROSSING TO TIGERCLAN
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub automove w gate
gosub grass
gosub automove 87|6
put #var caravan 0
pause 0.5
gosub put tell cara to wait
gosub move go outpost
setvariable lastdestination Crossing
goto CheckContracts

lethcheck:
setvariable emergencyleth no
counter set %lethcontracts
if %c = 3 then gosub readleth third
if %c = 2 then gosub readleth second
if %c = 1 then gosub readleth first
return

readleth:
action setvariable emergencyleth yes when less than an anlas
action setvariable emergencyleth yes when 2 anlaen
put read my $1 leth contract
pause 0.5
counter subtract 1
action remove less than an anlas
action remove 2 anlaen
return

CrossingToLeth:
gosub bankrun Leth
gosub statusbar ***Crossing to Leth***
ECHO -> TRAVEL - CROSSING TO LETH
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub automove Ferry
setvariable return CrossingToLethFerry
put #var caravan 0
pause 0.5
gosub ferry
CrossingToLethFerry:
STR:
gosub grass
gosub put tell caravan lead to leth deriel
gosub put tell caravan go faster
setvariable return CrossingToLeth1
goto skills
CrossingToLeth1:
put #var caravan 1
gosub put tell caravan follow
gosub put tell caravan go faster
gosub automove 26
put #var caravan 0
pause 0.5
gosub put tell cara to wait
gosub move go shanty
setvariable lastdestination Crossing
setvariable lethcontracts 0
goto CheckContracts

DirgeToStone:
gosub statusbar ***Dirge to Stone Clan***
ECHO -> TRAVEL - DIRGE TO STONE CLAN
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub move go gate
gosub grass
gosub automove NTR
put #var caravan 0
pause 0.5
gosub put tell caravan lead to stone clan
gosub put tell caravan to go faster
setvariable return DirgeToStone1
goto skills
DirgeToStone1:
gosub put tell caravan follow
gosub put tell caravan to go faster
gosub move d
if "$lefthand" != Empty then gosub put stow left
if "$righthand" != Empty then gosub put stow right
gosub move climb trail
gosub put tell cara to wait
gosub move go outpost
setvariable lastdestination Dirge
goto CheckContracts

DirgeToRiverhaven:
gosub statusbar ***Dirge to Riverhaven***
ECHO -> TRAVEL - DIRGE TO RIVERHAVEN
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub move go gate
gosub grass
gosub automove NTR
put #var caravan 0
pause 0.5
gosub put tell caravan lead to Riverhaven
gosub put tell caravan to go faster
setvariable return DirgeToRiverhaven1
goto skills
DirgeToRiverhaven1:
gosub put tell caravan follow
gosub put tell caravan to go faster
setvariable return DirgetoRiverhavenFerry
gosub ferry
DirgetoRiverhavenFerry:
gosub move go ramp
gosub move go arch
gosub move nw
gosub put tell cara to wait
gosub move go guild
setvariable lastdestination Dirge
goto CheckContracts

LethToCrossing:
gosub statusbar ***Leth to Crossing***
ECHO -> TRAVEL - LETH TO CROSSING
gosub move out
#gosub envelopecheck
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub automove Crossing
LethToCrossing2:
put #var caravan 0
pause 0.5
gosub grass
gosub put tell caravan lead to crossing
gosub put tell caravan to go faster
setvariable return LethToCrossing1
goto skills
LethToCrossing1:
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub move n
pause 5
setvariable return LethToCrossingFerry
gosub ferry
LethToCrossingFerry:
put #var caravan 1
gosub automove 86
put #var caravan 0
gosub put tell cara to wait
gosub move go door
setvariable lastdestination Leth
goto CheckContracts

StoneToArthe:
gosub statusbar ***Stone Clan to Arthe Dale***
ECHO -> TRAVEL - STONE CLAN TO ARTHE DALE
gosub move out
gosub grass
gosub put tell caravan lead to Arthe dale
gosub put tell caravan go faster
setvariable return StoneToArthe1
goto skills
StoneToArthe1:
put #var caravan 1
gosub put tell cara foll
gosub put tell caravan to go faster
gosub automove 543
put #var caravan 0
gosub put tell cara to wait
gosub move go build
gosub move go door
setvariable lastdestination Stone
goto CheckContracts

StoneToDirge:
gosub statusbar ***Stone Clan to Dirge***
ECHO -> TRAVEL - STONE CLAN TO DIRGE
gosub move out
gosub grass
gosub put tell caravan to lead to dirge
gosub put tell caravan to go faster
setvariable return StoneToDirge1
goto skills
StoneToDirge1:
gosub put tell cara to foll
gosub put tell caravan to go faster
put #var caravan 1
gosub move go path
gosub automove 37
put #var caravan 0
pause 0.5
gosub put tell cara to wait
gosub move go stable
setvariable lastdestination Stone
goto CheckContracts

TigerToCrossing:
gosub statusbar ***Tiger Clan to Crossing***
ECHO -> TRAVEL - TIGER CLAN TO CROSSING
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub automove crossing|crossing|86
put #var caravan 0
pause 0.5
gosub put tell cara to wait
gosub move go door
setvariable lastdestination Tiger
goto CheckContracts

TigerToWolf:
gosub statusbar ***Tiger Clan to Wolf Clan***
ECHO -> TRAVEL - TIGER CLAN TO WOLF CLAN
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub automove crossing|118
put #var caravan 0
gosub put tell cara to wait
pause 0.5
gosub move go outpost
setvariable lastdestination Tiger
goto CheckContracts

WolfToTiger:
gosub statusbar ***Wolf Clan to Tiger Clan***
ECHO -> TRAVEL - WOLF CLAN TO TIGER CLAN
gosub move out
put #var caravan 1
gosub put tell caravan to follow
gosub put tell caravan to go faster
gosub automove tiger|6
put #var caravan 0
gosub put tell cara to wait
pause 0.5
gosub move go outpost
setvariable lastdestination Wolf
goto CheckContracts

BankRun:
gosub move out
put #var caravan 0
gosub put tell cara to wait
put #goto teller
waitfor YOU HAVE ARRIVED
goto Bank1

Bank1:
gosub put deposit all
gosub put withdrawl 90 sil
gosub put balance
pause
goto BankReturn

BankLeth:
gosub put deposit all
gosub put withdrawl 215 sil
gosub put balance
pause
goto BankReturn

BankReturn:
if "%firstrun" = "yes" then setvariable OpeningBalance %balance
gosub statusbar
setvariable firstrun no
put #goto 86
waitfor YOU HAVE ARRIVED
gosub put tell cara to wait
gosub move go door
return

OnFerry:
setvariable return OnFerry2
gosub Ferry2
OnFerry2:
goto start

FERRY:
matchre Ferry \.\.\.wait|Sorry, you may only
matchre FerryRet You are engaged|While in combat|You'll have better luck if you first retreat
matchre ferry2 Obvious path|Obvious exit
matchre noferry I could not find|What were you referring to|isn't docked|no ferry here|just pulled away from the dock
matchre nomoney You dont have
put go ferry
matchwait

FERRYRET:
gosub put ret;put ret
goto Ferry

NOFERRY:
setvariable return1 %return
setvariable return NoFerry1
goto skills

NoFerry1:
setvariable return %return1
goto ferry

FERRY2:
setvariable return1 %return
setvariable return Ferry3
goto skills

Ferry3:
setvariable return %return1
goto ferrydocks

ferrydocks:
gosub put tell cara to follow
gosub move go dock
goto %return

nomoney:
Echo *
echo *
echo *
echo * ************* NO MONEY!!!! Start Beggin!!!!*********
echo *
echo *
echo *
exit

BrookEast:
gosub put east
gosub LookCara
gosub put east
gosub LookCara
return

Brookwest:
gosub put west
gosub LookCara
gosub put west
gosub LookCara
return

LookCara:
pause 3
matchre LookCara \.\.\.wait|Sorry, you may only|caravan belonging to
matchre return You tell the driver to give you an inventory report|following you|!resume
put look cara
matchwait

envelopecheck:
matchre envelopecheck \.\.\.wait|Sorry, you may only
matchre GetEnvelope I could not find|What were you referring to
matchre return You tap
put tap seventh envelope
matchwait

GetEnvelope:
gosub put tell cara to wait
gosub move sw
gosub move nw
gosub move sw
gosub move sw
gosub move nw
gosub move go tent
gosub put order fourth envelope
gosub put stow envel
gosub move out
gosub move se
gosub move ne
gosub move ne
gosub move se
gosub move ne
gosub put tell cara to follow
return

end:
put return caravan
echo **************************************************
echo You have returned to the Crossing.  Exiting script
echo **************************************************
put #echo  _______________________________
put #echo |COMPLETED CONTRACTS____________|
put #echo |
put #echo |To Arthe Dale---: %ToArthe
put #echo |To Stone Clan---: %ToStone
put #echo |To Dirge--------: %ToDirge
put #echo |To Crossing-----: %ToCrossing
put #echo |To Tiger Clan---: %ToTiger
put #echo |To Wolf Clan----: %ToWolf
put #echo |To Leth Deriel--: %ToLeth
put #echo |
put #echo |For a total of %Total Contracts
put #echo |and %profit Kronars in Profit
put #echo |_______________________________
echo **************************************************
echo You have returned to the Crossing.  Exiting script
echo **************************************************

leave:
put exit
exit
