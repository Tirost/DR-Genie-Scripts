#Ingot cutting.

var material %1
var size %2

action var matstow $1 when from inside your (.*)\.$
if_2 goto cutstart
echo Usage is: .cut_ing <material> <size>
exit

CutStart:
	pause
	pause 1
	send turn cutter to %size
	send get my %material ingot
	match cutloop You get
	match end referring
	matchwait

CutLoop:
	pause
	pause 1
	send push %material ing with cutter
	match stowcut cuts the ingot
	match finish need more metal
	matchwait

StowCut:
	pause
	pause 1
	send put second ing in my %matstow
	goto cutloop

Finish:
	echo Material insufficient to continue. Script complete.
	exit

End:
	echo Material insufficient to cut to that size. Script exiting.
	exit