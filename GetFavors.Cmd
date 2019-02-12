#### PELIC's Favor Script - Mouse Select Version.
#### EXP TRACKER PLUGIN REQUIRED!
#### UPDATED MAPS REQUIRED!
#### Changed from Climbing to Collecting, per suggestion from Worril.
#### Changed foraging location to a Ranger-friendly room, per suggestion from Stephinroth.
#### Added Fix for hugging orb with no exp from Dasffion
#### Fixed missing COLLECT sub.  (Thanks, Taz)
#### Added Aspect name to orb interactions to avoid issues with Osrel Meraud Orbs and Clerics (Thanks for the bug report, enki)
#### Updated room number, as noted in Genie thread.
#### Last Edited: 02 September, 2018
ABSOLUTE_TOP:
     # debuglevel 5
     delay 0.0001
     gosub STATUSBAR
     action var Recover 1;put #statusbar 3 Finishing current orb. when ^What do you want to stop\?
     action put #tvar Favors $1 when ^\s*Favors\s*\:\s*(\d+)
     action put #tvar Favors $1 when ^You currently have (\d+) favors with the gods\.
     var Recover 0
     gosub EMPTY_HANDS
     if ("$zoneid" = "1") then goto INIT
     if ("$zoneid" = "2a") then goto INIT
     goto INVALID_LOCATION
INIT:
SELECT:
     delay 0.0001
     put #tvar Aspect NULL
     delay 0.5
     put #echo 
     put #echo "**********************************************************************"
     put #echo "**    GODS        ** GUILDS                     ** RACES            **"
     put #echo "**********************************************************************"
     delay 0.2
     put #link "**  Chadatru      ** Paladins                   **                  **" "#tvar Aspect Chadatru;#parse CHOICE MADE!"
     put #link "**  Damaris       ** Thieves                    **                  **" "#tvar Aspect Damaris;#parse CHOICE MADE!"
     put #link "**  Eluned        **                            ** Elotheans        **" "#tvar Aspect Eluned;#parse CHOICE MADE!"
     put #link "**  Everild       ** Barbarians                 **                  **" "#tvar Aspect Everild;#parse CHOICE MADE!"
     put #link "**  Faenella      ** Bards/Paladins/Traders     ** Elves            **" "#tvar Aspect Faenella;#parse CHOICE MADE!"
     put #link "**  Glythtide     ** Bards                      ** Halflings        **" "#tvar Aspect Glythtide;#parse CHOICE MADE!"
     put #link "**  Hav'roth      **                            ** S'Kra Mur        **" "#tvar Aspect Hav'roth;#parse CHOICE MADE!"
     put #link "**  Hodierna      ** Empaths/Clerics            **                  **" "#tvar Aspect Hodierna;#parse CHOICE MADE!"
     put #link "**  Kertigen      ** Traders/Thieves            ** Dwarves          **" "#tvar Aspect Kertigen;#parse CHOICE MADE!"
     put #link "**  Meraud        ** Mages                      ** Elotheans        **" "#tvar Aspect Meraud;#parse CHOICE MADE!"
     put #link "**  Tamsine       **                            **                  **" "#tvar Aspect Tamsine;#parse CHOICE MADE!"
     put #link "**  Truffenyi     ** Clerics                    ** Humans/Halflings **" "#tvar Aspect Truffenyi;#parse CHOICE MADE!"
     put #link "**  Urrem'tier    **                            **                  **" "#tvar Aspect Urrem'tier;#parse CHOICE MADE!"
     delay 0.2
     put #echo "**********************************************************************"
     put #echo 
     put #echo "Please select the God of your choice."
     put #echo 
     waitforre ^CHOICE MADE\!
     if "$Aspect" = "NULL" then goto SELECT
