#Empath healing script. v1.2

##Changelog
## v1.0 : Initial release.
## v1.1 : Fixed issue with parsing known spells.
## v1.2 : Fixed issue with catching severe wounds at 'useless' level.
##        Also added code where if you're bleeding while healing scars
##	  (which means you've aquired new fresh wounds enough to bleed)
##	  the code will restart to keep fresh wounds from getting too
##	  severe, though it will attend 'severe' level wounds and scars
##	  first as usual.

#debug 10

##Settable Variables.
var hw.prep 6
var hs.prep 8
var harn.do 3
var cure.prep 8
var foc.prep 20
var foc.use 0

##Global variables and actions (Do not change these!)
var blood.staunch.active 0
var blood.staunch.known 0
var flush.poison.known 0
var cure.disease.known 0
var vitality.healing.known 0
var fountain.known 0

action send 2 $lastcommand when ^\.\.\.wait|^Sorry, you may only type
action INSTANT var blood.staunch.active 0 when force binding your
action send #var poisoned 1 when nerve poison

action (healing) math this.index add 1 when external wounds .* completely healed.
action (healing) math this.index add 1 when internal wounds .* completely healed.
action (healing) math this.index add 1 when external scars .* completely healed.
action (healing) math this.index add 1 when internal scars .* completely healed.
action (healing) math this.index add 1 when what isn't injured|what is not injured

action (check) var blood.staunch.known 1 when Blood Staunching
action (check) var flush.poison.known 1 when Flush Poisons
action (check) var cure.disease.known 1 when Cure Disease
action (check) var vitality.healing.known 1 when Vitality Healing
action (check) var fountain.known 1 when Fountain of Creation

action put #var poisoned 1 when have a .* poisoned

action (empath.heal) var TEMP $1 $2 when ^Wounds to the (LEFT|RIGHT) (\w+):$
action (empath.heal) var TEMP $1 when ^Wounds to the (\w+):$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+insignificant$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+insignificant$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+negligible$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+negligible$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+minor$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+minor$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+more than minor$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+more than minor$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+harmful$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+harmful$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+very harmful$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+very harmful$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+damaging$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+damaging$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+very damaging$
action (empath.heal) var list.scars %list.scars|%TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+very damaging$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; var severe.wound 1 ; var priority.wound %TEMP  ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+severe$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; var severe.scar 1 ; var priority.scar %TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+severe$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; var severe.wound 1 ; var priority.wound %TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+very severe$
action (empath.heal) var list.scars %list.scars|%TEMP ; var severe.scar 1 ; var priority.scar %TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+very severe$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; var severe.wound 1 ; var priority.wound %TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+devastating$
action (empath.heal) var list.scars %list.scars|%TEMP ; var severe.scar 1 ; var priority.scar %TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+devastating$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; var severe.wound 1 ; var priority.wound %TEMP ; math num.fresh add 1 when Fresh (External|Internal):.*?\-\-\s+very devastating$
action (empath.heal) var list.scars %list.scars|%TEMP ; var severe.scar 1 ; var priority.scar %TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+very devastating$
action (empath.heal) var list.wounds %list.wounds|%TEMP ; var severe.wound 1 ; math num.fresh add 1 ; var priority.wound %TEMP when Fresh (External|Internal):.*?\-\-\s+useless$
action (empath.heal) var list.scars %list.scars|%TEMP ; var severe.scar 1 ; var priority.scar %TEMP ; math num.scars add 1 when Scars (External|Internal):.*?\-\-\s+useless$

##Spell checking.
action (check) on
pause 0.5
send spells
waitforre ^You are currently
action (check) off

start:
var severe.wound 0
var priority.wound 0
var severe.scar 0
var priority.scar 0
var this.index 0
var num.fresh 0
var num.scars 0
var list.wounds
var list.scars

EmpathWounds:
	gosub check.condition
	action (empath.heal) on
	pause 0.5
	send perceive health self
	waitforre ^You .+ vitality
	action (empath.heal) off

	if %severe.wound then
		{
		gosub heal.do wound %priority.wound
		goto start
		}
	if %severe.scar then
		{
		gosub heal.do scar %priority.scar
		goto start
		}
	if %fountain.known then
		{
		if foc.use then
			{
			if %fresh > 10 then
				{
				send prep foc %foc.prep
				waitforre ^You feel fully prepared
				send harness %harn.do
				waitforre ^Roundtime
				send cast
				goto start
				}
			}
		}
	if %num.fresh > 0 then
		{
		eval list.wounds replacere("%list.wounds", "^\|", "")
		eval list.wounds tolower("%list.wounds")
		pause 0.5
		eval length.wounds count("%list.wounds","|")
		goto cleanup.fresh
		}
	if %num.scars > 0 then
		{
		eval list.scars replacere("%list.scars", "^\|", "")
		eval list.scars tolower("%list.scars")
		pause 0.5
		eval length.scars count("%list.scars","|")
		goto cleanup.scars
		}
	echo You have no wounds. Script complete.
	exit

cleanup.fresh:
	gosub check.condition
	if %this.index > %length.wounds then
		{
		goto start
		}
	eval this.wound element("%list.wounds", "%this.index")
	gosub heal.do wound %this.wound
	gosub clear
	goto cleanup.fresh


cleanup.scars:
	var blood.staunch.active 0
	gosub check.condition
	if %this.index > %length.scars then
		{
		goto start
		}
	eval this.scar element("%list.scars", "%this.index")
	gosub heal.do scar %this.scar
	gosub clear
	goto cleanup.scars

heal.do:
	pause 0.1
	var type $1
	var location $2 $3
	action (healing) on
		if $mana < 20 then gosub spell.cast.wait
	pause 1
	if %type = wound then put prep hw %hw.prep
	pause 0.1
	if %type = scar then put prep hs %hs.prep
	pause 15
	put harness %harn.do
	pause 3
	put cast %location
	pause 1
	action (healing) off
	return

check.condition:
	if $health < 50 then
		{
		if %vitality.healing.known then
			{
			gosub cure.do vh
			if $health < 50 then goto condition.check
			}
		}
	if $bleeding then
		{
		if %blood.staunch.known then
			{
			if !%blood.staunch.active then
				{
				gosub cure.do bs
				var blood.staunch.active 1
				if %type = scar then
					{
					gosub clear
					goto start
					}
				}
			}
		}
	if $diseased then
		{
		if %cure.disease.known then
			{
			gosub cure.do cd
			}
		}
	if $poisoned then
		{
		if %flush.poison.known then
			{
			gosub cure.do fp
			send #var poisoned 0
			}
		}
	return

cure.do:
	var spell $1
	if $mana < 10 then gosub spell.cast.wait
	pause 1
	send prep %spell %cure.prep
	waitforre ^You feel fully prepared
	send harness %harn.do
	waitforre ^Roundtime
	send cast
	waitforre ^You gesture
	return

spell.cast.wait:
	pause 0.1
	pause 0.1
	echo *** WAITING FOR MANA ***
	send power
	pause 5
	if $mana > 30 then return
	pause 1
	goto spell.cast.wait

done:
exit
