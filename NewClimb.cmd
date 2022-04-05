## Climbing script.
## Supports Crossing, Riverhaven (Swimming), Shard, Outside Shard North & East Gate, Wyvern Mountain, Boar Clan
	## Crossing|Shard|OutsideShard|WyvernMountain/BoarClan Climbing by Boobear
	## Swimming Script compiled by Thyon
	## Underwharf swimming by Nithogr
	## Faldesu part by... someone else - not sure who


##DEBUG 10
ACTION send exit when eval $health < 60

if_1 then var target_rate %1
else var target_rate 30

send #var room_temp $roomid

## ********
START_OVER:
if ("$zoneid" = "127") then {
	## BOAR_CLAN TREE CLIMBING
	var TREE_ROOMS 166|165|168|172|174|183|175|179|182|200|184|193|187|193|211|214|211|193|187|193|184|200|182|179|175|183|174|172|168|165|166
	eval TREE_ROOMS.count count("%TREE_ROOMS","|")
	var room_counter 0
	gosub CLIMB_BOARCLAN
	put #parse ATHLETICS DONE
	EXIT
}
if ("$zoneid" = "69") then {
	## WYVERN_MOUNTAIN CLIMBING
	GoSub CLIMB_WYVERNS
	gosub ROOM_CHECK $room_temp
	put #parse ATHLETICS DONE
	EXIT
if ("$zoneid" = "1") then {
	##CROSSING Climbing locations
	var CLIMB.ZONE CROSSING
	var ROOM.NUMBER 68|170|171|172|252|386|387|387|395|396|396|398|399|768
	var ROOM.CLIMB bank|wall|wall|wall|tree|embrasure|break|embrasure|embrasure|break|embrasure|embrasure|embrasure|trunk
}
if ("$zoneid") = "67") then {
	#SHARD Climbing locations
		var CLIMB.ZONE SHARD
		var ROOM.NUMBER 1|32|42|43|48|127|128|130|131|133|134|199|228|1|EAST-SHARD
		var ROOM.CLIMB ladder|ladder|city wall|ladder|city wall|ladder|embrasure|ladder|embrasure|ladder|embrasure|stairway|embrasure|ladder|NULL
}
if ("$zoneid" = "66") then {
	#Outside SHARD North & East Gates - Climbing locations
		var CLIMB.ZONE OUTSIDE_EAST-SHARD
		var ROOM.NUMBER 16|26|80|174|189|202|257|298|300|476|477|666|INSIDE-SHARD
		var ROOM.CLIMB tall cottonwood|steep trail|low stile|boulders|ridge|ladder|deadfall|tree|trunk|ledge|ledge|tree|NULL
}
if ("$zoneid" = "30") then {
	#RIVERHAVEN! --- SWIM!
	var target_rate 15
	GoSub ROOM_CHECK 8
	goto Underwharf
	# if ($Athletics.Ranks < 75) then goto Glade
	# if (($Athletics.Ranks > 74) && ($Athletics.Ranks < 399)) then goto Underwharf
	# if ($Athletics.Ranks > 400) then goto Faldesu 
}

eval ROOM.COUNT count ("%ROOM.NUMBER", "|")
counter set 0

## ********
MAIN:
	if ($Athletics.LearningRate >  %target_rate) then GOTO END
	if (%c > %ROOM.COUNT) then counter set 0
	
	if (matchre (%ROOM.NUMBER(%c),"EAST-SHARD")) then {
		var CLIMB.ZONE OUTSIDE_EAST-SHARD
		GoSub MAP_CHECK
		GOTO START_OVER
	}
	if (matchre (%ROOM.NUMBER(%c),"INSIDE-SHARD")) then {
		var CLIMB.ZONE SHARD
		GoSub MAP_CHECK
		GOTO START_OVER
	}
	GoSub MAP_CHECK
	put #ECHO >Output Going to %ROOM.NUMBER(%c) , %ROOM.CLIMB(%c)
	ECHO ****** CLIMBING %CLIMB.ZONE, ---->>>Going to RM: %ROOM.NUMBER(%c) to climb the: %ROOM.CLIMB(%c)

	GoSub ROOM_CHECK %ROOM.NUMBER(%c)
	GoSub CLIMB %ROOM.CLIMB(%c)
	counter add 1
	wait .1
	GOTO MAIN

