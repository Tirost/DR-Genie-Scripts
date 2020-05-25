#debuglevel 10
put #class racial on
put #class rp on
#put #class arrive off
#put #class combat off
#put #class joust off
# Script to Travel for Genie3 #
# Written by Chris/Achilles
# Revitalized and Robustified by Shroom
# version 2.5
# Requires EXP Plugin by VTCifer #
# USAGE - .travel <city> <room>  (room is optional!)
# If you are calling this script via another, use ^YOU ARRIVED! to match the end of travelling!
##########################################
#                                        #
#       ADJUSTABLE VARIABLES             #
#                                        #
##########################################
##   ADJUST THE RANKS BELOW TO YOUR     ##
##       PARTICULAR CHARACTER           ##
##   THESE ARE CONSERVATIVE ESTIMATES   ##
##                                      ##
##  If you are joined in a group,       ##
##  You will take public transportation ##
##                                      ##
##########################################
##########################################
##    ARE YOU A CITIZEN OF SHARD?       ##
##        CHOOSE yes or no              ##
     var shardcitizen yes
##########################################
##    RANKS TO USE THE ROSSMAN'S        ##
##          SHORTCUT                    ##
## NORTH
    var rossmannorth 250
## SOUTH
    var rossmansouth 125
##                                      ##
##########################################
##    RANKS TO USE THE FALDESU          ##
    var faldesu 240
##########################################
##    RANKS TO USE THE SEGOLTHA         ##
    var segoltha 550
##########################################
##    RANKS TO USE UNDER-GONDOLA        ##
    var undergondola 550
##########################################
##########################################
##    RANKS TO USE UNDER-SEGOLTHA(THIEF)##
    var undersegoltha 60
##########################################
## MULTIPLE CHARACTER SUPPORT FOR SHARD CITIZEN VARIABLE
## YOU MUST CREATE GENIE GLOBAL VARIABLES CHAR1, CHAR2 etc IN GENIE FOR THIS TO WORK
## type: #var char1 <charactername> 
## in genie to create a global variable
if ("$charactername") = ("$char1") then var shardcitizen yes
if ("$charactername") = ("$char2") then var shardcitizen no
if ("$charactername") = ("$char3") then var shardcitizen no
if ("$charactername") = ("$char4") then var shardcitizen no
#### DONT TOUCH ANYTHING BELOW THIS LINE
###########################################
# CHANGELOG - Latest Update: 5/25/2020
# - Heavy robustification to Segoltha and Faldesu River travel - both North and South
# - ADDED PORTAL TRAVEL FOR PLAT - AUTO CHECKS if you have enough time for portals and if so should take portals between major cities
# - MAJOR update to Random Movement Logic - And complete overhaul of Movement routines 
# - Added support to check for Passport and go get a passport if you don't have one, when travelling to Muspar'i
# - Added Support for Starting inside the Gondola
# - Robustified all matches for towns and cleaned up a bunch of code
# - Added checking current coin you have on you and only going to bank if needed for ferries
# - Should now check for/withdraw double the amount needed for ferries (to account for return trips/thieves) 
# - Added remove invisible checks when visiting the teller
# - Added support for Necros to check and keep up EOTB/ROC when using ferries
# - Fixed travel from Shard to Alfren 
# - Merged all changes from recent updates
# - Added Khri Harrier for Thieves when climbing
# - Added travel to/from Boar Clan and Muspari via the wizard
# - Added option for %2 to move a roomid or name when arriving at the location
# - Added travel to and from Muspar'i via new Airship in Crossing area
# - Smashed bug involving travel between M'riss, Mer'Kresh, Hara'Jaal
# - Added travel to and from Islands! - Aesry, Ratha, M'riss, Mer'Kresh, Hara'Jaal, Fang Cove  
# - Added Destination Wyvern Mountain
# - Fixed random hangups after withdrawing coins.  Other robustifications.
# - Added Destinations: Throne City, Beisswurms, Caravansary, Hvaral, Alfren's Ferry, Gondola
# - Added ASCII Art :)
# - Robustified undergondola check - Added buffs for thieves/rangers
# - Updated help log and updated labels for more matches
# - Fixed logic issue when starting from Map 50 
# - Fixed issue travelling between Fornsted area and Theren
# - Changed all single movements to gosubs to avoid stalls
# - Added currency conversion before checking for coin
# - Will now attempt to exchange coin for ferry before withdrawing
# - Fixed problem traveling to P5 
# - Fixed several bad nodes
# - Added multi-character support for shardcitizen variable
# - Added travel  to and from Muspari 
# - Added Passport check / Sand Barge to Muspari
##########################################
goto INIT
NODESTINATION:
  Echo ---------------------------------------------------------------------------------------------------------
  Echo ## Either you did not enter a destination, or your destination is not recognized.  Please try again! ##
  Echo ##
  Echo ## SYNTAX IS: .travel CITY or .travel CITY roomnumber/label
  Echo ## e.g - .travel CROSS 144  - travel to crossing and move to room 144
  Echo ##
  Echo ## Valid Destinations are: ##
  Echo -------------------------------------------
  Echo ## Zoluren:
  Echo ## Crossing | Arthe Dale | Tiger Clan ##
  Echo ## Wolf Clan | Caravansary |Dirge     ##
  Echo ## Knife Clan | Acenemacra | Kaerna Village ##
  Echo ## Stone Clan | Ilaya Taipa | Misenseor ##
  Echo ## Sorrow's Reach | Beisswurms| Vipers/Leucros ##
  Echo ## Malodorous Buccas | Dokt | 
  Echo ## Alfren's Ferry | Leth Deriel 
  Echo -------------------------------------------
  Echo ## Therengia:
  Echo ## Riverhaven | Rossmans | Langenfirth ##
  Echo ## El'Bains | Zaulfun | Therenborough  ##
  Echo ## Fornsted | Zaulfung |  Throne City  ##
  Echo ## Muspar'i | Hvaral                   ##
  Echo -------------------------------------------
  Echo ## Ilithi:
  Echo ## Shard | Horse Clan | Fayrin's Rest ##
  Echo ## Steelclaw Clan | Spire |Corik's Wall ##
  Echo ## Ylono | Granite Gargoyles | Gondola ##
  Echo ## Bone Wolves | Germishdin | Fang Cove ##
  Echo ## Wyvern Mountain ##
  Echo -------------------------------------------
  Echo ## Forfedhdar:
  Echo ## Raven's Point | Ain Ghazal| Outer Hib ##
  Echo ## Inner Hib | Hibarnhvidar |Boar Clan ##
  Echo -------------------------------------------
  Echo ## Qi:
  Echo ## Aesy Surlaenis'a | Ratha | M'riss  ##
  Echo ## Mer'Kresh | Hara'jaal (TF only)    ##
  Echo -------------------------------------------
  exit
INIT:
# action goto START when ^Just when it seems you will never reach the end of the road
action goto NOPASSPORT when No one proceeds through this checkpoint without a passport
action goto NOCOIN when You haven't got enough (.+) to pay for your trip\. Come back|You reach your funds\, but realize you\'re short\.|^\"Hey\,\" he says\, \"You haven\'t got enough lirums to pay for your trip\.
## action goto START when \"What in tarnation
action (moving) var Moving 1 when Obvious (path|exits)|Roundtime
action var offtransport platform when a barge platform
action var offtransport pier when the Riverhaven pier
action var offtransport beach when You also see the beach|mammoth and the beach
action var offtransport ladder when You also see a ladder|mammoth and a ladder
action var offtransport wharf when the Langenfirth wharf
action var offtransport dock when \[\"Her Opulence\"\]|\[\"Hodierna\'s Grace\"\]|\[\"Kertigen\'s Honor\"\]|\[\"His Daring Exploit\"\]|\[The Evening Star\]|\[The Damaris\' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"Imperial Glory\"\]|\[\"The Riverhawk\"\]|Baso Docks|a dry dock|the salt yard dock|covered stone dock|\[The Galley Sanegazat\]|\[The Galley Cercorim\]|\[Aboard the Warship\, Gondola\]
action put fatigue when ^You can see a ferry approaching on the left side.|^The ferry|^A kingfisher|^A burst of|^The Elven|^The skiff|^The polemen|^Small waves|^The sturdy stone|^You are about a fourth of the way across\.|^The ferry moves away\, nearly out of view\.|ferry passing you on the left\.|^You are nearing the docks\.|^A swarm of eels passes beneath the keel\, probably on their way to the river\'s fresh water to spawn\.|followed by the clatter of wood on wood\.|^A family of dolphins leaps from the water beside the galley\.|^Some geese in a perfect V fly north high overhead\.|^Some small blue sharks slide past through the water\.|^A sailor walks by with a coil of rope\.|^A green turtle as large as a tower shield swims past\,|^You are nearing the docks\.|A drumbeat sounds through the ship\.|^You are about a fourth of the way across\.|^A galley comes into sight\, its oars beating rhythmically\.|^The galley moves away\, the beat of its drum slowly fading\.|^For a few minutes\, the drumbeat from below is echoed across the water by the beat from the galley passing on the left\.|The door swings shut of its own accord, and the gondola pushes off\.|The platform vanishes against the ridgeline\.|The gondola arrives at the center of the chasm\, and keeps heading (north|south)\.|The cab trundles on along as the ropes overhead creak and moan\.|The ropes creak as the gondola continues (north|south)\.|^The gondola creaks as a wind pushes it back and forth\.|^You hear a bell ring out three times|^The barge|^Several oars pull|^All that is visible|^The opposite bank|^A few of the other passengers|^The shore disappears
action put fatigue when ^A desert oasis|^The oasis|The endless expanse of the desert|The dock disappears from view quickly|sand-bearing winds buffet|Several skilled yeehar-handlers|^The Sand Elf|^The harsh winds|^The Gemfire Mountains|^The extreme heat causes|^The sand barge|^The large yeehars|^The murderous shriek|dark-skinned elf|Dark-skinned Elves|^As the barge is pulled|^As the dirigible continues|^The thick canopy of|^The dirigible|^The sinuous Southern Trade Route|^The Reshal Sea|^The peculiar sight|^A long moment of breathless suspense|^A Gnomish mechanic|^As the dirigible|^A breathtaking panorama|^The Gnomish operators|^The river quickly gives|^A massive peak|^A large flock|^Far below\, you see|^The Greater Fist|^A clangorous commotion|^Passing over land|^A human who had been|^A cowled passenger peers|^The balloon|^A few scattered islands|^The mammoth\'s fur|^The sea mammoth|^The air cools|^Scarcely visible in|^Another sea mammoth|^Steadily climbing\,|^As the airship leaves the mountain range|^With a swift turn of the|^With another yank on the|^The pilot adjusts his controls|^Turning his wheel\, the pilot points the airship|^With a confident spin of the|^Coming down from the mountain|^A whoosh of steam escapes|^The warship (rumbles|continues)|The tropical island|(crewmen|crewman) (works|rush|swabs)|Sputtering loudly\, the cast-iron stove|Gnomish (crew|pilot|crewman)|warship (proceeds|continues)
action put look when ^Your destination
action put #tvar spellEOTB 0 when ^Your corruptive mutation fades\, revealing you to the world once more\.
action put #tvar spellEOTB 1 when ^You feel a rippling sensation throughout your body as your corruptive mutation alters you and your equipment into blind spots invisible to the world\.
action put #tvar spellEOTB 1 when ^Your spell subtly alters the corruptive mutation upon you\, creating a blind spot once more\.
action put #tvar spellEOTB 1 when ^You sense the Eyes of the Blind spell upon you\, which will last .*\.
action put #tvar spellROC 0 when ^The Rite of Contrition matrix loses cohesion\, leaving your aura naked\.
action put #tvar spellROC 0 when eval ($SpellTimer.RiteofContrition.active = 0)
action put #tvar spellROC 1 when ^You weave a field of sublime corruption\, concealing the scars in your aura under a layer of magical pretense\.
action put #tvar spellROC 1 when ^You sense the Rite of Contrition spell upon you\, which will last .*\.
action put #tvar spellROG 1 when ^You project your self-image outward on a gust of psychic miasma
action put #tvar spellROG 1 when eval ($SpellTimer.RiteofGrace.active = 1)
action put #tvar spellROG 0 when eval ($SpellTimer.RiteofGrace.active = 0)
put #tvar spellROG 0
put #tvar spellROC 0
put #tvar spellEOTB 0
if !def(guild) then action put #var guild $1 when Guild\: (\S+)
action put #var circle $1 when Circle\: (\d+)
action var kronars 0 when No Kronars\.
action var kronars $1 when \((\d*) copper Kronars\)\.
action var lirums 0 when No Lirums\.
action var lirums $1 when \((\d*) copper Lirums\)\.
action var dokoras 0 when No Dokoras\.
action var dokoras $1 when \((\d*) copper Dokoras\)\.
var passport 0
var premium 0
var kronars 0
var dokoras 0
var lirums 0
var portal 0
var moved 0
var randomloop 0
var ported 0
var lastmoved null
var detour null
var therencoin 300
var boarneeded 300
var destination %1
eval destination tolower("%destination")
TOP:
pause 0.001
send info;encumbrance
waitforre ^\s*Encumbrance\s*\:
action remove Guild\: (\S+)
action remove Circle\: (\d+)
pause 0.1
pause 0.1
send exp 0
waitforre EXP HELP
pause 0.2
gosub PREMIUM_CHECK
pause 0.2
action remove Circle\: (\d+)
action remove Guild\: (\S+)
put #var save
put #mapper reset
if matchre("$guild", "(Ranger|Thief)") then var undergondola 520
if matchre("$guild", "Necromancer") then 
     {
          put perceive
          pause
          pause 0.2
     }
put #echo >Log * Travel script start: $zonename (map $zoneid: room $roomid)
if $hidden then send unhide
pause 0.001
pause 0.001
timer clear
timer start
eval destination tolower("%destination")
if ($joined = 1) then
     {
          var rossmannorth 2000
          var rossmansouth 2000
          var faldesu 2000
          var segoltha 2000
          var undergondola 2000
          var undersegoltha 2000
          var shardcitizen no
          echo ### You are in a group!  You will NOT be taking the gravy short cuts today! ###
     }
START:
action (moving) on
if ("%destination" = "") then goto NODESTINATION
#DESTINATION
echo ** TRAVEL DRAGON
echo
echo                 \||/
echo                 |  @___oo ------------ Pew Pew Pew 
echo       /\  /\   / (__,,,,|
echo      ) /^\) ^\/ _)
echo      )   /^\/   _)
echo      )   _ /  / _)
echo  /\  )/\/ ||  | )_)
echo <  >      |(,,) )__)
echo  ||      /    \)___)\
echo  | \____(      )___) )___
echo   \______(_______;;; __;;;
echo 
echo *** LET'S GO!!
echo *** DESTINATION: %destination
if matchre ("$roomname","Aboard the Mammoth") then gosub FERRYLOGIC
if matchre("$roomname", "Gondola") then gosub FERRYLOGIC
if (("$zoneid" = "0") || ("$roomid" = "0")) then
     {
          echo ### Unknown map or room id - Attempting to move in random direction to recover
          gosub MOVERANDOM
     }
pause 0.001
if (("$zoneid" = "0") || ("$roomid" = "0")) then gosub MOVERANDOM
pause 0.001
if ("$zoneid" = "0") then
     {
          ECHO ### You are in a spot not recognized by Genie, please start somewhere else! ###
          exit
     }
pause 0.1
if matchre("Aesry","$zonename") then gosub AESRYBACK
if (matchre("%destination", "\b(ratha|hara?j?a?a?l?)") && matchre("$zoneid", "\b(1|30|42|47|61|66|67|90|99|107|108|116)\b")) then
     {
          if (("$game" = "DRX") && (%portal = 1)) then
          {
               if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
          }
     if (("$game" = "DRF") && matchre("%destination", "\brath?a?") || (%premium = 1) && matchre("%destination", "\brath?a?")) then
               {
                    echo *** GOING TO FC
                    gosub TO_SEACAVE
                    gosub AUTOMOVE 2
                    var toratha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
      if (("$game" = "DRF") && matchre("%destination", "\b(haraj?a?a?l?)")) then
          {
               echo ** TO FANG COVE
               gosub TO_SEACAVE
               gosub AUTOMOVE 3
               gosub JOINLOGIC
               goto ARRIVED
          }
    }
if (("$zoneid" = "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara)")) then
    {
          if (("$game" = "DRX") && (%portal = 1)) then
               {
                    if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
               }
        var toratha 0
        gosub AUTOMOVE 834
        gosub JOINLOGIC
        pause
        gosub JOINLOGIC
        gosub AUTOMOVE 2
    }
if (("$zoneid" = "150") && !matchre("%destination", "\b(rath?a?|acen?e?m?a?c?r?a?)")) then
     {
         gosub AUTOMOVE 85
         pause 0.3
         send go exit portal
         pause 0.5
         pause 0.2
     }
cheatstart:
if matchre("%destination", "\b(cros?s?i?n?g?s?|xing?)") then goto CROSSING
if matchre("%destination", "\b(wolfc?l?a?n?)") then
     {
          var detour wolf
          goto CROSSING
     }
if matchre("%destination", "\b(knif?e?c?l?a?n?)") then
     {
          var detour knife
          goto CROSSING
     }
if matchre("%destination", "\b(tige?r?c?l?a?n?)") then
     {
          var detour tiger
          goto CROSSING
     }
if matchre("%destination", "\b(dirg?e?)") then
     {
          var detour dirge
          goto CROSSING
     }
if matchre("%destination", "\b(arth?e?d?a?l?e?)") then
     {
          var detour arthe
          goto CROSSING
     }
if matchre("%destination", "\b(kaer?n?a?)") then
     {
          var detour kaerna
          goto CROSSING
     }
if matchre("%destination", "\b(ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa)") then
     {
          var detour taipa
          goto CROSSING
     }
if matchre("%destination", "\b(leth?d?e?r?i?e?l?)") then
     {
          var detour leth
          goto CROSSING
     }
if matchre("%destination", "\b(acen?a?m?a?c?r?a?)") then
     {
          var detour acen
          goto CROSSING
     }
if matchre("%destination", "\b(vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?)") then
     {
          var detour viper
          goto CROSSING
     }
if matchre("%destination", "\b(malod?o?r?o?u?s?|bucc?a?)") then
     {
          var detour bucca
          goto CROSSING
     }
if matchre("%destination", "\b(dokt?)") then
     {
          var detour dokt
          goto CROSSING
     }
if matchre("%destination", "\bsorr?o?w?s?") then
     {
          var detour sorrow
          goto CROSSING
     }
if matchre("%destination", "\bmisens?e?o?r?") then
     {
          var detour misen
          goto CROSSING
     }
if matchre("%destination", "\bbeis?s?w?u?r?m?s?") then
     {
          var detour beisswurms
          goto CROSSING
     }
if matchre("%destination", "\bston?e?c?l?a?n?") then
     {
          var detour stone
          goto CROSSING
     }
if matchre("%destination", "\bshar?d?") then goto ILITHI
if matchre("%destination", "\b(bone?w?o?l?f?|germ?i?s?h?d?i?n?)") then
     {
          var detour bone
          goto ILITHI
     }
if matchre("%destination", "\balfr?e?n?s?") then
     {
          var detour alfren
          goto ILITHI
     }
if matchre("%destination", "\b(gond?o?l?a?)") then
     {
          var detour gondola
          goto ILITHI
     }
if matchre("%destination", "\b(grani?t?e?|garg?o?y?l?e?)") then
     {
          var detour garg
          goto ILITHI
     }
if matchre("%destination", "\b(spir?e?)") then
     {
          var detour spire
          goto ILITHI
     }
if matchre("%destination", "\b(horse?c?l?a?n?)") then
     {
          var detour horse
          goto ILITHI
     }
if matchre("%destination", "\b(fayr?i?n?s?)") then
     {
          var detour fayrin
          goto ILITHI
     }
if matchre("%destination", "\b(steel?c?l?a?w?)") then
     {
          var detour steel
          goto ILITHI
     }
if matchre("%destination", "\b(cori?k?s?)") then
     {
          var detour corik
          goto ILITHI
     }
if matchre("%destination", "\b(ada?n?f?)") then
     {
          var detour adan'f
          goto ILITHI
     }
if matchre("%destination", "\b(ylo?n?o?)") then
     {
          var detour ylono
          goto ILITHI
     }
if matchre("%destination", "\b(wyve?r?n?)") then
     {
          var detour wyvern
          goto ILITHI
     }

if matchre("%destination", "\b(cara?v?a?n?s?a?r?y?)") then
     {
          var detour caravansary
          goto THERENGIA
     }
if matchre("%destination", "\b(rive?r?h?a?v?e?n?|have?n?)") then
     {
          var detour haven
          goto THERENGIA
     }
if matchre("%destination", "\b(ross?m?a?n?s?)") then
     {
          var detour rossman
          goto THERENGIA
     }
if matchre("%destination", "\b(ther?e?n?b?o?r?o?u?g?h?)") then
     {
          var detour theren
          goto THERENGIA
     }
if matchre("%destination", "\b(lang?e?n?f?i?r?t?h?)") then
     {
          var detour lang
          goto THERENGIA
     }
if matchre("%destination", "\b(el'?b?a?i?n?s?|elb?a?i?n?s?)") then
     {
	      var detour el'bain
		  goto THERENGIA
	 }
if matchre("%destination", "\b(raka?s?h?)") then
     {
          var detour rakash
          goto THERENGIA
     }
if matchre("%destination", "\bthro?n?e?") then
     {
          var detour throne
          goto THERENGIA
     }
if matchre("%destination", "\b(musp?a?r?i?)") then
     {
          var detour muspari
          goto THERENGIA
     }
if matchre("%destination", "\b(forn?s?t?e?d?)") then
     {
          var detour fornsted
          goto THERENGIA
     }
if matchre("%destination", "\b(hvar?a?l?)") then
     {
          var detour hvaral
          goto THERENGIA
     }
if matchre("%destination", "\b(zaul?f?u?n?g?)") then
     {
          var detour zaulfung
          goto THERENGIA
     }
if matchre("%destination", "\b(aing?h?a?z?a?l?)") then
     {
          var detour ain
          goto FORD
     }
if matchre("%destination", "\b(rave?n?s?)") then
     {
          var detour raven
          goto FORD
     }
if matchre("%destination", "\b(hib?a?r?n?h?v?i?d?a?r?|out?e?r?)") then
     {
          var detour outer
          goto FORD
     }
if matchre("%destination", "\b(inne?r?)") then
     {
          var detour inner
          goto FORD
     }
if matchre("%destination", "\b(boar?c?l?a?n?)") then goto FORD
if matchre("%destination", "\b(aes?r?y?|sur?l?a?e?n?i?s?)") then
    {
            var detour aesry
            goto ILITHI
    }
if matchre("%destination", "\b(mri?s?s?)") then
    {
            var detour mriss
            goto THERENGIA
    }
if matchre("%destination", "\b(merk?r?e?s?h?|kre?s?h?)") then
    {
            var detour merk
            goto THERENGIA
    }
if matchre("%destination", "\b(har?a?j?a?a?l?)") then
    {
            var detour hara
            goto THERENGIA
    }
if matchre("%destination", "\b(rath?a?)") then
    {
            var detour ratha
            if ("$zoneid" = "150") then
                {
                    gosub AUTOMOVE 2
                    var toratha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
                }
            goto CROSSING
    }
if (("$zoneid" = "150") && ("$game" != "DRF") && ("%detour" != "ratha")) then
    {
            gosub AUTOMOVE 2
            var toratha 0
            gosub JOINLOGIC
            gosub AUTOMOVE 2
            goto cheatstart
    }
if matchre("%destination", "\b(fan?g?|cov?e?)") then
    {
            var detour fang
            goto CROSSING
    }
goto NODESTINATION

AESRY_LONG:
echo 
echo ** NO SHORTCUT TO AESRY IN TF - TAKING LONG ROUTE
echo
if ("$zoneid" = "90") then goto AESRY_LONG_2
var detour aesry
if %lirums < 300 then goto NOCOIN
if ("$zoneid" = "67") then gosub AUTOMOVE east
gosub AUTOMOVE portal
pause 0.2
put go meeting portal
pause 0.5
pause 0.3
gosub AUTOMOVE 2
var toratha 1
gosub JOINLOGIC
AESRY_LONG_2:
pause 0.2
gosub AUTOMOVE 234
gosub JOINLOGIC
goto ARRIVED

# TRAVEL
CROSSING:
var label CROSSING
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if matchre("$zonename", "(Hara'jaal|Mer'Kresh|M'Riss)") then
     {
          var backuplabel CROSSING
          var backupdetour %detour
          var detour mriss
          var tomainland 1
          goto QITRAVEL
     }
if (("$zoneid" = "150") && !matchre("%destination", "\b(rath?a?|acen?e?m?a?c?r?a?|haraj?a?a?l?)")) then
     {
         gosub AUTOMOVE 85
         pause 0.3
         send go exit portal
         pause 0.5
         pause 0.2
     }
if ("$zoneid" = "35") then 
     {
          if (%lirums < 240) then goto NOCOIN
          gosub AUTOMOVE 166
          gosub FERRYLOGIC
          pause
     }
if ("$zoneid" = "1a") then gosub AUTOMOVE cross
if ("$zoneid" = "2a") then gosub AUTOMOVE cross
if ("$zoneid" = "47") then 
     {
          if (("$game" = "DRX") && (%portal = 1) && (%ported = 0)) then goto PORTAL_TIME
          gosub AUTOMOVE 117
          gosub FERRYLOGIC
          pause
     }
if ("$zoneid" = "41") then 
     {
          gosub AUTOMOVE 53
          pause 0.5
          put east
          waitforre ^Just when it seems
          pause
          # put #mapper reset
     }
if ("$zoneid" = "42") then gosub AUTOMOVE 2
if ("$zoneid" = "59") then gosub AUTOMOVE 12
if ("$zoneid" = "114") then
     {
          put wealth
          pause 0.7
          if (%dokoras < 120) then goto NOCOIN
          gosub AUTOMOVE 1
          gosub FERRYLOGIC
          send go oak doors
          pause
     }
if (("$zoneid" = "113") && ("$roomid" = "1")) then gosub AUTOMOVE 5
if ("$zoneid" = "40a") then gosub AUTOMOVE 125
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "40") && ($Athletics.Ranks >= %rossmansouth)) then gosub AUTOMOVE 213
if (("$zoneid" = "40") && ($Athletics.Ranks < %rossmansouth)) then
     {
          if (%lirums < 140) then goto NOCOIN
          gosub AUTOMOVE 36
          gosub FERRYLOGIC
     }
