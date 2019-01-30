if_1 goto setup
CyclicCheck:
#debug 10
if $train.cyclic = 0 then return
action (assess) var combat 1 when ^You.*(pole|melee|missle).*range\.$
action (assess) off

if $mana < 70 then
	{
	send rel cyc
	return
	}
evalmath timeSinceLastCyclic $gametime - $LastCyclic
if %timeSinceLastCyclic < 280 then return
var combat 0
if $monstercount > 0 then 
	{
	action (assess) on
	pause 0.5
	put assess
	pause 0.5
	action (assess) off
	}
	
goto SwitchCyclic

manawait:
pause 5
if $mana < 95 then goto manawait
return

SwitchCyclic:
var cyclics Warding|Utility|Augmentation|Debilitation|Targeted_Magic
precheck:
eval cyclics.length count("%cyclics","|")
counter set 0
cyclicspellcheck:
if %c <= %cyclics.length then
	{
	if "$%cyclics(%c)CycSpell" != "none" then
		{
		var low.cyclic %cyclics(%c)
		counter add 1
		goto skillcheck
		}
	counter add 1
	goto cyclicspellcheck
	}
echo You have no spells. You're doing it wrong.
exit

skillcheck:
if %c <= %cyclics.length then
	{
	if (($%cyclics(%c).LearningRate < $%low.cyclic.LearningRate) && ("$%cyclics(%c)CycSpell" != "none")) then
			{
			if (("Debilitation" = "%cyclics(%c)") && (%combat = 1)) then var low.cyclic %cyclics(%c)
			if (("Targeted_Magic" = "%cyclics(%c)") && (%combat = 1)) then var low.cyclic %cyclics(%c)
			if !contains("Debilitation|Targeted_Magic", "%cyclics(%c)") then var low.cyclic %cyclics(%c)
			}
        
	counter add 1
	goto skillcheck
	}
#if $%low.cyclic.LearningRate > 30 then return
put #var CurrentCyclic %low.cyclic
goto recast

recast:
if (("$charactername" = "Rishlu") && ("$%low.cyclicCycSpell" = "$DebilitationCycSpell") && $SpellTimer.HydraHex.active = 1) then return
if (("$charactername" = "Dasffion") && ("$%low.cyclicCycSpell" = "$DebilitationCycSpell") && $SpellTimer.ElectrostaticEddy.active = 1) then return
if "$preparedspell" != "None" then gosub release spell
gosub release cyclic
pause 0.5
gosub prepare $%low.cyclicCycSpell $%low.cyclicCycMana
gosub SPELL_WAIT
gosub SPELL_CAST_TARGET $%low.cyclicCycTarget
var fullprep 0
put #var LastCyclic $gametime
return

setup:
put #var WardingCycSpell GJ
put #var WardingCycMana 1
put #var WardingCycTarget $charactername
put #var UtilityCycSpell CARE
put #var UtilityCycMana 1
put #var UtilityCycTarget $charactername
put #var AugmentationCycSpell Fae
put #var AugmentationCycMana 1
put #var AugmentationCycTarget $charactername
put #var DebilitationCycSpell AEWO
put #var DebilitationCycMana 1
put #var DebilitationCycTarget $charactername
put #var Targeted_MagicCycSpell none
put #var Targeted_MagicCycMana none
put #var Targeted_MagicCycTarget none
put #var save