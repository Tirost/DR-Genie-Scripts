if_1 goto STARTSTUDY
if ($zoneid != 1) then goto ERROR
if ($roomid != 534) then
     {
          put #goto 534
          waitfor ^YOU HAVE ARRIVED
     }
# move go build
# move n
# move climb step
# move climb stair
# move s

STARTSTUDY:
     gosub study sculpture
     gosub study painting
     gosub study carving
     gosub study statue
     gosub study second painting
     move w
     gosub study painting
     gosub study triptych
     gosub study statue
     gosub study figurine
     gosub study second painting
     move s
     gosub study cylinder
     gosub study panel
     gosub study sphere
     gosub study painting
     gosub study canvas
     gosub study statue
     move s
     gosub study painting
     gosub study diorama
     gosub study figure
     gosub study statue
     gosub study second painting
     move e
     gosub study painting
     gosub study diorama
     gosub study figure
     gosub study statue
     gosub study second painting
     put #goto 72
     waitfor ^YOU HAVE ARRIVED
put #parse DONE STUDY
exit

STUDY:
     setvariable object $0
     if $Scholarship.LearningRate > 30 then goto leavestudy%room
     put study %object
     pause 0.5
     pause 0.5
     return

ERROR:
     echo ===============================================
     echo ** ERROR! YOU MUST START SCRIPT IN CROSSINGS
     echo ===============================================
     exit