## ********
MAP_CHECK:
	if (%CLIMB.ZONE = "CROSSING") then {
	## CROSSING Map checks
			## zoneid-4 is Outside Crossing West Gate
		if $zoneid = 4 then GoSub ROOM_CHECK 14
			## zoneid-6 is Outside Crossing North Gate
		if $zoneid = 6 then GoSub ROOM_CHECK 23
			## zoneid-7 is Outside Crossing, Northern Trade Road
		if $zoneid = 7 then GoSub ROOM_CHECK 349
			## zoneid-8 is Outside Crossing East Gate
		if $zoneid = 8 then GoSub ROOM_CHECK 43
		    ## zoneid = 1 is Crossing
		if $zoneid = 1 then RETURN	
	}
	if (%CLIMB.ZONE = "SHARD") then {
	## SHARD MAP Checks
			##zoneid = 67 is Shard
		if $zoneid = 67 then RETURN
			##zoneid = 68 is South Gate
		if $zoneid = 68 then GoSub ROOM_CHECK 225
			##zoneid = 69 is Outside West gate (Can't go in if not a citizen)
		if $zoneid = 69 then GoSub ROOM_CHECK 1
			##zoneid = 66 is Outside East & North gate (Go back in shard through East Gate (#216))
		if $zoneid = 66 then GoSub ROOM_CHECK 216
	}
	if (%CLIMB.ZONE = "OUTSIDE_EAST-SHARD") then {
			##zoneid = 66 is Outside North Shard
		if $zoneid = 66 then RETURN
			##zoneid = 67 is Inside Shard
		if $zoneid = 67 then GoSub ROOM_CHECK 132

	}
	wait .1
	GOTO MAP_CHECK

## ********
CLIMB:
	send climb $0
	wait .5
	RETURN
		
## ********
ROOM_CHECK:
	var Tmp_Room_ID $1
	var Tmp_Map_ID $zoneid
## ********
ROOM_CHECK.SUB:	
	wait .3
	if (($roomid != %Tmp_Room_ID) && ("$zoneid" = %Tmp_Map_ID) then {
			matchre RETURN ^YOU HAVE ARRIVED
			matchre ROOM_CHECK.SUB FAILED
			matchre ROOM_CHECK.SUB Destination ID
		put #goto %Tmp_Room_ID
		matchwait 15
		GOTO ROOM_CHECK.SUB
	}
	RETURN
}
RETURN
	
## ********
END:
	send #parse CLIMB DONE
	EXIT

## ********
RETURN1:
	RETURN
	

	
## *****
CLIMB_WYVERNS:
	gosub ROOM_CHECK 14
	gosub ROOM_CHECK 462
	gosub ROOM_CHECK 520
	gosub ROOM_CHECK 522
	gosub ROOM_CHECK 525
	gosub ROOM_CHECK 467
	gosub ROOM_CHECK 473
	gosub ROOM_CHECK 537
	gosub ROOM_CHECK 493
	gosub ROOM_CHECK 502
	gosub ROOM_CHECK 510
	gosub ROOM_CHECK 487
	gosub ROOM_CHECK 514
	gosub ROOM_CHECK 14
	send collect rock
	pause 14
	send kick rocks
	pause 1
	send collect rock
	pause 14
	send kick rocks
	pause 1
	if ($Athletics.LearningRate < 30) then GOTO CLIMB_WYVERNS

	RETURN






	
