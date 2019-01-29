## Climbing script.
## Supports Crossing, Shard, Outside Shard North & East Gate

##DEBUG 10
ACTION send exit when eval $health < 60

START_OVER:
if $zoneid = 1 then {
	##CROSSING Climbing locations
	var CLIMB.ZONE CROSSING
	var ROOM.NUMBER 68|170|171|172|252|386|387|387|395|396|396|398|399|768
	var ROOM.CLIMB bank|wall|wall|wall|tree|embrasure|break|embrasure|embrasure|break|embrasure|embrasure|embrasure|trunk
}
if $zoneid = 67 then {
	#SHARD Climbing locations
		var CLIMB.ZONE SHARD
		var ROOM.NUMBER 1|32|42|43|48|127|128|130|131|133|134|199|228|1|EAST-SHARD
		var ROOM.CLIMB ladder|ladder|city wall|ladder|city wall|ladder|embrasure|ladder|embrasure|ladder|embrasure|stairway|embrasure|ladder|NULL
}
if $zoneid = 66 then {
	#Outside SHARD North & East Gates - Climbing locations
		var CLIMB.ZONE OUTSIDE_EAST-SHARD
		var ROOM.NUMBER 16|26|80|174|189|202|257|298|300|476|477|666|INSIDE-SHARD
		var ROOM.CLIMB tall cottonwood|steep trail|low stile|boulders|ridge|ladder|deadfall|tree|trunk|ledge|ledge|tree|NULL
}

eval ROOM.COUNT count ("%ROOM.NUMBER", "|")
counter set 0

MAIN:
	if $Athletics.LearningRate > 33 then GOTO END
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

CLIMB:
	send climb $0
	wait .5
	RETURN
		
ROOM_CHECK:
    setvar temp $0
ROOM_CHECK.SUB:	
wait .3
if $roomid != %temp then {
		matchre RETURN1 YOU HAVE ARRIVED
		matchre ROOM_CHECK.SUB FAILED
		matchre ROOM_CHECK.SUB Destination ID
	put #goto %temp
	matchwait 30
	GOTO ROOM_CHECK.SUB
}
RETURN
	
END:
	send #parse CLIMB DONE
	EXIT

RETURN1:
	RETURN
