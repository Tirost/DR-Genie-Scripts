##DEBUG 10
## Thank you to Dasiffion/Ataelos/Any other Genie Folks on the chat boards I may have missed for helping build this.

## SETUP
## Requires cases to have the following labels (Holy, Life, Elemental, Lunar, Necro, Holy2, Life2, Elemental2, Lunar2) CASE SENSITIVE
## If you want different labels... then have fun.
## Will output to the Output window Spell Name - Spell Type it's going in.
## Will go through and flip all your cases when done to give you an inventory update.
## Set the following 3 variables below for your containers.
var scroll_container bag
var case_container rucksack
var non_scrolls_container rucksack



ACTION var contents $1 when ^In the .* you see (.*)

var case_list first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth
eval Case_Count count("%case_list","|")
math Case_Count add 1


ACTION setvar SPELL_NAME $1 when description of the ((?:\w+(?:\s)?)+) spell
ACTION setvar SPELL_NAME $1 when ^It is labeled "((?:\w+(?:\s)?)+)."

ACTION setvar SPELL_TYPE Holy when Aspects of the All-God|Auspice|Bitter Feast|Bless|Centering|Chill Spirit|Curse of Zachriedek|Divine Radiance|Fists of Faenella|Ghost Shroud|Glythtide's Gift|Hand of Tenemlor|Harm Evil|Heavenly Fires|Horn of the Black Unicorn|Huldah's Pall|Major Physical Protection|Malediction|Minor Physical Protection|Phelim's Sanction|Protection from Evil|Revelation|Sanctify Pattern|Soul Shield|Soul Sickness|Spite of Dergati|Uncurse|Vigil|Anti-Stun|Aspirant's Aegis|Clarity|Courage|Divine Guidance|Footman's Strike|Halt|Hands of Justice|Heroic Strength|Rebuke|Righteous Wrath|Rutilor's Edge|Sentinel's Resolve|Shatter|Smite Horde|Soldier's Prayer|Stun Foe

ACTION setvar SPELL_TYPE Life when Absolution|Adaptive Curing|Icutu Zaharenela|Aesandry Darlaeth|Aggressive Stance|Awaken|Blood Staunching|Compel|Gift of Life|Innocence|Iron Constitution|Lethargy|Mental Focus|Paralysis|Raise Power|Refresh|Tranquility|Vigor|Athleticism|Carrion Call|Compost|Curse of the Wilds|Deadfall|Devitalize|Eagle's Cry|EarthMeld|Essence of Yew|Forestwalker's Boon|Grizzly Claws|Hands of Lirisa|Harawep's Bonds|Instinct|Oath of the Firstborn|Senses of the Tiger|Stampede|Swarm|Wisdom of the Pack|Wolf Scent

ACTION setvar SPELL_TYPE Elemental when Beckon the Naga|Aura of Tongues|Breath of Storms|Demrris' Resolve|Drums of the Snake|Echoes of Aether|Eillie's Cry|Misdirection|Nexus|Rage of the Clans|Redeemer's Pride|Resonance|Soul Ablaze|Whispers of the Muse|Will of Winter|Words of the Wind|Air Bubble|Air Lash|Anther's Call|Arc Light|Ethereal Shield|Fire Ball|Fire Shards|Flame Shockwave|Frost Scythe|Frostbite|Gar Zeng|Geyser|Ice Patch|Ignite|Lightning Bolt|Paeldryth's Wrath|Rising Mists|Shockwave|Stone Strike|Substratum|Sure Footing|Swirling Winds|Tailwind|Thunderclap|Tingle|Tremor|Vertigo|Ward Break|Y'ntrel Sechra|Zephyr|Aethrolysis

ACTION setvar SPELL_TYPE Lunar when Saesordian Compass|Sever Thread|Sovereign Destiny|Tangled Fate|Tezirah's Veil|Artificer's Eye|Aura Sight|Burn|Cage of Light|Calm|Clear Vision|Dazzle|Dinazen Olkar|Hypnotize|Machinist's Touch|Partial Displacement|Piercing Gaze|Psychic Shield|Rend|Shadows|Shear|Sleep|Telekinetic Storm|Telekinetic Throw|Tenebrous Sense|Thoughtcast|Unleash|Avren Aevareae|Blur|Finesse|Fluoresce|Last Gift of Vithwok IV|Membrach's Greed|Nonchalance|Platinum Hands of Kertigen|Regalia|Turmar Illumination|Trabe Chalice|Crystal Dart

