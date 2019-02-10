var god damaris
var orbs 0
var maxorbs 15

action put #queue clear; send 1 $lastcommand when (\.\.\.wait|type ahead|^You don't seem to be able to move to do that)
action goto orb.done when your sacrifice is properly prepared

include base.cmd
if_1 then goto %1

echo
echo * SCRIPT MEANT TO BE RUN IN A PYRAMID SPAM ROOM FOR MECH!!
echo

RUB.ORB:
put hum $hum
put rub orb
pause 5
put rub orb
put rub orb
pause 5
put rub orb
put rub orb
pause 9
put rub orb
put rub orb
pause 2
goto RUB.ORB

ORB.DONE:
echo
echo *** FILLED A FAVOR ORB! GOING TO GET A NEW ONE!
echo
pause 
GOSUB automove portal
GOSUB walk go portal
GOSUB walk go gate
pause
if "$zoneid" == "67" then goto SHARD.TO.TEMPLE
FAVORGO:
SHARD.TO.TEMPLE:
gosub automove light temple
pause .5
gosub automove depart
pause .5
put get my orb
put put my orb on altar
pause
matchre GET.FAVOR ^I could not|^What were you|^Tap what
matchre BACK.TO.RUB ^You tap|^The orb is delicate
put tap my orb
matchwait 20

BACK.TO.RUB:
gosub automove light
goto SHARD.TO.ARCH

GET.FAVOR:
GET.FAVOR.ORB:
var orbs 0
echo ************** GETTING AN ORB **************
gosub automove light
gosub automove west
pause 0.1
pause 0.1
move w
pause 0.5
pause 0.5
pause 0.5
gosub automove 6

SEARCH.PATH:
pause	
pause 0.5
matchre FOUND.IT You find a narrow path
matchre SEARCH.PATH You don't find anything 
put search
matchwait 5
goto SEARCH

FOUND.IT:
pause 0.5
move go path
pause
move w
move w
move w
move w
move w
pause 0.5
put lie
send look brush
pause
send go open
waitforre Wyvern Mountain|you crawl out of the passage
pause 0.5
put stand
pause 0.5
put stand

ARCH:
pause 0.1
#matchre NEXT Obvious exits: down	
#matchre ARCH Obvious exits: none
put go white arch
pause 0.5
pause 0.5
pause 0.5
if $down then goto NEXT
else goto ARCH

NEXT:
pause 0.2
pause 0.1
pause 0.5
put down
pause 0.5
matchre NEXT2 Six carved columns of pale marble|Wyvern Mountain, Dragon Shrine
matchre ARCH Wyvern Mountain, Cavern
put look
matchwait

NEXT2:
move go dais
pause 0.5

GETTING.ORB:
math orbs add 1
put pray	
put pray
pause .2
put pray
pause .2
put pray
pause
put '%god
pause
pause .5
put stand
pause 0.5
put stand
pause .5
if $standing = 0 then put stand
put get %god orb
pause 0.5
put go arch
goto PUZZLE

PUZZLE:
pause 0.2
match fillfont You also see a granite altar with several candles and a water jug on it, and a granite font.
match lightcandle You also see some tinders, several candles, a granite font and a granite altar.
match cleanaltar You also see a granite altar with several candles on it, a granite font and a small sponge.
match pickflowers You also see a vase on top of the altar.
match openwindow A table sits against one wall, directly opposite an ancient window.  
match PUZZLE.DONE [Wyvern Mountain, Raised Dais]
put look
matchwait

fillfont:
pause 0.1
put fill font
pause 0.5
match fillfont With a practiced eye, you begin to check the various acoutrements around you.
match fillfont2 You reach the top of the stairway, and notice that the door has swung open of its own accord!  
put go stair
matchwait
fillfont2:
put go door
goto puzzle

pickflowers:
pause 0.1
put pick flowers
pause
put go tree
goto puzzle

lightcandle:
pause 0.1
put light candle
pause
match lightcandle With a practiced eye, you begin to check the various acoutrements around you.
match lightcandle2 You reach the top of the stairway, and notice that the door has swung open of its own accord!
put go stair
matchwait
lightcandle2:
put go door
goto puzzle

cleanaltar:
pause 0.1
put clean altar
pause
match cleanaltar With a practiced eye, you begin to check the various acoutrements around you.
match cleanaltar2 You reach the top of the stairway, and notice that the door has swung open of its own accord!  
put go stair
matchwait
cleanaltar2:
put go door
goto puzzle

openwindow:
pause 0.1
pause 0.1
matchre openwindow Roundtime|wait
match openwindow2 cool, swift breeze
put open window
matchwait
openwindow2:
pause 0.1
pause 0.1
match openwindow closed window
match puzzle hoist yourself
put go window
matchwait


PUZZLE.DONE:
echo **** %orbs Orbs! ***
put put my orb in my ruck
pause 
if %orbs >= %maxorbs then goto LEAVING.FAVORS
goto GETTING.ORB


LEAVING.FAVORS:
move down
move up

ARCH.RETURN:
pause 0.5
pause 0.1
matchre BACK.TO.SHARD a low opening
matchre ARCH.RETURN Obvious exits|Obvious paths
put go white arch
matchwait 5
goto ARCH.RETURN

BACK.TO.SHARD:
pause 0.5
put lie
put go open
waitforre Wyvern Trail, Clearing|Tangled brush surrounds a small clearing on all sides
put stand
pause 0.5
put stand
pause 0.5
put go trail
pause 0.5
pause 0.5
pause 0.5
pause 0.5
gosub automove shard
SHARD.TO.ARCH:
gosub automove portal
pause .1
gosub walk go portal
gosub walk east
gosub walk east
pause 0.5

done:
pause                              
echo
echo ************** YOU GOT A NEW FAVOR! **************
echo
put #echo >Log Blue *** GOT A FAVOR *** 
GOTO RUB.ORB

autoMove:
	if "$1" = "$roomid" then return
	if "$2" = "" then put .move2 $1 $1
	else if "$2" != "" then put .move2 $1 $2
	waitforre ^A good|^If you are trying to speak,
	return
