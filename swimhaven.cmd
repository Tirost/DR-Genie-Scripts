
echo *********************************
echo *********************************
echo *****Start at the Town Square****
echo *********************************
echo *********************************
pause 3
if $Athletics.Ranks < 80 then goto Glade
if $Athletics.Ranks < 95 then goto Barghests
if $Athletics.Ranks < 110 then goto Underwharf
if $Athletics.Ranks < 200 then goto Faldesu

Glade:
move w
move w
move w
pause 1
move w
move w
move w
pause 1
move w
put go gate
move nw
put go path
put go trail
pause .5
move ne
pause
move n
pause

Swim:
move n
pause
move sw
pause
move e
pause

mindcheck:
if $Athletics.LearningRate > 33 then
goto GladeHome
else
goto Swim
 
GladeHome:
move s
pause
move sw
pause
put go trail
pause 1
put go path
pause 1
move se
put go gate
pause .5
move e
move e
move e
pause .5
move e
move e
pause .5
move e
move e
pause 3
echo ************
echo You're Home!
echo ************
exit

Underwharf:
move w
move w
move w
move w
move w
send climb ladder
send go gap
goto swim2

swim2:
put #goto 194
waiteval !matchre("$scriptlist","automapper\.cmd")
put #goto 176
waiteval !matchre("$scriptlist","automapper\.cmd")
goto mindcheck2

mindcheck2:
if $Athletics.LearningRate > 33 then
goto Home2
else
goto swim2

Home2:
send go gap
send climb ladder
move e
move e
move e
move e
move e
echo **************
echo   YOU'RE HOME
echo **************
PAUSE 3
exit

Barghests:
put #goto 174
pause 5
put #goto 29
pause 4
put #goto 44
pause 5
goto Practice

Practice:
timer:
	timer clear
	timer start

Start:
put climb practi upper.branches
if $Athletics.LearningRate = 34 then {
		ECHO *** Mind Locked after %t seconds! Gracefully exiting the script. ***
		timer stop
		goto GoHome
                } else {
		match Start You finish practicing
                matchwait

GoHome:
put stop climb
put #goto #46
pause 5
put #goto 1
pause 5
#goto 8
pause 7
echo ********************
echo    YOU'RE HOME
echo ********************
exit

Faldesu:
move e
move e
move e
move e
move e
move e
move e
pause
send go gate
pause 1
send dive river
pause 2

swim3:
pause 2
swim.faldesu.look:
matchre swim.faldesu.north South Bank\]
matchre swim.faldesu.south North Bank\]
put look
matchwait


swim.faldesu.north:
pause .5
matchre swim.faldesu.northwest ^An enormous slab of rock is upthrust in the river to the north 
matchre swim.faldesu.return North Bank\]$|^You can't swim in that direction
matchre swim.faldesu.north ^Obvious paths:|^...wait|^Sorry|^You slap|^You struggle
put n
matchwait

swim.faldesu.northwest:
pause .5
matchre swim.faldesu.northeast ^The rushing waters split around a huge boulder rising out of the river to the east
matchre swim.faldesu.northwest ^...wait|^Sorry|^An enormous slab of rock is upthrust in the river to the north|^You work against
matchre swim.faldesu.south ^You slap
put nw
matchwait

swim.faldesu.northeast:
pause .5
matchre swim.faldesu.north ^An enormous slab of rock is upthrust in the river to the south
matchre swim.faldesu.northeast ^...wait|^Sorry|^You slap|^The rushing waters split around a huge boulder rising out of the river to the east|^You work against
put ne
matchwait

swim.faldesu.south:
pause .5
matchre swim.faldesu.southwest ^An enormous slab of rock is upthrust in the river to the south
matchre swim.faldesu.return South Bank]$|You can't swim in that|^You can't swim in that direction
matchre swim.faldesu.south ^Obvious paths:|^...wait|^Sorry|^You slap|^You struggle
put s
matchwait

swim.faldesu.southwest:
pause .5
matchre swim.faldesu.southeast ^The rushing waters split around a huge boulder rising out of the river to the east
matchre swim.faldesu.southwest ^...wait|^Sorry|^You slap|^An enormous slab of rock is upthrust in the river to the south|^You work against
put sw
matchwait

swim.faldesu.southeast:
pause .5
matchre swim.faldesu.south ^An enormous slab of rock is upthrust in the river to the north
matchre swim.faldesu.southeast ^...wait|^Sorry|^You slap|^The rushing waters split around a huge boulder rising out of the river to the east|^You work against
put se
matchwait

swim.faldesu.return:
mif $Athletics.LearningRate > 33 then
goto FaldesuHome
else
goto swim3


FaldesuHome:
send climb bridge
send go gate
move w
move w
move w
move w
move w
move w
move w
pause 
echo ****************
echo    YOU'RE HOME
echo ****************
pause 2
exit
