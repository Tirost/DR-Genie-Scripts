## Buy Throwing Blades by Shroom
## Start around Shard

include move.inc
include utility.inc
START:
     var tBlade 0
     put #echo >Log Pink **** RESTOCKING THROWING BLADES!
     if $zoneid = 68 then gosub automove shard
     if $zoneid = 69 then gosub automove shard
     if $zoneid = 66 then gosub automove shard
     if $zoneid = 66 then gosub automove shard
     if $zoneid = 67 then gosub automove teller
     pause 0.5
     send withdraw 5 plat
     gosub automove east
     gosub automove surv
     pause 0.1
     pause 0.1
BUYING.BLADES:
     delay 0.001
     pause 0.001
     pause 0.001
     matchre BLADE.ADD ^You decide to purchase|^The sales clerk
     matchre BLADE.WAIT ^That throwing|If you're trying|^Buy what\?
     put buy throwing blades
     matchwait 5
BLADE.WAIT:
     ECHO ***WAITING FOR THROWING BLADES TO RESTOCK!!!
     matchre BUYING.BLADES ^A young girl|^A young man
     put look
     matchwait 45
     goto BUYING.BLADES
BLADE.ADD: 
     pause 0.1
     math tBlade add 1
     if %tBlade > 30 then goto BLADE.RETURN
     if %tBlade < 10 then send stow blade in my hav
     if %tBlade < 20 then send stow blade in my bac
     if %tBlade < 30 then send stow blade in my bag
     if %tBlade = 30 then send stow blade 
     pause 0.1
     pause 0.1
     pause 0.1
     pause 0.001
     pause 0.001
     goto BUYING.BLADES
BLADE.RETURN:
     pause 0.1
     pause 0.1
     gosub stowing 
     pause 0.001
     gosub automove east
     ECHO ***** DONE!!!
     exit