SELECT.NUMBER:
     delay 0.0001
     var Count 0
     delay 0.5
     put #echo 
     put #echo "***********************************************"
     put #echo "**                                           **"
     put #echo "** How many favors do you wish to have?      **"
     put #echo "**                                           **"
     put #echo "** (Total, after script is finished.)        **"
     put #echo "**                                           **"
     put #echo "**  Please select the number of your choice  **"
     put #echo "**                                           **"
     delay 0.2
     put #link "**                     6                     **" "#parse OPTION1!"
     put #link "**                    12                     **" "#parse OPTION2!"
     put #link "**                    18                     **" "#parse OPTION3!"
     put #link "**                    24                     **" "#parse OPTION4!"
     put #link "**                    30                     **" "#parse OPTION5!"
     delay 0.2
     put #echo "**                                           **"
     put #echo "***********************************************"
     put #echo 
     matchre SET.OPTION1 ^OPTION1\!
     matchre SET.OPTION2 ^OPTION2\!
     matchre SET.OPTION3 ^OPTION3\!
     matchre SET.OPTION4 ^OPTION4\!
     matchre SET.OPTION5 ^OPTION5\!
     matchwait
SET.OPTION1:
     delay 0.0001
     put #tvar Count 6
     goto CONFIRM.CHOICE
SET.OPTION2:
     delay 0.0001
     put #tvar Count 12
     goto CONFIRM.CHOICE
SET.OPTION3:
     delay 0.0001
     put #tvar Count 18
     goto CONFIRM.CHOICE
SET.OPTION4:
     delay 0.0001
     put #tvar Count 24
     goto CONFIRM.CHOICE
SET.OPTION5:
     delay 0.0001
     put #tvar Count 30
     goto CONFIRM.CHOICE
CONFIRM.CHOICE:
     delay 0.5
     put #echo 
     put #echo "You wish to have a total of $Count favors from $Aspect."
     put #echo 
     put #echo "Select 'YES' to confirm, or 'NO' to refresh the list and choose again."
     put #echo 
     put #echo "***********************************************"
     delay 0.2
     put #link "**                     YES                   **" "#parse GOOD TO GO!"
     put #link "**                     NO                    **" "#parse RESELECT!"
     delay 0.2
     put #echo "***********************************************"
     put #echo 
     matchre SET.TO.GO ^GOOD TO GO\!
     matchre SELECT ^RESELECT\!
     matchwait
SET.TO.GO:
     delay 0.0001
     if !def(collectitem) then put #tvar collectitem rock
     gosub EMPTY_HANDS
FAVOR.CHECK:
     delay 0.0001
     gosub PUT info
     put #statusbar 4 Favor Target : $Count
     put #statusbar 5 Current Favors : $Favors
     if ($Favors >= $Count) then var Recover 1
     if (%Recover) then goto RECOVERED
     if ("$zoneid" = "2a") then goto RES.CRECHE.TO.FAVORS
     if ("$zoneid" = "1") then goto CROSSING.TO.FAVORS
RES.CRECHE.TO.FAVORS:
     delay 0.0001
     gosub AUTOMOVE crossing
CROSSING.TO.FAVORS:
     delay 0.0001
     gosub AUTOMOVE w gate
     gosub AUTOMOVE favors
ORB.INIT:
KNEEL:
     pause 0.0001
     matchre KNEEL ^\.\.\.wait|^Sorry\,
     matchre PRAY ^You kneel down upon the ground\.
     send kneel
     matchwait
PRAY:
     pause 0.0001
     matchre PRAY ^\.\.\.wait|^Sorry\,
     matchre PRAY ^You close your eyes and pray\.
     matchre PRAY ^As you continue to pray, another sound presents itself\.
     matchre PRAY ^You begin to pray
     matchre PRAY ^You continue to pray
     matchre DECLARE ^As the world around you returns to normal, you hear a faint voice echo within you\.
     send pray
     matchwait
DECLARE:
     pause 0.0001
     matchre DECLARE ^\.\.\.wait|^Sorry\,
     matchre STAND.FOR.ORB ^The voice speaks to you again saying\, \"If .* be your god\, .*\, rise and seek your favor\.  If this be not correct\, then declare your god again\.
     send say $Aspect
     matchwait
STAND.FOR.ORB:
     pause 0.0001
     matchre STAND.FOR.ORB ^\.\.\.wait|^Sorry\,
     matchre GET.ORB.INIT ^\[Siergelde, Labyrinth\]
     send stand
     matchwait