## ************	
CLIMB_BOARCLAN:
	gosub ROOM_CHECK %TREE_ROOMS(%room_counter)
	send climb tree
	pause 2
	if ($roomid = 0) then gosub CLIMB_DOWN_TREE
	math room_counter add 1
	if ($Athletics.LearningRate > 30) then {
		gosub ROOM_CHECK $room_temp
		RETURN
	}
	if (%room_counter = %TREE_ROOMS.count) then var room_counter 0
	goto CLIMB_BOARCLAN

## ************	
CLIMB_DOWN_TREE:
	if ($roomid = 0) then {
		gosub RETREAT
		send climb tree
		pause 2
		GOTO CLIMB_DOWN_TREE
	}
	RETURN



## ************	
RETREAT:
	wait .1
		matchre RETURN ^You retreat from combat.|^You are already as far away as you can get!
		matchre RETREAT ^You should stop practicing
		matchre RETREAT ^\.\.\.wait|^Sorry\,
	send retreat
	matchwait 1
	GOTO RETREAT
	
	
	
	
	
	
	
	
	
	

######################## RIEVERHAVEN SWIMMING SECTION ----- CLEAN THIS UP LATER , Doesn't work as good as I"d like.----- 	
	
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
	send go gate
	move nw
	send go path
	send go trail
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
	if $Athletics.LearningRate > %target_rate then
	goto GladeHome
	else
	goto Swim
 
GladeHome:
	move s
	pause
	move sw
	pause
	send go trail
	pause 1
	send go path
	pause 1
	move se
	send go gate
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
 put #parse ATHLETICS DONE
 exit

Underwharf:
	gosub ROOM_CHECK 176
	gosub ROOM_CHECK 194
	if ($Athletics.LearningRate > %target_rate) then {
		gosub ROOM_CHECK 8
		put #parse ATHLETICS DONE
		exit
	}
	goto Underwharf


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
	send look
	matchwait


swim.faldesu.north:
	pause .5
	matchre swim.faldesu.northwest ^An enormous slab of rock is upthrust in the river to the north 
	matchre swim.faldesu.return North Bank\]$|^You can't swim in that direction
	matchre swim.faldesu.north ^Obvious paths:|^...wait|^Sorry|^You slap|^You struggle
	send n
	matchwait

swim.faldesu.northwest:
	pause .5
	matchre swim.faldesu.northeast ^The rushing waters split around a huge boulder rising out of the river to the east
	matchre swim.faldesu.northwest ^...wait|^Sorry|^An enormous slab of rock is upthrust in the river to the north|^You work against
	matchre swim.faldesu.south ^You slap
	send nw
	matchwait

swim.faldesu.northeast:
	pause .5
	matchre swim.faldesu.north ^An enormous slab of rock is upthrust in the river to the south
	matchre swim.faldesu.northeast ^...wait|^Sorry|^You slap|^The rushing waters split around a huge boulder rising out of the river to the east|^You work against
	send ne
	matchwait

swim.faldesu.south:
	pause .5
	matchre swim.faldesu.southwest ^An enormous slab of rock is upthrust in the river to the south
	matchre swim.faldesu.return South Bank]$|You can't swim in that|^You can't swim in that direction
	matchre swim.faldesu.south ^Obvious paths:|^...wait|^Sorry|^You slap|^You struggle
	send s
	matchwait

swim.faldesu.southwest:
	pause .5
	matchre swim.faldesu.southeast ^The rushing waters split around a huge boulder rising out of the river to the east
	matchre swim.faldesu.southwest ^...wait|^Sorry|^You slap|^An enormous slab of rock is upthrust in the river to the south|^You work against
	send sw
	matchwait

swim.faldesu.southeast:
	pause .5
	matchre swim.faldesu.south ^An enormous slab of rock is upthrust in the river to the north
	matchre swim.faldesu.southeast ^...wait|^Sorry|^You slap|^The rushing waters split around a huge boulder rising out of the river to the east|^You work against
	send se
	matchwait

swim.faldesu.return:
	if $Athletics.LearningRate > %target_rate then
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
	****************
	YOU'RE HOME
	****************
	pause 2
	 put #parse ATHLETICS DONE	
	 EXIT
	
	
	
	