if ("$zoneid" = "34a") then gosub AUTOMOVE 134
if ("$zoneid" = "34") then gosub AUTOMOVE 15
if ("$zoneid" = "33a") then gosub AUTOMOVE 46
if ("$zoneid" = "33") then gosub AUTOMOVE 1
if ("$zoneid" = "32") then gosub AUTOMOVE 1
if ("$zoneid" = "31") then gosub AUTOMOVE 1
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "30") && ($Athletics.Ranks < %faldesu)) then
     {
          put wealth
          pause 0.7
          if (%lirums < 140) then goto NOCOIN
          gosub AUTOMOVE 103
          pause
          gosub FERRYLOGIC
     }
if (("$zoneid" = "30") && ($Athletics.Ranks >= %faldesu)) then
     {
          gosub AUTOMOVE 203
          gosub AUTOMOVE 79
     }
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "127") then gosub AUTOMOVE 510
if ("$zoneid" = "126") then gosub AUTOMOVE 49
if ("$zoneid" = "116") then gosub AUTOMOVE 3
if ("$zoneid" = "123") then gosub AUTOMOVE 175
if ("$zoneid" = "67a") then gosub AUTOMOVE shard
if ("$zoneid" = "69") then gosub AUTOMOVE 1
if ("$zoneid" = "68a") then gosub AUTOMOVE 29
if ("$zoneid" = "68b") then gosub AUTOMOVE 44
if (("$zoneid" = "68") && ("$guild" = "Thief")) then gosub AUTOMOVE 15
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)yes")) then
     {
          gosub AUTOMOVE 1
          gosub AUTOMOVE 135
     }
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)no")) then gosub AUTOMOVE 15
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "67") && ("$guild" = "Thief")) then
     {
          gosub AUTOMOVE 566
          gosub AUTOMOVE 23
     }
if ("$zoneid" = "67") then gosub AUTOMOVE 132
if (("$zoneid" = "66") && ("$guild" = "Thief") && ($Athletics.Ranks >= %undergondola)) then 
     {
          put khri flight harrier
          pause
     }
if (("$zoneid" = "66") && ("$guild" = "Ranger") && ($Athletics.Ranks >= %undergondola)) then 
     {
          put prep athletic 12
          pause 8
          put cast
          pause 0.2
     }
if (("$zoneid" = "66") && ($Athletics.Ranks >= %undergondola)) then gosub AUTOMOVE 317
if (("$zoneid" = "66") && ($Athletics.Ranks < %undergondola)) then
     {
          gosub AUTOMOVE 156
          pause
          gosub FERRYLOGIC
     }
if ("$zoneid" = "1a") then gosub AUTOMOVE cross
if ("$zoneid" = "63") then gosub AUTOMOVE 112
if ("$zoneid" = "65") then gosub AUTOMOVE 44
if ("$zoneid" = "62") then gosub AUTOMOVE 100
if ("$zoneid" = "112") then gosub AUTOMOVE 112
if ("$zoneid" = "58") then gosub AUTOMOVE leth
if (("$zoneid" = "60") && matchre("%detour", "(leth|acen|taipa|LETH|ACEN|ratha|fang)")) then gosub AUTOMOVE 57
if (("$zoneid" = "61") && matchre("%detour", "(leth|acen|taipa|LETH|ACEN|ratha|fang)")) then
     {
          if ("%detour" = "acen") then
               {
                    gosub AUTOMOVE 178
                    gosub AUTOMOVE 47
               }
          if ("%detour" = "taipa") then
               {
                    gosub AUTOMOVE 126
                    gosub AUTOMOVE 27
               }
          if ("%detour" = "ratha") then
               {
                    gosub AUTOMOVE 178
                    gosub AUTOMOVE 47
                    var toratha 1
                    gosub JOINLOGIC
                    pause
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
          if ("%detour" = "leth") then gosub AUTOMOVE 18
          goto ARRIVED
     }
if ("$zoneid" = "61") then gosub AUTOMOVE 115
if ("$zoneid" = "50") && matchre("%destination", "\b(knife?|wolf?|tige?r?|dirg?e?|arth?e?|kaer?n?a?|rive?r?|have?n?|ther?e?n?|lang?|raka?s?h?|musp?a?r?i?|zaul?f?u?n?g?|cross?i?n?g?)") && ($Athletics.Ranks > %segoltha) then gosub SEGOLTHA_NORTH
if ("$zoneid" = "50") then gosub SEGOLTHA_SOUTH
if (("$zoneid" = "60") && ("%detour" = "alfren")) then 
          {
          gosub AUTOMOVE 42
          goto ARRIVED
          }
if (("$zoneid" = "60") && matchre("%detour", "(leth|acen|taipa|LETH|ACEN|ratha|fang|ain|raven|outer|inner|adan'f|corik|steel|ylono|fayrin|horse|spire)")) then gosub AUTOMOVE leth
if (("$zoneid" = "60") && ("$guild" = "Thief")) then
          {
              if ($Athletics.Ranks >= %undersegoltha) then
                  {
                      gosub AUTOMOVE 107
                      if ("$zoneid" = "120") then gosub AUTOMOVE 107
                      gosub AUTOMOVE cross
                      pause 0.1
                      if ("$zoneid" = "1a") then gosub AUTOMOVE cross
                  }
          }
if (("$zoneid" = "60") && ($Athletics.Ranks >= %segoltha)) then gosub AUTOMOVE 108
pause 0.01
if ("$zoneid" = "50") && matchre("%destination", "\b(knife|wolf|tiger|dirge|arthe|kaerna|haven|theren|lang|rakash|muspari|zaulfung|cross|crossing)") && ($Athletics.Ranks > %segoltha) then gosub SEGOLTHA_NORTH
if ("$zoneid" = "50") then gosub SEGOLTHA_SOUTH
if (("$zoneid" = "60") && ($Athletics.Ranks < %segoltha)) then
          {
              put wealth
              pause 0.7
              if (%kronars < 40) then goto NOCOIN
              gosub AUTOMOVE 42
              if ("$roomid" != "42") then gosub AUTOMOVE 42
              if ("$roomid" != "42") then gosub AUTOMOVE 42
              pause
              gosub FERRYLOGIC
          }
if "$zoneid" = "6"  then gosub AUTOMOVE cross
if ("$zoneid" = "4a") then gosub AUTOMOVE 15
if ("$zoneid" = "4b") then gosub AUTOMOVE 1
if (("$zoneid" = "4") && (("%detour" = "dokt"))) then 
          {
              gosub AUTOMOVE dok
              goto ARRIVED
          }
if "$zoneid" = "4"  then gosub AUTOMOVE 14
if ("$zoneid" = "13") then gosub AUTOMOVE 71
if ("$zoneid" = "12a") then gosub AUTOMOVE 60
if ("$zoneid" = "10") then gosub AUTOMOVE 116
if ("$zoneid" = "9b") then gosub AUTOMOVE 9
if ("$zoneid" = "14b") then gosub AUTOMOVE 217
if ("$zoneid" = "11") then gosub AUTOMOVE 2
if (("$zoneid" = "1") && matchre("%detour", "(arthe|dirge|kaerna|stone|misen|sorrow|fist|beisswurms|bucca|viper)")) then gosub AUTOMOVE 171
if (("$zoneid" = "7") && matchre("%detour", "(arthe|dirge|kaerna|stone|misen|sorrow|fist|beisswurms|bucca|viper)")) then
     {
         if ("%detour" = "dirge") then
             {
                 gosub AUTOMOVE 147
                 gosub AUTOMOVE 38
             }
         if ("%detour" = "arthe") then gosub AUTOMOVE 535
         if ("%detour" = "kaerna") then gosub AUTOMOVE 352
         if ("%detour" = "stone") then gosub AUTOMOVE 396
         if (("%detour" = "stone") && ("$zoneid" = "7")) then gosub AUTOMOVE 396
         if (("%detour" = "stone") && ("$zoneid" = "7")) then gosub AUTOMOVE 396
         if ("%detour" = "beisswurms") then gosub AUTOMOVE 396
         if (("%detour" = "beisswurms") && ("$zoneid" = "7")) then gosub AUTOMOVE 396
         if ("%detour" = "fist") then gosub AUTOMOVE 253
         if ("%detour" = "misen") then gosub AUTOMOVE 437
         if ("%detour" = "viper") then
             {
                 gosub AUTOMOVE 394
                 if ($Perception.Ranks > 150) then gosub AUTOMOVE 5
             }
         if matchre("(sorrow|bucca)","%detour") then
             {
                 gosub AUTOMOVE 397
                 if ("%detour" = "sorrow") then 
                       {
                            gosub AUTOMOVE 77
                            goto ARRIVED
                       }
                 if ("%detour" = "bucca") then 
                       {
                            gosub AUTOMOVE 124
                            goto ARRIVED
                       }
             }
        if ("%detour" = "beisswurms") then gosub AUTOMOVE 31
         goto ARRIVED
     }
if ("$zoneid" = "7") then gosub AUTOMOVE 349
if ("$zoneid" = "7") then gosub AUTOMOVE 349
if ("$zoneid" = "8") then gosub AUTOMOVE 43
if (("$zoneid" = "1") && matchre("%detour", "(wolf|knife|tiger)")) then
     {
         gosub AUTOMOVE 172
         if ("%detour" = "wolf") then gosub AUTOMOVE 126
         if ("%detour" = "knife") then gosub AUTOMOVE 459
         if ("%detour" = "tiger") then gosub AUTOMOVE 87
         goto ARRIVED
     }
if (("$zoneid" = "1") && matchre("%detour", "(leth|acen|taipa|ratha)")) then
     {
         if ("$guild" = "Thief") then
             {
                 if ($Athletics.Ranks >= %undersegoltha) then
                     {
                         gosub AUTOMOVE 650
                         gosub AUTOMOVE 23
                     }
             }
         if (($Athletics.Ranks >= %segoltha) && ("$zoneid" = "1")) then
             {
                 gosub AUTOMOVE 476
                 gosub SEGOLTHA_SOUTH
             }
         if ("$zoneid" = "1") then
             {
                 if %kronars < 100 then goto NOCOIN
                 gosub AUTOMOVE 236
                 gosub FERRYLOGIC
             }
         pause
         put south
         wait
         put #mapper reset
         gosub AUTOMOVE 57
         if ("%detour" = "acen") then
             {
                 gosub AUTOMOVE 178
                 gosub AUTOMOVE 47
             }
         if ("%detour" = "taipa") then
             {
                 gosub AUTOMOVE 126
                 gosub AUTOMOVE 27
             }
         if ("%detour" = "ratha") then
             {
                 gosub AUTOMOVE 178
                 gosub AUTOMOVE 47
                 var toratha 1
                 gosub JOINLOGIC
                 pause
                 gosub JOINLOGIC
                 send go beach
                 pause 0.5
                 gosub AUTOMOVE 252
                 goto ARRIVED
             }
         if ("%detour" = "leth") then gosub AUTOMOVE 18
     }
if ("$zoneid" = "1") then gosub AUTOMOVE 42
goto ARRIVED

ILITHI:
var label ILITHI
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "127") then gosub AUTOMOVE south
if "$zoneid" = "6"  then gosub AUTOMOVE cross  
if ("$zoneid" = "2a") then gosub AUTOMOVE cross
if ("$zoneid" = "67a") then gosub AUTOMOVE shard
if matchre("$zonename", "(Hara'jaal|Mer'Kresh|M'Riss)") then
     {
         var backuplabel ILITHI
         var backupdetour %detour
         var detour mriss
         var tomainland 1
         goto QITRAVEL
     }