GET.ORB.INIT:
     pause 0.0001
     matchre GET.ORB.INIT ^\.\.\.wait|^Sorry\,
     matchre BEGIN.PUZZLE ^You get a glowing .* orb from atop an altar made of gleaming alabaster trimmed with onyx\.
     send get $Aspect orb on altar
     matchwait
BEGIN.PUZZLE:
     pause 0.0001
     matchre BEGIN.PUZZLE ^\.\.\.wait|^Sorry\,
     matchre LOOK ^You step through the luminous arch, and are instantly bathed in a soft, white glow\.
     matchre LOOK ^What were you referring to\?
     matchre LOOK ^I could not find what you were referring to\.
     send go arch
     matchwait
PUZZLE:
     pause 0.0001
     matchre LOOK ^\.\.\.wait|^Sorry\,
     matchre LOOK ^That's difficult to do from the bottom of the stairs\.
     matchre LOOK ^It would be difficult to go through the door from the bottom of the stairway\.
     matchre PLANT ^You are standing in a square room of smooth, stone walls\.
     matchre PLANT ^You cannot go through a closed window\.
     matchre SPONGE You also see a granite altar with several candles on it, a granite font and a small sponge\.
     matchre JUG You also see a granite altar with several candles and a water jug on it, and a granite font\.
     matchre TINDERS You also see some tinders, several candles, a granite font and a granite altar\.
     matchre VASE You also see a vase on top of the altar\.
     matchre NEXT ^\[Siergelde, Stone Grotto\]
     send %Command
     matchwait 1
LOOK:
     delay 0.0001
     var Command look
     goto PUZZLE
NEXT:
     pause 0.0001
     matchre ORB.INIT ^You drop your .*orb and it shatters on the ground\.
     matchre FAVORS.TO.CROSSING ^You put your
     send stow my $Aspect orb
     matchwait
PLANT:
     pause 0.0001
     matchre PLANT ^\.\.\.wait|^Sorry\,
     matchre PLANT ^Judging the thickness of the paint which has sealed the window shut, you shimmy the frame of the glass to loosen it\.  After a few strong shakes, you notice a thin crack running along the painted edge\.
     matchre PLANT ^Shaking the frame of the glass once more, you manage to loosen it even further\.  As you grunt with effort, you feel the thick paint binding slip, and flakes of the stuff fall to the floor\.
     matchre OPEN ^A cool, swift breeze moves into the room, chasing the stifling heat from your skin\.
     matchre OPEN ^That is already open\.
     send open window
     matchwait
OPEN:
     delay 0.0001
     var Command go window
     goto PUZZLE
SPONGE:
     delay 0.0001
     gosub PUT clean altar;-encumbrance
     gosub PUT climb stair;-encumbrance
     var Command go door
     goto PUZZLE
JUG:
     delay 0.0001
     gosub PUT fill font;-encumbrance
     gosub PUT climb stair;-encumbrance
     var Command go door
     goto PUZZLE
TINDERS:
     delay 0.0001
     gosub PUT light candle;-encumbrance
     gosub PUT climb stair;-encumbrance
     var Command go door
     goto PUZZLE
VASE:
     delay 0.0001
     gosub PUT get flower;-encumbrance
     var Command go path
     goto PUZZLE
FAVORS.TO.CROSSING:
     delay 0.0001
     gosub AUTOMOVE crossing
     gosub AUTOMOVE 337
     goto ORB.PREP.BEGIN
GO.FORAGE:
     delay 0.0001
     if ("$roomid" = "337") then goto MAIN
     if ("$zoneid" != "1") then gosub AUTOMOVE crossing
     gosub AUTOMOVE 337
MAIN:
     pause 0.0001
     gosub COLLECT $collectitem
     gosub KICKEM
EXP.CHECK:
     delay 0.0001
     if ($Outdoorsmanship.LearningRate > 29) || ($Perception.LearningRate > 29) then goto ORB.PREP.BEGIN
     goto MAIN
