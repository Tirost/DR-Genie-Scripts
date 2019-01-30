action (LIST) var skills %skills|$1 when ^([A-Za-z]+(?: [A-Za-z]+)?)\s+-
timer clear
timer start
var CircleCheck %t
math CircleCheck add 300

var skills
put /sort
waitforre ^EXP HELP

<%
	list = getVar('skills').toString();
	list = list.split("|");
	for(i = 0; i < list.length() - 1; i++)
	{
		if(list[i].localeCompare(list[i+1]) == 1) {
			var temp = list[i];
			list[i] = list[i+1];
			list[i+1] = temp;
			i = -1;
		}
	}
	setVar('skills',list.join("|"));
%>

action (LIST) off
eval skills replace("%skills", " ", "_")
eval skills replacere("%skills", "Holy_Magic|Life_Magic|Lunar_Magic|Elemental_Magic|Arcane_Magic", "Primary_Magic")
eval skillcount count("%skills", "|")
var count 1
put #clear Data
put #echo >Data #00FF00 Skill|PulseTime|Change|TilRank|PulsesNeeded

SetupLoop:
if %count <= %skillcount then
{
	var %skills(%count).pRate $%skills(%count).LearningRate
	var %skills(%count).pRank $%skills(%count).Ranks
	var %skills(%count).time %t
	var %skills(%count).data 0
	math count add 1
	goto SetupLoop
}

Loop:
if %count <= %skillcount then
{
	gosub SkillUpdate
	math count add 1
	goto Loop
}
delay 0.1
var toprint false
math count set 1
LoopCheck:
if %count <= %skillcount then 
{
	if "%toprint" = "false" then
	{
		if $%skills(%count).Ranks > %%skills(%count).pRank then var toprint true
		else math count add 1
		goto LoopCheck
	}
}
if ("%toprint" = "true") then math count set 1
else evalmath count %skillcount + 1
goto Loop

SkillUpdate:
if %count = 1 then
{
	put #clear Data
	put #echo >Data #00FF00 Skill|PulseTime|Change|TilRank|PulsesNeeded
}
if $%skills(%count).Ranks > %%skills(%count).pRank then
{
	evalmath TempTime %t - %%skills(%count).time
	var %skills(%count).time %t
	evalmath TempRank $%skills(%count).Ranks - %%skills(%count).pRank
	var %skills(%count).pRank $%skills(%count).Ranks
	gosub TimeCheck
	evalmath TimeTilRank round((%TempTime * %timecount)/60,4)
	evalmath TempRank round(%TempRank,4)
	evalmath TempTime round(%TempTime,4)
	var %skills(%count).data %TempTime|%TempRank|%TimeTilRank|%timecount
	put #echo >Data %skills(%count): $%skills(%count).Ranks CR|%TempTime S|%TempRank C|%TimeTilRank M|%timecount P
}
else
{
	if ($%skills(%count).LearningRate = 0) then var %skills(%count).data 0
	if !(%%skills(%count).data = 0) then
	{
		put #echo >Data %skills(%count): $%skills(%count).Ranks CR|%%skills(%count).data(0) S|%%skills(%count).data(1) C|%%skills(%count).data(2) M|%%skills(%count).data(3) P
	}
}
return

TimeCheck:
evalmath SkillCeiling ceiling($%skills(%count).Ranks)
evalmath SkillCheck %SkillCeiling - $%skills(%count).Ranks
evalmath timecount %SkillCheck / %TempRank
evalmath timecount round(%timecount)
return




