#################################################
# VAULT script by Shroom of TF
# Auto-enter vault and looks inside 
# Waits for you to be done
# Type "DONE" to auto-leave vault 
# Pays your rent if needed
# Start inside any city you own a vault 
##############################################
gosub automove vault
pause 0.3
if contains("$roomobjs", "Carousel Square") then put go square
pause 0.2
pause 0.2
if contains("$roomobjs", "vault") then put go vault
pause 0.2
pause 0.1
put go door
pause 0.3
pause 0.2
pause 0.1
vault:
1.ARCH:
pause 0.1
matchre PAY.RENT rent
matchre VAULT.GO escorts you
matchre 2.ARCH blocks|someone|using|Sorry
put go arch
matchwait
2.ARCH:
matchre PAY.RENT rent
matchre VAULT.GO escorts you
matchre 3.ARCH blocks|someone|using|Sorry
put go second arch
matchwait
3.ARCH:
matchre PAY.RENT rent
matchre VAULT.GO escorts you
matchre NO.ARCH blocks|someone|using|Sorry
put go third arch
matchwait
NO.ARCH:
echo NO ARCH AVAILABLE! WAITING.... 
pause 10
goto 1.ARCH

PAY.RENT:
pause 0.5
gosub automove teller
send with 8 gold
pause 0.1
pause 0.1
pause 0.1
gosub automove exchange
put exchan all dok to kro
put exchan all lir to kro
pause 0.1
pause 0.1
if ("$zoneid" = "67") then gosub automove 138
if ("$zoneid" = "116") then gosub automove 288
if ("$zoneid" = "61") then gosub automove 169
if ("$zoneid" = "47") then gosub automove 273
if ("$zoneid" = "42") then gosub automove 28
if ("$zoneid" = "30") then gosub automove 362
if ("$zoneid" = "1") then gosub automove 188
if ("$zoneid" = "99") then gosub automove 141
if ("$zoneid" = "107") then gosub automove 219
if ("$zoneid" = "90") then gosub automove 261
if ("$zoneid" = "127") then gosub automove 532
put pay 5000
pause 0.1
pause 0.1
move out
goto 1.ARCH

VAULT.GO:
put pull lever
pause 0.3
pause 0.4
send go door
pause 0.2
pause 0.2
pause 0.2
pause 0.4
send open vault
echo
echo *** TYPE "DONE" to LEAVE VAULT
echo
pause 0.1
pause 0.2
pause 0.2
VAULT.LOOK:
send look in vault
pause 0.5
send look on shelf
echo **** LOOKING IN YOUR VAULT!
echo **** TYPE DONE to LEAVE VAULT
put #parse VAULT
matchre VAULT.LEAVE \b(DONE|done)\b
matchwait 60
goto VAULT.LOOK

VAULT.LEAVE:
echo
echo LEAVING VAULT!
echo
pause 0.1
pause 0.1
put close vault
wait
pause 0.2
pause 0.1
move go door
pause 0.2
pause 0.1
move go arch
pause 0.2
move out
pause 0.2
pause 0.2
put out
pause 0.2
VAULT.DONE:
echo
echo *** DONE WITH VAULT SCRIPT!
echo
exit

AUTOMOVE:
     delay 0.0001
     var Destination $0
     var automovefailCounter 0
     if (!$standing) then gosub AUTOMOVE_STAND
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     delay 0.0001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     put #goto %Destination
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
     if (%automovefailCounter > 5) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.5
     pause 0.1
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     put #echo
     put #echo >$Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >$Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
     exit
AUTOMOVE_RETURN:
     return