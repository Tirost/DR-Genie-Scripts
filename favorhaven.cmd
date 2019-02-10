setvariable god damaris
action put #queue clear; send 1 $lastcommand when (\.\.\.wait|type ahead|^You don't seem to be able to move to do that)

GET.FAVOR.ORB:
echo ************** GETTING AN ORB **************
gosub automove e gate
pause 0.5
gosub automove 107
pause 0.1
pause 0.1

PRAY:
pause 0.5
send kneel
send pray
wait
pause 0.5
put pray
put pray
wait
pause .5
put pray
pause
put '%god
pause
pause 
pause .5
put stand
pause 0.5
pause 0.5
if $standing = 0 then put stand
put get %god orb
pause 0.5
put go arch
goto PUZZLE

PUZZLE:
pause 0.5
match fillfont You also see a granite altar with several candles and a water jug on it, and a granite font.
match lightcandle You also see some tinders, several candles, a granite font and a granite altar.
match cleanaltar You also see a granite altar with several candles on it, a granite font and a small sponge.
match pickflowers You also see a vase on top of the altar.
match openwindow A table sits against one wall, directly opposite an ancient window.  
match PUZZLE.DONE [Mausoleum, Alcove of the Font]
put look
matchwait

fillfont:
pause 0.5
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
pause
put pick flowers
pause
put go tree
goto puzzle

lightcandle:
pause
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
pause
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
pause
match openwindow Roundtime
match openwindow2 cool, swift breeze
put open window
matchwait
openwindow2:
pause
match openwindow closed window
match puzzle hoist yourself
put go window
matchwait


PUZZLE.DONE:
put put my orb in my ruck
pause
LEAVING.FAVORS:
move down
move out

BACK.TO.CITY:
gosub automove riverhaven


done:
pause        
echo
echo ************** YOU GOT A NEW FAVOR! **************
echo
put #echo >Log Blue *** GOT A FAVOR *** 
put #parse FAVOR DONE
put #parse FAVOR DONE
exit


automove:
var toroom $0
automovecont:
matchre automove.return YOU HAVE ARRIVED|SHOP CLOSED
matchre automovecont YOU HAVE FAILED|MOVE FAILED
put #goto %toroom
matchwait

automove.return:
pause 0.1
RETURN
RETURN:
RETURN