ORB.PREP.BEGIN:
GET.ORB:
     pause 0.0001
     matchre GET.ORB ^\.\.\.wait|^Sorry\,
     matchre HUG.ORB ^You get
     matchre BROKEN.BAD.ORB ^You drop your .* orb and it shatters on the ground\.
     send get my $Aspect orb
     matchwait
HUG.ORB:
     pause 0.0001
     matchre HUG.ORB ^\.\.\.wait|^Sorry\,
     matchre STOW.ORB ^As you press the .*orb against your chest\, it glows slightly more intensely and you feel a strange tugging\, as if something has been moved from you to the orb\.\s*You sense\, though\, that your sacrifice is not yet fully prepared\.
     matchre ORB.PREPPED ^As you press the .*orb against your chest\, it glows slightly more intensely and you feel a strange tugging\, as if something has been moved from you to the orb\.\s*You sense that your sacrifice is properly prepared\.
     matchre ORB.PREPPED ^The .*orb feels warm to your touch and has a strong, steady glow\.\s*The strange tugging sensation is gone\, leading you to believe that your sacrifice is properly prepared\.
     matchre STOW.ORB ^You press the .*orb against your chest and feel a strange tugging\, but nothing really seems to happen\.  You sense you are lacking in the type of sacrifice the orb requires\.
     matchre BAD.ORB ^You sense that this .*orb is not deemed worthy to hold your required sacrifice\.  Perhaps another would work at this time\?
     matchre BROKEN.BAD.ORB ^You drop your .* orb and it shatters on the ground\.
     send hug my $Aspect orb
     matchwait
STOW.ORB:
     pause 0.0001
     matchre STOW.ORB ^\.\.\.wait|^Sorry\,
     matchre GO.FORAGE ^Stow what\?  Type 'STOW HELP' for details\.
     matchre GO.FORAGE ^You put
     send stow my $Aspect orb
     matchwait
ORB.PREPPED:
     delay 0.3
     echo ***********************
     echo *** DEPOSITING ORB. ***
     echo ***********************
     delay 0.3
     gosub AUTOMOVE temple
     gosub AUTOMOVE favor altar
PUT.ORB:
     pause 0.0001
     matchre PUT.ORB ^\.\.\.wait|^Sorry\,
     matchre BROKEN.BAD.ORB ^You drop your .*orb and it shatters on the ground\.
     matchre FAVOR.CHECK ^Then\, an instant later\, the multicolored lights gather around you and mix together\, forming a white mass of brightness which completely obscures your vision\.  Slowly\, the light fades and you feel somehow changed\.
     send put my $Aspect orb on altar
     matchwait
BAD.ORB:
DROP.BAD.ORB:
     pause 0.0001
     matchre DROP.BAD.ORB ^\.\.\.wait|^Sorry\,
     matchre BROKEN.BAD.ORB ^You drop your .* orb\.
     matchre BROKEN.BAD.ORB ^You drop your .* orb and it shatters on the ground\.
     send drop my $Aspect orb
     matchwait
BROKEN.BAD.ORB:
     pause 0.0001
     goto FAVOR.CHECK
RECOVERED:
     delay 0.3
     echo ******************
     echo *** ALL DONE!  ***
     echo ******************
     delay 0.3
     put #script abort %scriptname
     exit
INVALID_LOCATION:
     delay 0.3
     echo *********************************************************
     echo *** PLEASE START THIS SCRIPT ANYWHERE IN THE CROSSING ***
     echo *********************************************************
     delay 0.3
     put #script abort %scriptname
     exit
END_SCRIPT:
     delay 0.0001
     gosub STATUSBAR_CLEAR
     put #script abort %scriptname
     exit
STATUSBAR:
     delay 0.0001
     put #statusbar 2 Getting Favors (GetFavors.Cmd)
     put #statusbar 3 Type STOP to finish orb and abort script.
     put #statusbar 4
     put #statusbar 5
     return
STATUSBAR_CLEAR:
     delay 0.0001
     put #statusbar 2
     put #statusbar 3
     put #statusbar 4
     put #statusbar 5
     return