if ("$zoneid" = "35") then 
     {
         if %lirums < 120 then goto NOCOIN
         gosub AUTOMOVE 166
         gosub FERRYLOGIC
     }
 if ("$zoneid" = "47") then 
     {
         if (("$game" = "DRX") && (%portal = 1) && (%ported = 0)) then goto PORTAL_TIME
         gosub AUTOMOVE 117
         gosub FERRYLOGIC
         pause 0.5
     }
if ("$zoneid" = "41") then 
     {
         gosub AUTOMOVE 53
         pause 0.5
         put east
         waitforre ^Just when it seems
         pause
         put #mapper reset
     }
if ("$zoneid" = "127") then gosub AUTOMOVE south
if ("$zoneid" = "40a") then gosub AUTOMOVE 125
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "40") && ($Athletics.Ranks >= %rossmansouth)) then gosub AUTOMOVE 213
if (("$zoneid" = "40") && ($Athletics.Ranks < %rossmansouth)) then
     {
        evalmath boarneeded ($circle * 20)
        if (%lirums < %boarneeded) then goto NOCOIN
        gosub AUTOMOVE 263
     }
if ("$zoneid" = "40a") then 
	{
	evalmath boarneeded ($circle * 20)
	if (%lirums < %boarneeded) then 
		{
		gosub AUTOMOVE 125
		goto NOCOIN
		}
	gosub AUTOMOVE 68
	gosub JOINLOGIC
	}
if ("$zoneid" = "126") then gosub AUTOMOVE 49
if ("$zoneid" = "127") then gosub AUTOMOVE south
if ("$zoneid" = "126") then gosub AUTOMOVE 49
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "116") then gosub AUTOMOVE 3
if ("$zoneid" = "114") then
          {
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 4
              gosub FERRYLOGIC
              send west
              wait
          }
if ("$zoneid" = "112") then gosub AUTOMOVE 112
if ("$zoneid" = "123") then gosub AUTOMOVE 175
if ("$zoneid" = "42") then gosub AUTOMOVE 2
if ("$zoneid" = "59") then gosub AUTOMOVE 12
if ("$zoneid" = "114") then
          {
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 1
              gosub FERRYLOGIC
              send go oak doors
          }
if ("$zoneid" = "40a") then gosub AUTOMOVE 125
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "40") && ($Athletics.Ranks >= %rossmansouth)) then gosub AUTOMOVE 213
if (("$zoneid" = "40") && ($Athletics.Ranks < %rossmansouth)) then
          {
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 36
              gosub FERRYLOGIC
          }
if ("$zoneid" = "34a") then gosub AUTOMOVE 134
if ("$zoneid" = "34") then gosub AUTOMOVE 15
if ("$zoneid" = "33a") then gosub AUTOMOVE 46
if ("$zoneid" = "33") then gosub AUTOMOVE 1
if ("$zoneid" = "32") then gosub AUTOMOVE 1
if ("$zoneid" = "31") then gosub AUTOMOVE 1
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "30") && ($Athletics.Ranks < %faldesu)) then
          {
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 103
              pause
              gosub FERRYLOGIC
          }
if (("$zoneid" = "30") && ($Athletics.Ranks >= %faldesu)) then
          {
              gosub AUTOMOVE 203
              gosub AUTOMOVE 79
          }
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "13") then gosub AUTOMOVE 71
if ("$zoneid" = "12a") then gosub AUTOMOVE 60
if ("$zoneid" = "4a") then gosub AUTOMOVE 15
if ("$zoneid" = "4") then gosub AUTOMOVE 14
if ("$zoneid" = "8") then gosub AUTOMOVE 43
if ("$zoneid" = "10") then gosub AUTOMOVE 116
if ("$zoneid" = "9b") then gosub AUTOMOVE 9
if ("$zoneid" = "14b") then gosub AUTOMOVE 217
if ("$zoneid" = "11") then gosub AUTOMOVE 2
if ("$zoneid" = "7") then gosub AUTOMOVE 349
if ("$zoneid" = "7") then gosub AUTOMOVE 349
if ("$zoneid" = "7") then gosub AUTOMOVE 349
if ("$zoneid" = "112") then gosub AUTOMOVE 112
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "1") then
          {
              if ("$guild" = "Thief") then
                  {
                      if ($Athletics.Ranks >= %undersegoltha) then
                          {
                              gosub AUTOMOVE 650
                              gosub AUTOMOVE 23
                          }
                  }
              if (($Athletics.Ranks >= %segoltha) && ("$zoneid" = "1")) then
                  {
                      gosub AUTOMOVE 476
                      gosub SEGOLTHA_SOUTH
                  }
              if ("$zoneid" = "1") then
                  {
                      if %kronars < 100 then goto NOCOIN
                      gosub AUTOMOVE 236
                      gosub FERRYLOGIC
                  }
              pause
              put south
              wait
              put #mapper reset
          }
if ("$zoneid" = "50") && matchre("(knife|wolf|tiger|dirge|arthe|kaerna|haven|theren|lang|rakash|muspari|zaulfung|cross|crossing)","%destination") && ($Athletics.Ranks > %segoltha) then gosub SEGOLTHA_NORTH
if ("$zoneid" = "50") then gosub SEGOLTHA_SOUTH
if ("$zoneid" = "1a") then gosub AUTOMOVE 23
if (("$zoneid" = "67") && matchre("alfren","%detour")) then 
          {
              goto CROSSING
          }
if (("$zoneid" = "62") && matchre("alfren","%detour")) then 
          {
              gosub AUTOMOVE leth
          }
if (("$zoneid" = "61") && matchre("alfren","%detour")) then 
          {
              gosub AUTOMOVE cross
              pause 0.2
          }
if (("$zoneid" = "60") && matchre("alfren","%detour")) then 
          {
              gosub AUTOMOVE 42
              goto ARRIVED
          }
if ("$zoneid" = "60") then gosub AUTOMOVE 57
if ("$zoneid" = "112") then gosub AUTOMOVE 112
if ("$zoneid" = "59") then gosub AUTOMOVE 12
if ("$zoneid" = "58") then gosub AUTOMOVE 2
if ("$zoneid" = "61") then gosub AUTOMOVE 130
if ("$zoneid" = "63") then gosub AUTOMOVE 112
if (("$zoneid" = "62") && matchre("gondola","%detour")) then
          {
              gosub AUTOMOVE 2
              goto ARRIVED
          }
if (("$zoneid" = "62") && matchre("(bone|germ)","%detour")) then
          {
              gosub AUTOMOVE 101
              goto ARRIVED
          }
if (("$zoneid" = "62") && ("$guild" = "Thief") && ($Athletics.Ranks >= %undergondola)) then 
          {
               put khri flight harrier
               pause
          }
if (("$zoneid" = "62") && ("$guild" = "Ranger") && ($Athletics.Ranks >= %undergondola)) then 
          {
               put prep athlet 10
               pause 8
               put cast
          }
if (("$zoneid" = "62") && ($Athletics.Ranks >= %undergondola)) then 
          {
             gosub AUTOMOVE 41
             pause
             if ("$game" = "DRF") then
                   {
                        gosub MOVE sw
                        gosub MOVE sw
                        gosub MOVE s
                        gosub AUTOMOVE 153
                        goto ILITHI_2
                   }
             if ("$game" = "DR") then
                   {
                        gosub MOVE sw
                        gosub MOVE sw
                        pause 0.2
                        put go blockade
                        pause 0.8
                        pause 0.1
                        gosub AUTOMOVE 153
                   }
          }
if (("$zoneid" = "62") && ("$game"= "DRF")) then
          {
              gosub AUTOMOVE 41
              gosub MOVE sw
              gosub MOVE sw
              gosub MOVE s
              pause 0.5
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
          }
if (("$zoneid" = "62") && ("$game" = "DR")) then
          {
              gosub AUTOMOVE 41
              gosub MOVE sw
              gosub MOVE sw
              pause 0.1
              put go blockade
              pause 0.8
              pause 0.1
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
          }
ILITHI_2:
if (("$zoneid" = "69") && matchre("(horse|spire|wyvern)","%detour")) then
          {
              if ("%detour" = "horse") then gosub AUTOMOVE 199
              if ("%detour" = "spire") then gosub AUTOMOVE 334
              if ("%detour" = "wyvern") then gosub AUTOMOVE 15
              goto ARRIVED
          }
if ("$zoneid" = "65") then gosub AUTOMOVE 1
if (("$zoneid" = "66") && ("%detour" = "garg")) then
          {
              gosub AUTOMOVE 167
              goto ARRIVED
          }
#if (("$zoneid" = "69") && ("%shardcitizen" = "yes")) then gosub AUTOMOVE 31
if ("$zoneid" = "69") then gosub AUTOMOVE 1
if ("$zoneid" = "68a") then gosub AUTOMOVE 29
if (("$zoneid" = "68") && matchre("(adan'f|corik)","%detour")) then
          {
              if ("%detour" = "corik") then gosub AUTOMOVE 114
              if ("%detour" = "adan'f") then gosub AUTOMOVE 29
              goto ARRIVED
          }
if (("$zoneid" = "68") && ("$guild" = "Thief")) then gosub AUTOMOVE 225
if ("$zoneid" = "67a") then gosub AUTOMOVE shard
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)yes")) then gosub AUTOMOVE 1
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)no")) then gosub AUTOMOVE 15
if (("$zoneid" = "67") && matchre("alfren","%detour")) then 
          {
              goto CROSSING
          }
if (("$zoneid" = "67") && ("$guild" = "Thief") && matchre("(steel|ylono|fayrin|horse|spire|wyvern)","%detour")) then
          {
              gosub AUTOMOVE 566
              gosub AUTOMOVE 23
          }
if (("$zoneid" = "67") && ("$guild" = "Thief") && matchre("(adan'f|corik)","%detour")) then
          {
              gosub AUTOMOVE 228
              pause
              send climb embrasure
              wait
              if ("%detour" = "adan'f") then gosub AUTOMOVE 29
              if ("%detour" = "corik") then gosub AUTOMOVE 114
          }
if (("$zoneid" = "67") && matchre("(steel|ylono|fayrin|horse|spire|wyvern|corik|adan'f)","%detour")) then gosub AUTOMOVE 132
if (("$zoneid" = "66") && matchre("(steel|fayrin|ylono|corik|adan'f)","%detour")) then
          {
              if ("%detour" = "steel") then gosub AUTOMOVE 99
              if ("%detour" = "fayrin") then gosub AUTOMOVE 127
              if ("%detour" = "ylono") then gosub AUTOMOVE 495
              if matchre("(corik|adan'f)","%detour") then
                  {
                      if ("$guild" = "Thief") then
                          {
                              gosub AUTOMOVE 66
                              put go trail
                              pause 0.5
                              gosub MOVE south
                              gosub MOVE south
                              pause 0.2
                              gosub MOVE shard
                              gosub AUTOMOVE 228
                              pause
                              send climb embrasure
                              wait
                          }
                      if (!matchre("%shardcitizen", "(?i)yes") && ("$zoneid" = 66)) then
                          {
                              gosub AUTOMOVE 216
                              gosub AUTOMOVE 230
                          }
                      if (matchre("%shardcitizen", "(?i)yes") && ("$zoneid" = 66) && ($roomid > 54)) then
                          {
                              gosub AUTOMOVE 215
                              gosub AUTOMOVE 230
                          }
                      if ("$zoneid" = "66") then gosub AUTOMOVE 3
                      if ("%detour" = "adan'f") then gosub AUTOMOVE 29
                      if ("%detour" = "corik") then gosub AUTOMOVE 114
                  }
              goto ARRIVED
          }
if (("$zoneid" = "66") && matchre("(horse|spire|wyvern)","%detour")) then
          {
              gosub AUTOMOVE 217
              if ("%detour" = "horse") then gosub AUTOMOVE 199
              if ("%detour" = "spire") then gosub AUTOMOVE 334
              if ("%detour" = "wyvern") then gosub AUTOMOVE 15
          }
if (("$zoneid" = "66") && ("$guild" = "Thief")) then
          {
               gosub AUTOMOVE 66
               gosub MOVE go trail
               pause 0.2
               gosub MOVE south
               gosub MOVE south
               pause 0.2
               gosub AUTOMOVE shard
          }
if ("$zoneid" = "66a") then gosub AUTOMOVE shard
if (matchre("%shardcitizen", "(?i)yes") && ("$zoneid" = 66) && ($roomid > 54)) then gosub AUTOMOVE 215
if ("$zoneid" = "66") then gosub AUTOMOVE 216
if ("$zoneid" = "67") then gosub AUTOMOVE 81
if (("$zoneid" = "67") && matchre("gondola","%detour")) then 
          {
              gosub AUTOMOVE north
              gosub AUTOMOVE platform
              goto ARRIVED
          }
if matchre("aesry","%detour") then
          {
              if matchre("$game", "DRF") then goto AESRY_LONG
              gosub AUTOMOVE 734
              gosub JOINLOGIC
              gosub AUTOMOVE 113
          }
goto ARRIVED
THERENGIA:
var label THERENGIA
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "42") && ("%detour" = "rakash")) then gosub AUTOMOVE lang
if ("$zoneid" = "2a") then gosub AUTOMOVE cross
if ("$zoneid" = "6")  then gosub AUTOMOVE cross
if ("$zoneid" = "67a") then gosub AUTOMOVE shard
if (matchre("%destination", "(ratha|hara?j?a?a?l?)") && matchre("$zoneid", "\b(1|30|42|47|61|66|67|90|99|107|108|116)\b")) then
     {
          if (("$game" = "DRX") && (%portal = 1)) then
          {
               if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
          }
     if (("$game" = "DRF") && matchre("%destination", "\brath?a?") || (%premium = 1) && matchre("%destination", "\brath?a?")) then
               {
                    echo *** GOING TO FC
                    gosub TO_SEACAVE
                    gosub AUTOMOVE 2
                    var toratha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
      if (("$game" = "DRF") && matchre("%destination", "\b(haraj?a?a?l?)")) then
          {
               echo ** TO FANG COVE
               gosub TO_SEACAVE
               gosub AUTOMOVE 3
               gosub JOINLOGIC
               goto ARRIVED
          }
    }
if matchre("$zonename", "(Hara'jaal|Mer'Kresh|M'Riss)") then
          {
              var backuplabel THERENGIA
              var backupdetour %detour
              var detour mriss
              var tomainland 1
              goto QITRAVEL
          }
if matchre("$zoneid", "106|107|108") then goto QITRAVEL
#debug 10
if (("$zoneid" = "150") && ("$game" = "DRF") && ("%detour" = "hara")) then
          {
              gosub AUTOMOVE 3
              gosub FERRYLOGIC
              pause
          }
if (("$zoneid" = "35") && ("%detour" != "throne")) then 
          {
              if (%lirums < 240) then goto NOCOIN
              gosub AUTOMOVE 166
              gosub FERRYLOGIC
              pause
          }
if ("$zoneid" = "127") then gosub AUTOMOVE 510
if ("$zoneid" = "126") then gosub AUTOMOVE 49
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "116") then gosub AUTOMOVE 3
if ("$zoneid" = "114") then
          {
              if (%dokoras < 140) then goto NOCOIN
              gosub AUTOMOVE 1
              gosub FERRYLOGIC
              put go oak doors
              waitforre ^Obvious
          }
