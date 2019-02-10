####################################
# Debt paying Script 
# By Shroom of TF 
####################################
var fine 0

echo ===========================
echo *** PAYING OFF YOUR DEBT!!
echo ===========================



TO.TELLER:
     var plat 20
     if ("$zoneid" = "116") then
          {
               gosub automove 1teller
               goto FINECHECK.FORFEDHDAR
          }
     if ("$zoneid" = "90") then
          {
               gosub AUTOMOVE 1teller
               goto FINECHECK.QI
          }
     gosub AUTOMOVE teller
     if ("$zoneid" = "107") then goto FINECHECK.QI
     if ("$zoneid" = "99") then goto FINECHECK.QI
     if ("$zoneid" = "90") then goto FINECHECK.QI
     if ("$zoneid" = "61") then goto FINECHECK.ZOLUREN
     if ("$zoneid" = "1") then goto FINECHECK.ZOLUREN
     if ("$zoneid" = "30") then goto FINECHECK.THERENGIA
     if ("$zoneid" = "34a") then goto FINECHECK.THERENGIA
     if ("$zoneid" = "42") then goto FINECHECK.THERENGIA
     if ("$zoneid" = "47") then goto FINECHECK.THERENGIA
     if ("$zoneid" = "67") then goto FINECHECK.ILITHI
     pause
     echo
     echo *** CRITICAL ERROR!
     echo *** UNSUPPORTED LOCATION!!
     echo
     put #echo >Log Red *** ERROR! UNSUPPORTED LOCATION: Zone- $zoneid Room- $roomid
     put #echo >Log Red *** PAY YOUR DEBT MANUALLY!
     pause 0.1
     exit
FINECHECK.QI:
var LOCATION FINECHECK.QI
     matchre SET.FINE Qi\.\s*\((\d+) copper Lirums\)
     match NO.FINE Wealth:
     send wealth
     matchwait
FINECHECK.THERENGIA:
var LOCATION FINECHECK.THERENGIA
     matchre SET.FINE Therengia\.\s*\((\d+) copper Lirums\)
     match NO.FINE Wealth:
     send wealth
     matchwait
FINECHECK.ZOLUREN:
var LOCATION FINECHECK.ZOLUREN
     matchre SET.FINE Zoluren\.\s*\((\d+) copper Kronars\)
     match NO.FINE Wealth:
     send wealth
     matchwait
FINECHECK.ILITHI:
var LOCATION FINECHECK.ILITHI
     matchre SET.FINE Ilithi\.\s*\((\d+) copper Dokoras\)
     match NO.FINE Wealth:
     send wealth
     matchwait
FINECHECK.FORFEDHDAR:
var LOCATION FINECHECK.FORFEDHDAR
     matchre SET.FINE Forfedhdar\.\s*\((\d+) copper Dokoras\)
     match NO.FINE Wealth:
     send wealth
     matchwait
SET.FINE:
     pause 0.1
     var fine $1
     pause 0.1
     math currentfine add %fine
     if (%fine > 250000) then goto BIGGER.FINE
     if (%fine > 100000) then goto BIG.FINE
     goto WITHDRAW
WITHDRAW:
var LOCATION WITHDRAW
     if ($invisible = 1) then gosub stopinvis
     pause 0.2
     pause 0.1
     matchre WITHDRAW ^\.\.\.wait|^Sorry\,
     matchre BANK.INVIS ^How can you withdraw money when the clerk can't even see
     matchre TO.TELLER ^You must be at a bank teller's window
     matchre PAY.DEBT ^The clerk counts out
     matchre NO.FUNDS we are not lending money|You don't have that much
     send withdraw %fine copper
     matchwait 15
     goto NO.FUNDS
BIG.FINE:
var LOCATION BIG.FINE
     if ($invisible = 1) then gosub stopinvis
     pause 0.2
     pause 0.1
     matchre BIG.FINE ^\.\.\.wait|^Sorry\,
     matchre BANK.INVIS ^How can you withdraw money when the clerk can't even see
     matchre TO.TELLER ^You must be at a bank teller's window
     matchre PAY.DEBT ^The clerk counts out
     matchre NO.FUNDS we are not lending money|You don't have that much
     send withdraw %plat plat
     matchwait 15
     goto NO.FUNDS
