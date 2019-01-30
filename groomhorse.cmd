#Horse grooming script by Azarael

#You must have all the proper grooming tools!!

#debug 10

var needs.food 0
var needs.coat 0
var needs.mane 0
var nograss 0
var hoof 0

action var needs.food 1 when feed the horse
action var needs.coat 1 when coat (?:could use|is a bit)
action var needs.mane 1 when mane and tail (?:could use|is a bit)

gosub Stow right
gosub Stow left

pause 1
Study:
	match Study you let the horse sniff you
	match Start You look over the horse carefully
	match end referring to
	put study horse
	matchwait
	
Start:
	pause 1
	if ((%needs.food = 1) && (%nograss = 0)) then goto FeedHorse
	else if ((%needs.food = 1) && (def("ALTFOOD"))) then goto AltFeed
	if !("$righthand" = "Empty") then gosub Stow right
	if %needs.mane = 1 then gosub CleanMane
	if !("$righthand" = "Empty") then gosub Stow right
	if %needs.coat = 1 then gosub CleanCoat
	goto CleanHooves
		
FeedHorse:
	match NoGrass Roundtime
	match GiveHorse grass
	put forage grass
	var needs.food 0
	matchwait
	
GiveHorse:
	put feed horse
	goto Study
	
AltFeed:
	match GiveHorse You get
	match AltOut referring
	put get my $ALTFOOD
	matchwait
	
AltOut:
	put #beep
	echo Out of alternate food.
	echo Not feeding horse.
	var need.food 0
	goto Start
	
NoGrass:
	echo No grass available to forage.
	var nograss 1
	goto Start
	
CleanMane:
	gosub DoClean
	pause
	gosub DoClean
	pause
	gosub Get brush soft
	pause
	gosub DoClean brush
	pause
	gosub DoClean brush
	pause
	gosub Stow right
	gosub Get brush mane
	gosub DoClean brush
	pause
	return
	
CleanCoat:
	gosub Get comb
	gosub DoClean
	pause
	gosub Stow right
	gosub Get brush stiff
	gosub DoClean brush
	pause
	put turn my brush
	gosub DoClean brush
	pause
	gosub DoClean brush
	pause
	gosub Stow right
	return
	
CleanHooves:
	if %hoof = 4 then
		{
		gosub Stow right
		goto Finish
		}
	pause
	if $righthand = Empty then gosub Get pick
	match CleanHooves Roundtime
	match Finish short while
	gosub DoClean
	math hoof add 1
	matchwait
	
DoClean:
	if $1 = brush then put brush horse
	else put clean horse
	return
	
Get:
	var tool $1
	var type $2
	
	if %type = mane then
		{
		put get my mane brush
		return
		}
	if %tool = brush then
		{
		match return You get
		match AltGet referring
		put get my %type %tool
		matchwait
		}
	put get my %tool
	return
	
AltGet:
	if %type = soft then put get my stiff brush
	if %type = stiff then put get my soft brush
	put turn my brush
	return

Stow:
	put stow $$1handnoun in my $GROOMSTOW
	return
	
Return:
	return
	
Finish:
	gosub Stow right
	echo Horse has been fed and groomed.
	echo Exiting script.
	exit