if (("$zoneid" = "113") && ("$roomid" = "1")) then gosub AUTOMOVE 5
if ("$zoneid" = "123") then gosub AUTOMOVE 175
if ("$zoneid" = "69") then gosub AUTOMOVE 1
if ("$zoneid" = "68a") then gosub AUTOMOVE 29
if ("$zoneid" = "68b") then gosub AUTOMOVE 44
if (("$zoneid" = "68") && ("$guild" = "Thief")) then gosub AUTOMOVE 15
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)yes")) then
          {
              gosub AUTOMOVE 1
              gosub AUTOMOVE 135
          }
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)no")) then gosub AUTOMOVE 15
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "67") && ("$guild" = "Thief")) then
          {
              gosub AUTOMOVE 566
              pause 0.5
              gosub AUTOMOVE 23
          }
if ("$zoneid" = "67a") then gosub AUTOMOVE STR
if ("$zoneid" = "67") then gosub AUTOMOVE 132
if (matchre("%destination", "\b(ratha|hara?j?a?a?l?)") && matchre("$zoneid", "\b(1|30|42|47|61|66|67|90|99|107|108|116)\b")) then
     {
          if (("$game" = "DRX") && (%portal = 1)) then
          {
               if ("$zoneid" = "66") then gosub AUTOMOVE east
               if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
          }
     if (("$game" = "DRF") && matchre("%destination", "\brath?a?") || (%premium = 1) && matchre("%destination", "\brath?a?")) then
               {
                    echo *** GOING TO FC
                    gosub TO_SEACAVE
                    gosub AUTOMOVE 2
                    var toratha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
      if (("$game" = "DRF") && matchre("%destination", "\b(haraj?a?a?l?)")) then
          {
               echo ** TO FANG COVE
               gosub TO_SEACAVE
               gosub AUTOMOVE 3
               gosub JOINLOGIC
               goto ARRIVED
          }
    }
if (("$zoneid" = "66") && matchre("gondola","%detour")) then 
          {
              gosub AUTOMOVE platform
              goto ARRIVED
          }  
if (("$zoneid" = "66") && ("$guild" = "Thief") && ($Athletics.Ranks >= %undergondola)) then 
          {
               put khri flight harrier
               pause
          }
if (("$zoneid" = "66") && ("$guild" = "Ranger") && ($Athletics.Ranks >= %undergondola)) then 
          {
               put prep athlet 10
               pause 8
               put cast
          }
if (("$zoneid" = "66") && ($Athletics.Ranks >= %undergondola)) then gosub AUTOMOVE 317
if (("$zoneid" = "66") && ($Athletics.Ranks < %undergondola)) then
          {
              gosub AUTOMOVE 156
              pause
              gosub FERRYLOGIC
          }
if ("$zoneid" = "65") then gosub AUTOMOVE 44
pause 0.1
if ("$zoneid" = "63") then gosub AUTOMOVE 112
if ("$zoneid" = "62") then gosub AUTOMOVE 100
if ("$zoneid" = "112") then gosub AUTOMOVE 112
if ("$zoneid" = "59") then gosub AUTOMOVE 12
if ("$zoneid" = "58") then gosub AUTOMOVE 2
if (("$zoneid" = "50") && ($Athletics.Ranks > %segoltha)) then gosub SEGOLTHA_NORTH
if ("$zoneid" = "50") then gosub SEGOLTHA_SOUTH
if ("$zoneid" = "61") then gosub AUTOMOVE 115
if (("$zoneid" = "50") && ($Athletics.Ranks < %segoltha)) then gosub AUTOMOVE STR
if (("$zoneid" = "60") && ("$guild" = "Thief")) then
          {
              if ($Athletics.Ranks >= %undersegoltha) then
                  {
                      gosub AUTOMOVE 107
                      gosub AUTOMOVE 6
                  }
          }
if (("$zoneid" = "60") && ($Athletics.Ranks >= %segoltha)) then gosub AUTOMOVE 108
if (("$zoneid" = "60") && ($Athletics.Ranks < %segoltha)) then
          {
              if %kronars < 100 then goto NOCOIN
              gosub AUTOMOVE 42
              pause
              gosub FERRYLOGIC
          }
if (("$zoneid" = "50") && ($Athletics.Ranks > %segoltha)) then gosub SEGOLTHA_NORTH
if ("$zoneid" = "13") then gosub AUTOMOVE 71
if ("$zoneid" = "4a") then gosub AUTOMOVE 15
if ("$zoneid" = "32") then gosub AUTOMOVE 1
if ("$zoneid" = "4") then gosub AUTOMOVE 14
if ("$zoneid" = "8") then gosub AUTOMOVE 43
if ("$zoneid" = "10") then gosub AUTOMOVE NTR
if ("$zoneid" = "9b") then gosub AUTOMOVE 9
if ("$zoneid" = "14b") then gosub AUTOMOVE 217
if ("$zoneid" = "11") then gosub AUTOMOVE 2
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "1") then gosub AUTOMOVE 171
if (("$zoneid" = "7") && ("%detour" = "muspari") && ("$game" != "DRF")) then
          {
              gosub AUTOMOVE 271
              gosub JOINLOGIC
              goto ARRIVED
          }
if (("$zoneid" = "7") && ("%detour" = "caravansary")) then
          {
              gosub AUTOMOVE caravan
              goto ARRIVED
          }
if (("$zoneid" = "7") && ($Athletics.Ranks >= %faldesu)) then gosub AUTOMOVE 197
if (("$zoneid" = "7") && ($Athletics.Ranks >= %faldesu)) then gosub AUTOMOVE 197
if (("$zoneid" = "7") && ($Athletics.Ranks < %faldesu)) then
          {
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 81
              gosub FERRYLOGIC
          }
if ("$zoneid" = "14c") then gosub FALDESU_NORTH
if ("$zoneid" = "33a") then gosub AUTOMOVE 46
if ("$zoneid" = "33") then gosub AUTOMOVE 1
if (("$zoneid" = "31") && ("%detour" = "zaulfung")) then gosub AUTOMOVE 100
if ("$zoneid" = "31") then gosub AUTOMOVE 1
if (("$zoneid" = "34a") && ("%detour" != "rossman")) then gosub AUTOMOVE forest
if (("$zoneid" = "34") && ("%detour" = "rossman")) then
          {
              if (%lirums < 70) then goto NOCOIN
              gosub AUTOMOVE 22
              goto ARRIVED
          }
if (("$zoneid" = "34") && matchre("%detour", "(lang|theren|rakash|muspari|fornsted|el'bain)")) then gosub AUTOMOVE 137
if (("$zoneid" = "34") && matchre("%detour", "(haven|zaulfung)")) then
          {
              if $Athletics.Ranks < %rossmansouth then gosub AUTOMOVE 137
              if $Athletics.Ranks >= %rossmansouth then
                  {
                      gosub AUTOMOVE 15
                      gosub AUTOMOVE 46
                      gosub AUTOMOVE 1
                  }
          }
if ("$zoneid" = "47") then 
          {
              gosub AUTOMOVE 117
              gosub FERRYLOGIC
          }
if ("$zoneid" = "41") then if matchre("%detour", "(muspari|fornsted)") then
          {
              if matchre("fornsted","%detour") then
                  {
                      gosub AUTOMOVE 91
                      goto ARRIVED
                  }
              if matchre("muspari","%detour") then
                  {
                      gosub AUTOMOVE 91
                      gosub PASSPORT
                      gosub AUTOMOVE 160
                      gosub FERRYLOGIC
                      gosub STOWING
                  }
          }
if (("$zoneid" = "41") && matchre("%detour", "(rossman|lang|theren|rakash|el'bain|haven|zaulfung)")) then 
          {
              gosub AUTOMOVE 53
              pause 0.5
              put east
              waitforre ^Just when it seems
              pause 0.5
              put #mapper reset
          }
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "47") && matchre("muspari","%detour")) then
          {
              gosub AUTOMOVE 235
              goto ARRIVED
          }
if ("$zoneid" = "47") then 
          {
              gosub AUTOMOVE 117
              gosub FERRYLOGIC
          }
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "30") && matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)")) then
          {
              if $Athletics.Ranks < %rossmannorth then
                  {
                      if (%lirums < 140) then goto NOCOIN
                      gosub AUTOMOVE 99
                      gosub FERRYLOGIC
                  }
              if $Athletics.Ranks >= %rossmannorth then
                  {
                      gosub AUTOMOVE 174
                      gosub AUTOMOVE 29
                      gosub AUTOMOVE 48
                      if ("%detour" = "rossman") then
                          {
                              gosub AUTOMOVE 22
                              goto ARRIVED
                          }
                      gosub AUTOMOVE 137
                  }
          }
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "116") then 
			{
			evalmath therencoin $circle*20
			if (%dokoras < %therencoin) then goto NOCOIN
			gosub AUTOMOVE 217
			}
if ("$zoneid" = "126") then 
			{
			evalmath therencoin $circle*20
			if (%dokoras < %therencoin) then 
				{
				gosub AUTOMOVE 49
				goto NOCOIN
				}
			gosub AUTOMOVE 103
			}
if ("$zoneid" = "127") then
			{
			evalmath therencoin $circle*20
			if (%dokoras < %therencoin) then 
				{
				gosub AUTOMOVE 510
				gosub AUTOMOVE 49
				goto NOCOIN
				}
			gosub AUTOMOVE 363
			gosub JOINLOGIC
			}
# if matchre("rakash", "(?i)%detour" then goto ARRIVED
if ("$zoneid" = "40a") then gosub AUTOMOVE 125
if "$zoneid" = "42" && "%detour" != "theren" then gosub AUTOMOVE 2
if (("$zoneid" = "40") && ("$game" = "DRX") && (%portal = 1) && !matchre("%detour", "(?i)(el'bain|lang|rakash)") && (%ported = 0)) then goto PORTAL_TIME
if (("$zoneid" = "40") && ("%detour" = "muspari")) then
          {
              gosub PASSPORT_CHECK
              if (%passport = 0) then gosub GET_PASSPORT
          }
if (("$zoneid" = "40") && ("%detour" = "rossman")) then
          {
              gosub AUTOMOVE 213
              gosub AUTOMOVE 22
              goto ARRIVED
          }
if (("$zoneid" = "40") && matchre("%detour", "(?i)(lang|rakash|el'bain|mriss|merk|hara)")) then
          {
              if ("%detour" = "el'bain") then
                  {
                      gosub AUTOMOVE 142
                      goto ARRIVED
                  }
              if ("%detour" = "lang") then
                  {
                      gosub AUTOMOVE 1
                      goto ARRIVED
                  }
              if ("%detour" = "rakash") then
                  {
                      gosub AUTOMOVE 263
                      gosub AUTOMOVE 96
                      goto ARRIVED
                  }
              if matchre("%detour", "(mriss|merk|hara)") then
                  {
                      gosub AUTOMOVE 305
                      gosub JOINLOGIC
                      goto QITRAVEL
                  }
          }
if (("$zoneid" = "40") && matchre("(haven|zaulfung|throne)","%detour")) then
          {
              if ($Athletics.Ranks >= %rossmansouth) then
                  {
                      gosub AUTOMOVE 213
                      gosub AUTOMOVE 15
                      gosub AUTOMOVE 46
                      gosub AUTOMOVE 1
                  }
              if ($Athletics.Ranks < %rossmansouth) then
                  {
                      if (%lirums < 140) then goto NOCOIN
                      gosub AUTOMOVE 36
                      gosub FERRYLOGIC
                  }
          }
if (("$zoneid" = "40") && ("%detour" = "theren")) then gosub AUTOMOVE 211
if (("$zoneid" = "42") && ("%detour" = "theren")) then
          {
              gosub AUTOMOVE 56
              goto ARRIVED
          }
if (("$zoneid" = "40") && matchre("%detour", "(muspari|fornsted|hvaral)")) then
          {
              gosub AUTOMOVE 376
              pause 0.5
              put west
              waitforre ^Just when it seems
              pause
              put #mapper reset
          }
if (("$zoneid" = "41") && ("%detour" = "fornsted")) then 
          {
              gosub AUTOMOVE 91
              goto ARRIVED
          }
if (("$zoneid" = "41") && ("%detour" = "hvaral")) then 
          {
              gosub AUTOMOVE 91
              gosub PASSPORT
              gosub AUTOMOVE 145
              goto ARRIVED
          }
if (("$zoneid" = "41") && ("%detour" = "muspari")) then
          {
              gosub AUTOMOVE 91
              gosub PASSPORT
              gosub AUTOMOVE 160
              gosub FERRYLOGIC
          }
if (("$zoneid" = "41") && matchre("%detour", "(rossman|lang|theren|rakash|el'bain|haven|zaulfung)")) then 
          {
              gosub AUTOMOVE 53
              waitforre ^Just when
              pause
              put #mapper reset
          }
if (("$zoneid" = "30") && ("%detour" = "throne")) then
          {
              gosub AUTOMOVE throne city barge
              gosub FERRYLOGIC
              goto ARRIVED
          }
if (("$zoneid" = "30") && ("%detour" = "zaulfung")) then
          {
              gosub AUTOMOVE 203
              gosub AUTOMOVE 100
          }
if ("$zoneid" = "30") then
          {
              gosub AUTOMOVE 8
              goto ARRIVED
          }
gosub STOWING
goto ARRIVED
FORD:
var label FORD
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if matchre("$zoneid", "(Hara'jaal|Mer'Kresh|M'Riss)") then
          {
              var backuplabel FORD
              var backupdetour %detour
              var detour mriss
              var tomainland 1
              goto QITRAVEL
          }
if (("$zoneid" = "35") && ("%detour" != "throne")) then 
          {
              if (%lirums < 240) then goto NOCOIN
              gosub AUTOMOVE 166
              gosub FERRYLOGIC
              pause
          }  
if ("$zoneid" = "47") then 
          {
              if (("$game" = "DRX") && (%portal = 1) && (%ported = 0)) then goto PORTAL_TIME
              gosub AUTOMOVE 117
              gosub FERRYLOGIC
          }
if ("$zoneid" = "41") then 
          {
              gosub AUTOMOVE 53
              pause 0.5
              put east
              waitforre ^Just when it seems
              pause
              put #mapper reset
          }
if ("$zoneid" = "40a") then gosub AUTOMOVE 125
if ("$zoneid" = "42") then gosub AUTOMOVE 2
if (("$zoneid" = "40") && ("$game" = "DRX") && (%portal = 1) && (%ported = 0)) then goto PORTAL_TIME
if (("$zoneid" = "40") && ($Athletics.Ranks >= %rossmansouth)) then gosub AUTOMOVE 213
if (("$zoneid" = "40") && ($Athletics.Ranks < %rossmansouth)) then
          {
		    evalmath boarneeded $circle*20
              if (%lirums < %boarneeded) then goto NOCOIN
              gosub AUTOMOVE 263
          }
if ("$zoneid" = "40a") then 
			{
				evalmath boarneeded $circle*20
				if (%lirums < %boarneeded) then 
					{
					gosub AUTOMOVE 125
					goto NOCOIN
					}
				gosub AUTOMOVE 68
				gosub JOINLOGIC
				goto FORD_3
			}
if ("$zoneid" = "34a") then gosub AUTOMOVE 134
if ("$zoneid" = "34") then gosub AUTOMOVE 15
if ("$zoneid" = "33a") then gosub AUTOMOVE 46
if ("$zoneid" = "33") then gosub AUTOMOVE 1
if ("$zoneid" = "32") then gosub AUTOMOVE 1
if ("$zoneid" = "31") then gosub AUTOMOVE river 
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "30") && ($Athletics.Ranks < %faldesu)) then
          {
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 103
              pause
              gosub FERRYLOGIC
          }
if (("$zoneid" = "30") && ($Athletics.Ranks >= %faldesu)) then
          {
              ## TO FALDESU
              gosub AUTOMOVE 203
              gosub AUTOMOVE 79
          }
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "14c") then gosub FALDESU_SOUTH
if ("$zoneid" = "13") then gosub AUTOMOVE 71
if ("$zoneid" = "4a") then gosub AUTOMOVE 15
if ("$zoneid" = "4") then gosub AUTOMOVE 14
if ("$zoneid" = "8") then gosub AUTOMOVE 43
if ("$zoneid" = "10") then gosub AUTOMOVE NTR
if ("$zoneid" = "9b") then gosub AUTOMOVE 9
if ("$zoneid" = "14b") then gosub AUTOMOVE 217
if ("$zoneid" = "11") then gosub AUTOMOVE 2
if ("$zoneid" = "7") then gosub AUTOMOVE 349
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if ("$zoneid" = "1") then
          {
              if ("$guild" = "Thief") then
                  {
                      if ($Athletics.Ranks >= %undersegoltha) then
                          {
                              gosub AUTOMOVE 650
                              gosub AUTOMOVE 23
                          }
                  }
              if (($Athletics.Ranks >= %segoltha) && ("$zoneid" = "1")) then
                  {
                      gosub AUTOMOVE 476
                      gosub SEGOLTHA_SOUTH
                  }
              if ("$zoneid" = "1") then
                  {
                      if %kronars < 100 then goto NOCOIN
                      gosub AUTOMOVE 236
                      gosub FERRYLOGIC
                  }
              pause
              put south
              wait
              put #mapper reset
          }
