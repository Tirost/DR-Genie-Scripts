#debuglevel 10
ECHO ## Uses guild contact skill to find current Haven Bolt-Hole. Will travel to location and pause. Type Bankit to return to Town Square
ECHO ## Need to create global variable haven.pw for your guild password.
ECHO ##
Start:
put contact guild
matchre Crescentway ^(.*)A visit to Crescent Way might be worth your time\.\"
matchre Teahouse ^(.*)Well I'll tell you, the boss is with his own kind\.\.\. if you know what I mean\.\"
matchre Rookery ^(.*)I'd suggest checking around the rookery\.\"
matchre Pawnshop ^(.*)They're at a convenient spot to be selling off some stolen goods\.\"
matchre Silvermoon ^(.*)"Silvermoon Road would be a good place to start\.\"
matchre ChickenCoop ^.*Well, they're certainly cooped up somewhere\.\"
matchwait

ChickenCoop:
put #goto 41
waitforre ^A group of animated Halfling children dart in wild\,|^The cobbled stone street of the Halfling Quarter is virtually silent here\.

put search
pause 2
put knock door
pause 1
put whisper $haven.pw
pause 2
put north
pause 1
put go corner
waitforre ^\[Thieves' Guild, A Shadowed Corner\]
ECHO ######### AT CHICKEN COOP BOLT HOLE #######
ECHO ######### TYPE BANKIT TO LEAVE #######
waitfor Bankit
put out
pause 1
put south
pause 1
put go door
pause 1
put #goto town square
waitforre ^\[Riverhaven, Town Square\]
ECHO ####### FINISHED ###########
goto End

Teahouse:
pause 1
put #goto 45
waitforre ^A tall, shed roof building stands out among the low
put look door
pause .5
put go footpath
pause .5
put search
pause 3
put knock grate
pause .5
put whisper $haven.pw
pause 2
put #goto 416
waitforre ^\[Thieves' Guild, A Shadowed Corner\]
ECHO ######## At Teahouse Way Bolt Hole #########
ECHO ######## Type Bankit to leave ########
waitfor Bankit
ECHO ####### ALL GOOD HEADING TO TOWN SQUARE ######
put #goto 388
waitforre ^Boxes and crates have been carefully piled
put go grate
pause .5
put #goto town square
waitforre ^\[Riverhaven, Town Square\]
ECHO ####### FINISHED ###########
goto End
  
Crescentway:
pause 1
put #goto Crescent Way
waitforre ^The mud-caked lane crosses the far more prosperous(.*)
put search
pause 3
put knock door
pause .5
put whisper $haven.pw
pause .5
put #goto 424
waitforre ^\[Thieves' Guild, A Shadowed Corner\]
ECHO ######## AT Crescent Way Bolt Hole #########
ECHO ######## Type Bankit to leave ########
waitfor Bankit
ECHO ####### ALL GOOD HEADING TO TOWN SQUARE ######
put out
pause 1
put out
pause 1
put go door
pause 1
put #goto town square
waitforre ^\[Riverhaven, Town Square\]
goto End

Rookery:
pause 1
put #goto rookery
waitforre ^\[Blind Alley, Corner Slip\]
pause 1
put search
pause 1
put knock door
pause 1
put whisper $haven.pw
pause 1
put #goto 427
waitforre ^\[Thieves' Guild, A Shadowed Corner\]
ECHO ######## At Rookery Bolt Hole #########
ECHO ######## Type Bankit to leave ########
waitfor Bankit
ECHO ####### ALL GOOD HEADING TO TOWN SQUARE ######
put #goto 390
waitforre ^Built out of scraps from wooden crates and boxes\,
pause 1
put go door
pause 1
pause 1
put #goto Town Square 
waitforre ^\[Riverhaven, Town Square\]
goto End

Pawnshop:
put #goto stolen goods
waitforre ^South of here, the road runs down to River Road and the river itself\.
put search
pause 2
put knock door
pause 1
put whisper $haven.pw
pause 1
put #goto 420
waitforre ^\[Thieves' Guild, A Shadowed Corner\]
ECHO ######## At Stolen Goods Bolt Hole #########
ECHO ######## Type Bankit to leave ########
waitfor Bankit
ECHO ####### ALL GOOD HEADING TO TOWN SQUARE ######
put #goto 389
waitforre ^\[Thieves' Guild Bolthole, Near the Pawnshop\]
pause .5
put go door
pause .5
put #goto Town Square 
waitforre ^\[Riverhaven, Town Square\]
goto End

Silvermoon:
put #goto silvermoon
waitforre ^A curiously ordinary shop somehow catches your eye\.
put search
pause 2
put knock door
pause 1
put whisper $haven.pw
pause 1
put #goto 422
waitforre ^\[Thieves' Guild, A Shadowed Corner\]
ECHO ######## At Silvermoon Road Bolt Hole #########
ECHO ######## Type Bankit to leave ########
waitfor Bankit
ECHO ####### ALL GOOD HEADING TO TOWN SQUARE ######
put #goto 386
waitforre ^\[Riverhaven, A Cramped Corridor\]
put out
pause .5
put #goto Town Square

End:
ECHO ###### END SCRIPT #######
ECHO #########################

