#debug 10
var ranks 10|20|20|30|30|40|40|50|50|60|60|70|70|80|80|90|90|100|100|100|100|100|100|100|100|100|100|100|120|120|120|140|140|160|160|180|180|180|200|200|220|220|230|240|240|260|260|260|280|300|300|320|320|340|340|360|360|380|380|400|410|420|430|440|450|460|470|480|490|500|510|520|530|540|550|560|570|580|590|600|610|620|630|640|650|660|670|680|690|700|710|720|730|740|750|760|770|780|790|800|810|820|830|840|850|860|870|880|890|900|910|920|930|940|950|960|970|980|990|1000|1050|1050
var charts Rat|Croff Pothanit|Heggarangi Frog|Brocket Deer|Scavenger Gobli|Wild Boar|Silver Leucro|Grass Eel|Striped Badger|Blood Dryad|Equine|Blood Nyad|Glutinous|Kelpie|Trollkin|Boggle|Cougar|Dwarven|Elothean|Elven|Gnome|Gor'Tog|Halfling|Human|Kaldar|Prydaen|Rakash|S'Kra Mur|Boobrie|Snow Goblin|Thunder Ram|Copperhead|Malodorous|Dusk Ogre|Young Ogre|Bison|Rock Troll|Sun Vulture|Fire Maiden|Moss Mey|Prereni|Vela'tohr|Peccary|Blue-belly|Kashika Serpent|River Caiman|Sluagh|Wood Troll|Gidii|Black Goblin|Granite|Rhoat Moda|River Sprite|Bawdy Swain|Swamp Troll|Heggarangi Boar|Warcat|Blacktip Shark|Piranha|Lanky Grey Lach|Ape|Merrows|Selkie|Geni|Trekhalo|Giant|Bobcat|Snowbeast|Arzumos|Caracal|Firecat|Gryphon|Seordmaor|Bull|Mammoth|Hawk|Armadillo|Shark|La'heke|Angiswaerd|Toad|Elsralael|Celpeze|Spider|Silverfish|Crab|Westanuryn|Dolomar|Warklin|Wasp|Dryad|Fendryad|Sprite|Alfar|Frostweaver|Spriggan|Gremlin|Cyclops|Atik'et|S'lai|Adan'f|Kra'hei|Faenrae|Bear|Barghest|Shalswar|Dyrachis|Poloh'izh|Korograth|Larva|Bizar|Pivuh|Vulture|Unyn|Moruryn|Moth|Kartais|Colepexy|Vykathi|Wyvern|Elpalzi|Xala'shar
var Playing 0
action var currentchart $1 when ^You turn to page \d+ of your textbook, containing (.*) physiology\.
action var currentchart $1 when ^You turn to the section on (.*) physiology
action var Playing 1 when ^You begin .* on your .*|^You\'re already playing a song|^You .* as you begin a|^You effortlessly begin a .* on your .*|^You maneuver through a difficult|^You cannot (use|play) the .* while in combat\!
action var Playing 0 when ^Your song comes to an end\.|^In the name of love\?|^You stop playing|^You cannot play that|^You finish playing

eval skill tolower(%1)
if matchre("first", "%skill") then goto first
if matchre("scholarship, "%skill") then goto scholarship
exit

first:
evalmath minranks $Scholarship.Ranks - 100
evalmath maxranks $Scholarship.Ranks + 100
if %minranks < 0 then var minranks 0
eval totalcharts count("%ranks", "|")
goto getranks

scholarship:
var maxranks $Scholarship.Ranks
evalmath minranks $Scholarship.Ranks - 200
if %minranks < 0 then var minranks 0
eval totalcharts count("%ranks", "|)
goto getranks

getranks:
gosub getmin
gosub getmax
goto read

getmin:
var tracker 0
getmin1:
if %minranks < 10 then 
	{
	var lowchart %charts(0)
	return
	}
if %minranks < %ranks(%tracker) then
	{
	math tracker subtract 1
	var lowchart %charts(%tracker)
	var chartnumber %tracker
	return
	}
math tracker add 1 
goto getmin1


getmax:
var tracker 0
getmax1:
if %maxranks > 1050 then 
	{
	var highchart %charts(%totalcharts)
	return
	}
if %maxranks < %ranks(%tracker) then
	{
	math tracker subtract 1
	var highchart %charts(%tracker)
	return
	}
math tracker add 1
goto getmax1

read:
put turn textbook to %lowchart
pause 0.5
charts:
if %Playing = 0 then 
	{
	put play $Song
	pause 1
	}
matchre charts ^\.\.\.wait|^Sorry,
match next With a sudden moment of clarity,
match next In a sudden moment of clarity
match next having a difficult time comprehending the advanced text
match next Why do you need to study this chart again?
match chartsdone You take on a studious look
match chartsdone What were you referring to
match chartsdone find it almost impossible to do
match chartsdone You attempt to study
match OPEN You think that you could OPEN
match expcheck You begin
match expcheck You continue studying the
match expcheck You continue to study
put study my textbook
matchwait

open:
put open my textbook
goto charts

expcheck:
if $%skill.LearningRate > 30 then goto chartsdone
if "%skill" = "First_Aid" then goto next
goto charts

next:
math chartnumber add 1
if $%skill.LearningRate > 30 then goto chartsdone
if matchre("%currentchart", "%highchart") then goto chartsdone
put turn my textbook to %charts(%chartnumber)
pause 0.5
goto charts

chartsdone:
pause
put stop play
put stow textbook
pause
put #parse TEXTBOOK DONE