if ("$zoneid" = "50") then gosub SEGOLTHA_SOUTH
if ("$zoneid" = "60") then gosub AUTOMOVE 57
if ("$zoneid" = "58") then gosub AUTOMOVE 2
if (("$zoneid" = "61") && ("%detour" = "ain")) then gosub AUTOMOVE 126
if (("$zoneid" = "114") && ("%detour" != "ain")) then
          {
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 4
              gosub FERRYLOGIC
              gosub MOVE west
          }
if (("$zoneid" = "63") && ($Athletics.Ranks < %undergondola)) then
          {
              gosub AUTOMOVE 112
              gosub AUTOMOVE 100
              gosub AUTOMOVE 126
          }
if (("$zoneid" = "112") && ("$guild" = "Ranger") && ($Athletics.Ranks >= %undergondola)) then 
          {
               put prep athlet 10
               pause 8
               put cast
          }
if (("$zoneid" = "112") && ("$guild" = "Thief") && ($Athletics.Ranks >= %undergondola)) then 
          {
               put khri flight harrier
               pause
          }
if (("$zoneid" = "112") && ("%detour" = "ain")) then
          {
              if ($Athletics.Ranks >= %undergondola) then
                  {
                      gosub AUTOMOVE 112
                      gosub AUTOMOVE 130
                  }
              if ($Athletics.Ranks < %undergondola) then
                  {
                      if (%dokoras < 120) then goto NOCOIN
                      gosub AUTOMOVE 98
                      gosub FERRYLOGIC
                  }
          }
if ("$zoneid" = "112") then gosub AUTOMOVE 112
if ("$zoneid" = "58") then gosub AUTOMOVE 2
if ("$zoneid" = "61") then gosub AUTOMOVE 130
if ("$zoneid" = "63") then gosub AUTOMOVE 112
if (("$zoneid" = "62") && ($Athletics.Ranks >= %undergondola)) then 
          {
             gosub AUTOMOVE 41
             pause
             if ("$game" = "DRF") then
                   {    
                        put sw
                        pause 0.5
                        put sw
                        pause 0.7
                        put s
                        pause 0.5
                        gosub AUTOMOVE 153
                        goto FORD_2
                   }
             if ("$game" = "DR") then
                   {
                        put sw
                        pause 0.5
                        put sw
                        pause 0.7
                        put go blockade
                        pause 0.8
                        pause 0.1
                        gosub AUTOMOVE 153
                        goto FORD_2
                   }
          }
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$game" = "DR") && ("$zoneid" = "62")) then
          {
              gosub AUTOMOVE 41
              put sw
              pause 0.5
              put sw
              pause 0.5
              put go blockade
              pause 0.8
              pause 0.1
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
          }
if (("$game" = "DRF") && ("$zoneid" = "62")) then
          {
              gosub AUTOMOVE 41
              put sw
              pause 0.5
              pause
              put sw
              pause 0.5
              put s
              pause 0.5
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
          }
FORD_2:
if ("$zoneid" = "65") then gosub AUTOMOVE 1
if ("$zoneid" = "68b") then gosub AUTOMOVE 44
if ("$zoneid" = "68a") then gosub AUTOMOVE 29
if (("$zoneid" = "68") && ("$guild" = "Thief")) then gosub AUTOMOVE 15
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)yes")) then
          {
              gosub AUTOMOVE 1
              gosub AUTOMOVE 129
          }
if (("$zoneid" = "68") && matchre("%shardcitizen", "(?i)no")) then gosub AUTOMOVE 15
if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
if (("$zoneid" = "67") && ("$guild" = "Thief")) then
          {
              gosub AUTOMOVE 566
              gosub AUTOMOVE 23
          }
if ("$zoneid" = "67a") then gosub AUTOMOVE STR
if ("$zoneid" = "67") then gosub AUTOMOVE 132
if ("$zoneid" = "66") then gosub AUTOMOVE 217
if ("$zoneid" = "69") then gosub AUTOMOVE 283
FORD_3:
if (("$zoneid" = "127") && matchre("%detour", "(raven|outer|inner|ain)")) then gosub AUTOMOVE 510
if (("$zoneid" = "126") && matchre("%detour", "(raven|outer|inner|ain)")) then gosub AUTOMOVE 49
if (("$zoneid" = "116") && matchre("%detour", "(raven|ain)")) then gosub AUTOMOVE 3
if (("$zoneid" = "123") && ("%detour" = "ain")) then
          {
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 174
              gosub FERRYLOGIC
          }
if (("$zoneid" = "123") && ("%detour" = "raven")) then
          {
              gosub AUTOMOVE 133
              goto ARRIVED
          }
if ("$zoneid" = "123") then gosub AUTOMOVE 169
if (("$zoneid" = "116") && ("%detour" = "outer")) then
          {
              gosub AUTOMOVE 225
              goto ARRIVED
          }
if (("$zoneid" = "116") && ("%detour" = "inner")) then
          {
              gosub AUTOMOVE 96
              goto ARRIVED
          }
if (("$zoneid" = "113") && ("$roomid" = "4")) then
          {
              gosub MOVE west
              waitforre ^Obvious
          }
if (("$zoneid" = "113") && ("$roomid" = "8")) then
          {
              gosub MOVE north
          }
if (("$zoneid" = "114") && ("%detour" = "ain")) then gosub AUTOMOVE 34
if ("$zoneid" = "116") then gosub AUTOMOVE 217
if ("$zoneid" = "126") then gosub AUTOMOVE 103
if ("$zoneid" = "127") then gosub AUTOMOVE 24
goto ARRIVED
  
AESRYBACK:
  pause 0.1
  pause 0.1
  var label AESRYBACK
  if ("$zoneid" = "98") then gosub AUTOMOVE 86
  if (("$game" = "DRX") && (%portal = 1) && (%ported = 0)) then goto PORTAL_TIME
  gosub AUTOMOVE 427
  gosub JOINLOGIC
  return
  
QITRAVEL:
  pause 0.1
  pause 0.1
  var label QITRAVEL
  if (("$game" = "DRX") && (%portal = 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|99|107|116)\b") && (%ported = 0)) then goto PORTAL_TIME
     }
  if !matchre("106|107|108","$zoneid") then goto therengia
  if (("$zoneid" = "108") && matchre("%detour", "(merk|hara)")) then 
            {
                gosub AUTOMOVE 151
                if ("$roomid" != "151") then gosub AUTOMOVE 151
                gosub FERRYLOGIC
            }
  if (("$zoneid" = "107") && ("%detour" = "hara")) then
            {
                gosub AUTOMOVE 78
                gosub FERRYLOGIC
                gosub AUTOMOVE 173
            }
  if (("$zoneid" = "106") && ("$game" = "DRF")) then
            {
                gosub AUTOMOVE 102
                gosub JOINLOGIC
                pause 
                put #mapper reset
                goto %label
            }
  if (("$zoneid" = "106") && matchre("%detour", "(merk|mriss)")) then
            {
                gosub AUTOMOVE 101
                gosub FERRYLOGIC
            }
  if (("$zoneid" = "107") && ("%detour" = "merk")) then
            {
                gosub AUTOMOVE 194
                goto ARRIVED
            }
  if (("$zoneid" = "107") && ("%detour" = "mriss")) then
            {
                gosub AUTOMOVE 113
                gosub FERRYLOGIC
            }
  if %tomainland then
            {
                gosub AUTOMOVE 222
                var tomainland 0
                var label %backuplabel
                var detour %backupdetour
                gosub JOINLOGIC
                pause
                put #mapper reset
                goto %label
            }
  if (("$zoneid" = "108") && ("%detour" = "mriss")) then
            {
                gosub AUTOMOVE 150
                goto ARRIVED
            }