BANK.INVIS:
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
     goto %LOCATION
BIGGER.FINE:
var LOCATION BIGGER.FINE
     if (%fine > 200000) then var plat 25
     if (%fine > 250000) then var plat 35
     if (%fine > 350000) then var plat 40
     if (%fine > 400000) then var plat 45
     if (%fine > 450000) then var plat 50
     if (%fine > 500000) then var plat 90
     if (%fine > 900000) then var plat 120
     if (%fine > 1200000) then var plat 150
     if (%fine > 1500000) then var plat 200
     if (%fine > 2000000) then var plat 300
     goto BIG.FINE
NO.FINE:
     echo
     echo *** You have no fine!
     echo
     goto DONE.DEBT
PAY.DEBT:
var LOCATION PAY.DEBT
     echo
     echo **** Paying off your debt! ***
     echo
     pause 0.3
     # Walking to pay off the debt
     gosub AUTOMOVE debt
     if ($invisible = 1) then gosub stopinvis
     pause 0.2
     send pay %fine
     pause
     if ("$zoneid" = "116") then
          {
               gosub automove 1teller
               goto DONE.DEBT
          }
     if ("$zoneid" = "90") then
          {
               gosub AUTOMOVE 1teller
               goto DONE.DEBT
          }
     gosub AUTOMOVE teller
DONE.DEBT:
var LOCATION DONE.DEBT
     pause 0.1
     if ($invisible = 1) then gosub stopinvis
     send deposit all
     pause 0.1
     echo ===================================
     echo ** DONE! Paid off Debt: %fine 
     echo ===================================
     put #parse SCRIPT FINISHED!
     put #parse SCRIPT FINISHED!
     exit
     
     
##### AUTOMOVE SUBROUTINE #####
AUTOMOVE:
     delay 0.0001
     pause 0.0001
     var Destination $0
     var automovefailCounter 0
     if $roomid = 0 then GOSUB MOVE.RANDOM
     if (!$standing) then gosub AUTOMOVE.STAND
     if ("%goPawn" = "ON") then goto PAWN.SKIP
     if ("$roomid" = "%Destination") then return
AUTOMOVE.GO:
     matchre AUTOMOVE.FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE.RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE.RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE.RETURN ^SHOP IS CLOSED(?:\!)?
     matchre AUTOMOVE.INVIS ^The shop appears to be closed, and you can't flag anyone down without being seen
     matchre AUTOMOVE.FAIL.BAIL ^DESTINATION NOT FOUND
     send #goto %Destination
     matchwait
AUTOMOVE.STAND:
     pause 0.1
     matchre AUTOMOVE.STAND ^\.\.\.wait|^Sorry\,
     matchre AUTOMOVE.STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre AUTOMOVE.STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE.STAND ^You are still stunned\.
     matchre AUTOMOVE.STAND.PLAYING ^You are a bit too busy performing to do that\.
     matchre AUTOMOVE.RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE.RETURN ^You are already standing\.
     matchre AUTOMOVE.RETURN ^You begin to get up and
     send stand
     matchwait
AUTOMOVE.FAILED:
     evalmath automovefailCounter (automovefailCounter + 1)
     if (%automovefailCounter > 3) then goto AUTOMOVE.FAIL.BAIL
     send #mapper reset
     pause 0.5
     goto AUTOMOVE.GO
AUTOMOVE.FAIL.BAIL:
     put #echo
     put #echo >$Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >$Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo Crimson Skipping to next shop
     put #echo
     put #parse MOVE FAILED
     gosub clear
     goto %LAST
AUTOMOVE.RETURN:
     if matchre("%Destination", "teller|exchange|debt|PAWN") then if $invisible = 1 then gosub stopinvis
     pause 0.001
     return
AUTOMOVE.STAND.PLAYING:
     matchre AUTOMOVE.STAND ^You stop playing your song\.|^In the name of love\?
     send stop play
     matchwait 15
     goto AUTOMOVE.STAND
AUTOMOVE.INVIS:
     send hum scale
     pause 0.2
     send stop hum
     pause 0.5
     goto AUTOMOVE.GO