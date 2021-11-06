#debug 10

var tables 
action (shop) var tables %tables|$1 when shop .(\d+)
action action (shop) on when ^The following items contain goods
action action (shop) off when ^\[Type SHOP
action (shop) off

var Market.Plaza.start 2
var Market.Plaza.rooms 14|15|16|10|9|8|6|5|4|35|42|41|40|39|38|37|36|29|30|31|33|32|34

var Riverhaven.start 429
var Riverhaven.rooms 430|431|432|433|434|435|436|437|438|439

counter set 0

eval zone replacere("$zonename", " ", ".")

if ($roomid != %%zone.start) then
{
send #goto %%zone.start
exit
}

Next.Room:
  put #goto %%zone.rooms(%c)
  waitforre YOU HAVE ARRIVED	
	counter add 1
	
Shop.Room:
	put #xml
	gosub doshop door
  gosub doshop arch
  gosub doshop entrance
  put #xml
	if %c > count("%%zone.rooms","|") then goto Finish
	else goto Next.Room

Finish:
 put #goto %%zone.start
exit

# ----------------------------------------------

doshop:
var tables 
gosub moveshop $0
if %insideshop = 0 then
{
put #echo >Log ""
put #echo >Log === RoomId: %myroomid, Shop: $1 - CLOSED ===
return
}
put #echo >Log ""
put #echo >Log === RoomId: %myroomid, Shop: $1, Room Name: $roomname ===

gosub shop
eval table_count count("%tables", "|")
var index 1
var parsedtables 
gosub doparseshop
gosub move out
return

doparseshop:
if %index > %table_count then return
var target %tables(%index)

var parsedtables %parsedtables|%target
action (shoplist) on
gosub shop "#%target"
action (shoplist) off
math index add 1
goto doparseshop

# ----------------------------------------------

move:
var dir $0
moving:
matchre pausethenmove %retry_messages
matchre moving.done ^Obvious
put %dir
matchwait
pausethenmove:
pause 0.2
goto moving
moving.done:
var myroomid $roomid
return

moveshop:
var dir $0
moveshop.move:
var insideshop 0
matchre moveshop.pause %retry_messages
matchre return ^An attendant approaches you and says
matchre moveshop.inside ^Obvious
put go %dir
matchwait
moveshop.pause:
pause 0.2
goto moveshop.move
moveshop.inside:
var insideshop 1
return

shop:
gosub do "shop $1" "^There is nothing to buy here|^\[Type SHOP|^The SHOP verb"
return

return:
return

# ---

do:
var cmd $1
var success_messages $2
goto put_do
put_do:
matchre put_retry %retry_messages
if len("%success_messages") > 0 then matchre return %success_messages
put %cmd
matchwait
put_retry:
pause 0.2
goto put_do