#####################################################################################
## ENGINE
ARRIVED:
     if_2 then gosub AUTOMOVE %2 %3 %4
     echo
     echo      |\          .(' *) ' .
     echo      | \        ' .*) .'*
     echo      |(*\      .*(// .*) .
     echo      |___\       // (. '*
     echo      ((("'\     // '  * .
     echo      ((c'7')   /\)
     echo      ((((^))  /  \
     echo    .-')))(((-'   /
     echo       (((()) __/'
     echo        )))( |
     echo         (()
     echo          ))      
     echo
     ## "
  put #parse YOU ARRIVED!
  put #parse REACHED YOUR DESTINATION
  # put #play Just Arrived.wav
  echo ## WOW! YOU ARRIVED AT YOUR DESTINATION: %destination in %t seconds!  That's FAST! ##
  put #echo >Log Travel script arrival at: $zonename (map $zoneid: room $roomid)
  put #class arrive off
  exit
######################################################################################
SEGOLTHA_NORTH:
     pause 0.1
     if matchre("$roomid", "\b(24|25|26|27|28|29|31|42|43|44|45|46)\b") then gosub AUTOMOVE 23
     echo *** Swimming the Segoltha - Heading NORTH
     if matchre("$roomid", "\b(7|6|5)\b") then 
          {
               gosub MOVE east
               goto SEGOLTHA_NORTH
          }
    if matchre("$roomid", "\b(35|34|33|32)\b") then 
          {
               gosub AUTOMOVE 3
               return
          }
    if matchre("$roomid", "\b(5|4|3|2|1)\b") then 
          {
               gosub AUTOMOVE crossing
               return
          }
     if matchre("$roomid", "\b(7|6|5)\b") then 
          {
               gosub MOVE east
               goto SEGOLTHA_NORTH
          }
    if ($north) then gosub MOVE north
    goto SEGOLTHA_NORTH
SEGOLTHA_SOUTH:
     pause 0.1
     if ("$zoneid" = "1") then gosub AUTOMOVE segoltha
     echo *** Swimming the Segoltha - Heading SOUTH
     if matchre("$roomid", "\b(1|2|3|4|5|6)\b") then 
          {
               gosub AUTOMOVE 7
               goto SEGOLTHA_SOUTH
          }
    if (($roomid = 0) && ($south)) then
          {
               gosub MOVE south
               goto SEGOLTHA_SOUTH
          }
    if ($south) then gosub MOVE south
    if ((!$southwest) && (!$southeast) && (!$south)) then
          {
               gosub AUTOMOVE south
               return
          }
    goto SEGOLTHA_SOUTH
FALDESU_NORTH:
    echo *** Swimming the Faldesu - Heading NORTH 
    gosub MoveAllTheWay north
    if ($northwest) then
         {
             gosub MOVE northwest
             gosub MoveAllTheWay northeast
         }
    if ((!$northwest) && (!$northeast) && (!$north)) then
         {
              gosub Move climb stone bridge
              return
         }
    goto FALDESU_NORTH
FALDESU_SOUTH:
    echo *** Swimming the Faldesu - Heading SOUTH
    if ($south) then
         {
             gosub MOVE south
             pause 0.1
             goto FALDESU_SOUTH
         }
    if ($southwest) then
         {
             gosub Move southwest
             gosub MoveAllTheWay southeast
         }
    if ((!$southwest) && (!$southeast) && (!$south)) then
         {
              gosub Move climb stone bridge
              return
         }
    goto FALDESU_SOUTH
MoveAllTheWay:
    # Keeps moving in a direction until it is no longer a portal option
    var direction $1
MovingAllTheWay:
    if $%direction then gosub Move %direction
    pause .1
    if $%direction then goto MovingAllTheWay
    return
PASSPORTCHECK:
  pause 0.2
  put get my passport
  pause 2
  if !matchre("$righthand $lefthand", "passport") then var passport 0
  if matchre("$righthand $lefthand", "passport") then var passport 1
  put stow passport
  pause 0.4
  return
FERRYLOGIC:
  if contains("(1|7|30|35|60|40|41|47|113|106|107|108|150)","$zoneid" then goto FERRY
  if matchre ("$roomname","Aboard the Mammoth") then goto FERRY
  if matchre("$roomname", "Gondola") then
     {
         if matchre("%destination", "\b(acen?e?m?a?c?r?a?|cros?s?i?n?g?s?|xing?|knif?e?c?l?a?n?|tige?r?c?l?a?n?|dirg?e?|arth?e?d?a?l?e?|kaer?n?a?|ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa|leth?d?e?r?i?e?l?|acen?a?m?a?c?r?a?|vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?|malod?o?r?o?u?s?|bucc?a?|dokt?|sorr?o?w?s?|misens?e?o?r?|beis?s?w?u?r?m?s?|ston?e?c?l?a?n?|bone?w?o?l?f?|germ?i?s?h?d?i?n?|alfr?e?n?s?|cara?v?a?n?s?a?r?y?|rive?r?h?a?v?e?n?|have?n?|ross?m?a?n?s?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|el\'?b?a?i?n?s?|elb?a?i?n?s?|raka?s?h?|thro?n?e?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|zaul?f?u?n?g?|mri?s?s?|merk?r?e?s?h?|kre?s?h?|har?a?j?a?a?l?|rath?a?)\b") then
          {
               echo *** ON GONDOLA! - HEADING NORTH
               var direction north
               goto ONGONDOLA
          }
         if matchre("%destination", "\b(shar?d?|grani?t?e?|garg?o?y?l?e?|spir?e?|horse?c?l?a?n?|fayr?i?n?s?|steel?c?l?a?w?|cori?k?s?|ada?n?f?|ylo?n?o?|wyve?r?n?|aing?h?a?z?a?l?|rave?n?s?|hib?a?r?n?h?v?i?d?a?r?|out?e?r?|inne?r?|boar?c?l?a?n?|aes?r?y?|sur?l?a?e?n?i?s?|fan?g?|cov?e?)\b") then
          {
               echo *** ON GONDOLA! - HEADING SOUTH
               var direction south
               goto ONGONDOLA
          }
        if matchre("%destination", "\bgondola?\b") then goto ARRIVED
     }
  if ("$zoneid" = "66") then
        {
            var direction north
            goto GONDOLA
        }
  if ("$zoneid" = "62") then
        {
            var direction south
            goto GONDOLA
        }
  else goto NODESTINATION
GONDOLA:
  pause 0.1
  pause 0.1
  send look
  pause 2
  matchre ONGONDOLA \[Gondola\,
  if matchre ("$roomobjs","gondola") then send go gondola
  matchwait 2
  pause 7
  goto GONDOLA
ONGONDOLA:
  pause
  pause
  if ("%direction" = "north") && ($north = 1) then gosub MOVE north
  if ("%direction" = "south") && ($south = 1) then gosub MOVE south
GONDOLAWAIT:
  pause
  if ($out) then goto GONDOLAOUT
  waitforre ^With a soft
  if ($standing = 0) then gosub STAND
GONDOLAOUT:
  put look
  pause 0.8
  if ($out = 0) then goto GONDOLAWAIT
  gosub MOVE out
  pause
  put #mapper reset
  return
STOP_INVIS:
     delay 0.001
     if ("$guild" = "Necromancer") then
          {
               put release eotb
               pause 0.3
          }
     if ("$guild" = "Thief") then
          {
               put khri stop silence vanish
               pause 0.3
          }
     if ("$guild" = "Moon Mage") then
          {
               put release rf
               pause 0.3
          }
     pause 0.3
FERRY:
  pause 0.1
  if ($invisible) then goto STOP_INVIS
  pause 0.1
  matchre ONFERRY \[\"Her Opulence\"\]|\[\"Hodierna\'s Grace\"\]|\[\"Kertigen\'s Honor\"\]|\[\"His Daring Exploit\"\]|\[\"Northern Pride\"\, Main Deck\]|\[\"Theren\'s Star\"\, Deck\]|\[The Evening Star\]|\[The Damaris\' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"The Desert Wind\"\]|\[\"The Suncatcher\"\]|\[\"The Riverhawk\"\]|\[\"Imperial Glory\"\]\"Hodierna\'s Grace\"|\"Her Opulence\"\]|\[The Galley Cercorim\]|\[The Jolas\, Fore Deck\]|\[Aboard the Warship\, Gondola\]|\[The Halasa Selhin\, Main Deck\]|\[Aboard the Mammoth\, Platform\]
  matchre ONFERRY Secured to the gigantic balloon overhead\, the armored ironwood gondola dangles on a convoluted network of hempen rope\.
  matchre ONFERRY ^One of the barge\'s crew members stops you and requests a transportation fee|A row of benches occupies the deck
  matchre ONFERRY Long\, wide and low\, this vessel is built for utility\, but the hand of luxury can be discerned in the ornately carved walnut railings\, down-cushioned benches and the well polished deck
  matchre ONFERRY ^A few weary travelers lean against a railing at the bow of this ferry\, anxiously waiting to reach the opposite bank\.
  matchre ONFERRY ^The ferry rocks gently as you step aboard\. Surrounded by the cool\, briny air of the Segoltha\, you take your place on the deserted deck and gaze up into the night sky\.
  matchre ONFERRY ^Most of the passengers on this low riding barge have descended into quiet conversation\, not wishing to stir the night\. A single lantern, swinging from the fore rail\, pushes its dull gold rays across the dark water\. 
  matchre ONFERRY ^This is the only barge of its type to ply the waters of Lake Gwenalion|^A white-washed wood railing surrounds the entire upper deck of the barge
  matchre ONFERRY ^The first of the massive barges to traverse Lake Gwenalion\, \"Theren\'s Star\" still maintains a quiet elegance despite its apparent age\.
  matchre ONFERRY ^Long and low\, the sleek lines of the ferry are designed so that it slips through the water with a minimum of disturbance\.
  matchre ONFERRY ^This particular skiff is roomy and solid with benches only slightly worn from use
  matchre ONFERRY ^The newly crafted skiff smells of fresh wood and paint\.
  matchre ONFERRY ^The warship (continues|rumbles)|^The din of battle abates as the Gnomish crew|^Sputtering loudly\, the cast\-iron stove
  matchre ONFERRY ^The resounding boom of a nearby cannon|^A flaming arrow narrowly misses the balloon|^Your ears are left ringing as the crew begins to fire the cannons|^Fang's Peak sinks below the southern horizon
  matchre ONFERRY ^The Desert Wind barge is made up of a wooden flatboat mounted atop steel rails
  matchre ONFERRY ^The deck of the wooden barge is mostly covered with tightly packed crates and barrels\, all tied down so as not to tumble about or fall overboard during the sometimes turbulent river journeys\.
  matchre ONFERRY ^A row of water-stained benches occupies the deck of the Imperial Glory\, where wealthy passengers can sit at ease and view the beautiful landscape\, rolling forests and a few sandy beaches\, of southern Therengia\.
  matchre ONFERRY ^The light bowl-shaped boat has a blue leather hide stretched tightly over its birch sapling frame
  matchre ONFERRY ^Flecks of foam spray through the air when the Jolas cuts through the waves\.
  matchre ONFERRY ^The deck is split down the middle by an open pit\, bracketed on each end by the two masts\.
  matchre ONFERRY ^Walking in this tiny area is difficult due to the litter of ropes\, some coiled and some stretching from the railings and belaying pins up into the maze of wood and canvas above\.
  matchre ONFERRY ^In anticipation of the sudden influx of passengers\, makeshift benches have been hastily constructed from kegs\, driftwood\, and nets stretched tight between boards\, then have been cleverly placed so that they are as out of the way as possible\.
  matchre ONFERRY ^Passengers and cargo crowd the deck of the sleek\, black galley\.
  matchre ONFERRY ^The light bowl-shaped boat has a new leathery hide stretched tightly over its birch sapling frame\.
  matchre ONFERRY ^The galley\, like its twin\, carries passengers and cargo\, but it can easily become a war galley\.
  matchre ONFERRY ^The bowsprit attached to the jib boom on the bow is rigged to hold three triangular foresails in front of the foremast\.
  matchre ONFERRY ^The length of this ferry is filled to capacity with travelers making their way to the opposite bank of the Segoltha
  matchre ONFERRY ^A few weary travelers lean against a railing at the bow of this ferry
  matchre ONFERRY ^Passengers and cargo crowd the deck of the sleek\, black galley\.|^The galley\, like its twin\, carries passengers and cargo\,|^Grease spewed from the galley
  matchre ONFERRY ^The Selhin ties off to the Uaro Dock\!
  matchre STOP_INVIS ^How do you expect the barge crew to let you onboard if they can't see you\?
  send look
  pause 0.5
  pause 0.2
  if matchre ("$roomobjs","Gnomish warship") then send join warship
  if matchre ("$roomobjs","Riverhawk") then send go riverhawk
  if matchre ("$roomobjs","Imperial") then send go imperial glory
  if matchre ("$roomobjs","Star") then send go ferry
  if matchre ("$roomobjs","skiff") then send go skiff
  if matchre ("$roomobjs","Kiss") then send go ferry
  if matchre ("$roomobjs","ferry") then send go ferry
  if matchre ("$roomobjs","barge") then send go barge
  if matchre ("$roomobjs","galley") then send go galley
  if matchre ("$roomobjs","Jolas") then send go jolas
  if matchre ("$roomobjs","Selhin") then send go selhin
  if matchre ("$roomobjs","warship") then send join warship
  matchwait 5
  if matchre ("$roomname","Aboard the Mammoth") then goto ONFERRY
  if matchre ("$roomname","Imperial") then goto ONFERRY
  if matchre ("$roomname","Kertigen") then goto ONFERRY
  if matchre ("$roomname","Hodierna") then goto ONFERRY
  if matchre ("$roomname","Opulence") then goto ONFERRY
  if matchre ("$roomname","Daring") then goto ONFERRY
  if matchre ("$roomname","Northern Pride") then goto ONFERRY
  if matchre ("$roomname","Theren\'s Star") then goto ONFERRY
  if matchre ("$roomname","Damaris") then goto ONFERRY
  if matchre ("$roomname","Evening Star") then goto ONFERRY
  if matchre ("$roomname","Birch Skiff") then goto ONFERRY
  if matchre ("$roomname","Polished Skiff") then goto ONFERRY
  if matchre ("$roomname","Desert Wind") then goto ONFERRY
  if matchre ("$roomname","Suncatcher") then goto ONFERRY
  if matchre ("$roomname","Riverhawk") then goto ONFERRY
  if matchre ("$roomname","Imperial Glory") then goto ONFERRY
  if matchre ("$roomname","Galley Cercorim") then goto ONFERRY
  if matchre ("$roomname","Jolas") then goto ONFERRY
  if matchre ("$roomname","Aboard the Warship") then goto ONFERRY
  if matchre ("$roomname","Halasa Selhin") then goto ONFERRY
  if ($hidden = 0) then put hide
  pause 10
  echo ### Waiting for a transport..
  goto FERRY
ONFERRY:
  pause 0.1
  pause 0.1
  echo
  echo ### Riding on public transport. Final Destination: %destination
  echo
  send hide
  pause
  if matchre("$roomobjs","the beach") && matchre("%destination", "\bratha?") then goto OFFTHERIDE
  if matchre("$roomobjs","a ladder") && !matchre("%destination", "\bratha?") then goto OFFTHERIDE
  if ("$guild" = "Necromancer") then
     {
          if (($spellROC = 0) || ($spellEOTB = 0)) then gosub NECRO_PREP
     }
  if matchre ("$roomname","(Jolas|Selhin)") then goto shiploop
  matchre OFFTHERIDE dock and its crew ties the (ferry|barge) off\.|^You come to a very soft stop|^The skiff lightly taps|^The sand barge pulls into dock|^The barge pulls into dock|The crew ties it off and runs out the gangplank\.
  matchre OFFTHERIDE ^The warship lands with a creaky lurch|^The captain barks the order to tie off .+ to the docks\.|returning to Fang Cove|returning to Ratha
  matchwait
  
SHIPLOOP:
  pause 0.1
  pause 0.1
  matchre OFFTHERIDE ^The captain barks the order to tie off the Selhin to the docks\.
  matchre OFFTHERIDE ^The captain barks the order to tie off the Jolas to the docks\.
  matchwait 180
  put fatigue
  goto SHIPLOOP
  
OFFTHERIDE:
  put look
  pause 0.5
  if ($hidden = 1) then 
     {
          put unhide
          pause 0.4
     }
  if ("$guild" = "Necromancer") then
     {
          if (($spellROC = 0) || ($spellEOTB = 0)) then gosub NECRO_PREP
     }
  pause 0.1
  pause 0.1
  if matchre ("$roomname","Jolas") then
    {
        pause 0.1
        if matchre ("$roomobjs","Sumilo") then put go dock
        if matchre ("$roomobjs","Wharf") then put go end
        pause
        put #mapper reset
        return
    }
  if ($standing = 0) then gosub STAND
  put go %offtransport
  pause
  put #mapper reset
  return
  
JOINLOGIC:
  pause 0.1
  pause 0.1
  matchre ONJOINED ^\[Aboard the Dirigible\, Gondola\]|^\[Alongside a Wizened Ranger\]|^An intricate network of silken rope|^\[Aboard the Balloon\, Gondola\]|^A veritable spiderweb of ropes secures|^Thick\, barnacle\-encrusted ropes secure the platform to the|\[Aboard the Mammoth\, Platform\]|\[The Bardess\' Fete\, Deck\]|^Silken rigging suspends the sweeping teak|\[Aboard the Warship\, Gondola\]
  put look
  wait
  pause
  if matchre("$roomobjs","warship") then send join warship
  if matchre("$roomobjs","airship") then put join airship
  pause 0.2
  if matchre("$roomobjs","dirigible") then put join dirigible;join dirigible
  if matchre("$roomobjs","balloon") then put join balloon;join balloon
  pause 0.2
  if matchre("$roomobjs","wizened ranger") then put join wizened ranger;join wizened ranger
  if (("$zoneid" = "58") && matchre("$roomobjs","tall sea mammoth")) then put join tall mammoth
  if (("$zoneid" = "90") && matchre("$roomobjs","massive sea mammoth")) then put join sea mammoth
  if ("$zoneid" = "150") then
        {
            if ("%detour" = "fang") then goto ARRIVED
            if %toratha = 1 && matchre ("$roomobjs","massive sea mammoth") then put join sea mammoth
            if %toratha = 0 && matchre ("$roomobjs","tall sea mammoth") then put join tall mammoth
            if "%detour" = "hara" && matchre ("$roomobjs","warship") then put join warship
        }
  matchwait 5
  echo ### Waiting for a transport..
  pause 20
  goto joinlogic
  
ONJOINED:
  pause 0.1
  pause 0.1
  matchre OFFJOINED ^The grasses of this wide clearing|^From its northwest\-facing position|^A deep firepit has been hacked into the frozen earth|^The distance between the surrounding hills is narrower|^The ironwood platform has withstood|^A rickety platform in the top of this huge\,|^Beyond the harbor\, spray is thrown|^Giant boulders are scattered|^Crudely assembled yet sturdy just the|\[Fang Cove\, Dock\]|\[Smuggler\'s Wharf\]|\[Outside Muspar\'i\]|\[Northeast Wilds\, Grimsage Way\]|^The once pristine tower of the Warrior Mages|returning to Fang Cove|returning to Ratha
  matchwait
OFFJOINED:
  put look
  wait
  if matchre("$roomname", "Rocky Path") then put go beach
  pause
  put #mapper reset
  return
 
PASSPORT_CHECK: 
  pause 0.3
  matchre YES_PASSPORT ^You tap
  matchre NO_PASSPORT ^What were you|^I could not
  send tap my passport
  matchwait 5
NO_PASSPORT:
  var passport 0
  return
YES_PASSPORT:
  var passport 1
  return
  
GET_PASSPORT:
    echo ===============
    echo ** NO PASSPORT FOUND
    echo ** GOING TO GET ONE
    echo ===============
    if ("$zoneid" = "40") then gosub AUTOMOVE theren
    pause 0.2
    gosub AUTOMOVE passport
    pause 0.5
    pause 0.2
    put ask lic for passport
    pause 0.5
    put ask lic for passport
    pause 0.5
    gosub STOWING
    gosub AUTOMOVE gate
    return
    
PASSPORT:
  gosub STOWING
  pause 0.3
  matchre RETURN ^You get|^You are already
  matchre NOPASSPORT ^What were you|^I could not
  send get my passport
  matchwait 5

NOPASSPORT:
  echo ### You don't have a Muspari Passport! Go back to Therenborough to get one.
  goto ARRIVED
  
NOCOIN:
  put #parse NO COINS!
  Echo ### You don't have enough coins to travel, you vagrant!  Trying to get coins from the nearest bank!!!
  pause 0.5
  put wealth
  pause
  if ("$zoneid" = "1") then
        {
            var currencyneeded kro
            if (%kronars < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub KRONARS
               }
            if (%kronars >= 120) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 120 copper
            wait
        }
  if ("$zoneid" = "60") then gosub AUTOMOVE leth
  if ("$zoneid" = "61") then
        {
            var currencyneeded kro
            gosub AUTOMOVE 57
            if (%kronars < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub KRONARS
               }
            if (%kronars >= 120) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 120 copper
            wait
        }
   if ("$zoneid" = "30") then
        {
            var currencyneeded lir
            if (%lirums < 140) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            if (%lirums >= 140) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 140 copper
            wait
        }
   if ("$zoneid" = "7") then
        {
            var currencyneeded lir
            gosub AUTOMOVE 349
            if (%lirums < 200) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            if (%lirums >= 200) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 200 copper
            wait
            pause 0.2
            gosub AUTOMOVE exchange
            pause 0.2
            put exchange 200 copper kronar for lirum
            wait
            pause 0.2
        }
    if ("$zoneid" = "40") then
        {
            var currencyneeded lirtoboar
            gosub AUTOMOVE 211
            if (%lirums < %boarneeded) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            gosub AUTOMOVE teller
            if (%lirums >= %boarneeded) then goto COIN.CONTINUE
            if ($invisible = 1) then gosub stopinvis                                        
            if matchre ("%detour", "(mriss|merk|hara)") then 
                {
                    var currencyneeded qi
                    put withdraw 10 gold
                }
            else put withdraw %boarneeded copper
            wait
        }
    if (("$zoneid" = "113") && ("$roomid" = "4")) then gosub AUTOMOVE 10
    if (("$zoneid" = "113") && ("$roomid" = "9")) then gosub AUTOMOVE 8
    if ("$zoneid" = "114") then
        {
            var currencyneeded dok
            if (%dokoras < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > 120) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 120 copper
            wait
        }
    if (("$zoneid" = "113") && ("$roomid" = "6")) then gosub AUTOMOVE 7
    if ("$zoneid" = "123") then gosub AUTOMOVE hibar
    if (("$zoneid" = "116") && matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)")) then
        {
            var currencyneeded doktotheren
            if (%dokoras < %therencoin) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > %therencoin) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
		  put withdraw %therencoin copper
            wait
        }
	if (("$zoneid" = "116") && !matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)")) then
        {
            var currencyneeded dok
            if (%dokoras < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > 120) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 120 copper
            wait
        }
     if (("$zoneid" = "113") && ("$roomid" = "1")) then gosub AUTOMOVE 5
     if ("$zoneid" = "112") then
        {
            var currencyneeded dok
            if (%dokoras < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > 120) then goto COIN.CONTINUE
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 120 copper
            wait
        }
    if (("$zoneid" = "67") && ("%detour" = "aesry")) then
        {
            var currencyneeded aesry
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            if ("$game" = "DR") then put withdraw 10 gold
            if ("$game" = "DRF") then 
               {
                    var currencyneeded lir
                    put withdraw 5 silver
                    wait
                    gosub AUTOMOVE exchange
                    put exchange all dok to lirum
               }
            pause
        }
	if (("$zoneid" = "67") && !matchre("(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara|cross|river|haven|arthe|kaerna|stone|sorrow|throne|hvaral)","%detour")) then
        {
            var currencyneeded kro
            gosub AUTOMOVE exchange
            gosub DOKORAS
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 300 copper
            wait
            gosub AUTOMOVE exchange
            pause 0.3
            put exchang 50 copper dok to kro
            wait
            pause 0.5
            if matchre("(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara|river|haven|arthe|kaerna|stone|sorrow|throne|hvaral)","%detour") then put exchang 250 copper dok to lir
            pause 0.5
        }
    if ("$zoneid" = "99") then
        {
            var currencyneeded aesryback
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 10 gold
        }
    if ("$zoneid" = "107") then
        {
            var currencyneeded lir
            gosub AUTOMOVE teller
            if ($invisible = 1) then gosub stopinvis                                        
            put withdraw 140 copper
        }
    if ("$zoneid" = "108") then
        {
            ECHO ## YOU ARE ON MRISS WITH NO COINS!  YOU NEED TO FIND A FRIEND, OR KILL STUFF TO SELL HIDES OR GEMS!
            exit
        }
    put wealth
    waitforre Dokoras
    pause 0.5
    if (("%currencyneeded" = "kro") && (%kronars < 50)) then goto COINQUIT
    if (("%currencyneeded" = "lirtoboar") && (%lirums < %boarneeded)) then goto COINQUIT
    if (("%currencyneeded" = "lir") && (%lirums < 70)) then goto COINQUIT
    if (("%currencyneeded" = "dok") && (%dokoras < 60)) then goto COINQUIT
    if (("%currencyneeded" = "doktotheren") && (%dokoras < %therencoin)) then goto COINQUIT
    if (("%currencyneeded" = "aesry") && (%dokoras < 10000)) then goto COINQUIT
    if (("%currencyneeded" = "aesryback") && (%lirums < 10000)) then goto COINQUIT
    if (("%currencyneeded" = "qi") && (%lirums < 10000)) then goto COINQUIT
    put #echo >Log Green You withdrew some money to ride the ferry from Zone $zonename!
    ECHO YOU HAD MONEY IN THE BANK, LET'S TRY THIS AGAIN!
    pause
    goto %label
COIN.CONTINUE:
    put #echo >Log Green You exchanged some money to ride the ferry from Zone $zonename!
    ECHO YOU EXCHANGED SOME MONIES, LET'S TRY THIS AGAIN!
    pause
    goto %label     
COINQUIT:
    echo YOU DIDN'T HAVE ENOUGH MONEY IN THE BANK TO RIDE PUBLIC TRANSPORT.
    echo EITHER GET MORE ATHLETICS, OR MORE MONEY, FKING NOOB!
    put #echo >Log Red Travel Script Aborted! No money in bank to ride ferry in $zonename!
    put #parse OUT OF MONEY!
    exit
LIRUMS:
     var Target.Currency LIRUMS
     if ("%kronars" != "0") then gosub EXCHANGE KRONARS
     if ("%dokoras" != "0") then gosub EXCHANGE DOKORAS
     goto EXCHANGE.FINISH
KRONARS:
     var Target.Currency KRONARS
     if ("%lirums" != "0" then gosub EXCHANGE LIRUMS
     if ("%dokoras" != "0" then gosub EXCHANGE DOKORAS
     goto EXCHANGE.FINISH
DOKORAS:
     var Target.Currency DOKORAS
     if ("%kronars" != "0" then gosub EXCHANGE KRONARS
     if ("%lirums" != "0" then gosub EXCHANGE LIRUMS
     goto EXCHANGE.FINISH
EXCHANGE:
     var Coin $0
EXCHANGE.CONTINUE:
     pause 0.1
     matchre EXCHANGE.CONTINUE ^\.\.\.wait\s+\d+\s+sec(?:onds?|s)?\.?|^Sorry\,
     matchre EXCHANGE.FINISH ^You hand your money to the money-changer\.\s*After collecting a.* fee, .* hands you .*\.
     matchre EXCHANGE.FINISH Enjoy the holiday, friend\!
     matchre EXCHANGE.FINISH ^The money-changer says crossly, \"A transaction that small isn't worth my time\.\s*The minimum is one bronze or ten coppers\.\"
     matchre EXCHANGE.FINISH ^You count out all of your .* and drop them in the proper jar\.\s*After figuring a .* fee in the ledger beside the jar\, you reach into the one filled with .* and withdraw .*\.
     matchre EXCHANGE.FINISH ^One of the guards mutters\, \"None of that\, $charactername\.\s*You'd be lucky to get anything at all with an exchange that small\.\"
     matchre EXCHANGE.FINISH ^But you don't have any .*\.
     matchre EXCH.INVIS ^How can you exchange money when you can't be seen\?
     matchre EXCHANGE.SMALLER transactions larger than a thousand
     matchre EXCHANGE.FINISH ^There is no money-changer here\.
     put EXCHANGE ALL %Coin FOR %Target.Currency
     matchwait
EXCHANGE.SMALLER:
     pause 0.1
     pause 0.1
     matchre EXCHANGE.SMALLER ^\.\.\.wait\s+\d+\s+sec(?:onds?|s)?\.?|^Sorry\,
     matchre EXCHANGE.SMALLER ^You hand your .* to the money-changer\.\s*After collecting a.* fee, .* hands you .*\.
     matchre RETURN ^The money-changer says crossly, \"A transaction that small isn't worth my time\.\s*The minimum is one bronze or ten coppers\.\"
     matchre RETURN ^One of the guards mutters\, \"None of that\, $charactername\.\s*You'd be lucky to get anything at all with an exchange that small\.\"
     matchre EXCH.INVIS ^How can you exchange money when you can't be seen\?
     matchre EXCHANGE.CONTINUE Enjoy the holiday, friend\!
     matchre EXCHANGE.CONTINUE ^You count out all of your .* and drop them in the proper jar\.\s*After figuring a .* fee in the ledger beside the jar\, you reach into the one filled with .* and withdraw .*\.
     matchre EXCHANGE.CONTINUE ^But you don't have any .*\.
     matchre EXCHANGE.CONTINUE ^You don't have that many
     matchre EXCHANGE.FINISH ^There is no money-changer here\.
     put EXCHANGE 1000 plat %Coin FOR %Target.Currency
     matchwait
EXCHANGE.FINISH:
     pause 0.001
     put wealth
     pause 0.5
     RETURN
EXCH.INVIS:
     pause 0.1
     send hum scale
     pause 0.5
     send stop hum
     pause 0.1
     goto EXCHANGE.CONTINUE
     
TO_SEACAVE:
TO_SEACAVES:
     if ("$zoneid" = "67") then gosub AUTOMOVE east
     if ("$zoneid" = "127") then gosub AUTOMOVE south
     if ("$zoneid" = "124") then gosub AUTOMOVE hib
     if ("$zoneid" = "112") then gosub AUTOMOVE leth
     if ("$zoneid" = "4") then gosub AUTOMOVE cross
     if ("$zoneid" = "7") then gosub AUTOMOVE cross
     if ("$zoneid" = "67") then gosub AUTOMOVE east
     if ("$zoneid" = "42") then gosub AUTOMOVE gate
     pause 0.1
     gosub AUTOMOVE portal
     pause 0.5
     if ($invisible = 1) then gosub STOP.INVIS
     if ($invisible = 1) then gosub STOP.INVIS
     pause 0.2
     send go meeting portal
     pause 0.5
     pause 0.2
     return
     
STOP.INVIS:
     delay 0.001
     echo *** Removing Invis..
     if ("$guild" = "Necromancer") then
          {
               gosub PUT release eotb
               pause 0.3
          }
     if ("$guild" = "Thief") then
          {
               gosub PUT khri stop silence vanish
               pause 0.3
          }
     if ("$guild" = "Moon Mage") then
          {
               gosub PUT release rf
               pause 0.3
          }
     pause 0.3
     return
    
PREMIUM_CHECK:
     matchre PREMIUM_NO ^You are not currently a Premium
     matchre PREMIUM_YES ^Your premium service has been continuous
     matchre PRETRAININGLOOP ^You need to concentrate
     put ltb info
     matchwait 5
     goto PREMIUM_NO
PREMIUM_NO:
     var premium 0
     return
PREMIUM_YES:
     var premium 1
     echo *** PREMIUM ACCOUNT ENABLED
     pause 0.2
     if !matchre("$game", "DRX") then return
PREMIUM_TIME:
     var premtime 0
     matchre PREMIUM_SET ^You have a cumulative Premium time of (\d+) months\.
     matchre PREMIUM_SET ^You have a cumulative Platinum time of (\d+) months\.
     put prem 10
     matchwait 5
     return
PREMIUM_SET:
     var premtime $1
     pause 0.1
     if (%premtime >= 120) then
          {
               var portal 1
               if matchre("$game", "DRX") then echo *** Using Plat Portals!
          }
     return

###########################################################################################################
## Plat Portals
#########################################################
PORTAL_TIME:
     echo ========================
     echo ** USING PLAT PORTALS TO TRAVEL!
     echo ** Starting ZoneID:$zoneid RoomID:$roomid
     echo ========================
     pause 0.5
## CROSS PORTAL ENTRANCE Zone 1 Room 484
CROSS_PORTAL:
     if ("$zoneid" = "1") then
          {
               if ($roomid != 484) then gosub AUTOMOVE 484
               if ($roomid != 484) then goto CROSS_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "aesr?y?") then goto ARRIVED
          }
## AESRY PORTAL ENTRANCE Zone 99 Room 115
AESRY_PORTAL:
     if ("$zoneid" = "99") then
          {
               if ($roomid != 115) then gosub AUTOMOVE 115
               if ($roomid != 115) then goto AESRY_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.2
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "shard?") then goto ARRIVED
               if matchre("%destination", "\b(grani?t?e?|garg?o?y?l?e?|spir?e?|horse?c?l?a?n?|fayr?i?n?s?|steel?c?l?a?w?|cori?k?s?|ada?n?f?|ylo?n?o?|wyve?r?n?|rave?n?s?|fan?g?|cov?e?)\b") then goto ILITHI
          }
## SHARD PORTAL ENTRANCE Zone 67 Room 455
SHARD_PORTAL:
     if ("$zoneid" = "67") then
          {
               if ($roomid != 455) then gosub AUTOMOVE 455
               if ($roomid != 455) then goto SHARD_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "merk?r?e?s?h?") then goto ARRIVED
          }
## MERKRESH PORTAL ENTRANCE Zone 107 Room 273
MERKRESH_PORTAL:
     if ("$zoneid" = "107") then
          {
               if ($roomid != 273) then gosub AUTOMOVE 273
               if ($roomid != 273) then goto MERKRESH_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "(rive?r?h?a?v?e?n?|have?n?)") then goto ARRIVED
          }
## RIVERHAVEN PORTAL ENTRANCE Zone 30 Room 331
RIVERHAVEN_PORTAL:
     if ("$zoneid" = "30") then
          {
               if ($roomid != 331) then gosub AUTOMOVE 331
               if ($roomid != 331) then goto RIVERHAVEN_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "(ratha?)") then goto ARRIVED
          }
## RATHA PORTAL ENTRANCE Zone 90 Room 468
RATHA_PORTAL:
     if ("$zoneid" = "90") then
          {
               if ($roomid != 468) then gosub AUTOMOVE 468
               if ($roomid != 468) then goto RATHA_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "(el\'?b?a?i?n?s?|elbai?n?s?)") then goto ARRIVED
               if matchre("%destination", "\b(ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|el\'?b?a?i?n?s?|elb?a?i?n?s?|raka?s?h?|thro?n?e?|forn?s?t?e?d?|hvar?a?l?)\b") then goto THERENGIA
          }
## ELBAINS PORTAL ENTRANCE Zone 40 Room 254
ELBAINS_PORTAL:
     if ("$zoneid" = "40") then
          {
               if ($roomid != 254) then gosub AUTOMOVE 254
               if ($roomid != 254) then goto ELBAINS_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "(mus?p?a?r?i?)") then goto ARRIVED
          }
## MUSPARI PORTAL ENTRANCE Zone 47 Room 97
MUSPARI_PORTAL:
     if ("$zoneid" = "47") then
          {
               if ($roomid != 97) then gosub AUTOMOVE 97
               if ($roomid != 97) then goto MUSPARI_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.4
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "(hiba?r?n?h?v?i?d?a?r?)") then goto ARRIVED
               if matchre("%destination", "\b(aing?h?a?z?a?l?|rave?n?s?|hib?a?r?n?h?v?i?d?a?r?|out?e?r?|inne?r?|boar?c?l?a?n?)\b") then goto FORD
          }
## HIBAR PORTAL ENTRANCE Zone 116 Room 188
HIB_PORTAL:
     if ("$zoneid" = "127") then gosub AUTOMOVE boar
     if ("$zoneid" = "126") then gosub AUTOMOVE boar
     put east
     pause 0.5
     pause 0.2
     if ("$zoneid" = "116") then
          {
               if ($roomid != 188) then gosub AUTOMOVE 188
               if ($roomid != 188) then goto HIB_PORTAL
               pause 0.2
               put go portal
               var ported 1
               wait
               pause 0.4
               pause 0.1
               put #mapper reset
               pause 0.1
               if ($roomid = 0) then gosub MOVERANDOM
               if ($roomid = 0) then gosub MOVERANDOM
               if matchre("%destination", "cross?i?n?g?s?") then goto ARRIVED
               if matchre("%destination", "\b(knif?e?c?l?a?n?|tige?r?c?l?a?n?|dirg?e?|arth?e?d?a?l?e?|kaer?n?a?|ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa|leth?d?e?r?i?e?l?|acen?a?m?a?c?r?a?|vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?|malod?o?r?o?u?s?|bucc?a?|dokt?|sorr?o?w?s?|misens?e?o?r?|beis?s?w?u?r?m?s?|ston?e?c?l?a?n?|bone?w?o?l?f?|germ?i?s?h?d?i?n?|alfr?e?n?s?|cara?v?a?n?s?a?r?y?)\b") then goto CROSSING     
          }
     goto CROSS_PORTAL
###############################################################
#### END OF PLAT PORTAL LOGIC
###############################################################
NECRO_PREP:
     if ("$guild" != "Necromancer") then return
     var donotcastlist The Crossing, Western Gate|Northeast Wilds, Outside Northeast Gate
     pause 0.1
     if ($spellEOTB = 0) then gosub EOTB
     if ($SpellTimer.EyesoftheBlind.active = 0) then gosub EOTB
     if ($SpellTimer.RiteofContrition.active = 0) then gosub ROC
     return
JUSTICE_CHECK:
     pause 0.001
     matchre NECRO_KNOWN sorcerer|monster|necromancer
     matchre NECRO_UNKNOWN You|You\'re
     send justice
     matchwait 8
     goto NECRO_KNOWN
NECRO_KNOWN:
     var Necro.Known 1
     echo * KNOWN AS A NECRO!
     return
NECRO_UNKNOWN:
     var Necro.Known 0
     echo * NOT KNOWN AS A NECRO
     return
ROC:
     var ROCLoop 0
     var NecroPrep ROC
ROC_1:
     math ROCLoop add 1
     # if matchre("%spelltimer", "Liturgy") && ($Utility.Ranks >= 800) then var NecroPrep ROG
     if (%ROCLoop > 1) then var NecroPrep ROC
     if (($spellROC = 1) && ("%NecroPrep" = "ROC")) then goto NECRO.DONE
     # if (($spellROG = 1) && ("%NecroPrep" = "ROG")) then goto NECRO.DONE
     echo **** Prepping %NecroPrep ****
     pause 0.1
     if ("$preparedspell" != "None") then send release spell
     pause 0.3
     if (((matchre("$roomobjs", "exchange board")) || (matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) || (matchre("$roomname", "(%donotcastlist)"))) then
          {
               echo *** BAD ROOM
               return
          }
     # gosub NECRO.CHECKROOM
     if ($Utility.Ranks < 40) then var NecroMana 2
     if ($Utility.Ranks >= 40) && ($Utility.Ranks < 120) then var NecroMana 5
     if ($Utility.Ranks >= 120) && ($Utility.Ranks < 240) then var NecroMana 7
     if ($Utility.Ranks >= 240) && ($Utility.Ranks < 400) then var NecroMana 8
     if ($Utility.Ranks >= 400) && ($Utility.Ranks < 550) then var NecroMana 10
     if ($Utility.Ranks >= 550) && ($Utility.Ranks < 800) then var NecroMana 15
     if ($Utility.Ranks >= 800) then var NecroMana 20
     pause 0.2
     put prep %NecroPrep %NecroMana
     pause 17
     if ((!("$roomplayers" = "")) && (matchre("$preparedspell", "(Rite of Contrition|Eyes of the Blind)")) then gosub RANDOMMOVE
     put cast
     pause 0.6
     pause 0.3
     matchre ROC_1 ivory mask|bone structure beneath is subtly altered|gleaming with arcane power|mutative nervous system|whitened ridges|black mist|sheath of spell\-disrupting miasma|sensitive eye\-cysts
     matchre ROC_RETURN You are
     put look $charactername
     matchwait 2
ROC_RETURN:
     if (($spellROC = 0) && ($spellROG = 0) && (ROCLoop < 3)) then goto ROC_1
     var ROCLoop 0
     return
EOTB:
     var EOTBLoop 0
EOTB_1:
     if (($spellEOTB = 1) && ($invisible = 1)) then goto NECRO.DONE
     pause 0.1
     echo  **** Prepping EOTB ****
     if ("$preparedspell" != "None") then send release spell
     pause 0.3
     ## ** Waits for invis pulse or casts the spell if invisible is off..
     pause 0.1
     if (($spellEOTB = 1) && ($invisible = 0)) then
          {
               ## ** This return is slightly different, it will not wait for pulse inside the exchange.
               ## ** It will also not wait for a pulse if destination = exchange, account or any teller trips to the exchange when moving areas.
               ## ** It should wait for a pulse inside the teller if going anywhere else.
               if (((matchre("$roomobjs", "exchange rate board")) || (matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) || (matchre("$roomname", "(%donotcastlist)"))) && ((matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) && (matchre("%Destination", "(teller|exchange)")))) then return
               matchre EOTB_1 ^Your spell subtly|^Your corruptive mutation fades
               matchwait 30
               put #echo >log Red *** Error with EOTB not pulsing invis. Attempting to recast.
          }
     if ($invisible = 1) then return
     ## ** If script made it to this section then EOTB must be recast.
     ## ** This will not cast while inside the bank or any other unapproved rooms.
     if (((matchre("$roomobjs", "exchange rate board")) || (matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) || (matchre("$roomname", "(%donotcastlist)"))) then return
     if ($stamina < 30) then return
     # gosub NECRO.CHECKROOM
     if ($Utility.Ranks < 40) then var NecroMana 2
     if ($Utility.Ranks >= 40) && ($Utility.Ranks < 120) then var NecroMana 5
     if ($Utility.Ranks >= 120) && ($Utility.Ranks < 240) then var NecroMana 7
     if ($Utility.Ranks >= 240) && ($Utility.Ranks < 400) then var NecroMana 8
     if ($Utility.Ranks >= 400) && ($Utility.Ranks < 500) then var NecroMana 10
     if ($Utility.Ranks >= 500) && ($Utility.Ranks < 700) then var NecroMana 12
     if ($Utility.Ranks >= 700) then var NecroMana 20
     pause 0.4
     put prep EOTB %NecroMana
     pause 16
     put cast 
     pause 0.5
     if (($spellEOTB = 0) && (EOTBLoop < 3)) then goto EOTB_1
     var EOTBLoop 0
     return
NECRO.DONE:
     delay 0.0001
     return
NECRO.CHECKROOM:
     pause 0.01
     pause 0.01
     pause 0.01
     if !("$roomplayers" = "") then gosub RANDOMMOVE
     send search
     pause $roundtime
     pause 0.5
     if !("$roomplayers" = "") then gosub RANDOMMOVE
     echo **** FOUND EMPTY ROOM! ***
     return
###############################################################
## Stow
STOWING:
     delay 0.0001
     var LOCATION STOWING
     if ("$righthand" = "vine") then put drop vine
     if ("$lefthand" = "vine") then put drop vine
     if "$righthandnoun" = "rope" then put coil my rope
     if "$righthand" = "bundle" || "$lefthand" = "bundle" then put wear bund;drop bun
     #if matchre("$righthandnoun","(crossbow|bow|short bow)") then gosub unload
     if matchre("$righthandnoun","(block|granite block)") then put drop block
     if matchre("$lefthandnoun","(block|granite block)") then put drop block
     if matchre("$righthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj)") then gosub wear my $1
     if matchre("$lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj)") then gosub wear my $1
     if matchre("$lefthand","(longbow|khuj)") then gosub stow my $1 in my %SHEATH
     if ("$righthand" != "Empty") then GOSUB STOW right
     if ("$lefthand" != "Empty") then GOSUB STOW left
     if ("$righthand" != "Empty") then put sheath
     RETURN
STOW:
     var todo $0
STOW1:
     delay 0.0001
     var LOCATION STOW1
     if "$righthand" = "vine" then put drop vine
     if "$lefthand" = "vine" then put drop vine
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre STOW2 not designed to carry anything|any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|^But that's closed|I can't find your container|^You can't 
     matchre RETURN ^Wear what\?|^Stow what\?  Type 'STOW HELP' for details\.
     matchre RETURN ^You put
     matchre RETURN ^You open
     matchre RETURN needs to be
     matchre RETURN ^You stop as you realize
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^That can't be picked up
     matchre LOCATION.unload ^You should unload the
     matchre LOCATION.unload ^You need to unload the
     put stow %todo
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW (base.inc)
STOW2:
     delay 0.0001
     var LOCATION STOW2
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN ^You put
     matchre RETURN ^But that is already in your inventory\.
     matchre stow3 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|not designed to carry anything|^But that's closed
     matchre LOCATION.unload ^You should unload the
     matchre LOCATION.unload ^You need to unload the
     put stow %todo in my pack
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW2! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW2 (base.inc)
STOW3:
     delay 0.0001
     var LOCATION STOW3
     if "$lefthandnoun" = "bundle" then put drop bun
     if "$righthandnoun" = "bundle" then put drop bun
     matchre open.thing ^But that's closed
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN ^You put
     matchre RETURN ^But that is already in your inventory\.
     matchre STOW4 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|not designed to carry anything|^But that's closed
     matchre LOCATION.unload ^You should unload the
     matchre LOCATION.unload ^You need to unload the
     put stow %todo in my backpack
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW3! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW3 (base.inc)
STOW4:
     delay 0.0001
     var LOCATION STOW4
     if "$lefthandnoun" = "bundle" then put drop bun
     if "$righthandnoun" = "bundle" then put drop bun
     matchre open.thing ^But that's closed
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN ^You put your
     matchre RETURN ^But that is already in your inventory\.
     matchre REM.WEAR any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide
     matchre LOCATION.unload ^You should unload the
     matchre LOCATION.unload ^You need to unload the
     put stow %todo in my haversack
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW4! (base.inc) ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW4 (base.inc)
OPEN.THING:
     put open back
     put open hav
     pause 0.2
     goto STOWING
REM.WEAR:
     put rem bund
     put drop bund
     wait
     pause 0.5
     goto WEAR1

## Movement
MOVE:
     delay 0.0001
     var Direction $0
     var movefailCounter 0
     var randomloop 0
     var lastmoved %Direction
MOVE_RESUME:
     matchre MOVE_RETRY ^\.\.\.wait|^Sorry\, you may only type|^Please wait\.|You are still stunned\.
     matchre MOVE_RESUME ^You make your way up the .*\.\s*Partway up\, you make the mistake of looking down\.\s*Struck by vertigo\, you cling to the .* for a few moments\, then slowly climb back down\.
     matchre MOVE_RESUME ^You pick your way up the .*\, but reach a point where your footing is questionable\.\s*Reluctantly\, you climb back down\.
     matchre MOVE_RESUME ^You approach the .*\, but the steepness is intimidating\.
     matchre MOVE_RESUME ^You struggle
     matchre MOVE_RESUME ^You blunder
     matchre MOVE_RESUME ^You slap
     matchre MOVE_RESUME ^You work
     matchre MOVE_RESUME make much headway
     matchre MOVE_RESUME ^You flounder around in the water\.
     matchre MOVE_RETREAT ^You are engaged to .*\!
     matchre MOVE_RETREAT ^You can't do that while engaged\!
     matchre MOVE_STAND ^You start up the .*\, but slip after a few feet and fall to the ground\!\s*You are unharmed but feel foolish\.
     matchre MOVE_STAND ^Running heedlessly over the rough terrain\, you trip over an exposed root and land face first in the dirt\.
     matchre MOVE_STAND ^You can\'t do that while lying down\.
     matchre MOVE_STAND ^You can\'t do that while sitting\!
     matchre MOVE_STAND ^You can\'t do that while kneeling\!
     matchre MOVE_STAND ^You must be standing to do that\.
     matchre MOVE_STAND ^You don\'t seem
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_STAND ^Stand up first.
     matchre MOVE_DIG ^You make no progress in the mud \-\- mostly just shifting of your weight from one side to the other\.
     matchre MOVE_DIG ^You find yourself stuck in the mud\, unable to move much at all after your pathetic attempts\.
     matchre MOVE_DIG ^You struggle forward\, managing a few steps before ultimately falling short of your goal\.
     matchre MOVE_DIG ^Like a blind\, lame duck\, you wallow in the mud in a feeble attempt at forward motion\.
     matchre MOVE_DIG ^The mud holds you tightly\, preventing you from making much headway\.
     matchre MOVE_DIG ^You fall into the mud with a loud \*SPLUT\*\.
     matchre MOVE_FAIL_BAIL ^You can't go there
     matchre MOVE_FAILED ^Noticing your attempt
     matchre MOVE_FAILED ^I could not find what you were referring to\.
     matchre MOVE_FAILED ^What were you referring to\?
     matchre MOVE_RETURN ^It's pitch dark
     matchre MOVE_RETURN ^Obvious
     send %Direction
     matchwait 15
     goto MOVE_RETURN
MOVE_RETRY:
     pause
     echo *** Retrying.... 
     pause 0.5
     goto MOVE_RESUME
MOVE_STAND:
     pause 0.1
     matchre MOVE_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_STAND ^The weight
     matchre MOVE_STAND ^You try
     matchre MOVE_STAND ^You don\'t
     matchre MOVE_RETREAT ^You are already standing\.
     matchre MOVE_RETREAT ^You stand(?:\s*back)? up\.
     matchre MOVE_RETREAT ^You stand up\.
     send stand
     matchwait 15
     goto MOVE_STAND
MOVE_RETREAT:
     pause 0.1
     if ($invisible = 1) then gosub STOP_INVIS
     matchre MOVE_RETREAT ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_RETREAT ^You retreat back to pole range\.
     matchre MOVE_RETREAT ^You stop advancing
     matchre MOVE_RETREAT ^You try to back away
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_RESUME ^You retreat from combat\.
     matchre MOVE_RESUME ^You are already as far away as you can get\!
     send retreat
     matchwait 10
     goto MOVE_RETREAT
MOVE_DIG:
     pause 0.1
     matchre MOVE_DIG ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_DIG ^You struggle to dig off the thick mud caked around your legs\.
     matchre MOVE_STAND ^You manage to dig enough mud away from your legs to assist your movements\.
     matchre MOVE_DIG_STAND ^Maybe you can reach better that way\, but you'll need to stand up for that to really do you any good\.
     matchre MOVE_RESUME ^You will have to kneel
     send dig
     matchwait 10
     goto MOVE_DIG
MOVE_DIG_STAND:
     pause 0.1
     matchre MOVE_DIG_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_DIG_STAND ^The weight
     matchre MOVE_DIG_STAND ^You try
     matchre MOVE_DIG_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_DIG ^You stand(?:\s*back)? up\.
     matchre MOVE_DIG ^You are already standing\.
     send stand
     matchwait 10
     goto MOVE_DIG_STAND
MOVE_FAILED:
     var moved 0
     math movefailCounter add 1
     if (%movefailCounter > 3) then goto MOVE_FAIL_BAIL
     pause 0.5
     put look
     pause 0.4
     goto MOVE_RESUME
MOVE_FAIL_BAIL:
     put #echo
     # put #echo >$Log Crimson *** MOVE FAILED. ***
     ## put #echo Crimson *** MOVE FAILED.  ***
     return
MOVE_RETURN:
     var moved 1
     pause 0.001
     return

STAND:
     delay 0.0001
     var LOCATION STAND_1
     STAND_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre WAIT ^The weight of all your possessions prevents you from standing\.
     matchre WAIT ^You are overburdened and cannot manage to stand\.
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre STAND_RETURN ^You stand (?:back )?up\.
     matchre STAND_RETURN ^You stand up in the water
     matchre STAND_RETURN ^You are already standing\.
     send stand
     matchwait
     STAND_RETURN:
     pause 0.1
     pause 0.1
     if (!$standing) then goto STAND
     return
     
MOVERANDOM:
RANDOMMOVE:
     pause 0.0001
     var moved 0
     math randomloop add 1
     if (%randomloop > 60) then 
          {
               echo *** Cannot find a room exit!!?? Stupid fog!
               echo *** ATTEMPTING RANDOM DIRECTIONS...
               pause 0.2
               gosub TRUE_RANDOM
               return
          }
     if (matchre("$roomname","Segoltha River") && ($north)) then
          {
               gosub MOVE north
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname","Temple Hill Manor, Grounds") then
          {
               gosub MOVE go gate
               return
          }
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then
          {
               gosub MOVE climb pine branches
               return
          }
     if matchre("$roomname","Darkling Wood, Pine Tree") then
          {
               gosub MOVE climb white pine
               return
          }
     if matchre("$roomobjs","strong creeper") then
          {
               gosub MOVE climb ladder
               return
          }
     random 1 11
     if (%moved = 1) then return
     if ((%r = 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if (%moved = 1) then return
     if ((%r = 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 5) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 6) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 7) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved = 1) then return
     if ((%r = 8) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%r = 9) && ($out) then gosub MOVE out
     if ((%r = 10) && ($up) && ("%lastmoved" != "up")) then gosub MOVE up
     if ((%r = 11) && ($down) && ("%lastmoved" != "down")) then gosub MOVE down
     if (%moved = 1) then return
     if (%randomloop > 10) then
          {
               if ($out) then gosub MOVE out
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bcrevice") && ("%lastmoved" != "go crevice") then gosub MOVE go crevice
               if matchre("$roomobjs $roomdesc","\bgate") && ("%lastmoved" != "go gate") then gosub MOVE go gate
               if matchre("$roomobjs $roomdesc","\barch") && ("%lastmoved" != "go arch") then gosub MOVE go arch
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit") then gosub MOVE go exit
               if matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path") then gosub MOVE go path
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor") then gosub MOVE go trapdoor
               if matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go curtain") then gosub MOVE go curtain
               if matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door") then gosub MOVE go door
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal") then gosub MOVE go portal
               if matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel") then gosub MOVE go tunnel
               if matchre("$roomobjs $roomdesc","\bstrong creeper\b") && ("%lastmoved" != "climb creeper") then gosub MOVE climb creeper
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair") then gosub MOVE climb stair
               if matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step") then gosub MOVE climb step
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel") then gosub MOVE go panel
               if matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track") then gosub MOVE go track
               if matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field") then gosub MOVE go lava field
          }
     if ($roomid = 0) then goto RANDOMMOVE
     if (%moved = 1) then return
     if (%moved = 0) then goto RANDOMMOVE
     return
     
MOVE_RANDOM_OLD:
     delay 0.0001
     random 1 13
     if (%r = 1) && (!$north) then goto MOVE_RANDOM
     if (%r = 2) && (!$northeast) then goto MOVE_RANDOM
     if (%r = 3) && (!$east) then goto MOVE_RANDOM
     if (%r = 4) && (!$southeast) then goto MOVE_RANDOM
     if (%r = 5) && (!$south) then goto MOVE_RANDOM
     if (%r = 6) && (!$southwest) then goto MOVE_RANDOM
     if (%r = 7) && (!$west) then goto MOVE_RANDOM
     if (%r = 8) && (!$northwest) then goto MOVE_RANDOM
     if (%r = 9) && (!$out) then goto MOVE_RANDOM
     if (%r = 10) && (!$up) then goto MOVE_RANDOM
     if (%r = 11) && (!$down) then goto MOVE_RANDOM
     if (%r = 12) && !matchre("$roomobjs","doorway|door") then goto MOVE_RANDOM
     if (%r = 13) && !matchre("$roomobjs","archway|arch") then goto MOVE_RANDOM
     #
     if (%r = 1) then var Direction north
     if (%r = 2) then var Direction northeast
     if (%r = 3) then var Direction east
     if (%r = 4) then var Direction southeast
     if (%r = 5) then var Direction south
     if (%r = 6) then var Direction southwest
     if (%r = 7) then var Direction west
     if (%r = 8) then var Direction northwest
     if (%r = 9) then var Direction out
     if (%r = 10) then var Direction up
     if (%r = 11) then var Direction down
     if (%r = 12) then var Direction go door
     if (%r = 13) then var Direction go arch
     #
     if (%r = 1) then var Reverse.Direction south
     if (%r = 2) then var Reverse.Direction southwest
     if (%r = 3) then var Reverse.Direction west
     if (%r = 4) then var Reverse.Direction northwest
     if (%r = 5) then var Reverse.Direction north
     if (%r = 6) then var Reverse.Direction northeast
     if (%r = 7) then var Reverse.Direction east
     if (%r = 8) then var Reverse.Direction southeast
     if (%r = 9) then var Reverse.Direction out
     if (%r = 10) then var Reverse.Direction down
     if (%r = 11) then var Reverse.Direction up
     if (%r = 12) then var Reverse.Direction go door
     if (%r = 13) then var Reverse.Direction go arch
     #
     var Exits 0
     if ($north) then math Exits add 1
     if ($northeast) then math Exits add 1
     if ($east) then math Exits add 1
     if ($southeast) then math Exits add 1
     if ($south) then math Exits add 1
     if ($southwest) then math Exits add 1
     if ($west) then math Exits add 1
     if ($out) then math Exits add 1
     if ($up) then math Exits add 1
     if ($down) then math Exits add 1
     if matchre("$roomobjs","doorway|door") then math Exits add 1
     if matchre("$roomobjs","archway|arch") then math Exits add 1
     #
     # don't move "back" on a path unless we'we hit a dead end
     if (%Exits > 1) && ("%Last.Direction" = "%Reverse.Direction") then goto MOVE_RANDOM
     #
     var Last.Direction %Direction
     gosub MOVE_RESUME
     return

TRUE_RANDOM:
     pause 0.001
     var moved 0
     math randomloop add 1
     if (%randomloop > 12) then
          {
               var lastmoved null
               var randomloop 0
               return
          }
     random 1 16
     if (%r = 1) then gosub MOVE n
     if (%r = 2) then gosub MOVE ne
     if (%r = 3) then gosub MOVE e
     if (%r = 4) then gosub MOVE nw
     if (%r = 5) then gosub MOVE se
     if (%r = 6) then gosub MOVE s
     if (%r = 7) then gosub MOVE sw
     if (%r = 8) then gosub MOVE w
     if (%r = 9) then gosub MOVE out
     if (%r = 10) then gosub MOVE up
     if (%r = 11) then gosub MOVE go door
     if (%r = 12) then gosub MOVE go path
     if (%r = 13) then gosub MOVE climb stair
     if (%r = 14) then gosub MOVE climb step
     if (%r = 15) then gosub MOVE go panel
     if (%r = 16) then gosub MOVE go arch
     if (%moved = 0) then goto TRUE_RANDOM
     return

AUTOMOVE:
     delay 0.0001
     action (moving) on
     var Moving 0
     var randomloop 0
     var Destination $0
     var automovefailCounter 0
     if ($hidden = 1) then 
          {
               send unhide
               pause 0.5
          }
     if ($standing = 0) then gosub AUTOMOVE_STAND
     if ($roomid = 0) then gosub RANDOMMOVE
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     pause 0.0001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchre AUTOMOVE_FAILED ^You don\'t seem
     put #goto %Destination
     matchwait 4
     if (%Moving = 0) then goto AUTOMOVE_FAILED
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchwait 160
     goto AUTOMOVE_FAILED
AUTOMOVE_STAND:
     pause 0.1
     if ($standing = 1) then goto AUTOMOVE_RETURN
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing
     send stand
     matchwait 20
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     pause 0.1
     # put #script abort automapper
     pause 0.2
     math automovefailCounter add 1
     if (%automovefailCounter > 3) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.1
     put look
     pause 0.5
     pause 0.2
     if ($roomid = 0) || (%automovefailCounter > 2) then gosub RANDOMMOVE
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     action (moving) off
     put #echo
     put #echo >Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
     return
AUTOMOVE_RETURN:
     action (moving) off
     pause 0.1
     pause 0.2
     return
     
#### CATCH AND RETRY SUBS
WAIT:
     delay 0.0001
     pause 0.1
     if (!$standing) then gosub STAND
     goto %LOCATION
WEBBED:
     delay 0.0001
     if ($webbed) then waiteval (!$webbed)
     if (!$standing) then gosub STAND
     goto %LOCATION
IMMOBILE:
     delay 0.0001
     if contains("$prompt" , "I") then pause 20
     if (!$standing) then gosub STAND
     goto %LOCATION
STUNNED:
     delay 0.0001
     if ($stunned) then waiteval (!$stunned)
     if (!$standing) then gosub STAND
     goto %LOCATION
CALMED:
     delay 5
     if ($stunned) then waiteval (!$stunned)
     if (!$standing) then gosub STAND
     goto %LOCATION 
STOPINVIS:
     if ("$guild" = "Necromancer") then
          {
               put release eotb
               pause 0.3
          }
     if ("$guild" = "Thief") then
          {
               put khri stop silence vanish
               pause 0.3
          }
     if ("$guild" = "Moon Mage") then
          {
               put release rf
               pause 0.3
          }
     pause 0.3
     return
RETURN:
  delay 0.001
  pause 0.001
  return 