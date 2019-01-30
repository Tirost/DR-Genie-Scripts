#Weapon grinding.

var weapon %1

if_1 goto getweapon
echo Usage is: .balancing <weapon>
exit

GetWeapon:
	pause
	pause 1
	send get my weapon book
	send study book
	pause
	pause 1
	send put book in my have
	pause 1
	match turnwheel You get
	match end What were you referring
	send get %weapon in my have
	matchwait

TurnWheel:
	pause
	pause 1
	if $lefthandnoun = brush then send put brush in my haversack
	match grindweapon keeping it spinning fast
	match turnwheel Roundtime:
	send turn grind
	matchwait

GrindWeapon:
	pause
	pause 1
	match finishweapon pouring oil on it
	match brushweapon nicks and burs 
	match turnwheel Roundtime:
	send push grind with %weapon
	matchwait

BrushWeapon:
	pause
	pause 1
	send get my brush
	match finishweapon pouring oil on it
	match turnwheel Roundtime:
	send rub %weapon with brush
	matchwait

FinishWeapon:
	pause
	pause 1
	if $lefthandnoun = brush then send put brush in my haversack
	send get oil
	pause 1
	send pour oil on %weapon
	pause
	pause 1
	send put oil in my sack
	send put %weapon in my back
	goto getweapon

End:
	echo All weapons balanced. Script complete.
	exit