##Reasearch training script.
##Not for symbiosis!
##
## Script by Azrael - please give credit!
##
## Version 1.3
## History
## v1.0  	:  Initial script release
## v1.01 	:  Removed unnecessary action
## v1.1  	:  Added routine to format options for skill names properly.
##           Changed skill floor from 33 to 15 to keep ahead of skill drain.
## v1.2  	:  Made script self-repeating, will evaluate each skill and train
##           the first one below 5%.
##           Changed skill floor from 15 to 5 to keep ahead of skill drain.
## v1.2.1	:  Added a help section (use .research help to access).
## v1.3		:	 Added in a check and actions to make sure Fundamentals were done
##					 twice.
##
## To-do	:	 Add in checks for research types that are unavailable during setup.
##					 Add in routine to change abbreviated options into full-length names.
##

#debug 10

if_1 then
	{
	eval option tolower(%1)
	if matchre("%option","h(e|el|elp)") then goto Help
	if %option = set then
		{
		shift
		goto Set.Start
		}
	echo To run this script simply use .research
  echo To set the skills to train use .research set <gaf prep> <skill1> <skill2> <skill3> ...
  exit
	}
else
	{
	if !(def(research.set)) then
		{
		echo Please run the setup prior to utilizing this script!
		echo To set the skills to train use .research set <gaf prep> <skill1> <skill2> <skill3> ...
		echo Valid options are (you may mix types):
		echo Fundamental -	Magic/Arcana experience (50% full to each)
		echo Augmentation - Augmentation experience (34/34)
		echo Stream - Attunement Experience (34/34)
  	echo Sorcery - Sorcery Experience (34/34)
  	echo Utility - Utility Experience (34/34)
  	echo Warding - Warding Experience (34/34)
  	echo Energy - Attunement Experience (34/34)
  	echo Field - Magic, Sorcery, Attunement Experience (17/34 each)
  	echo Spell - Augmentation, Utility, Warding Experience (17/34 each)
  	exit
		}
	}

var magics $research.magics
eval length count("%magics","|")
var current.research 0
var gaf.active 0
var gaf.prep $gaf.prep
var fund.times 0

action var gaf.active 0;goto Do.research when ^Your eyes briefly darken

Check.Research:
	eval this.magic tolower(%magics(%current.research))
	if ((%this.magic = energy) || (%this.magic = stream)) then
		{
		if $Attunement.LearningRate < 5 then goto Do.Research
		}
	if %this.magic = fundamental then
		{
		if ((($Primary_Magic.LearningRate < 18) || ($Arcana.LearningRate < 18)) && (%fund.times < 2)) then
			{
			math fund.times add 1
			goto Do.Research
			}
		}
	if %this.magic = field then
		{
	if (($Primary_Magic.LearningRate < 5) || ($Sorcery.Learning Rate < 5) || ($Arcana.LearningRate < 5)) then goto Do.Research
		}
	if %this.magic = spell then
		{
	if (($Augmentation.LearningRate < 5) ||($Warding.LearningRate < 5) || ($Utility.LearningRate < 5)) then goto Do.Research
		}
	if $%magics(%current.research).LearningRate < 5 then goto Do.Research
	if %current.research <= %length then
		{
		math current.research add 1
		goto Check.Research
		}
	else
		{
		var fund.times 0
		var current.research 0
		}
		pause 10
		goto Check.Research
		
Do.Research:
	pause 1
	if %gaf.active = 0 then gosub SetGaf
	match Do.Research there is still more to learn
	matchre Check.Research ^Breakthrough
	put research %this.magic 300
	matchwait
	
SetGaf:
	send prep gaf %gaf.prep
	waitforre ^You feel fully prepared
	send cast
	pause 1
	var gaf.active 1
	return

Set.Start:
	put #var gaf.prep %1
	shift
	var builder %1
	var set.num 1
	shift
Set.Build:
	if_1 then
		{
		eval first toupper(substring("%1","0","1"))
		eval second.end len("%1")
		math second.end subtract 1
		eval second tolower(substring("%1","1","%second.end"))
		eval word %first%second
  	var builder %builder|%word
  	math set.num add 1
  	shift
  	goto Set.Build
  	}
Set.Save:
	put #var research.magics %builder
	put #var research.num %set.num
	put #var research.set 1
	put #var save
	echo Setup complete. Run script.
	exit
	
Help:
		echo To set the skills to train use .research set <gaf prep> <skill1> <skill2> <skill3> ...
		echo Valid options are (you may mix types):
		echo Fundamental -	Magic/Arcana experience (50% full to each)
		echo Augmentation - Augmentation experience (34/34)
		echo Stream - Attunement Experience (34/34)
  	echo Sorcery - Sorcery Experience (34/34)
  	echo Utility - Utility Experience (34/34)
  	echo Warding - Warding Experience (34/34)
  	echo Energy - Attunement Experience (34/34)
  	echo Field - Magic, Sorcery, Attunement Experience (17/34 each)
  	echo Spell - Augmentation, Utility, Warding Experience (17/34 each)