#### INCLUDE CONTENT FOLLOWS

#### EMPTY HANDS SUB
EMPTY_HANDS:
     pause 0.0001
     if ("$righthand" != "Empty") then gosub STOW $righthandnoun
     if ("$lefthand" != "Empty") then gosub STOW $lefthandnoun
     return
#### PUT SUB
PUT:
     delay 0.0001
     var command $0
     var LOCATION PUT_1
     PUT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre CALMED ^Strangely\, you don\'t feel like fighting right now\.
     matchre PUT_STOW ^You need a free hand to pick that up\.
     matchre PUT_STAND ^You should stand up first\.|^Maybe you should stand up\.
     matchre WAIT ^\[Enter your command again if you want to\.\]
     matchre RETURN_CLEAR ^.*Roundtime\s*\:?
     matchre RETURN_CLEAR ^.*\[Roundtime\s*\:?
     matchre RETURN_CLEAR ^.*\(Roundtime\s*\:?
     matchre RETURN_CLEAR ^.*\[Praying for \d+ sec\.\]
     matchre RETURN_CLEAR ^You cannot do that while engaged\!
     matchre RETURN_CLEAR ^I could not find what you were referring to\.
     matchre RETURN_CLEAR ^Please rephrase that command\.
     matchre RETURN_CLEAR ^That (?:is|has) already
     matchre RETURN_CLEAR ^What were you referring to\?
     matchre RETURN_CLEAR ^In the name of love\?
     matchre RETURN_CLEAR ^.* what\?
     matchre RETURN_CLEAR ^I don\'t
     matchre RETURN_CLEAR ^(\S+) has accepted
     matchre RETURN_CLEAR ^You (?:hand|push|move|put|whisper|lean|tap|drop|place|knock|toss|set|add|search|circle|fake|slip|weave|shove|try|must|wave|sit|fail|turn|are already|can\'t|glance|bend|kneel|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|open|fumble|exhale|allow|have|are|wring|aren\'t|scan|vigorously|adjust|bundle|ask|form|get|lose|remove|pull|accept|slide|wear|sling|pick|silently|realize|open|close|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel|read|come|count|.*analyze|relax|awaken|gaze) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^You sense that you are as pure of spirit as you can be\, and you are ready for whatever rituals might face you\.
     matchre RETURN_CLEAR ^Subservient type|^The shadows|^Close examination|^Try though
     matchre RETURN_CLEAR ^USAGE\:
     matchre RETURN_CLEAR ^Allows a Moon Mage
     matchre RETURN_CLEAR ^A slit across the door
     matchre RETURN_CLEAR ^Your (?:actions|dance|nerves) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^Having no further use for .*\, you discard it\.
     matchre RETURN_CLEAR ^Brother Durantine|^Durantine|^Mags|^Ylono|^Malik|^Kilam|^Ragge|^(?:An?|The) attendant|^(?:An?|The) clerk|^(?:An?|The) Teller|^(?:An?|The).*spider|^.*He says\,
     matchre RETURN_CLEAR ^After a moment\, .*\.
     matchre RETURN_CLEAR ^.* (?:is|are) not in need of cleaning\.
     matchre RETURN_CLEAR ^Quietly touching your lips with the tips of your fingers as you kneel\, you make the Cleric's sign with your hand\.
     matchre RETURN_CLEAR ^You hear a soft voice say\, \"Thou should first attend to thy own woes before seeking to help others\.\"
     matchre RETURN_CLEAR ^The gem pouch
     matchre RETURN_CLEAR ^The .* is not damaged enough to warrant repair\.
     matchre RETURN_CLEAR ^There is no more room in .*\.
     matchre RETURN_CLEAR \[Type INVENTORY HELP for more options\]
     matchre RETURN_CLEAR ^There is nothing in there\.
     matchre RETURN_CLEAR ^A vortex
     matchre RETURN_CLEAR ^In a flash
     matchre RETURN_CLEAR ^An aftershock
     matchre RETURN_CLEAR ^The waters
     matchre RETURN_CLEAR ^In the .* you see .*\.
     matchre RETURN_CLEAR ^That is closed\.
     matchre RETURN_CLEAR ^This spell cannot be targeted\.
     matchre RETURN_CLEAR ^You cannot figure out how to do that\.
     matchre RETURN_CLEAR ^You will now store .* in your .*\.
     matchre RETURN_CLEAR ^That tool does not seem suitable for that task\.
     matchre RETURN_CLEAR ^There isn't any more room in .* for that\.
     matchre RETURN_CLEAR ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
     matchre RETURN_CLEAR ^\s*LINK ALL CANCEL\s*\- Breaks all links
     matchre RETURN_CLEAR ^This ritual may only be performed on a corpse\.
     matchre RETURN_CLEAR ^There is nothing else to face\!
     matchre RETURN_CLEAR ^Stalking is an inherently stealthy endeavor\, try being out of sight\.
     matchre RETURN_CLEAR ^You're already stalking
     matchre RETURN_CLEAR ^There aren't any .*\.
     matchre RETURN_CLEAR ^You don't think you have enough focus to do that\.
     matchre RETURN_CLEAR ^You have no idea how to cast that spell\.
     matchre RETURN_CLEAR ^An offer
     matchre RETURN_CLEAR ^Obvious (?:exits|paths)
     matchre RETURN_CLEAR ^But the merchant can't see you|are invisible
     matchre RETURN_CLEAR ^The book|Page|^The sconce|^As the world|^The voice|^A ravenous energy
     matchre RETURN_CLEAR ^In the|^The attendant|^That is already open\.|^Your inner
     matchre RETURN_CLEAR ^(\S+) hands you|^Searching methodically|^But you haven\'t prepared a symbiosis\!
     matchre RETURN_CLEAR ^Illustrations of complex\,|^It is labeled|^Your nerves
     matchre RETURN_CLEAR ^The lockpick|^Doing that|is not required to continue crafting
     # matchre RETURN_CLEAR ^
     matchre RETURN ^\s*Encumbrance\s*\:
     send %command
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT! (utility.inc) ***
     put #echo >$Log Crimson $datetime Command = %command
     put #log $datetime MISSING MATCH IN PUT (utility.inc)
     return
PUT_STOW:
     delay 0.0001
     gosub EMPTY_HANDS
     goto PUT_1
PUT_STAND:
     delay 0.0001
     gosub STAND
     goto PUT_1
#### GET SUB
GET:
     delay 0.0001
     var get $0
     var LOCATION GET_1
     GET_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre HOLD_1 ^But that is already in your inventory\.
     matchre RETURN ^Get what\?
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^You (?:get|grab|pick|carefully|are already) .*(?:\.|\!|\?)?
     matchre RETURN ^As best it can\, .* moves in your direction\.
     send get %get
     matchwait 10
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN GET! (%scriptname.cmd) ***
     put #echo >$Log Crimson $datetime Get = %get
     put #log $datetime MISSING MATCH IN GET (%scriptname.cmd)
     return
#### STOW SUB
STOW:
     delay 0.0001
     var stow $0
     var LOCATION STOW_1
     STOW_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre WEAR_1 ^(?:An?|The).* is too (?:long|wide) to fit in .*\.
     matchre RETURN ^You put .*\.
     matchre RETURN ^You pick up
     matchre RETURN ^You open your pouch and put .* inside\, closing it once more\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Stow what\?  Type 'STOW HELP' for details\.
     send stow %stow
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW! (%scriptname.cmd) ***
     put #echo >$Log Crimson $datetime Stow = %stow
     put #log $datetime MISSING MATCH IN STOW (%scriptname.cmd)
     return
#### WEAR SUB
WEAR:
     delay 0.0001
     var stow $0
     var LOCATION WEAR_1
     WEAR_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre STOW_1 ^You can't wear that\!
     matchre STOW_1 ^You can't wear any more items like that\.
     matchre STOW_1 ^You need at least one free hand for that\.
     matchre STOW_1 ^This .* can't fit over the .* you are already wearing which also covers and protects your .*\.
     matchre RETURN ^You (?:sling|put|slide|slip|attach|work|strap|hang|are already) .*(?:\.|\!|\?)?
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Wear what\?
     send wear %stow
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN WEAR! (%scriptname.cmd) ***
     put #echo >$Log Crimson $datetime Stow = %stow
     put #log $datetime MISSING MATCH IN WEAR (%scriptname.cmd)
     return
#### DOUBLE PUT SUB
PUT_IT:
     delay 0.0001
     var putit $0
     var LOCATION PUT_IT_1
     PUT_IT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^You (?:put|drop|set|carefully) .*\.
     matchre RETURN ^That's too heavy to go in there\!
     matchre RETURN ^Please rephrase that command\.
     matchre RETURN ^.* what\?
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^There isn't any more room in .* for that\.
     matchre RETURN ^What were you referring to\?
     send put %putit
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT_IT! (%scriptname.cmd) ***
     put #echo >$Log Crimson $datetime PutIt = %putit
     put #log $datetime MISSING MATCH IN PUT_IT (%scriptname.cmd)
     return
#### ITEM SWAP SUB
SWAP:
     delay 0.0001
     var LOCATION SWAP_1
     SWAP_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^You move
     matchre RETURN ^You have nothing to swap\!
     send swap
     matchwait
     return
##### STANDING SUB
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
     matchre STAND_RETURN ^You are already standing\.
     matchre STAND_RETURN ^As you stand
     send stand
     matchwait
     STAND_RETURN:
     pause 0.1
     pause 0.1
     if (!$standing) then goto STAND
     return
#### FORAGING SUBS
FORAGE:
     delay 0.0001
     var forage $0
     var LOCATION FORAGE_1
     FORAGE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You manage to find .*\.
     matchre RETURN ^The room is too cluttered to find anything here\!
     matchre RETURN ^You really need to have at least one hand free to forage properly\.
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     send forage %forage
     matchwait
COLLECT:
     delay 0.0001
     var collect $0
     var LOCATION COLLECT_1
     COLLECT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^You cannot collect anything while in combat\!
     matchre RETURN ^You manage to collect a pile of .*\.
     matchre RETURN ^The room is too cluttered to find anything here\!
     matchre RETURN ^You survey the area and realize that any collecting efforts would be futile\.
     matchre WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     send collect %collect
     matchwait
KICKEM:
     delay 0.0001
     if matchre("$roomobjs" , "a pile of \S+") then gosub KICKIT
     if matchre("$roomobjs" , "a pile of \S+") then gosub KICKIT
     return
KICKIT:
     delay 0.0001
     var LOCATION KICKIT_1
     KICKIT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre KICKIT_STAND ^You can't do that from your position\.
     matchre KICKIT_STAND ^You can't quite manage to kick while sitting\.
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^You take a step back and run up to the pile of .*\.
     send kick pile
     matchwait
KICKIT_STAND:
     delay 0.0001
     if ($standing) then goto KICKIT
     gosub STAND
     goto KICKIT_STAND
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
     delay 15
     if ($stunned) then waiteval (!$stunned)
     if (!$standing) then gosub STAND
     goto %LOCATION
#### RETURNS
RETURN_CLEAR:
     delay 0.0001
     put #queue clear
     pause 0.0001
     return
RETURN:
     delay 0.0001
     return
#### END INCLUDE CONTENT
#### AUTOMAPPER MOVEMENT SUBS
AUTOMOVE:
     delay 0.0001
     var Destination $0
     var automovefailCounter 0
     if (!$standing) then gosub AUTOMOVE_STAND
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     send #goto %Destination
     matchwait
AUTOMOVE_STAND:
     pause 0.1
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry\,
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing\.
     send stand
     matchwait
AUTOMOVE_FAILED:
     evalmath automovefailCounter (automovefailCounter + 1)
     if (%automovefailCounter > 3) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.5
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     put #echo
     put #echo >$Log Crimson *** AUTOMOVE FAILED. ***
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo
     exit
AUTOMOVE_RETURN:
     return
#### END AUTOMAPPER MOVEMENT SUBS