ACTION setvar SPELL_TYPE Necro when Acid Splash|Blood Burst|Heighten Pain|Liturgy|Obfuscation|Petrifying Visions|Researcher's Insight|Rite of Contrition|Rite of Grace|Siphon Vitality|Viscous Solution|Visions of Darkness

ACTION setvar SPELL_TYPE Analogous when Burden|Dispel|Ease Burden|Gauge Flow|Imbue|Lay Ward|Manifest Force|Seal Cambrinth|Strange Arrow


pause 1
send look in my %scroll_container
pause 1

eval contents replacere("%contents", " and |, ", "|")
var contents |%contents|
eval total count("%contents", "|") 
action var temparray %temparray|$1 when ^@(?:an?|some).* ([\w-']+)
var i 0
var temparray

if %1 = "flip" then GOTO CASE_FLIP


## ***************
LOOP:
    put #parse @%contents(%i)
    math i add 1
    pause 0.1
    if (%i>=%total) then goto STOW_SPELLS_START
    goto loop

STOW_SPELLS_START:
    var i 1
    SCROLL_LOOP:
    if (%i>=%total) then goto done
        matchre READ_ITEM ^You get|^You are already holding that
        matchre STOW-RIGHT ^You need a free hand
    send get %temparray(%i) from my %scroll_container
    matchwait 5
	ECHO NO Scrolls/Spells?
    GOTO CASE_FLIP

STOW-RIGHT:
	send stow right
	wait .5
	GOTO STOW_SPELLS_START

READ_ITEM:
	setvar SPELL_TYPE NULL
	send look my %temparray(%i)
	wait .5
	if (%SPELL_TYPE = "NULL") then {
				matchre NOT_SPELL There is nothing there to read.
		send read my %temparray(%i)
		matchwait 5
	}
	setvar counter 0
	GOTO LOOK_CASES
	
NOT_SPELL:
	send put $righthandnoun in my %non_scrolls_container
	math i add 1
	GOTO SCROLL_LOOP

LOOK_CASES:
		matchre FOUND_CASE %SPELL_TYPE
##		matchre FOUND_CASE \b%SPELL_TYPE\b
		matchre END_CASE_LIST ^I could not find what you were referring to.
		matchre EXIT ^What were
	send tap my %case_list(%counter) case in %case_container
	matchwait 1

	math counter add 1
	if %counter > %Case_Count then var counter 0
	GOTO LOOK_CASES

EXIT:
	EXIT	
	
END_CASE_LIST:
	setvar counter 0
	GOTO LOOK_CASES
	
FOUND_CASE:
	if %SPELL_TYPE = "NULL" then {
		put $righthandnoun in my %non_scrolls_container
		math i add 1
		GOTO SCROLL_LOOP
	}
	send get %case_list(%counter) case from my %case_container
	wait .1
	
		matchre CORRECT_CASE %SPELL_TYPE
	send tap my case
	matchwait 3
	
	send stow case
	wait .5
	GOTO LOOK_CASES
	
CORRECT_CASE:	
	send open my case
	wait .5
		matchre No_ROOM_CASE ^Flipping through your case, you realize there's no more room
	send push my case with my $righthandnoun
	matchwait 1

	send stow case
	wait .1
	math i add 1
	send #ECHO >Output * %SPELL_NAME to %SPELL_TYPE
	GOTO SCROLL_LOOP

NO_ROOM_CASE:
	setvar counter 0
	send stow case
	wait .5
	if matchre("%SPELL_TYPE", "Elemental2|Holy2|Life2|Lunar2") then {
		send put $righthandnoun in my %non_scrolls_container
		math i add 1
		GOTO SCROLL_LOOP
	}
	if matchre("%SPELL_TYPE", "Elemental") then setvar SPELL_TYPE Elemental2
	if matchre("%SPELL_TYPE", "Holy") then setvar SPELL_TYPE Holy2
	if matchre("%SPELL_TYPE", "Life") then setvar SPELL_TYPE Life2
	if matchre("%SPELL_TYPE", "Lunar") then setvar SPELL_TYPE Lunar2
	
	GOTO LOOK_CASES

	
CASE_FLIP:
	put #clear main
	var counter 0
	CASE_FLIP_SUB:
	
		matchre DONE ^I could not find what you were referring to.
	send get my %case_list(%total) case in %case_container
	matchwait 1
	
	FLIP_CASES:
		send flip my case
		wait 1
		send stow case
		wait .5
		math counter add 1
		if %counter > %total then EXIT
		GOTO CASE_FLIP_SUB
			
	DONE:
		setvar counter 0
		GoSub CASE_FLIP
		EXIT	