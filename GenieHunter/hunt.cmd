########################################################
#Version 60.2 (5/1/2018)
#Edited by the player of Isharon to work with Combat 3.1
#Other major contributors to Geniehunter 3.1 include Azarael and Londrin.
#Download: http://www.genieclient.com/bulletin/files/file/175-geniehunter-31-and-geniebuff-31/
#Support Thread: http://www.genieclient.com/bulletin/topic/4644-download-combat-geniehunter-31-and-geniebuff-31/
#*added construct mode (Empath-safe weapon and TM training by Londrin)
#*added Nissa mode (Empath debilitation training)
#*added point mode for hidden creatures (Azarael)
#*added enhanced multi setup support (Azarael)
#*replaced skill checks with 3.1 skill names
#*removed humming and all references thereto
#*replaced damaging combat maneuvers with attack (kludge)
#*reduced minimum attunement for Geniebuff to 80% (if toupper("$GH_BUFF") = "ON" and $mana > 80 then gosub GH_BUFF_ON)
#*added tactics training mode for melee weapons (Londrin and Azarael)
#*fixed TM (Azarael)
#*removed nuggets and bars from gem loot
#*fixed issues with worn bundles (Londrin) and ARRANGE ALL (Azarael)
#*added Barbarian magic training (Londrin)
#*added manipulation mode (empathy training) (Isharon)
#*added Paralysis mode (Empath TM training) (Isharon with bug fixes by Londrin)
#*added Analysis/combo mode (Azarael)
#*added Thief mark (trains appraisal and perception) (Londrin)
#*added support for arranging for bones or parts (Londrin)
#*added optional Thief/mark syntax (Londrin)
#*added support for Thief khri (Londrin)
#*added support for throwing bonded weapons (Azarael)
########################################################

put #class alert on
put #class combat on
put #class arrive off
put #class joust off
put #class racial off
put #class rp off
put #class shop off
put #clear main

#CHECK HERE
put #var save
#debuglevel 10
##########################################################################
##		                                                                ##
##		             General combat script                              ##
##		       By: Warneck (with help from SFHunter)                    ##
##		                                                                ##
##		General Options:                                                ##
## APPR: appraises monsters, will not appraise if appraisal is locked   ##
## ARRANGE #: arranges skinnable creatures before skinning them         ##
##		The # designates the number of times you want to arrange (1-5)  ##
##		If no # entered, will default to 1 time                         ##
## BARB: Analyzes monsters with Barbarian options for Expertise         ##
##		syntax is BARB (type)                                           ##
##		Valid types are: FLAME, ACCURACY, DAMAGE, INTIMIDATION,         ##
##		FATIGUE, BALANCE, VITALITY, RAGE or CALM.                       ##
## Only one type at a time can be active.                               ##
## BLOCK: sets stance to shield stance                                  ##
## BONE: arranges for bones                                             ##
## BUFF: uses buffing subroutine                                        ##
## BUNDLE: bundles skins if you have ropes.  Bundles are untied, and    ##
##		dropped.  See TIE and WEAR for other options                    ##
## COLLECTIBLE: loots collectibles (diras and cards)                    ##
## COUNT/DANCE: dances with X number of creatues.                       ##
## CUSTOM: sets stance to custom stance                                 ##
## DANGER: part of the BUFF command, it sets BUFF and retreats during   ##
##		casting                                                         ##
## DEFAULT: use the default setting, use DSET fist to set up defaults   ##
##		can also use .hunt with no arguments to do this                 ##
## DMSET: setup for multi-weapon with default settings                  ##
##		use is .hunt dmset weapon1 weapon2 ...                          ##
## DMULTI: Multi-weapon with default settings                           ##
## DODGE/EVADE: sets stance to evasion stance                           ##
## DSET: used to set up the default settings                            ##
##		run .hunt DSET <<all other options>> once to set the            ##
##		defaults, this will go through init like normal, and then       ##
##		save all the settings globally for use as default               ##
## ENCHANTE: casts designated Bard cyclic every 7 minutes               ##
## EXP: checks weapon experience.  Will end script when skill is        ##
##		bewildered or above                                             ##
## HUNT: will use the HUNT verb to train perception and stealth, but    ##
##		will not move around the hunting ground                         ##
## JUGGLE/YOYO: juggles when no more monsters in the room               ##
## JUNK: loots scrolls/runestones/cards, exclusive from LOOT            ##
## KHRI: Uses Thief khri. Please use the khri's name in lowercase       ##
## to set the correct variables on for the khri you use                 ##
## LOOTALL: loots everything it can                                     ##
## LOOTBOXES: loots  boxes, redundant if used with LOOTALL              ##
## LOOTCOINS: loots coins, redundant if used with LOOTALL               ##
## LOOTGEMS: loots gems, redundant if used with LOOTALL                 ##
## MANIP: adds manipulation (empathy training);                         ##
## requires $manipulate variable                                        ##
## MARK (Thief only): Utilizes MARK ALL instead of APPRAISE             ##
## MSET: setup for multi-weapon, break up multi setups with quotation   ##
##		marks: .hunt "setup 1" "setup 2"..."setup 10"                   ##
##		supports up to 10 setups currently                              ##
##		setups are saved as GH_MULTI_# for edittabillity                ##
## MULTI: multi-weapon training, will use a weapon until locked         ##
##		then switch to the next setup when locked                       ##
## NECROHEAL: Necromancer healing.  Only use if you have the consume    ##
##		spell.  Will not activate if below 80% mana or if               ##
##		$roomplayers shows anyone present.  Minor scuffs                ##
##		are not healed.                                                 ##
## NECRORITUAL: Will perform a necromancer ritual, if of right guild    ##
##		and $roomplayers shows no one present.  Options are             ##
##		dissect, preserve, harvest, arise.  If no ritual is specified,  ##
##		will use dissect. Usage is                                      ##
##		.hunt necroritual dissect/preserve/harvest/arise                ##
## NOEVASION: Will skip the evasion stance when switching stances       ##
## NOPARRY: Will skip the parry stance when switching stances           ##
## NOSHIELD: Will skip the shield stance when switching stances         ##
## PARALYSIS: shock-free TM training for Empaths                        ##
##		requires $paralysis variable                                    ##
## PART: arranges for parts                                             ##
## PARRY: sets stance to parry stance                                   ##
## PILGRIM: prays on a pilgrim's badge every 30 minutes                 ##
## POINT: toggles hidden critter pointing (Default is OFF)              ##
## POUCH: changes gem pouches when current one is full.  See help       ##
## POWERP: will power perceive once every 6 minutes.                    ##
## RETREAT: turns on retreating for ranged weapons / spells. This       ##
##		does not work with poaching yet                                 ##
## RITUAL: maintains a ritual spell during                              ##
##		combat (some assembly required)                                 ##
## ROAM: will roam around the hunting area if no more monsters in       ##
##		room to kill                                                    ##
##		!!!CAUTION!!!                                                   ##
##		There is no safeguard for leaving a hunting area or             ##
##		wandering into a more dangerous area.                           ##
## SCRAPE: scrape skins/pelts/hides after skinning, retreating works    ##
##		while doing this activity.  Use SKINRET for this                ##
## SEARCH: Sets loot option.  Treasure/Boxes/Equipment/Goods/All        ##
##		without setting an option, uses game default see in game        ##
##		LOOT HELP for more information on differences                   ##
## SKIN: skins monsters                                                 ##
## SKINRETREAT: will turn on retreating while skinning                  ##
## SLOW: for weaklings or noobs, will wait for stamina to refill        ##
##		before next attack if it drops below 90%                        ##
## STANCE: will cycle through stances once that skill is locked         ##
##		current cycle is evas -> shield -> parry and back               ##
## TACTICS: Will add tactics-training to your hunting routine           ##
## TARGET: specifies a target to aim/target for attacks                 ##
## THIEF: This option uses Thief-only ambushes                          ##
## TIE: Ties bundles when first created, saves inventory space          ##
## TIMER: will set a timer to abort the script after x seconds          ##
## TRAIN: will check experience after every combat cycle, ranged        ##
##		weapon firing/throwing, or spell cast                           ##
## WEAR: Wears bundles.  Uses STOW verb to put skin into bundle if it   ##
##		this is used w/ the TIE option.                                 ##
##		                                                                ##
##		Weapon Options:                                                 ##
## AMBUSH: hides/stalks and attacks from hiding, checks stealth exp     ##
##		has a feature that will attempt to return to your original      ##
##		room if you stalk a creature into another by accident.          ##
##		If you have the ROAM option activated, this part of the         ##
##		feature is deactivated.                                         ##
## ANALYZE: Analyzes monsters to get debuff combos;                     ##
## syntax is ANALYZE # (1-10)                                           ##
## BACKSTAB: backstabs with weapon                                      ##
## BRAWL: brawls, will brawl with a weapon out if so desired            ##
## CONSTRUCT: adds construct check (to avoid Empathic shock) to weapon  ##
##		and TM training													##
## DUAL: dual-load (for Rangers and Barbarians							##
## EMPATH: non-lethal brawling (trains tactics)                         ##
## FEINT: use a feinting routine to keep balance up                     ##
## MAGIC: uses magic in the same syntax as TM/PM, but will only cast    ##
##		once per critter, then use the primary weapon to kill           ##
## OFFHAND: uses weapon in offhand, works with melee or thrown          ##
## POACH: poaches with a ranged weapon, checks stealth exp              ##
## SMITE: trains Conviction by executing a smite every 60 seconds       ##
## SNAP: snap-fires ranged weapon and snapcasting for magic             ##
##		Following this command with a # will pause for that many		##
##		seconds before casting/firing                                   ##
## SNIPE: snipes with a ranged weapon                                   ##
## STACK: throws stacks of weapons (throwing blades). If you use        ##
##		this, don't use THROW too                                       ##
## SWAP/BASTARD: swappable weapon support, equips the weapon and 		##
## swaps it to the desired weapon "mode" 								##
## 	Available mode options: 											##
## 		SE - Small Edged (Light Edged, Medium Edged) 					##
## 		LE - Large Edged 												##
## 		2HE - Two-handed Edged 											##
## 		SB - Small Blunt (Light Blunt, Medium Blunt) 					##
## 		LB - Large Blunt 												##
## 		2HB - Two-handed Blunt 											##
## 		POLE - Polearms (Halberd, Pike)									##
##      S - Staves (Quarter Staff, Short Staff) 	   					##
## TSWAP: does the same as SWAP, but for throwing weapons               ##
## FSWAP: does the same as SWAP, but for Fans with open/close 			##
## THROW: throws a thrown weapon                                        ##
## HURL: hurls a thrown weapon, causing puncturing weapons to stick     ##
## LOB: lobs a thrown weapon, preventing weapon from sticking           ##
## TM/PM/DEBIL/AUG/UTIL: uses magic as the primary weapon, with         ##
##		brawling as the backup if no other weapon is specified (and     ##
##		you run out of mana). The extra harness is optional. TM for     ##
##		targeted exp check, PM for primary magic exp checks,            ##
##		DEBIL/AUG/UTIL for other exp checks. SNAP will snapcast.        ##
##		Use as follows:                                                 ##
##		(SNAP) <TM|PM|DEBIL|AUG|UTIL> <spell> <mana> <weapon> <shield>  ##
##		                                                                ##
## Use:                                                                 ##
##	.hunt (General options) (Weapon Options) weapon shield              ##
##		                                                                ##
## Note: You must have the EXPTracker Plugin for this script to work    ##
##########################################################################

pause

timer clear
timer start
## GAG_ECHO can be YES or NO
## YES - Will not show any of the informative echoes
## NO - Default, will show all informative echoes
var GAG_ECHO YES
var TACTICS weave|circle|bob
var tact_move 0

#action (hunt) put #queue clear; send 1 $lastcommand when ^\.\.\.wait|^Sorry, you may only type
#action (hunt) put #queue clear; send 1 $lastcommand when ^You are still stunned
action goto ADVANCE when ^You must be closer to
#action put #play Speech;put #flash when ^\w+ asks, \"|exclaims, \"|hisses, \"|lectures, \"|says, \"|^You hear .+ say|^You hear the voice of
#action put #play Whisper;put #flash when ^\w+ whispers, \"
#action put #play Whisper;put #flash when ^\[Personal\]\[(\w+)\]\s+\"\<to you\>\"\s+\"(.*)\"$
#action put #play Whisper;put #flash when ^You hear \w+'s thoughts in your head|^You hear \w+'s (faint|loud) thoughts in your head
action (stalk) goto SNEAKING when eval $roomid != %starter.room
action (stalk) off
action var _COMBO $1;eval _COMBO replacere("%_COMBO", "(,?\s?((an|a)|and (an|a))\s)", "|");eval _COMBO replacere("%_COMBO","^\|","");eval _combocount count("%_COMBO", "|") when by landing (.*)\.$
action (LOOTBOX) put #math BOXES add 1 when ^You put your.* (\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|(\bbox\b)(?:\s|\.|\,)) .*\.$
action put #var GH_LOOT_BOX OFF when eval $BOXES >= 6
action (standup) send stand when eval $standing = 0



##Bodypart Array
var BODY_PART head|neck|back|chest|abdomen|right arm|left arm|right leg|left leg

var AUGMENTATION off
Var WARDING off
var SMITE 0

#############################
#	SpellWeave Variables	#
#############################
var SPELLWEAVE OFF
var PREPSPELLWEAVE OFF

##LOOT Variables
var gweths (jadeite|lantholite|lasmodi|sjatmal|waermodi) stones
var boxtype brass|copper|deobar|driftwood|iron|ironwood|mahogany|oaken|pine|steel|wooden
var boxes \bbox\b|caddy|casket|chest|coffer|crate|skippet|strongbox|trunk
var junkloot fragment|hhr'lav'geluhh bark|lockpick|ostracon|package|papyrus roll|runestone|scroll|sheiska leaf|smudged parchment|tablet|vellum
var collectibles albredine ring|crystal ring|kirmhiro draught|\bmap\b|package|soulstone|\bbolts?\b|flarmencrank|\bgear\b|glarmencoupler|\bnuts?\b|rackensprocket|spangleflange|dragon pendant|frothy-green oil|ilomba boards|mistsilk padding|seastars?|vardite hinges

##Monster Variables
var monsters1 \badder\b|ashu hhinvi|atik'et|banshee|bloodvine|bucca|clay archer|clay mage|clay soldier|clockwork monstrosity|\bcrag\b|creeper|cutthroat
var monsters2 /bdoll\b|dragon fanatic|dragon priest|dryad|dummy|dusk ogre|dyrachis|eviscerator|faenrae assassin|fendryad|fire maiden|folsi immola
var monsters3 footpad|frostweaver|gam chaga|\bgeni\b|gidii|goblin shaman|graverobber|guardian|gypsy marauder|\bhag\b|harbinger|\bimp\b|juggernaut
var monsters4 kelpie|kra'hei|kra'hei hatchling|lipopod|lun'shele hunter|madman|malchata|mountain giant|nipoh oshu|\bnyad\b|orc bandit
var monsters5 orc clan chief|orc raider|orc reiver|orc scout|pile of rubble|pirate|river sprite|ruffian|sandstone golem|scavenger troll|scout ogre|screamer
var monsters6 sentinel|shadow master|shadoweaver|sky giant|sleazy lout|sprite|swain|swamp troll|telga moradu|\bthug\b|trekhalo
var monsters7 tress|umbramagii|velver|\bvine\b|vykathi builder|vykathi excavator|wood troll|\bwretch\b|young ogre|zealot

var undead1 boggle|emaciated umbramagus|fiend|gargantuan bone golem|olensari mihmanan|plague wraith|resuscitant
var undead2 revivified mutt|shylvic|sinister maelshyvean heirophant|skeletal peon|skeletal sailor|skeleton
var undead3 skeletal kobold headhunter|skeletal kobold savage|snaer hafwa|soul|spectral pirate|spectral sailor
var undead4 spirit|ur hhrki'izh|wind hound|wir dinego|(?<!arisen \S+ )zombie(?!\s)|zombie (head-splitter|mauler|nomad|stomper)

var skinnablemonsters1 angiswaerd hatchling|antelope|arbelog|armadillo|armored warklin|arzumo|asaren celpeze|badger|barghest|basilisk|\bbear\b|beisswurm|bison|black ape
var skinnablemonsters2 blight ogre|blood warrior|\bboa\b|\bboar\b|bobcat|boobrie|brocket deer|burrower|caiman|caracal|carcal|cave troll
var skinnablemonsters3 cinder beast|cougar|\bcrab\b|crayfish|crocodile|\bdeer\b|dobek moruryn|faenrae stalker|firecat|\bfrog\b|gargoyle|giant blight bat
var skinnablemonsters4 goblin|grass eel|\bgrub\b|gryphon|Isundjen conjurer|jackal|kartais|kobold|la'heke|larva|la'tami|leucro
var skinnablemonsters5 marbled angiswaerd|merrows|misty black husk|\bmoda\b|\bmoth\b|mottled westanuryn|musk hog|\bpard\b|peccary|pivuh|poloh'izh|pothanit|prereni|\bram\b
var skinnablemonsters6 \brat\b|retan dolomar|rock troll|scaly seordmaor|serpent|shadow beast|shadow mage|shalswar|silverfish|sinuous elsralael|skunk|S'lai scout
var skinnablemonsters7 sleek hele'la|sluagh|snowbeast|\bsow\b|spider|spirit dancer|steed|storm bull|trollkin|\bunyn\b|viper|vulture|vykathi harvester
var skinnablemonsters8 vykathi soldier|warcat|\bwasp\b|\bwolf\b|\bworm\b|zephyr husk

var skinnableundead1 enraged tusky|fell hog|ghoul|ghoul crow|gremlin|grendel|lach|mastiff|mey|misshapen germish'din|ice adder|ice-covered adder skeleton
var skinnableundead2 mutant togball|reaver|shadow hound|squirrel|zombie kobold headhunter|zombie kobold savage|skeletal kobold headhunter|skeletal kobold savage

var construct ashu hhinvi|boggle|bone amalgam|clay archer|clay mage|clay soldier|clockwork assistant|clockwork monstrosity|gam chaga|glass construct|granite gargoyle|lachmate|lava drake|marble gargoyle|origami \S+|quartz gargoyle|(alabaster|andesite|breccia|dolomite|marble|obsidian|quartzite|rock) guardian|rough-hewn doll|sandstone golem|Endrus serpent
var skinnableconstruct granite gargoyle|lava drake|marble gargoyle|quartz gargoyle|Endrus serpent

var invasioncritters bone amalgam|bone warrior|Elpalzi (bowyer|deadeye|dissident|fomenter|hunter|incendiary|instigator|malcontent|malcontent|partisan|rebel|sharpshooter|toxophilite)|flea-ridden beast|ogre (berserker|deadshot|enraged|hurler|pelter|shooter|youngling)|putrefying shambler|rebel (gladiator|hunter|novice)|revivified mutt|shambling horror|skeletal peon|starcrasher|transmogrified oaf|zenzic

var skinnablecritters %skinnablemonsters1|%skinnablemonsters2|%skinnablemonsters3|%skinnablemonsters4|%skinnablemonsters5|%skinnablemonsters6|%skinnablemonsters7|%skinnablemonsters8|%skinnableundead1|%skinnableundead2|%skinnableconstruct
var nonskinnablecritters %monsters1|%monsters2|%monsters3|%monsters4|%monsters5|%monsters6|%monsters7|%undead1|%undead2|%undead3|%undead4|construct

var ritualcritters %monsters1|%monsters2|%monsters3|%monsters4|%monsters5|%monsters6|%monsters7|%skinnablemonsters1|%skinnablemonsters2|%skinnablemonsters3|%skinnablemonsters4|%skinnablemonsters5|%skinnablemonsters6|%skinnablemonsters7|%skinnablemonsters8|%skinnableundead1|%skinnableundead2|%undead1|%undead2|%undead3|%undead4

var critters %skinnablecritters|%nonskinnablecritters

##Tactics Variables
var TACTICS weave|circle|bob
var tact_move 0
var barb.tact

##Empath Variables
var Empath_Monster

var OPTIONVARS AMB.*?|ANAL.*?|APPR.*?|ARM.*?|ARRA.*?|AUG|BACKS.*?|BARB.*?|BAST.*?|BLO(?!WGUN).*?|BON.*?|BRA.*?|BS|BUF.*?|BUN.*?|COLL.*?|CONS.*?|COUNTSKIP|COUNT|CUST.*?|DANCE|DANG.*?|DEBIL|DEF.*?|DLOAD|DMSET|DMULTI|DODGE|DSET|DUAL.*?|DYING|EMP.*?|\bENCH.*?|EVA.*?|EXP|FEINT|FLEE|FSWAP|HELP|HUNT|HURL|JUGG.*?|JUNK|KHRI|LOB|LOOTA.*?|LOOTB.*?|LOOTC.*?|LOOTG.*?|MAGIC|MANIP|MARK|MSET|MULTI|NECROH.*?|NECROR.*?|NISS.*?|NOEV.*?|NOPA.*?|NOSH.*?|OFF.*?|PARA(?!NG).*?|PARRY|PARTb|PART\b|PILGRIM|PM|POACH|POINT|POUCH|POWER|\bPP\b|RET.*?|RITUAL|ROAM|SCRAPE.*?|SCREAM|SEARCH|SKIN.*?|SKINRET.*?|SLOW|SMITE|SNAP|SNIP.*?|SPEL.*?|STACK|STANCE|SWAP|TAC.*?|TARG.*?|THIEF|THROWb|THROW\b|TIE|TIME.*?|TM|TRAIN|TSWAP|UTIL|WEAR|YOYO
var OPTION NONE

var lastmaneuver none

var LAST TOP

action (point) off
action (point) send point $1 when (%critters) attempting to stealthily advance upon you
TOP:
## Initialize multi-weapon variable
## This part will be skipped when multi-weapons are implemented

#############################################################################
###                                                                       ###
###                                                                       ###
###       VARIABLE INIT: ONLY CHANGE VARIABES IN THIS SECTION             ###
###                                                                       ###
###                                                                       ###
#############################################################################

VARIABLE_INIT:
var BOW_AMMO $GH_CONTAINER_BOW_AMMO
var XB_AMMO $GH_CONTAINER_XB_AMMO
var SLING_AMMO $GH_CONTAINER_SLING_AMMO
var BLOWGUN_AMMO $GH_CONTAINER_BLOWGUN_AMMO
var QUIVER $GH_CONTAINER_QUIVER
var LT_SHEATH $GH_CONTAINER_LT_SHEATH
var HT_SHEATH $GH_CONTAINER_HT_SHEATH
var BOX_CONTAINER $GH_CONTAINER_BOX_CONTAINER
var GEM_CONTAINER $GH_CONTAINER_GEM_CONTAINER
var JUNK_CONTAINER $GH_CONTAINER_JUNK_CONTAINER
var DEFAULT_CONTAINER $GH_CONTAINER_DEFAULT_CONTAINER
var POUCH_CONTAINER $GH_CONTAINER_POUCH_CONTAINER
var PREP_MESSAGE $PREP_MESSAGE
var RITUAL_FOCUS $focusr
var RITUAL_FOCUS_CONTAINER $focusc
var RITUAL_STANCE $rstance

if matchre("$charactername" = "CHARACTER|NAMES") then
{
	var ARMOR1 Light_Armor
	var ARMOR2 Chain_Armor
	var ARMOR3 Brigandine
	var ARMOR4 Plate_Armor
}

########################
##                    ##
##   Buff Variables   ##
##                    ##
########################
goto gh_buff.end
gh_buff.start:
	var buff.secondcambrinth NO
	var buff.trace 1
	var buff.spell $buff.spells
	var buff.prep $buff.prep
	var buff.charge.total $buff.charge.total
	if def("buff.charge.total2") then
		{
		var buff.charge.total2 $buff.charge.total2
		}
	else
		{
		var buff.charge.total2 0
		}
	var buff.charge.increment $buff.charge.increment
	var buff.harness.total $buff.harness.total
	var buff.harness.increment $buff.harness.increment
	var buff.cambrinth $cambrinth
	if def("secondcambrinth") then
		{
		#var buff.secondcambrinth $secondcambrinth
		}
	var buff.worn YES
	var buff.remove NO
	var buff.harness NO
	var buff.prep.message $PREP_MESSAGE
	var buff.continue $buff.continue
	var buff.held NO
	var buff.manalevel 10

	if $guild = Paladin then
		{
		var buff.ba.thrown yes
		}

	#Cleric
	#var buff.spell GAF|MAF|MPP|PFE|BENE|MAPP|EASE|LW
	#var buff.prep 5|5|1|5|10|5|1|6
	#var buff.charge.total 100|101|100|100|100|100|98|110

	#Paladin
	#var buff.spell GAF|MAF|AA|CLARITY|COURAGE|DIG|HES|MO|RW|SR|BOT|BA|DA|RUE|EASE|LW|SP|CRC|AS|HOJ
	#var buff.prep 5|5|1|15|5|5|1|15|5|5|15|10|15|15|1|6|15|30|15|5
	#var buff.charge.total 100|101|100|100|100|100|100|100|100|100|100|100|100|100|98|110|100|100|100|100

	#Empath
	#var buff.spell GAF|MAF|IC|TRANQUILITY|AGS|GOL|MEF|REFRESH|VIGOR|BS|CD|FP|HL|EASE|LW|AWAKEN|RP|INNOCENCE
	#var buff.prep 5|5|5|15|5|5|5|1|15|5|15|15|15|1|6|15|15|5
	#var buff.charge.total 100|101|100|100|100|100|100|100|100|100|100|100|100|98|110|100|100|95

	#Ranger
	#var buff.spell GAF|MAF|EY|COTC|HOL|STW|SOTT|WOTP|EM|MON|INST|EASE|LW
	#var buff.prep 5|5|5|15|5|1|10|10|20|30|1|1|6
	#var buff.charge.total 100|101|100|100|100|100|100|100|100|100|99|98|110

	#Warrior Mage
	#var buff.spell GAF|MAF|ES|VOI|SUBSTRATUM|SUF|SW|TW|YS|EASE|LW
	#var buff.prep 5|5|1|15|5|5|5|5|15|1|6
	#var buff.charge.total 100|101|100|100|100|100|100|100|100|98|110

	#Bard
	#var buff.spell REPR|ECRY|GAF|MAF|NAME|DRUM|HARMONY|RAGE|EASE|LW|MIS
	#var buff.prep 5|1|5|5|30|15|30|15|1|6|15
	#var buff.charge.total 100|100|100|101|100|100|100|100|98|110|100

	#Moon Mage
	#var buff.spell GAF|PG|MAF|SHADOWS|SEER|AUS|TS|EASE|CV|LW
	#var buff.prep 5|5|5|1|14|5|5|1|1|6
	#var buff.charge.total 100|102|101|100|100|99|98|98|97|110

	#Necromancer
	#var buff.spell IVM|OBFUSCATION|PHP|KS|GAF|MAF|EASE|LW
	#var buff.prep 8|2|5|15|5|5|1|6
	#var buff.charge.total 103|101|98|96|100|101|98|110

	## Don't edit below here
	var gh.counter %c
	gosub buff.start
	counter set %gh.counter
	return

gh_buff.end:


#############################################################################
###                                                                       ###
###                                                                       ###
###      END VARIABLE INIT: DO NOT CHANGE ANY MORE VARIABLES              ###
###                                                                       ###
###                                                                       ###
#############################################################################

action remove ^You are still stunned

var JUGGLIE $juggle

## Has full aim been attained yet
var FULL_AIM NO

## Has full targetting been attained yet
var FULL_TARGET NO

## Has spell been fully prepped
var FULL_PREP NO

## Already searched the dead creature
var SEARCHED NO

var APPRAISED NO

## Arm-worn shield during ranged attempts
var REM_SHIELD NONE

## Stance variables
var PARRY_LEVEL 0
var EVAS_LEVEL 0
var SHIELD_LEVEL 0

## Initialize variable for roaming
var lastdirection none

## Variable for rest mode
var REST OFF

## Local variable for counting kills, loots, skins, etc
var LOCAL 0
var LOOTED NO
var CURR_WEAPON

## Special request
var DYING OFF

## Global variables for kills, loots, skins, etc
if matchre($GH_KILLS, \D+) then put #var GH_KILLS 0
if matchre($GH_LOOTS, \D+) then put #var GH_LOOTS 0
if matchre($GH_SKINS, \D+) then put #var GH_SKINS 0

## Analyze Variables
var _COMBO null
var ANALYZELEVEL 1
var ANALYZEAMOUNT 0
var this.attack 0

#######################
## SCRIPT VARIALBLES ##
#######################

## variable LAST is used with the WEBBED and PAUSE subroutines
## LAST is set to the current subroutine you in within the script
if ("%1" != "MULTIWEAPON") then
{
	## MULTI can be OFF or ON
	## ON - Will switch weapons to the next multi setup when locked
	## OFF - Default, attacks with just this weapon
	put #var GH_MULTI OFF
} else
{
	shift
}

## Counter is used to send you back to combat from searching

######################################################
##                 GLOBAL VARIABLES                 ##
## These variables can be changed while Hunt ##
## is running to modify how the script works.       ##
## eg If you get tired of skinning, but have GH set ##
## to skin, just change GH_SKIN to OFF              ##
## All global variables are GH_<<name>> so they are ##
## all in the same spot in the variables window     ##
######################################################

## AMBUSH can be OFF or ON
## ON - Using ambushing attacks, hides and stalks before every attack
## OFF - Default, attacks normally
put #var GH_AMBUSH OFF
action (stalk) off

## ANALYZE can be OFF or ON
## ON - Analyze monsters to get debuff combos
## OFF - Default, attacks normally
put #var GH_ANALYZE OFF

## APPR can be NO or YES
## YES - Kills first creature, then appraises one creature once before entering the combat loop
##      Will appraise once after each kill, will not appraise once skill is dazed or mind locked
## NO - Default, no appraising of creatures
put #var GH_APPR NO

## ARMOR can be OFF or ON
## ON - Will include the armor swapping routine and use it
## OFF - Default, no include
put #var GH_ARMOR OFF

## ARRANGE can be OFF or ON
## ON - Will attempt to arrange a skinnable creature before skinning it.
## OFF - Default, will just skin creatures
put #var GH_ARRANGE OFF

## ARRANGE_ALL can be OFF or ON
## ON - Will arrange kills with the 'ALL' option. Requires outfitter technique.
## OFF - Default, till arrange to MAX_ARRANGE value
put #var GH_ARRANGE_ALL OFF

## BONE can be SKIN, PART, or BONE
## BONE - Will arrange an attempt to skin for Bones
## PART - Will arrange an attempt to skin for a body part
## SKIN - DEFAULT: Will arrange an attempt to skin for a (PELT, SKIN, Etc.)
put #var GH_BONE OFF

## BUFF can be OFF or ON
## ON - Will include the buffing routine and use it
## OFF - Default, no include
put #var GH_BUFF OFF
if "$BW" != "$righthand" then put #var BW OFF

## BUN can be OFF or ON
## Note: Skinning must be enabled for bundling to work
## ON - Will bundle skinnings with rope
##      If no more bundling ropes are available, will be set to OFF
## OFF - Default, will just drop skins
put #var GH_BUN OFF

## COUNTING can be OFF or ON
## ON - Will dance with specified number of creatures.
##      Checks number of creatures after each pass through loop.
## OFF - Default, will kill everything as fast as possible
put #var GH_DANCING OFF

## COUNTSKIP can be OFF or ON
## ON - Will skip dancing with creatures if defensive skills are high.
## OFF - Default, Will dance with the set of mobs forever until more mobs arrive.
put #var GH_COUNTSKIP OFF

## CONSTRUCT can be OFF or ON
## ON - Will only allow damaging moves on constructs (prevents Empathic shock)
## OFF - Default, will allow damaging moves on everything
put #var GH_CONSTRUCT OFF

## DANGER can be OFF or ON
## ON - Will retreat while buffing, it will also set BUFF to on if it's not set already
## OFF - Default
put #var GH_BUFF_DANGER OFF

## DUALLOAD Can be OFF or ON
## ON - Will dual load your ranged weapon
## OFF - Standard loading - Default
put #var GH_DUAL_LOAD OFF

## ENCHANTE can be OFF or ON
## ON - Casts designated Bard cyclic every 7 minutes
## OFF - Default
put #var GH_ENCHANTE OFF

## EXP can be ON or OFF
## ON - Checks weapons experience after every kill
##      Also checks mindstate and any alternate experience
## OFF - No experience checks
if ("$GH_MULTI" = "OFF") then put #var GH_EXP OFF

## FEINT can be OFF or ON
## ON - Uses a feinting routine (feint slice, etc) to maintain balance
## OFF - Default, will use normal combat routine
## Note: Only usable with melee weapon fighting
put #var GH_FEINT OFF

## FLEE can be OFF or ON
## ON - Use the FLEE command every 5 minutes to gain Athletics experience
## OFF - Default, will not use FLEE
## Note: Uses Stamina, might consider using SLOW as well.
put #var GH_FLEE OFF

## HARN is the amount of extra mana to harness before casting the spell.
put #var GH_HARN 0

## HUNT can be OFF or ON
## ON - Uses the HUNT verb every 90 seconds to train perception and stealth
## OFF - Default, will only use HUNT if roaming
put #var GH_HUNT OFF

## JUGGLE can be OFF or ON
## ON - Juggles when no monsters in the room
## OFF - Default, uses standard operations when no monsters in the room
put #var GH_JUGGLE OFF

## LOOT can be OFF or ON
## ON - Loots everything: boxes, gems coins; stores loot in LOOT_CONTAINER
##      If LOOT_CONTAINER fills up, stops looting boxes and gems
## OFF - Default, leaves loot on the ground
## Note: Turning on LOOT turns on LOOT_BOX, LOOT_GEM, LOOT_COIN
put #var GH_LOOT OFF

## LOOT_BOX can be OFF or ON
## ON - Loots boxes until LOOT_CONTAINER is full
## OFF - Default, leaves boxes on the ground
put #var GH_LOOT_BOX OFF

## LOOT_COIN can be OFF or ON
## ON - Loots coins
## OFF - Default, leaves coins on the ground
put #var GH_LOOT_COIN OFF

## LOOT_COLL can be OFF or ON
## ON - Will loot collectibles: Imperial diras and cards
## OFF - Default, will collectibles on the ground
put #var GH_LOOT_COLL OFF

## LOOT_GEM can be OFF or ON
## ON - Loots gems until LOOT_CONTAINER is full
## OFF - Default, leaves gems on the ground
put #var GH_LOOT_GEM OFF

## LOOT_JUNK can be OFF or ON
## ON - Loots junk items until LOOT_CONTAINER is full
## OFF - Default, leaves junk items on the ground
put #var GH_LOOT_JUNK OFF

## MANA is the amount of initial mana to prep the spell at.
put #var GH_MANA 0

## MANIP can be OFF or ON
## ON - Manipulates creatures while empathically brawling; requires $manipulate variable
## OFF - Default, does not manipulate
put #var GH_MANIP OFF

## MARK changes appraise to use ALL for thieves instead of appraise
put #var GH_MARK OFF

## NECROHEAL can be OFF or ON
## ON - Performs the consume spell and ritual if injured.
## OFF - Default, does not perform spell / ritual.
put #var GH_NECROHEAL OFF

## NECRORITUAL can be OFF, DISSECT, PRESERVE, HARVEST, or ARISE
## OFF - Default, does not perform ritual
## DISSECT / PRESERVE / HARVEST / ARISE - Performs said ritual
put #var GH_NECRORITUAL OFF

## NISSA can be OFF or ON
## ON - Trains Debilitation by casting Nissa's Binding on all creatures in the room.
## OFF - Default, does not cast Nissa's Binding
put #var GH_NISSA OFF

## PARALYSIS can be OFF or ON
## ON - shock-free TM training for Empaths; requires $paralysis variable
## OFF - Default, does not manipulate
put #var GH_PARALYSIS OFF

## PART can be SKIN, PART, or BONE
## BONE - Will arrange an attempt to skin for Bones
## PART - Will arrange an attempt to skin for a body part
## SKIN - DEFAULT: Will arrange an attempt to skin for a (PELT, SKIN, Etc.)
put #var GH_PART OFF

## PILGRIM can be OFF or ON
## ON - boosts Cleric devotion or Paladin soul state by praying on a pilgrim's badge every 30 minutes
## OFF - Default, does not pray on a pilgrim's badge
put #var GH_PILGRIM OFF

## POUCH can be OFF or ON
## ON - Will remove current pouch, put it into special container, and get a new one from default container
## OFF - Default, does not remove full pouch
put #var GH_POUCH OFF

## PP can be OFF or ON
## ON - Perceives once every 6 minutes to train power perception
## OFF - Default, does nothing with perceive
put #var GH_PP OFF

## RITUAL can be OFF or ON
## ON - maintains the ritual spell of your choice
## OFF - Default, does not use ritual spells
put #var GH_RITUAL OFF

## RETREAT can be OFF or ON
## ON - Uses the retreats for ranged combat, melee!
## OFF - Default, bypasses retreats for ranged combat
put #var GH_RETREAT OFF

## ROAM can be OFF or ON
## ON - Will roam around the hunting area  on main directions (n,nw,w,sw,s,se,e,ne,u,d)
##      if you kill all the creatures in your area
## OFF - Default, will stay in your own room no matter what
put #var GH_ROAM OFF

## SCRAPE can be OFF or ON
## ON - Scrapes skins/pelts/hides after skinning
## OFF - Default, just searches all creatures
## Note: This works with SKIN_RETREAT and BUNDLING
put #var GH_SCRAPE OFF

put #var GH_SCREAM OFF

## SEARCH can be set to Treasure, Boxes, Equipment, Goods, or All
## Defaults to loot goods, which is game default
## See in game LOOT HELP for more information
put #var GH_SEARCH GOODS

## SKIN can be OFF or ON
## ON - Skin creatures that can be skinned
##      Drops skins unless BUN is set to ON
## OFF - Default, just searches all creatures
put #var GH_SKIN OFF

## SKIN_RET can be OFF or ON
## ON - Turns on the retreat triggers while skinning
## OFF - Default, doesn't retreat for skinning
put #var GH_SKIN_RET OFF

## SLOW can be OFF or ON
## ON - Turns on pauses between weapon strikes
## OFF - Default, no pauses
put #var GH_SLOW OFF

## SNAP can be OFF or ON
## ON - Snap fires a ranged weapon
## OFF - Default, waits for a full aim to fire a ranged
put #var GH_SNAP OFF

## SPELL can be the shortname of any castable spell. It's what will be prepped.
put #var GH_SPELL eb

## STANCE can be OFF or ON
## ON - Check stance exp after each kill, switch on dazed or mind lock
## OFF - Default, no stance exp checking
put #var GH_STANCE OFF

## TACTICS can be OFF or ON
## ON - Use tactical moves as part of combat
## OFF - Default, no additional tactics training (other than what may be autoselected from "attack")
put #var GH_TACTICS OFF

## TARGET (global) can be ""(null) or any valid body part spells should target
put #var GH_TARGET ""

## Thief - Uses special ambushes
## ON - Will use special ambushes
## OFF - Default, will only use non-ambush
put #var GH_THIEF OFF

## TIE can be OFF or ON
## ON - Will tie bundle when created
## OFF - Default, leaves bundle untied
put #var GH_TIE OFF

## TIMER can be OFF or ON
## ON - If the timer is greater than MAX_TRAIN_TIME, end the script
## OFF - Default, run script endlessly
put #var GH_TIMER OFF

## TRAIN can be ON or OFF
## ON - Weapon or Alternate experience will be checked more often than just when critters die.
## OFF - Default, normal EXP check cycle.
if ("$GH_MULTI" = "OFF") then put #var GH_TRAIN OFF

## WEAR can be OFF or ON
## ON - Will wear a bundle
## OFF - Default, Will drop bundles
put #var GH_WEAR OFF

############################
##  End GLOBAL Variables  ##
############################

############################
## Local Script Variables ##
############################
## ALTEXP can be OFF or ON
## ON - Will check an alternate skill as well as weapon skill
## OFF - Just check weapon experience
var ALTEXP OFF

## BACKSTAB can be OFF or ON
## ON - Will backstab with a weapon
##      If weapon is not suitable for backstabbing, will enter normal combat with weapon
## OFF - Default, will attack normally with weapon
var BACKSTAB OFF

## BONDED can be OFF or ON
## ON - Uses invoke to retrieve bonded throwing weapon.
## OFF - Default.
var BONDED OFF

## BRAWLING can be OFF or ON
## ON - Brawling mode, uses bare hands to kill creatures (or non-lethal for Empaths)
## OFF - Default
var EMPTY_HANDED OFF

## CURR_STANCE can be Evasion, Parry_Ability or Shield_Usage
## Note: Used in stance switching
## Evasion - evasion stance is current one set, Default
## Parry_Ability - parry stance is current one set
## Shield_Usage - shield stance is current one set
var CURR_STANCE Evasion

## EXP2 can be Backstab, Hiding, NONE, Offhand_Weapon, Primay_Magic, Stalking, or Target_Magic
## Backstab - Used when backstabbing
## Hiding - Used when sniping
## Offhand_Weapon - Used when offhand attacks are done
## Debilitation - Used when performing magic and want to check debilitation
## Stalking - Used when ambushing and poaching
## Target_Magic - Used when performing magic and want to check TM
## NONE - Default
var EXP2 NONE

## FIRE_TYPE can be FIRE, POACH or SNIPE
## FIRE - Default, generic firing of ranged weapon
## POACH - Poaches creatures, hides and stalks before poaching
##         If creatures cannot be poached, fires normally
## SNIPE - Snipe creatures, hides and stalks before sniping
var FIRE_TYPE FIRE

## FLEE_TIMER is used to determine if you should flee or not
var FLEE_TIMER 1

## HAND can be <blank> or left
## <blank> - Default, attacks with the right hand
## left - Attacks with the left hand, used for one-handed weapons and throwing
var HAND

## HAND2 can be left or right
## Note: Used in stackables throwing to ensure you don't fill your hands
## left - Default
## right - Set when HAND = "left"
var HAND2 left

## KHRI can be OFF or ON
## Will use the KHRI in the KHRI label
## ON - Uses the KHRI that you have chosen to use in the KHRI label
## OFF - Default, will not use KHRI
put #var GH_KHRI OFF
var AVOIDANCE OFF
var DAMPEN OFF
var DARKEN OFF
var ELUSION OFF
var FLIGHT OFF
var FOCUS OFF
var HASTEN OFF
var PROWESS OFF
var STEADY OFF
var STRIKE OFF

## MAGIC can be OFF or ON
## ON - Will cause a single cast of the specified spell before attacking with mundane weapons
## OFF - Default, won't trigger magic section
var MAGIC OFF

## MAGIC_TYPE can be TM or PM or OFF
## TM - Will cause the appropriate TM usage, with targeting, and checks against TM skill
## PM - Avoid targeting, and uses the PM skill for checks
## OFF - Default
var MAGIC_TYPE OFF

## MAGIC_COUNT can be 0 or anything greater. It tracks the original numeric combo for resetting the counter.
var MAGIC_COUNT 0

## MAX_TRAIN_TIME is how long, in seconds, you want the script to run before stopping
## Note: MAX_TRAIN_TIME defaults to 10 minutes
var MAX_TRAIN_TIME 600

## NOEVADE, NOPARRY, NOSHIELD are used with stance switching to indicate when you wish to skip a stance
## ON - Will skip the designated stance in the SWITCH_STANCE routine
## OFF - Default, will not skip this stance when switching
## Note: can only use one of these at a time.
var NOEVADE OFF
var NOPARRY OFF
var NOSHIELD OFF

## RANGED can be OFF or ON
## ON - For use with ranged weapons; bows, xbows and thrown
## OFF - Default, used with melee weapons
var RANGED OFF

## RETREATING can be OFF or ON. This variable is set internally.
## ON - Retreat triggers are ON
## OFF - Default, retreat triggers are OFF
var RETREATING OFF

## ROUNDS is the number of rounds the script will attempt to train
## a weapon before moving on due to lack of experience gain.
var ROUNDS 2
var current_rounds 0

## RUCK can be OFF or ON
## ON - Weapon was tied to a rucksack, used for sheathing while looting/skinning
## OFF - Default
## Note: Not yet implemented
var RUCK OFF

## SHIELD can be NONE or <shield type>
## NONE - Default, no shield used
## <shield type> - This is set either during the weapon check or ranged combat
##                 If set during the weapon check for a melee weapon, the shield is used during combat
##                 If set during ranged, the shield is removed and stowed, and reworn upon leaving the script
var SHIELD NONE

## STACK can be OFF or ON
## ON - Throwing weapon is a stackable
## OFF - Default
var STACK OFF

## THROWN can be OFF or ON
## ON - Throw a weapon
## OFF - Default
var THROWN OFF

## HURL can be OFF or ON
## Will cause thrown weapons to be hurled
## ON - Hurls weapons, causing them to lodge if possible
## OFF - Default, will not use HURL
var HURL OFF

## LOB can be OFF or ON
## Will cause thrown weapons to be lobbed
## ON - Lobs weapons, preventing them from lodging
## OFF - Default, will not use LOB
var LOB OFF

## YOYO can be OFF or ON
## YOYO is a subset of JUGGLING, it uses a yoyo instead of a standard jugglie
## ON - "juggle" with a yoyo
## OFF - Default, normal jugglie
var YOYO OFF
################################
## End Local Script Variables ##
################################

counter set 0
gosub RETREAT_UNTRIGGERS
action var guild $1;put #var guild $1 when Guild:\s+(Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage)$
action var circle $1;put #var circle $1 when Circle:\s+(\d+)$
action var estance $1 when ^You are currently using (\d+)% of your evasion skill\.$
action var sstance $1 when ^You are currently using (\d+)% of your shield block skill\.$
action var pstance $1 when ^You are currently using (\d+)% of your weapon parry skill\.$
action var ostance $1 when ^You are attacking with (\d+)% of your offensive skill\.$
action var ANALYZELEVEL 10 when massive opening
action var BONDED ON when sense a deep connection
put info
waitforre ^Debt:$
put exp 1
waitforre ^EXP HELP for more information
put awaken

if ("$GH_MULTI" = "DMULTI") then goto LOAD_DEFAULT_SETTINGS
if_1 goto VARIABLE_CHECK
if ("$GH_DEF_SET" = "YES") then goto LOAD_DEFAULT_SETTINGS

DEFAULT_NOT_SET:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ERROR ***
		echo Your default setting are not set yet.
		echo Run .hunta DSET <<default settings>> to set them
		echo
		echo Now exiting script
	}
	goto DONE

##############################
##                          ##
##  Start of actual script  ##
##                          ##
##############################
VARIABLE_CHECK:
	var LAST VARIABLE_CHECK
	gosub clear
	if matchre (toupper("%1"),"(\b%OPTIONVARS)") then
	{
		var OPTION %1
		#pause 0.1
		shift
		gosub %OPTION
		goto VARIABLE_CHECK
	}

	gosub GENERAL_TRIGGERS

BEGIN:
	var LAST BEGIN
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BEGIN: ***
		echo
	}
		matchre WEAPON_CHECK ^With a flick of your wrist|^You draw|already holding|free to
		match BEGIN_HANDS free hand|need to have your right hand
		matchre BEGINA out of reach|remove|What were you|can't seem|Wield what\?
		match VARIABLE_CHECK You can only wield a weapon or a shield!
	put wield right my %1
	matchwait 15

BEGINA:
	var LAST BEGINA
		matchre WEAPON_CHECK You sling|already holding|inventory|You remove
		matchre BEGIN_HANDS free hand|hands are full
		matchre BEGINB Remove what?|You aren't wearing
	put remove my %1
	matchwait 15

BEGINB:
	var LAST BEGINB
		matchre WEAPON_CHECK You get|you get|You are already holding
		match NO_VALUE Please rephrase that command
		match VARIABLE_ERROR What were you
		match UNTIE it is untied.
	put get my %1
	matchwait 30
	goto VARIABLE_ERROR

UNTIE:
	var RUCK ON
		match WEAPON_CHECK you get
		match NO_VALUE Please rephrase that command
		match VARIABLE_ERROR What were you
	put untie my %1 from ruck
	matchwait 30
	goto VARIABLE_ERROR

####################################
##                                ##
##  First input was not a weapon  ##
##  Checking for variables now    ##
##                                ##
####################################

### Ambushing creatures, using the stalking skill for experience checks
AMB:
AMBU:
AMBUS:
AMBUSH:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** AMBUSHING: ***
		echo
	}
	put #var GH_AMBUSH ON
	var starter.room $roomid
	var ALTEXP ON
	var EXP2 Stealth
	var CURRSTEALTHEXP $%EXP2.LearningRate
	var CURR_RATE $%EXP2.LearningRate
	if "$GH_ROAM" = "OFF" then action (stalk) on
	return

##Analyzing creatures for weakness
ANA:
ANAL:
ANALY:
ANALYZ:
ANALYZE:
	put #var GH_ANALYZE ON
	var ANALYZEAMOUNT %1
	if %ANALYZEAMOUNT > 1 then evalmath ANALYZEAMOUNT %ANALYZEAMOUNT - 1
	shift
	return

## Appraising creatures until appraisal is locked
APPR:
APPRAISE:
APPRAISAL:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** APPRAISAL: ***
		echo
	}
	put #var GH_APPR YES
	return

## Will include buffing routine
ARM:
ARMO:
ARMOR:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ARMORSWAPPING: ***
		echo
	}
	put #var GH_ARMOR ON
	var ARMORSWAP ON
	return

## Arranging skinnable creatures before skinning
## Turns skinning on if it is not already
ARRA:
ARRAN:
ARRANG:
ARRANGE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ARRANGE: ***
		echo
	}
	put #var GH_ARRANGE ON
	if ("$GH_SKIN" != "ON") then gosub SKIN
	if matchre("%1","^\d+$") then
	{
		put #var MAX_ARRANGE %1
		if ("%GAG_ECHO" != "YES") then echo *** Arranging %1 times ***
		shift
		return
	}
	if tolower(%1) = all then
		{
		if "$guild" = "Ranger" then goto ARRANGE_ALL
		match ARRANGE_ALL Leather Tanning Expertise
		match ARRANGE_ALL Basic Bone Collecting
		put craft tailor
		put craft carving
		matchwait 2
		echo *** You do not know how to Arrange all. Arranging 5 times ***
		put #var MAX_ARRANGE 5
		shift
		}
	else put #var MAX_ARRANGE 1
	return
ARRANGE_ALL:
	put #var GH_ARRANGE_ALL ON
	shift
	return

## Backstabbing with a weapon
BS:
BACK:
BACKS:
BACKST:
BACKSTA:
BACKSTAB:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BACKSTAB: ***
		echo
	}
	if ("%guild" != "Thief") then
	{
		echo
		echo ***  Can only backstab if you are a thief!!  ***
		echo
		return
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	if ("$GH_FEINT" = "ON") then put #var GH_FEINT OFF
	put #var GH_AMBUSH ON
	var BACKSTAB ON
	var ALTEXP ON
	var EXP2 Backstab
	var CURR_RATE $%EXP2.LearningRate
	var CURRBACKSTABEXP $Backstab.LearningRate
	var LAST_ATTACK none
	counter set 1300
	var CURR_WEAPON %1
	var LAST GET_BS_WEAPON
GET_BS_WEAPON:
		matchre APPRAISE_BS You draw|already holding|free to
		match GET_BS_WEAPON2 out of reach
		match BEGIN_HAND need to have your right hand
	put wield my %CURR_WEAPON
	matchwait 15
	goto VARIABLE_ERROR
GET_BS_WEAPON2:
		matchre APPRAISE_BS You draw|already holding|free to
		match BEGIN_HAND need to have your right hand
	put get my %CURR_WEAPON
	matchwait 15
	goto VARIABLE_ERROR
	APPRAISE_BS:
		var LAST APPRAISE_BS
			matchre LE_BS (a|and) light edged
			matchre ME_BS (a|and) medium edged
			matchre SB_BS (a|and|the) small blunt
			matchre MB_BS (a|and|the) medium blunt
			matchre WEAPON_APPR_ERROR Roundtime|It's hard to appraise
		send appraise my %CURR_WEAPON quick
		matchwait 15
		goto WEAPON_APPR_ERROR
	LE_BS:
		var WEAPON_EXP Small_Edged
		var CURR_RATE $Small_Edged.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 unused
		var _COMBO7 unused
		var _COMBO8 unused
		goto 1_HANDED_WEAPON
	ME_BS:
		var WEAPON_EXP Small_Edged
		var CURR_RATE $Small_Edged.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 unused
		var _COMBO7 unused
		var _COMBO8 unused
		goto 1_HANDED_WEAPON
	SB_BS:
		var WEAPON_EXP Small_Blunt
		var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 unused
		var _COMBO7 unused
		var _COMBO8 unused
		goto 1_HANDED_WEAPON
	MB_BS:
		var WEAPON_EXP Small_Blunt
		var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 unused
		var _COMBO7 unused
		var _COMBO8 unused
		goto 1_HANDED_WEAPON

## Barbarian Expertise tactics
BAR:
BARB:
	put #var GH_ANALYZE ON
	var ANALYZEAMOUNT 1
	var BARB ON
	var barb.tact %1
	shift
	return

## Setting the stance to shield/blocking
BLO:
BLOC:
BLOCK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BLOCK: ***
		echo
	}
	var CURR_STANCE Shield_Usage
	SET_SHIELD_STANCE:
		var LAST SET_SHIELD_STANCE
			match RETURN You are now set to
		put stance shield
		matchwait 15
	return

## Will change arrange for SKIN to BONE
BON:
BONE:
if ("%GAG_ECHO" != "YES") then
{
	echo
	echo *** ARRANGE FOR BONE ***
	echo
}
put #var GH_BONE ON
return

## Will include buffing routine
BUF:
BUFF:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BUFF: ***
		echo
	}
	put #var GH_BUFF ON
	put #var GH_BUFF_INCLUDE 0
	return

## Will bundle anything skinned.  If skinning not enabled this does nothing.
BUN:
BUND:
BUNDL:
BUNDLE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BUNDLE: ***
		echo
	}
	put #var GH_BUN ON
	if ("$GH_SKIN" != "ON") then gosub SKIN
	return

## Implements brawling attacks
BRA:
BRAW:
BRAWL:
BRAWLI:
BRAWLIN:
BRAWLING:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BRAWLING: ***
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	var WEAPON_EXP Brawling
	var CURR_RATE $%WEAPON_EXP.LearningRate
	if_1 then goto BRAWL_CHECK
	BRAWL_EMPTY:
		var EMPTY_HANDED ON
		var _COMBO1 dodge
		var _COMBO2 attack
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		goto BRAWL_SETUP
	BRAWL_CHECK:
		if matchre ("%1","shield|\baegis\b|\bblock\b|buckler|carapace|heater|\bkwarf\b|\blid\b|pavise|platter|rondache|scutum|\bshell\b|\bsipar\b|\btarge\b|\btray\b|variog|\bwheel\b") then goto BRAWL_EMPTY
		var EMPTY_HANDED OFF
		var _COMBO1 dodge
		var _COMBO2 circle
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 500
		var CURR_WEAPON %1
		shift
	BRAWL_WEAPON:
		var LAST BRAWL_WEAPON
		gosub WIELD_WEAPON %CURR_WEAPON
		goto BRAWL_SETUP

COLL:
COLLE:
COLLEC:
COLLECT:
COLLECTIBLE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOOT_COLLECTIBLES: ***
		echo
	}
	if ("$GH_LOOT" != "ON") then put #var GH_LOOT ON
	put #var GH_LOOT_COLL ON
	return

CONS:
CONST:
CONSTR:
CONSTRU:
CONSTRUC:
CONSTRUCT:
	if "%GH_RITUALSPELL" = "ABSOLUTION" then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** CONSTRUCT: ***
		echo
	}
	put #var GH_CONSTRUCT ON
	action (hunt) goto DEAD_MONSTER when ^A granite gargoyle grumbles and falls over with a \*THUD\*\.$
	return

CUST:
CUSTO:
CUSTOM:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** CUSTOM STANCE: ***
		echo
	}
	action var PARRY_LEVEL $1 when ^You are currently using (\d+)% of your weapon parry skill
	action var EVAS_LEVEL $1 when ^You are currently using (\d+)% of your evasion skill
	action var SHIELD_LEVEL $1 when ^You are currently using (\d+)% of your shield block skill
	put stance custom
	waitfor You are now set to
	if (%PARRY_LEVEL > %EVAS_LEVEL) then
	{
		if (%PARRY_LEVEL > %SHIELD_LEVEL) then
		{

			var CURR_STANCE Parry_Ability
		}
		else
		{

			var CURR_STANCE Shield_Usage
		}
	}
	else
	{

		if (%EVAS_LEVEL >= %SHIELD_LEVEL) then
		{

			var CURR_STANCE Evasion
		} else
		{

			var CURR_STANCE Shield_Usage
		}
	}
	action remove ^You are currently using (\d+)% of your weapon parry skill
	action remove ^You are currently using (\d+)% of your evasion skill
	action remove ^You are currently using (\d+)% of your shield block skill
	return

## Dances with a number of creatures
## The number of creatures to dance with
COUNT:
DANCE:
	if ("%GAG_ECHO" != "YES") then
	{

		echo
		echo *** COUNT: ***
		echo
	}
	put #var GH_DANCING ON
	put #var GH_COUNT %1
	shift
	return

COUNTSKIP:
	if ("%GAG_ECHO" != "YES") then
	{

		echo
		echo *** SKIP COUNT/DANCING: ***
		echo
	}

	put #var GH_COUNTSKIP ON
	return

## Danger, adds retreating to buffing
DANGER:

	if ("%GAG_ECHO" != "YES") then
	{

		echo
		echo *** DANGER: ***
		echo
	}
	put #var GH_BUFF_DANGER ON
	if toupper("$GH_BUFF") != "YES") then gosub BUFF
	return

DEF:
DEFA:
DEFAU:
DEFAUL:
DEFAULT:
	if ("%GAG_ECHO" != "YES") then
	{

		echo
		echo *** DEFAULT: ***
		echo Using Default Settings
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	if ("$GH_MULTI" != "OFF") then goto DEFAULT_ERROR
	goto LOAD_DEFAULT_SETTINGS

DSET:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** DEFAULT-SET: ***
		echo Preparing to set Default settings
		echo
	}
	var DSET ON
	return

DMSET:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** DEFAULT-MULTI-SET: ***
		echo Preparing to setup up weapons to use in multi.
		echo Using other default settings
		echo
	}
	var SET_NUM 1
	SET_DM_STRING:
		if (SET_NUM > 10) then goto DONE_SET_DM
		put #var GH_MULTI_WEAPON_%SET_NUM %1
		math SET_NUM add 1
		shift
		if_1 goto SET_DM_STRING
	DONE_SET_DM:
	math SET_NUM subtract 1
	put #var GH_MULTI_NUM %SET_NUM
	goto DONE

DMULTI:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** DMULTI: ***
		echo
	}
	gosub clear
	put #var GH_EXP ON
	put #var GH_TRAIN ON
	put #var GH_MULTI DMULTI
	if matchre ("%1","^\d+$") then
	{
		put #var GH_MULTI_CURR_NUM %1
		if ($GH_MULTI_CURR_NUM > $GH_MULTI_NUM) then goto MULTI_ERROR
		put .hunt MULTIWEAPON $GH_MULTI_WEAPON_$GH_MULTI_CURR_NUM
	}
	put #var GH_MULTI_CURR_NUM 1
	put .hunt MULTIWEAPON $GH_MULTI_WEAPON_1
DMULTI_ERROR:
	echo
	echo *** DMULTI_ERROR: ***
	echo Something bad happened trying to multi-weapon with defaults
	goto DONE

DLOAD:
DUAL:
DUALL:
DUALLO:
DUALLOA:
DUALLOAD:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** DUAL LOAD: ***
		echo
	}
put #var GH_DUAL_LOAD ON
return

## Non-lethal brawling, useful for Empaths or dancing
EMP:
EMPU:
EMPA:
EMPUF:
EMPAT:
EMPUFF:
EMPATH:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** EMPATH_BRAWLING: ***
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	var WEAPON_EXP Tactics
	var _COMBO1 parry
	var _COMBO2 shove
	var _COMBO3 circle
	var _COMBO4 weave
	var _COMBO5 bob
	var _COMBO6 unused
	var _COMBO7 unused
	var _COMBO8 unused
	var EMPTY_HANDED ON
	counter add 500
	EMPATH_WEAPON_CHECK:
		var LAST EMPATH_WEAPON_CHECK
		if_1 then
		{
			if matchre ("%1","shield|buckler|pavise|heater|kwarf|sipar|lid|targe\b") then goto BRAWL_SETUP
			else
			{
				var CURR_WEAPON %1
				shift
				gosub WIELD_WEAPON %CURR_WEAPON
				var EMPTY_HANDED OFF
			}
		}
		goto BRAWL_SETUP

##Casts a single cyclic bard spell in combat
ENCH:
ENCHA:
ENCHAN:
ENCHANT:
ENCHANTE:
	if ("%GAG_ECHO" != "YES") then
	{
	echo
	echo *** ENCHANTE: Casting %1 at %2 mana. ***
	echo
	}
	put #var GH_ENCHANTE ON
	var enchante_list hodi|fae|botf|aewo|dalu|alb|eye|sanctuary|care|gj|pyre|aban
	var enchante_name %1
	shift
	var enchante_mana %1
	shift
	if matchre("%enchante_name","%enchante_list") then
	{
	if matchre("%enchante_name", "hodi|fae|botf") then
	{
	var enchante_school Augmentation
	echo Augmentation spell
	}
	else if matchre("%enchante_name", "aewo|dalu|alb") then
	{
	var enchante_school Debilitation
	echo Debilitation spell
	}
	else if matchre("%enchante_name", "eye|sanctuary|care") then
	{
	var enchante_school Utility
	echo Utility spell
	}
	else if matchre("%enchante_name", "gj") then
	{
	var enchante_school Warding
	echo Warding spell
	}
	else if matchre("%enchante_name", "aban|pyre") then
	{
	var enchante_school Targeted_Magic
	echo Targeted magic spell
	}
	}
	else
	{
	echo ERROR: Valid spells are hodi, fae, botf, aewo, dalu, alb, eye, sanctuary, care, gj, aban, and pyre
	exit
	}
	put prep %enchante_name %enchante_mana
	pause 1
	put release cyc
	pause 1
	waitfor You feel fully prepared
	put cast
	var enchante_timer 420
	return

## Sets the stance to evasion
DODGE:
EVAS:
EVAD:
EVASI:
EVADE:
EVASIO:
EVASION:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** EVASION: ***
		echo
	}
	var CURR_STANCE Evasion
	SET_EVAS_STANCE:
		var LAST SET_EVAS_STANCE
			match RETURN You are now set to
		put stance evasion
		matchwait 15
	return

## Will check exp, ends scripts when checked skill is locked
EXP:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** EXP: ***
		echo
	}
	put #var GH_EXP ON
	return

## This will use feint during combat to keep balance up
FEINT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FEINT: ***
		echo
	}
	if ("%BACKSTAB" != "ON") then put #var GH_FEINT ON
	return

FLEE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FLEE: ***
		echo
	}
	put #var GH_FLEE ON
	return

## Uses HUNT to train perception and stalk, but not move
HUNT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** HUNT: ***
		echo
	}
	put #var GH_HUNT ON
	var HUNT_TIME 0
	return

## Juggles when no monsters
JUGG:
JUGGL:
JUGGLE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** JUGGLE: ***
		echo
	}
	put #var GH_JUGGLE ON
	return

## Loots gems
JUNK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOOT_JUNK: ***
		echo
	}
	if ("$GH_LOOT" != "ON") then put #var GH_LOOT ON
	put #var GH_LOOT_JUNK ON
	return

## Uses KHRI
KHRI:
	if ("%GAG_ECHO" != "YES") then
	{
	echo
	echo *** THIEF KHRI: ***
	echo
	}
	put #var GH_KHRI ON
	var KHRI_TIME 0
	KHRI.SET:
	if matchre("%1", "focus|strike|prowess|avoidance|hasten|elusion|steady|flight|darken|dampen") then
	{
		if %1 = avoidance then var AVOIDANCE ON
		if %1 = dampen then var DAMPEN ON
		if %1 = darken then var DARKEN ON
		if %1 = elusion then var ELUSION ON
		if %1 = flight then var FLIGHT ON
		if %1 = focus then var FOCUS ON
		if %1 = hasten then var HASTEN ON
		if %1 = prowess then var PROWESS ON
		if %1 = steady then var STEADY ON
		if %1 = strike then var STRIKE ON
		shift
		goto KHRI.SET
	}
	return

## Loots everything
LOOTA:
LOOTAL:
LOOTALL:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOOT_ALL: ***
		echo
	}
	put #var GH_LOOT ON
	put #var GH_LOOT_GEM ON
	if ($BOXES >= 6) then put #var GH_LOOT_BOX OFF
	else put #var GH_LOOT_BOX ON
	put #var GH_LOOT_COIN ON
	put #var GH_LOOT_COLL ON
	return

## Loots boxes
LOOTB:
LOOTBO:
LOOTBOX:
LOOTBOXE:
LOOTBOXES:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOOT_BOXES: ***
		echo
	}
	if ("$GH_LOOT" != "ON") then put #var GH_LOOT ON
	if ($BOXES >= 6) then put #var GH_LOOT_BOX OFF
	else put #var GH_LOOT_BOX ON
	return

## Loots coins
LOOTC:
LOOTCO:
LOOTCOI:
LOOTCOIN:
LOOTCOINS:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOOT_COINS: ***
		echo
	}
	if ("$GH_LOOT" != "ON") then put #var GH_LOOT ON
	put #var GH_LOOT_COIN ON
	return

## Loots gems
LOOTG:
LOOTGE:
LOOTGEM:
LOOTGEMS:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOOT_GEMS: ***
		echo
	}
	if ("$GH_LOOT" != "ON") then put #var GH_LOOT ON
	put #var GH_LOOT_GEM ON
	return

POUCH:
if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SWAP_POUCH: ***
		echo
	}
	if ("$GH_LOOT" != "ON") then put #var GH_LOOT ON
	if ("$GH_LOOT_GEM" != "ON") then put #var GH_LOOT_GEM ON
	put #var GH_POUCH ON
	return

## Single cast of spell before non-magical combat
MAGIC:
	if contains("Barbarian|Commoner|Thief", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** MAGIC: ***
		echo
	}
	counter add 2000
	var MAGIC ON
	var ALTEXP OFF
	var EXP2 Debilitation
	var MAGIC_TYPE %1
	eval MAGIC_TYPE toupper("%MAGIC_TYPE")
	shift
	put #var GH_SPELL %1
	shift
	put #var GH_MANA %1
	shift
	if matchre ("%1","^\d+$") then
		{
			put #var GH_HARN %1
			if ("%GAG_ECHO" != "YES") then
			{
				echo *** Harnessing an extra %1 ***
			}
			shift
		} else put #var GH_HARN 0
	echo Casting $GH_SPELL with a prep of $GH_MANA and harnessing $GH_HARN
	if_1 return
	else goto BRAWL



## Starts training Multiple weapons
MULTI:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** MULTI: ***
		echo
	}
	gosub clear
	put #var GH_EXP ON
	put #var GH_TRAIN ON
	put #var GH_MULTI MULTI
	if matchre ("%1","^\d+$") then
	{
		put #var GH_MULTI_CURR_NUM %1
		if ($GH_MULTI_CURR_NUM > $GH_MULTI_NUM) then goto MULTI_ERROR
		put .hunt MULTIWEAPON $GH_MULTI_$GH_MULTI_CURR_NUM
	}
	put #var GH_MULTI_CURR_NUM 1
	put .hunt MULTIWEAPON $GH_MULTI_1
MULTI_ERROR:
	echo
	echo *** MULTI_ERROR: ***
	echo Something bad happened trying to multi-weapon
	goto DONE

MSET:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** MULTI-SET: ***
		echo Preparing to setup up multi-weapon training
		echo
	}
	gosub clear
	var SET_NUM 1
	SET_M_STRING:
		if (SET_NUM > 11) then goto DONE_M_SET
		put #var GH_MULTI_%SET_NUM %1
		math SET_NUM add 1
		shift
		if_1 goto SET_M_STRING
	DONE_M_SET:
	math SET_NUM subtract 1
	put #var GH_MULTI_NUM %SET_NUM
	goto DONE

#Necromancer healing
NECROH:
NECROHE:
NECROHEA:
NECROHEAL:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NECROHEAL: ***
		echo
	}
	if "$guild" = "Necromancer" then put #var GH_NECROHEAL ON
	return

#Necromancer ritual
NECROR:
NECRORI:
NECRORIT:
NECRORITU:
NECRORITUA:
NECRORITUAL:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NECRORITUAL: ***
		echo
	}
	if "$guild" = "Necromancer" then
	{
		if toupper("%1") = "HARVEST" || toupper("%1") = "DISSECT" || toupper("%1") = "PRESERVE" || toupper("%1") = "ARISE" then
		{
		put #var GH_NECRORITUAL %1
		shift
		}
		else
		put #var GH_NECRORITUAL dissect
	}
	return

# Not using evasion stance in stance switching
NOEVADE:
NOEVAS:
NOEVASION:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NOEVADE: ***
		echo
	}
	var NOEVADE ON
	return

# Not using parry stance in stance switching
NOPA:
NOPARRY:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NOPARRY: ***
		echo
	}
	var NOPARRY ON
	return

# Not using shield stance in stance switching
NOSH:
NOSHIELD:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NOSHIELD: ***
		echo
	}
	var NOSHIELD ON
	return

## Uses the weapon in the offhand
## Currently just for throwing weapons from the left hand
OFF:
OFFH:
OFFHA:
OFFHAN:
OFFHAND:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** OFFHAND: ***
		echo
	}
	var HAND left
	var HAND2 right
	var ALTEXP ON
	var EXP2 Offhand_Weapon
	var CURR_RATE $%EXP2.LearningRate
	return

## Sets the stance to parry
PARRY:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** PARRY: ***
		echo
	}
	var CURR_STANCE Parry_Ability
	SET_PARRY_STANCE:
		var LAST SET_PARRY_STANCE
			match RETURN You are now set to
		put stance parry
		matchwait 15
	return

PART:
if ("%GAG_ECHO" != "YES") then
{
	echo
	echo *** ARRANGE FOR PART ***
	echo
}
put #var GH_PART ON
return

PILGRIM:
	if contains("Barbarian|Bard|Commoner|Empath|Moon Mage|Necromancer|Ranger|Thief|Trader|Warrior Mage", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** PILGRIM'S BADGE: ***
		echo
	}
	var PILGRIM_TIME 0
	put #var GH_PILGRIM ON
	return

PP:
POW:
POWER:
POWERP:
	if contains("Barbarian|Commoner|Thief", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** POWER PERCEIVE: ***
		echo
	}
	put #var GH_PP ON
	var PP_TIME 0
	return

MANIP:
	if contains("Barbarian|Bard|Cleric|Commoner|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FRIENDSHIP MANIPULATION: ***
		echo
	}
	var MANIP_TIME 0
	put #var GH_MANIP ON
	return

MARK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** THIEF MARK ***
		echo
	}
	put #var GH_MARK ON
	put #var GH_APPR YES
	return

NIS:
NISS:
NISSA:
	if contains("Barbarian|Bard|Cleric|Commoner|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** EMPATH DEBILITATION (NISSA'S BINDING): ***
		echo
	}
	var nissa_time 0
	if matchre("%1","^\d+$") then
	{
	var nissamana %1
	evalmath nissaharness round(%nissamana / 2)
	if ("%GAG_ECHO" != "YES") then echo *** Casting Nissa's Binding with %1 mana ***
	shift
	}
	put #var GH_NISSA ON
	return

PARA:
PARAL:
PARALY:
PARALYS:
PARALYSI:
PARALYSIS:
	if contains("Barbarian|Bard|Cleric|Commoner|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** EMPATH PARALYSIS (TM): ***
		echo
	}
	var PARALYSIS_TIME 0
	if matchre("%1","^\d+$") then
	{
	var PARAMANA %1
	if ("%GAG_ECHO" != "YES") then echo *** Casting Paralysis with %1 mana ***
	shift
	}
	put #var GH_PARALYSIS ON
	return

SMITE:
	if contains("Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Necromancer|Ranger|Thief|Trader|Warrior Mage", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SMITE: ***
		echo
	}
	put #var GH_SMITE ON
	var SMITE_TIME 0
	return

## Casts a spell using non-targeted magic
PM:
TM:
DEBIL:
AUG:
UTIL:
	if contains("Barbarian|Commoner|Thief", "%guild") then return
	if (toupper("%OPTION") = "TM") then
	{
		var MAGIC OFF
		var MAGIC_TYPE TM
	}
	if (toupper("%OPTION") = "DEBIL") then
	{
		var MAGIC OFF
		var MAGIC_TYPE DEBIL
	}
	if (toupper("%OPTION") = "AUG") then
	{
		var MAGIC OFF
		var MAGIC_TYPE AUG
	}
	if (toupper("%OPTION") = "UTIL") then
	{
		var MAGIC OFF
		var MAGIC_TYPE UTIL
	}
	if (toupper("%OPTION") = "PM") then
	{
		var MAGIC OFF
		var MAGIC_TYPE PM
	}
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** %MAGIC_TYPE: ***
		echo
	}
	counter add 2000
	var ALTEXP ON
	if (toupper("%MAGIC_TYPE") = "TM") then
	{
		var EXP2 Targeted_Magic
		var CURR_RATE $%EXP2.LearningRate
	}
	if (toupper("%MAGIC_TYPE") = "DEBIL") then
	{
		var EXP2 Debilitation
		var CURR_RATE $%EXP2.LearningRate
	}
	if (toupper("%MAGIC_TYPE") = "PM") then
	{
		var EXP2 Primary_Magic
		var CURR_RATE $%EXP2.LearningRate
	}
	if (toupper("%MAGIC_TYPE") = "AUG") then
	{
		var EXP2 Augmentation
		var CURR_RATE $%EXP2.LearningRate
	}
	if (toupper("%MAGIC_TYPE") = "UTIL") then
	{
		var EXP2 Utility
		var CURR_RATE $%EXP2.LearningRate
	}
	put #var GH_SPELL %1
	shift
	put #var GH_MANA %1
	shift
	if matchre ("%1","^\d+$") then
		{
			put #var GH_HARN %1
			if ("%GAG_ECHO" != "YES") then echo *** Harnessing an extra %1 ***
			shift
		} else put #var GH_HARN 0
	echo Casting $GH_SPELL with a prep of $GH_MANA and harnessing $GH_HARN
	action (summon) put #var pathway ON when ^You focus on manipulating
	action (summon) put #var pathway OFF when ^You gently relax your mind and release your hold on the aethereal pathways\.$
	action (summon) put #var pathway OFF when eval $Summoning.LearningRate < 30
	action (summon) put pathway stop when eval $Summoning.LearningRate >= 30
	action (summon) on
	if_1 return
	else goto BRAWL

## Poaching a target, if target is unpoachable, just fires
POACH:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** POACH: ***
		echo
	}
	var FIRE_TYPE POACH
	var ALTEXP ON
	var EXP2 Stealth
	var starter.room $roomid
	var CURRSTEALTHEXP $%EXP2.LearningRate
	var CURR_RATE $%EXP2.LearningRate
	if "$GH_ROAM" = "OFF" then action (stalk) on
	return

## Point out hidden creatures
POINT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** POINT: ***
		echo
	}
	action (point) on
	return

### Turns off Retreating
RET:
RETREAT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** RETREAT: ***
		echo
	}
	put #var GH_RETREAT ON
	return

## Maintains a ritual spell
RITUAL:
	if contains("Barbarian|Commoner|Thief", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo ***  RITUAL SPELL:  ***
		echo
	}
	if (toupper("%OPTION") = "RITUAL") then
	{
	put #var GH_RITUAL ON
	var GH_RITUALSPELL %1
	var GH_RITUALMANA %2
	}
	shift
	shift
	if "%GH_RITUALSPELL" = "ABSOLUTION" then put #var GH_CONSTRUCT OFF
	return

# Roam hunting area if all creatures in your room are dead
ROAM:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ROAM: ***
		echo
	}
	put #var GH_ROAM ON
	if "$GH_AMBUSH" = "ON" then action (stalk) off
	return

# Scrape skins/pelts/hides after skinning
SCRAPE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SCRAPE: ***
		echo
	}
	if ("$GH_SKIN" != "ON") then gosub SKIN
	put #var GH_SCRAPE ON
	return

SCREAM:
	if (!matchre("$guild", "Bard")) then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SCREAM: ***
		echo
	}
	action (SCREAM) var SCREAM_HAVOC OFF when ^You feel sufficiently recovered to use your cry of havoc again\.$
	action (SCREAM) var SCREAM_DEFIANCE OFF when ^You feel sufficiently recovered to use your.*defiance.*\.$
	action (SCREAM) var SCREAM_CONCUSSIVE OFF when ^You feel sufficiently recovered to use your concussive scream again\.$
	action (SCREAM) put #var SCREAM_TIMER #evalmath $gametime + 600 when ^You open your mouth, then close it suddenly, looking somewhat like a fish\.
	if $circle >= 30 then var SCREAM_DEFIANCE OFF
	if $Circle >= 2 then
	{
		var SCREAM_CONCUSSIVE OFF
		var SCREAM_HAVOC OFF
	}
	put #var GH_SCREAM ON
	return

# Sets looting option
SEARCH:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SEARCH: ***
		echo
	}
	if toupper("%1") = "ALL" || toupper("%1") = "TREASURE" || toupper("%1") = "BOXES"  || toupper("%1") = "EQUIPMENT"  || toupper("%1") = "GOODS" then
	{
		put #var GH_SEARCH %1
		shift
	}
	return

## Skins creatures that can be skinned
SKIN:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SKIN: ***
		echo
	}
	var BELT_WORN OFF
	action var BELT_WORN ON when ^You are wearing.+(ankle|arm|belt|outdoors|ritualist'?s?|skinning|tail|thigh|wrist|steel) (blade|knife)
	put inventory
	waitforre ^You are wearing
	action remove ^You are wearing.+(ankle|arm|belt|outdoors|ritualist'?s?|skinning|tail|thigh|wrist) (blade|knife)
	put #var GH_SKIN ON
	if "$GH_BONE" = "ON" then put #var GH_SKINPART BONE
	if "$GH_PART" = "ON" then put #var GH_SKINPART PART
	if "$GH_BONE" = "OFF" && "$GH_PART" = "OFF" then put #var GH_SKINPART SKIN
	return

## Retreats while skinning
SKINR:
SKINRE:
SKINRET:
SKINRETREAT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SKINRET: ***
		echo
	}
	if ("$GH_SKIN" != "ON") then gosub SKIN
	put #var GH_SKIN_RET ON
	return

## Pauses between combat manuevers to sustain stamina
SLOW:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo ***  SLOW:  ***
		echo
	}
	put #var GH_SLOW ON
	return

## Snapfires a ranged weapon or snapcasts spells
SNAP:
SNAPFIRE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SNAP: ***
		echo
	}
	put #var GH_SNAP ON
	if matchre ("%1", "(\d+)") then
	{
		put #var GH_PAUSE_SNAP $1
		shift
	} else put #var GH_PAUSE_SNAP 0
	return

## Snipes with a ranged weapon
SNIP:
SNIPE:
SNIPING:
	if contains("Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Paladin|Trader|Warrior Mage", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SNIPE: ***
		echo
	}
	var FIRE_TYPE SNIPE
	var ALTEXP ON
	var EXP2 Stealth
	return

SPE:
SPEL:
SPELL:
SPELLW:
SPELLWE:
SPELLWEA:
SPELLWEAV:
SPELLWEAVE:
	if contains("Barbarian|Thief", "%guild") then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SPELLWEAVING: ***
		echo
	}
	action (SPELLWEAVE) var FULL_PREP YES when ^You feel fully prepared to cast your spell\.
	action (SPELLWEAVE) var FULL_PREP YES when ^The formation of the target pattern around|^Your formation of a targeting pattern|^Your target pattern dissipates
	var FULL_PREP NO
	var SPELLWEAVE ON
	var ALTEXP OFF
	var MAGIC_TYPE %1
	eval MAGIC_TYPE toupper("%MAGIC_TYPE")
	if matchre("%MAGIC_TYPE", "AUG|AUGM|AUGME|AUGMEN|AUGMENT|AUGMENTA|AUGMENTAT|AUGMENTATI|AUGMENTATIO|AUGMENTATION") then var MAGIC_TYPE AUG
	if matchre("%MAGIC_TYPE", "DEB|DEBI|DEBIL") then var MAGIC_TYPE DEBIL
	if matchre("%MAGIC_TYPE", "TM|TAR|TARG|TARGE|TARGET") then var MAGIC_TYPE TM
	if matchre("%MAGIC_TYPE", "UTI|UTIL|UTILI|UTILIT|UTILITY") then var MAGIC_TYPE UTIL
	if matchre("%MAGIC_TYPE", "WAR|WARD|WARDI|WARDIN|WARDING") then var MAGIC_TYPE WARD
	shift
	put #var GH_SPELL %1
	shift
	put #var GH_MANA %1
	shift
	if matchre ("%1","^\d+$") then
		{
			put #var GH_HARN %1
			if ("%GAG_ECHO" != "YES") then
			{
				echo *** Harnessing an extra %1 ***
			}
			shift
		} else put #var GH_HARN 0
	echo Casting $GH_SPELL with a prep of $GH_MANA and harnessing $GH_HARN
	if_1 return
	else goto BRAWL

## Will cycle through stances
STA:
STAN:
STANC:
STANCE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** STANCE: ***
		echo
	}
	action var PARRY_LEVEL $1 when ^You are currently using (\d+)% of your weapon parry skill
	action var EVAS_LEVEL $1 when ^You are currently using (\d+)% of your evasion skill
	action var SHIELD_LEVEL $1 when ^You are currently using (\d+)% of your shield block skill
	put #var GH_STANCE ON
	put stance
	waitfor Last Combat Maneuver:
	if (%PARRY_LEVEL > %EVAS_LEVEL) then
	{
		if (%PARRY_LEVEL > %SHIELD_LEVEL) then
		{
			var CURR_STANCE Parry_Ability
		} else
		{
			var CURR_STANCE Shield_Usage
		}
	} else
	{
		if (%EVAS_LEVEL >= %SHIELD_LEVEL) then
		{
			var CURR_STANCE Evasion
		} else
		{
			var CURR_STANCE Shield_Usage
		}
	}
	action remove ^You are currently using (\d+)% of your weapon parry skill
	action remove ^You are currently using (\d+)% of your evasion skill
	action remove ^You are currently using (\d+)% of your shield block skill
	echo %CURR_STANCE
	return

## Throws a stacked weapon (e.g. throwing blades)
STACK:
STACKS:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** STACK: ***
		echo
	}
	var STACK ON
	goto THROW

SWAP:
BAST:
BASTA:
BASTAR:
BASTARD:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SWAP: ***
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	var SWAP_TYPE %1
	var GOING_TO WEAPON_CHECK
	shift
	goto SWAP_WIELD

TSWAP:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** THROWN SWAP: ***
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	var SWAP_TYPE %1
	var GOING_TO THROW_VARI
	counter add 1200
	shift

## Swap but for fans
FSWAP:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FAN SWAP: ***
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	var FSWAP_TYPE %1
	var FAN_STATUS CLOSED
	var GOING_TO WEAPON_CHECK
	shift
	goto FSWAP_WIELD
	FSWAP_WIELD:
		var LAST FSWAP_WIELD
		matchre FSWAP_%FSWAP_TYPE You draw|already holding|free to|With a flick of your wrist
		match BEGIN_HANDS free hand|need to have your right hand
		matchre FSWAP_REMOVE out of reach|remove|What were you|can't seem|Wield what\?
		match VARIABLE_ERROR You can only wield a weapon or a shield!
		put wield right my %1
		matchwait 15
	FSWAP_REMOVE:
		var LAST FSWAP_REMOVE
		matchre FSWAP_%FSWAP_TYPE You sling|re already|inventory|you remove
		matchre FSWAP_GET Remove what|You aren't wearing
		match BEGIN_HANDS hands are full
		put remove my %1
		matchwait 15
	FSWAP_GET:
		var LAST FSWAP_GET
		match FSWAP_%FSWAP_TYPE You get
		match VARIABLE_ERROR What were you
		put get my %1
		matchwait 15
		goto VARIABLE_ERROR
	FSWAP_SE:
		var LAST FSWAP_SE
		if ("%FAN_STATUS" = "CLOSED") then
		{
			matchre PAUSE (heavy|two-handed) edged|(heavy|medium|light|two-handed) blunt|(short|quarter) staff|pike|halberd
			matchre %GOING_TO (medium|light) edged
			put open my %1
			var FAN_STATUS OPENED
			matchwait 15
			goto SWAP_ERROR
		}
		if ("%FAN_STATUS" = "OPENED") then
		{
			matchre PAUSE (heavy|two-handed) edged|(heavy|medium|light|two-handed) blunt|(short|quarter) staff|pike|halberd
			matchre %GOING_TO (medium|light) edged
			put close my %1
			var FAN_STATUS CLOSED
			matchwait 15
			goto SWAP_ERROR
		}
	FSWAP_S:
		var LAST FSWAP_S
		if ("%FAN_STATUS" = "CLOSED") then
		{
			matchre PAUSE (heavy|medium|light|two-handed) edged|(heavy|medium|light|two-handed) blunt|pike|halberd
			matchre %GOING_TO (short|quarter) staff
			put open my %1
			var FAN_STATUS OPENED
			matchwait 15
			goto SWAP_ERROR
		}
		if ("%FAN_STATUS" = "OPENED") then
		{
			matchre PAUSE (heavy|medium|light|two-handed) edged|(heavy|medium|light|two-handed) blunt|pike|halberd
			matchre %GOING_TO (short|quarter) staff
			put close my %1
			var FAN_STATUS CLOSED
			matchwait 15
			goto SWAP_ERROR
		}

	SWAP_WIELD:
		var LAST SWAP_WIELD
			matchre SWAP_%SWAP_TYPE You draw|already holding|free to|With a flick of your wrist
			match BEGIN_HANDS free hand|need to have your right hand
			matchre SWAP_REMOVE out of reach|remove|What were you|can't seem|Wield what\?
			match VARIABLE_ERROR You can only wield a weapon or a shield!
		put wield right my %1
		matchwait 15
	SWAP_REMOVE:
		var LAST SWAP_REMOVE
			matchre SWAP_%SWAP_TYPE You sling|re already|inventory|you remove
			matchre SWAP_GET Remove what|You aren't wearing
			match BEGIN_HANDS hands are full
		put remove my %1
		matchwait 15
	SWAP_GET:
		var LAST SWAP_GET
			match SWAP_%SWAP_TYPE You get
			match VARIABLE_ERROR What were you
		put get my %1
		matchwait 15
		goto VARIABLE_ERROR
	SWAP_SE:
		var LAST SWAP_SE
			matchre PAUSE (heavy|two-handed) edged|(heavy|medium|light|two-handed) blunt|(short|quarter) staff|pike|halberd
			matchre %GOING_TO (medium|light) edged
		put swap my %1
		matchwait 15
		goto SWAP_ERROR
	SWAP_LE:
		var LAST SWAP_LE
			matchre PAUSE (medium|light|two-handed) edged|(heavy|medium|light|two-handed) blunt|(short|quarter) staff|pike|halberd
			match %GOING_TO heavy edged
		put swap my %1
		matchwait 15
		goto SWAP_ERROR
	SWAP_SB:
		var LAST SWAP_SB
			matchre PAUSE (heavy|medium|light|two-handed) edged|(heavy|two-handed) blunt|(short|quarter) staff|pike|halberd
			matchre %GOING_TO (medium|light) blunt
		put swap my %1
		matchwait 15
		goto SWAP_ERROR
	SWAP_LB:
		var LAST SWAP_LB
			matchre PAUSE (heavy|medium|light|two-handed) edged|(medium|light|two-handed) blunt|(short|quarter) staff|pike|halberd
			match %GOING_TO heavy blunt
		put swap my %1
		matchwait 15
		goto SWAP_ERROR
	SWAP_2HE:
		var LAST SWAP_2HE
			matchre PAUSE (heavy|medium|light) edged|(heavy|medium|light|two-handed) blunt|(short|quarter) staff|pike|halberd
			match %GOING_TO two-handed edged
		put swap my %1
		matchwait 15
		goto SWAP_ERROR
	SWAP_2HB:
		var LAST SWAP_2HB
			matchre PAUSE (heavy|medium|light|two-handed) edged|(heavy|medium|light) blunt|(short|quarter) staff|pike|halberd
			match %GOING_TO two-handed blunt
		put swap my %1
		matchwait 15
		goto SWAP_ERROR

	SWAP_POLE:
		var LAST SWAP_POLE
			matchre PAUSE (heavy|medium|light|two-handed) edged|(heavy|medium|light|two-handed) blunt|(short|quarter) staff
			matchre %GOING_TO pike|halberd
		put swap my %1
		matchwait 60
		goto SWAP_ERROR
	SWAP_S:
		var LAST SWAP_S
			matchre PAUSE (heavy|medium|light|two-handed) edged|(heavy|medium|light|two-handed) blunt|pike|halberd
			matchre %GOING_TO (short|quarter) staff
		put swap my %1
		matchwait 60
		goto SWAP_ERROR

## Trains tactics as part of routine
TAC:
TACT:
TACTIC:
TACTICS:
if ("%GAG_ECHO" != "YES") then
{
  echo
  echo *** TACTICS: ***
  echo
}
put #var GH_TACTICS ON
return

## Sets a bodypart to target for ranged & spells
TARG:
TARGET:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** TARGET: ***
		echo
	}
	if matchre ("%1","^\D+$") then
	{
		put #VAR GH_TARGET %1
		echo Targetting the %1 with attacks.
		shift
	}
	return

THIEF:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** THIEF AMBUSHES ***
		echo
	}
	put #var GH_THIEF ON
	return

## Uses HURL to throw weapons and make them stick
HURL:
	var HURL ON
	goto throw

## Uses LOB to throw weapons and prevent them from sticking
LOB:
	var LOB ON
	goto throw

## Throws a weapon
THROW:
THROWN:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** THROWN: ***
		echo
	}
	gosub clear
	gosub GENERAL_TRIGGERS
	var THROWN ON
	counter add 1200
	WIELD_THROWN:
		var LAST WIELD_THROWN
			matchre THROW_VARI You draw|already holding|free to|With a flick of your wrist
			match BEGIN_HANDS free hand|need to have your right hand
			matchre THROW_EQUIP out of reach|remove|What were you|can't seem|Wield what\?|^You can only wield
		put wield right my %1
		matchwait 60

	THROW_EQUIP:
			matchre THROW_VARI You sling|re already|inventory|You remove|right hand
			matchre THROW_EQUIP_2 ^Remove what\?|You aren't wearing that
			match BEGIN_HANDS hands are full
		put remove my %1
		matchwait 60

	THROW_EQUIP_2:
			matchre THROW_VARI ^You get|^You are already holding
			matchre VARIABLE_CHECK ^What were you
		put get my %1
		matchwait 15
	goto VARIABLE_ERROR

	THROW_VARI:
		var LAST THROW_VARI
		var CURR_WEAPON %1
		if ("$GH_FEINT" = "ON") then put #var GH_FEINT OFF
		if ("%MAGIC_TYPE" != "OFF") then var MAGIC_COUNT %c
		if (("%HAND" = "left") && ("$lefthand" = "Empty")) then gosub SWAP_LEFT $righthandnoun
		else if_2 then gosub EQUIP_SHIELD %2
	APPRAISE_THROWN:
		var LAST APPRAISE_THROWN
		if (toupper("%CURR_WEAPON") = "LOG") then goto HT
		if (toupper("%CURR_WEAPON") = "ROCK") then goto LT
			matchre LT light thrown|small blunt
			matchre HT heavy thrown|heavy blunt
			matchre WEAPON_APPR_ERROR Roundtime|It's hard to appraise
		send appraise my %CURR_WEAPON quick
		matchwait 15
		goto WEAPON_APPR_ERROR
	LT:
		var T_SHEATH %LT_SHEATH
		var WEAPON_EXP Light_Thrown
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		else var CURR_RATE $%EXP2.LearningRate
		if ("%DSET" = "ON") then goto SET_DEFAULT
		else goto %c
	HT:
		var T_SHEATH %HT_SHEATH
		var WEAPON_EXP Heavy_Thrown
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		else var CURR_RATE $%EXP2.LearningRate
		if ("%DSET" = "ON") then goto SET_DEFAULT
		else goto %c

## Will tie bundles.
TIE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** TIE: ***
		echo
	}
	put #var GH_TIE ON
	if ("$GH_BUNDLE" != "ON") then gosub BUNDLE
	return

## Wears bunles
WEAR:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** WEAR: ***
		echo
	}
	put #var GH_WEAR ON
	if ("$GH_BUNDLE" != "ON") then gosub BUNDLE
	return

TIME:
TIMER:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** TIMER: ***
		echo
	}
	put #var GH_TIMER ON
	var START_TIME %t
	if matchre ("%1", "(\d+)") then
	{
		var MAX_TRAIN_TIME $1
		shift
	}
	math MAX_TRAIN_TIME add %START_TIME
	return

TRAIN:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** TRAIN: ***
		echo
	}
	put #var GH_EXP ON
	put #var GH_TRAIN ON
	return

## Juggles a yoyo when no monsters
YOYO:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** YOYO: ***
		echo
	}
	put #var GH_JUGGLE ON
	var YOYO ON
	return

####################################
##                                ##
##    End variables & options     ##
##                                ##
####################################

BEGIN_HANDS:
	echo
	echo *** BEGIN_HANDS: ***
	echo
	echo *************************************
	echo **  Empty your hands and try again **
	echo **         Ending script           **
	echo *************************************
	echo
	exit

###############################
##                           ##
##  Weapon checking section  ##
##                           ##
###############################

WEAPON_CHECK:
	put #var GH_LAST_COMMAND appraise my %CURR_WEAPON quick
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** WEAPON_CHECK: ***
		echo
	}
	var LAST WEAPON_CHECK
	gosub clear
	if ("%BACKSTAB" != "ON") then var CURR_WEAPON %1
		matchre LE (a|and) light edged
		matchre ME (a|and) medium edged
		matchre HE (a|and) heavy edged
		matchre 2HE (a|and) two-handed edged
		matchre LB (a|and) light blunt
		matchre MB (a|and) medium blunt
		matchre HB (a|and) heavy blunt
		matchre 2HB (a|and) two-handed blunt
		matchre STAFF_SLING (a|and) staff sling
		matchre SHORT_BOW (a|and) short ?bow
		matchre LONG_BOW (a|and) long ?bow
		matchre COMP_BOW (a|and) composite ?bow
		matchre BLOWGUN (a|and) brawling
		matchre LX  (a|and) light crossbow
		matchre HX (a|and) heavy crossbow
		matchre SHORT_STAFF (a|and) short staff
		matchre Q_STAFF (a|and) quarter ?staff
		matchre PIKE (a|and) pike
		matchre HALBERD (a|and) halberd
		matchre SLING (a|and) sling
		matchre WEAPON_APPR_ERROR Roundtime|It's hard to appraise
	put appraise my %CURR_WEAPON quick
	matchwait 15
	goto WEAPON_APPR_ERROR

	2HE:
		echo
		echo *** 2HE: ***
		echo
		var WEAPON_EXP Twohanded_Edged
		if ("%ALTEXP" != "ON") then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		if ("%HAND" = "left") then
		{
			var HAND
			var ALTEXP NONE
		}
		goto 2_HANDED_WEAPON

	HE:
		echo
		echo *** HE: ***
		echo
		var WEAPON_EXP Large_Edged
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		if matchre("$righthandnoun", "cinquedea") then goto HE_STAB
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		goto 1_HANDED_WEAPON
	HE_SLICE:
		echo
        echo *** HE Slicer ***
		echo
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 attack
		var _COMBO8 attack
		counter add 800
		goto 1_HANDED_WEAPON

	HE_STAB:
		echo
		echo *** HE Stabber ***
		echo
		var _COMBO1 parry
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 attack
		var _COMBO8 unused
		counter add 700
		goto 1_HANDED_WEAPON
	ME:
		echo
		echo *** ME: ***
		echo
		var WEAPON_EXP Small_Edged
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		if matchre("$righthand","adze|axe|cleaver|curlade|cutlass|hanger|hatchet|lata'oloh|mallet|mirror blade|nimsha|parang|riste|sapara|scimitar|scythe-blade|shotel|sword|tei'oloh'ata|telo|zobens") then goto ME_SLICE
		if matchre("$righthand","baselard|blade|foil|gladius|nambeli|pasabas|rapier|saber|sabre|shashqa|yataghan") then goto ME_STAB
		if matchre("$righthand","iltesh") then goto ME_ILTESH
		goto WEAPON_APPR_ERROR

		ME_SLICE:
			echo
			echo *** ME_SLICE: ***
			echo
			var _COMBO1 parry
			var _COMBO2 feint
			var _COMBO3 attack
			var _COMBO4 attack
			var _COMBO5 attack
			var _COMBO6 attack
			var _COMBO7 unused
			var _COMBO8 unused
			counter add 600
		goto 1_HANDED_WEAPON

		ME_ILTESH:
			echo
			echo *** ME_ILTESH: ***
			echo
			var _COMBO1 feint
			var _COMBO2 attack
			var _COMBO3 attack
			var _COMBO4 attack
			var _COMBO5 attack
			var _COMBO6 attack
			var _COMBO7 attack
			var _COMBO8 attack
			counter add 800
		goto 1_HANDED_WEAPON

		ME_STAB:
			echo
			echo *** ME_THRUST: ***
			echo
			var _COMBO1 parry
			var _COMBO2 feint
			var _COMBO3 attack
			var _COMBO4 attack
			var _COMBO5 attack
			var _COMBO6 unused
			var _COMBO7 unused
			var _COMBO8 unused
			counter add 500
		goto 1_HANDED_WEAPON

	LE:
		echo
		echo *** LE: ***
		echo
		var WEAPON_EXP Small_Edged
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		if matchre("$righthandnoun", "bin|blade|bodkin|dagger|dirk|kasai|kindjal|lata|marlinspike|misericorde|pick|poignard|pugio|shavi|shriike|stiletto|takouba|telek") then goto LE_STAB
		if matchre("$righthandnoun", "fan|dao|falcata|jambiya|kanabu|katar|knife|kounmya|kris|kythe|nehlata|oben|sword|tago|uenlata") then goto LE_SLICE
		goto WEAPON_APPR_ERROR

		LE_SLICE:
			echo
			echo *** LE_SLICE: ***
			echo
			var _COMBO1 parry
			var _COMBO2 feint
			var _COMBO3 attack
			var _COMBO4 attack
			var _COMBO5 attack
			var _COMBO6 attack
			var _COMBO7 unused
			var _COMBO8 unused
			counter add 600
		goto 1_HANDED_WEAPON

		LE_STAB:
			echo
			echo *** LE_STAB: ***
			echo
			var _COMBO1 parry
			var _COMBO2 feint
			var _COMBO3 attack
			var _COMBO4 attack
			var _COMBO5 attack
			var _COMBO6 unused
			var _COMBO7 unused
			var _COMBO8 unused
			counter add 500
		goto 1_HANDED_WEAPON

	2HB:
		echo
		echo *** 2HB: ***
		echo
		var RANGED OFF
		var WEAPON_EXP Twohanded_Blunt
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var _COMBO1 dodge
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		if ("%HAND" = "left") then
		{
			var HAND
			var ALTEXP NONE
		}
		goto 2_HANDED_WEAPON

	HB:
		echo
		echo *** HB: ***
		echo
		var WEAPON_EXP Large_Blunt
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 dodge
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		goto 1_HANDED_WEAPON

	MB:
		echo
		echo *** MB: ***
		echo
		var WEAPON_EXP Small_Blunt
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 dodge
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		goto 1_HANDED_WEAPON

	LB:
		echo
		echo *** LB: ***
		echo
		var WEAPON_EXP Small_Blunt
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 dodge
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 attack
		var _COMBO8 unused
		counter add 700
		goto 1_HANDED_WEAPON

	HALBERD:
		echo
		echo *** HALBERD: ***
		echo
		var WEAPON_EXP Polearms
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 dodge
		var _COMBO2 feint
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		if ("%HAND" = "left") then
		{
			var HAND
			var ALTEXP NONE
		}
		goto 2_HANDED_WEAPON

	PIKE:
		echo
		echo *** PIKE: ***
		echo
		var WEAPON_EXP Polearms
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 dodge
		var _COMBO2 attack
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 unused
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 500
		if ("%HAND" = "left") then
		{
			var HAND
			var ALTEXP NONE
		}
		goto 2_HANDED_WEAPON

	SHORT_STAFF:
		echo
		echo *** SHORT_STAFF: ***
		echo
		var WEAPON_EXP Staves
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 attack
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 unused
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 500
		goto 1_HANDED_WEAPON

	Q_STAFF:
		echo
		echo *** QUARTER_STAFF: ***
		echo
		var WEAPON_EXP Staves
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED OFF
		var _COMBO1 parry
		var _COMBO2 attack
		var _COMBO3 attack
		var _COMBO4 attack
		var _COMBO5 attack
		var _COMBO6 attack
		var _COMBO7 unused
		var _COMBO8 unused
		counter add 600
		if ("%HAND" = "left") then
		{
			var HAND
			var ALTEXP NONE
		}
		goto 2_HANDED_WEAPON

	SHORT_BOW:
		echo
		echo *** SHORT_BOW: ***
		echo
		var WEAPON_EXP Bow
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %BOW_AMMO
		pause 1
		put retreat
		counter add 1000
		goto 2_HANDED_WEAPON

	LONG_BOW:
		echo
		echo *** LONG_BOW: ***
		echo
		var WEAPON_EXP Bow
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %BOW_AMMO
		pause 1
		put retreat
		counter add 1000
		goto 2_HANDED_WEAPON

	COMP_BOW:
		echo
		echo *** COMP_BOW: ***
		echo
		var WEAPON_EXP Bow
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %BOW_AMMO
		pause 1
		put retreat
		counter add 1000
		goto 2_HANDED_WEAPON

	HX:
		echo
		echo *** HX: ***
		echo
		var WEAPON_EXP Crossbow
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %XB_AMMO
		pause 1
		put retreat
		counter add 1000
		goto 2_HANDED_WEAPON

	LX:
		echo
		echo *** LX: ***
		echo
		var WEAPON_EXP Crossbow
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %XB_AMMO
		pause 1
		put retreat
		counter add 1000
		goto LX_SLING

	SLING:
		echo
		echo *** SLING: ***
		echo
		var WEAPON_EXP Slings
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %SLING_AMMO
		pause 1
		put retreat
		counter add 1000
		goto LX_SLING

	STAFF_SLING:
		echo
		echo *** STAFF_SLING: ***
		echo
		var WEAPON_EXP Slings
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %SLING_AMMO
		pause 1
		put retreat
		counter add 1000
		goto 2_HANDED_WEAPON

	BLOWGUN:
		echo
		echo *** BLOW_GUN: ***
		echo
		var WEAPON_EXP Brawling
		if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
		if ("%ALTEXP" = "ON") && ("%EXP2" = "Stealth") then var CURR_RATE $%WEAPON_EXP.LearningRate
		var RANGED ON
		var AMMO %BLOWGUN_AMMO
		pause 1
		put retreat
		counter add 1000
		goto 2_HANDED_WEAPON

	2_HANDED_WEAPON:
		var LAST 2_HANDED_WEAPON
		save %c
		if (("%RANGED" = "ON") && ("$GH_FEINT" = "ON")) then put #var GH_FEINT OFF
		if ("%MAGIC_TYPE" != "OFF") then var MAGIC_COUNT %c
		if ("%DSET" = "ON") then goto SET_DEFAULT
		goto COUNT_$GH_DANCING

	1_HANDED_WEAPON:
		var LAST 1_HANDED_WEAPON
		save %c
		if ("%MAGIC_TYPE" != "OFF") then var MAGIC_COUNT %c
		if ("%DSET" = "ON") then goto SET_DEFAULT
		if (("%HAND" = "left") && ("$lefthand" = "Empty")) then gosub SWAP_LEFT $righthandnoun
		else if_2 then gosub EQUIP_SHIELD %2
		goto COUNT_$GH_DANCING

	LX_SLING:
		var LAST LX_SLING
		save %c
		if ("$GH_FEINT" = "ON") then put #var GH_FEINT OFF
		if ("%MAGIC_TYPE" != "OFF") then var MAGIC_COUNT %c
		if ("%DSET" = "ON") then goto SET_DEFAULT
		if_2 then gosub EQUIP_SHIELD %2
		goto COUNT_$GH_DANCING

	BRAWL_SETUP:
		var LAST BRAWL_SETUP
		save %c
		if ("%MAGIC_TYPE" != "OFF") then var MAGIC_COUNT %c
		if ("%DSET" = "ON") then goto SET_DEFAULT
		if_1 then gosub EQUIP_SHIELD %1
		goto COUNT_$GH_DANCING

#######################
##                   ##
##   Useful gosubs   ##
##                   ##
#######################
SWAP_LEFT:
	var ITEM $1
SWAPPING_LEFT:
		matchre SWAPPING_LEFT %ITEM(.*)to your right hand
		matchre RETURN %ITEM(.*)to your left hand
	put swap
	matchwait 15
	goto SWAP_ERROR

SWAP_RIGHT:
	var ITEM $1
SWAPPING_RIGHT:
		matchre SWAPPING_RIGHT %ITEM(.*)to your left hand
		matchre RETURN %ITEM(.*)to your right hand
	put swap
	matchwait 15
	goto SWAP_ERROR

EQUIP_SHIELD:
	if ("%SHIELD" = "NONE") then var SHIELD $1
	pause 0.5
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** EQUIP_SHIELD: ***
		echo
	}
	GETTING_SHIELD:
			match WEAPON_APPR_ERROR What were you
			matchre RETURN already|You get|You sling|You remove|You loosen
		put remove my %SHIELD
		put get my %SHIELD
		matchwait 15
	EQUIP_SHIELD_FAIL:
		echo
		echo *** Something happened while getting shield ***
		echo ***           Aborting script               ***
		echo
		gosub clear
		put #beep
		goto ERROR_DONE

UNEQUIP_SHIELD:
	pause 0.5
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** UNEQUIP_SHIELD ***
		echo
	}
	STOWING_SHIELD:
			matchre RETURN You put your|You sling|You are already wearing that|But that is already in your inventory|You slide your left
		put wear my %SHIELD
		put stow my %SHIELD
		matchwait 15
	UNEQUIP_SHIELD_FAIL:
		echo
		echo *** Something happened while stowing shield ***
		echo ***           Aborting script               ***
		echo
		gosub clear
		put #beep
		goto ERROR_DONE

WIELD_WEAPON:
	var STRING $1
	pause 0.5
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** WIELD_WEAPON: ***
		echo
	}
	WIELDING_WEAPON:
			matchre REMOVING_WEAPON out of reach|You'll need to remove|What were you|can't seem|is out of reach|You can only wield
			matchre RETURN You draw|already holding|You deftly remove|With a flick of your wrist|With fluid and stealthy movements|You slip a
		put wield my %STRING
		matchwait 10
	REMOVING_WEAPON:
			matchre WIELD_FAIL free hand|hands are full
			matchre GETTING_WEAPON Remove what?|You aren't wearing
			matchre RETURN You sling|already holding|inventory|You remove|You deftly remove
		put remove my %STRING
		matchwait 10
	GETTING_WEAPON:
			matchre WIELD_FAIL Please rephrase that command|What were you
			matchre RETURN You get|You are already holding
		put get my %STRING
		matchwait 10
	WIELD_FAIL:
		echo
		echo *** Something happened during wielding ***
		echo ***           Aborting script          ***
		echo
		gosub clear
		put #beep
		goto ERROR_DONE

SHEATHE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SHEATHE ***
		echo
	}
	if ("$0" = "blades") then var COMM_STRING blade
	else var COMM_STRING $0
	pause 0.5
	if "$BW" != "OFF" && "$GH_BUFF" = "ON" then
	{
	put #send release bond
	waitforre ^You sense|^You are not|^Release what|^You are ending the bond with your
	}
	if ("$righthandnoun" = "fan") && ("%FAN_STATUS" = "OPENED") then
	{
		put close my $righthand
		var FAN_STATUS CLOSED
		pause .5
	}
	SHEATHING:
			matchre WEAR_WEAPON where\?
			matchre RETURN ^Sheathe what\?|^Sheathing an?|^With a flick of your wrist|^With fluid and stealthy movements|^You easily strap|^You hang|^You secure|^You sheath|^You slip|^You strap|you sheath
		put sheathe my %COMM_STRING
		matchwait 10
	WEAR_WEAPON:
		match STOW_WEAPON You can't wear that!
		matchre RETURN You sling|Wear what?|You attach|You slide your left arm
		put wear my %COMM_STRING
		matchwait 10
	STOW_WEAPON:
			matchre RETURN You put|easily strap|already in your inventory
		put stow my %COMM_STRING
		matchwait 10
	SHEATHE_FAIL:
		echo
		echo *** Something happened during sheathing ***
		echo ***                 Aborting script                 ***
		echo
		gosub clear
		put #beep
		goto ERROR_DONE

RANGE_SHEATHE:
	if ("%GAG_ECHO" != "YES") then
		{
		echo
		echo *** RANGE_SHEATHE: ***
		echo
		}
	pause 1
	put retreat
	waitfor You
	pause 1
	put unload %CURR_WEAPON
	pause 1
	STOW_AMMO:
	matchre STOW_AMMO You pick up|You put
	matchre GO_ON Stow what?|You stop as you
	if "%AMMO" = "basilisk head arrow" then put stow basilisk arrow
	else
	put stow %AMMO
	matchwait 40
	GO_ON:
	pause 1
	gosub SHEATHE %CURR_WEAPON
	return

############################################
##                                        ##
##  Default section, setting and loading  ##
##                                        ##
############################################
SET_DEFAULT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SET_DEFAULT ***
		echo Setting default values
		echo
	}
	put #var GH_DEF_SET YES
	put #var GH_DEF_COUNTER %c
	put #var GH_DEF_ALTEXP %ALTEXP
	put #var GH_DEF_AMMO %AMMO
	put #var GH_DEF_BACKSTAB %BACKSTAB
	put #var GH_DEF_COMBO1 %_COMBO1
	put #var GH_DEF_COMBO2 %_COMBO2
	put #var GH_DEF_COMBO3 %_COMBO3
	put #var GH_DEF_COMBO4 %_COMBO4
	put #var GH_DEF_COMBO5 %_COMBO5
	put #var GH_DEF_COMBO6 %_COMBO6
	put #var GH_DEF_COMBO7 %_COMBO7
	put #var GH_DEF_COMBO8 %_COMBO8
	put #var GH_DEF_CURR_STANCE %CURR_STANCE
	put #var GH_DEF_WEAPON %CURR_WEAPON
	put #var GH_DEF_EMPTY_HANDED %EMPTY_HANDED
	put #var GH_DEF_EVAS_LVL %EVAS_LEVEL
	put #var GH_DEF_EXP2 %EXP2
	put #var GH_DEF_FIRE_TYPE %FIRE_TYPE
	if ("%HAND" = "") then put #var GH_DEF_HAND none
	else put #var GH_DEF_HAND %HAND
	put #var GH_DEF_HAND2 %HAND2
	put #var GH_DEF_MAGIC %MAGIC
	put #var GH_DEF_MAGIC_TYPE %MAGIC_TYPE
	put #var GH_DEF_MAGIC_COUNT %MAGIC_COUNT
	put #var GH_DEF_MAX_TRAIN_TIME %MAX_TRAIN_TIME
	put #var GH_DEF_NOEVADE %NOEVADE
	put #var GH_DEF_NOPARRY %NOPARRY
	put #var GH_DEF_NOSHIELD %NOSHIELD
	put #var GH_DEF_PARRY_LVL %PARRY_LEVEL
	put #var GH_DEF_RANGED %RANGED
	put #var GH_DEF_RUCK %RUCK
	put #var GH_DEF_SHIELD %SHIELD
	put #var GH_DEF_SHIELD_LVL %SHIELD_LEVEL
	put #var GH_DEF_STACK %STACK
	put #var GH_DEF_THROWN %THROWN
	put #var GH_DEF_WEAPON_EXP %WEAPON_EXP
	put #var GH_DEF_XCOUNT %xCOUNT
	put #var GH_DEF_YOYO %YOYO

	put #var GH_DEF_AMBUSH $GH_AMBUSH
	put #var GH_DEF_APPR $GH_APPR
	put #var GH_DEF_ARRANGE $GH_ARRANGE
	put #var GH_DEF_BUN $GH_BUN
	put #var GH_DEF_COUNTING $GH_DANCING
	put #var GH_DEF_EXP $GH_EXP
	put #var GH_DEF_HARN $GH_HARN
	put #var GH_DEF_HUNT $GH_HUNT
	put #var GH_DEF_JUGGLE $GH_JUGGLE
	put #var GH_DEF_LOOT $GH_LOOT
	put #var GH_DEF_LOOT_BOX $GH_LOOT_BOX
	put #var GH_DEF_LOOT_COIN $GH_LOOT_COIN
	put #var GH_DEF_LOOT_COLL $GH_LOOT_COLL
	put #var GH_DEF_LOOT_GEM $GH_LOOT_GEM
	put #var GH_DEF_LOOT_JUNK $GH_LOOT_JUNK
	put #var GH_DEF_MANA $GH_MANA
	put #var GH_DEF_PP $GH_PP
	put #var GH_DEF_RETREAT $GH_RETREAT
	put #var GH_DEF_ROAM $GH_ROAM
	put #var GH_DEF_SCRAPE $GH_SCRAPE
	put #var GH_DEF_SKIN $GH_SKIN
	put #var GH_DEF_SKIN_RET $GH_SKIN_RET
	put #var GH_DEF_SLOW $GH_SLOW
	put #var GH_DEF_SNAP $GH_SNAP
	put #var GH_DEF_SPELL $GH_SPELL
	put #var GH_DEF_STANCE $GH_STANCE
	if ("$GH_TARGET" = "") then put #var GH_DEF_TARGET none
	else put #var GH_DEF_TARGET $GH_TARGET
	put #var GH_DEF_TIMER $GH_TIMER
	put #var GH_DEF_TRAIN $GH_TRAIN

	echo
	echo Default setting are now ready
	echo
	exit

LOAD_DEFAULT_SETTINGS:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** LOAD_DEFAULT_SETTINGS ***
		echo
	}
	gosub GENERAL_TRIGGERS
	## Loading default nonweapon settings
	var ALTEXP $GH_DEF_ALTEXP
	var BACKSTAB $GH_DEF_BACKSTAB
	var CURR_STANCE $GH_DEF_CURR_STANCE
	var EMPTY_HANDED $GH_DEF_EMPTY_HANDED
	var EVAS_LEVEL $GH_DEF_EVAS_LVL
	var EXP2 $GH_DEF_EXP2
	var FIRE_TYPE $GH_DEF_FIRE_TYPE
	if ("$GH_DEF_HAND" = "none") then var HAND
	else var HAND $GH_DEF_HAND
	var HAND2 $GH_DEF_HAND2
	var MAGIC $GH_DEF_MAGIC
	var MAGIC_TYPE $GH_DEF_MAGIC_TYPE
	var MAGIC_COUNT $GH_DEF_MAGIC_COUNT
	var PARRY_LEVEL $GH_DEF_PARRY_LVL
	var RANGED $GH_DEF_RANGED
	var RUCK $GH_DEF_RUCK
	var SHIELD_LEVEL $GH_DEF_SHIELD_LVL
	var STACK $GH_DEF_STACK
	var THROWN $GH_DEF_THROWN
	var xCOUNT $GH_DEF_XCOUNT
	var YOYO $GH_DEF_YOYO

	put #var GH_AMBUSH $GH_DEF_AMBUSH
	put #var GH_APPR $GH_DEF_APPR
	put #var GH_ARRANGE $GH_DEF_ARRANGE
	put #var GH_BUN $GH_DEF_BUN
	put #var GH_DANCING $GH_DEF_COUNTING
	if ("$GH_MULTI" = "OFF") then put #var GH_EXP $GH_DEF_EXP
	put #var GH_HARN $GH_DEF_HARN
	put #var GH_HUNT $GH_DEF_HUNT
	put #var GH_JUGGLE $GH_DEF_JUGGLE
	put #var GH_LOOT $GH_DEF_LOOT
	put #var GH_LOOT_BOX $GH_DEF_LOOT_BOX
	put #var GH_LOOT_COIN $GH_DEF_LOOT_COIN
	put #var GH_LOOT_COLL $GH_DEF_LOOT_COLL
	put #var GH_LOOT_GEM $GH_DEF_LOOT_GEM
	put #var GH_LOOT_JUNK $GH_DEF_LOOT_JUNK
	put #var GH_MANA $GH_DEF_MANA
	put #var GH_PP $GH_DEF_PP
	put #var GH_RETREAT $GH_DEF_RETREAT
	put #var GH_ROAM $GH_DEF_ROAM
	put #var GH_SCRAPE $GH_DEF_SCRAPE
	put #var GH_SKIN $GH_DEF_SKIN
	put #var GH_SKIN_RET $GH_DEF_SKIN_RET
	put #var GH_SLOW $GH_DEF_SLOW
	put #var GH_SNAP $GH_DEF_SNAP
	put #var GH_SPELL $GH_DEF_SPELL
	put #var GH_STANCE $GH_DEF_STANCE
	if ("$GH_DEF_TARGET" = "none") then put #var GH_TARGET
	else put #var GH_TARGET  $GH_DEF_TARGET
	put #var GH_TIMER $GH_DEF_TIMER
	if ("$GH_MULTI" = "OFF") then put #var GH_TRAIN $GH_DEF_TRAIN

	var MAX_TRAIN_TIME $GH_DEF_MAX_TRAIN_TIME
	DEF_STANCE_SETUP:
		if ("%CURR_STANCE" = "Evasion") then put stance evasion
		elseif ("%CURR_STANCE" = "Parry_Ability") then put stance parry
		elseif ("%CURR_STANCE" = "Shield_Usage") then put stance shield
		elseif ("%CURR_STANCE" = "Custom") then put stance custom

	if ("$GH_MULTI" != "OFF") then goto VARIABLE_CHECK

	## Loading default weapon settings
	var AMMO $GH_DEF_AMMO
	var _COMBO1 $GH_DEF_COMBO1
	var _COMBO2 $GH_DEF_COMBO2
	var _COMBO3 $GH_DEF_COMBO3
	var _COMBO4 $GH_DEF_COMBO4
	var _COMBO5 $GH_DEF_COMBO5
	var _COMBO6 $GH_DEF_COMBO6
	var _COMBO7 $GH_DEF_COMBO7
	var _COMBO8 $GH_DEF_COMBO8
	counter set $GH_DEF_COUNTER
	var RANGED $GH_DEF_RANGED
	var SHIELD $GH_DEF_SHIELD
	var CURR_WEAPON $GH_DEF_WEAPON
	var WEAPON_EXP $GH_DEF_WEAPON_EXP
	echo
	echo Ready to go!
	echo
	var LAST DEF_WIELD_WEAPON
	DEF_WIELD_WEAPON:
			matchre SWAP_CHECK You draw|already holding|free to|With a flick of your wrist
			match BEGIN_HANDS free hand
			matchre DEF_REMOVE_WEAPON out of reach|remove|What were you|can't seem|Wield what\?
		put wield my %CURR_WEAPON
		matchwait 16
	DEF_REMOVE_WEAPON:
			matchre SWAP_CHECK You sling|already holding|inventory|You remove
			matchre BEGIN_HANDS free hand|hands are full
			match DEF_GET_WEAPON Remove what?
		put remove my %CURR_WEAPON
		matchwait 15
	DEF_GET_WEAPON:
			match SWAP_CHECK you get
			match NO_VALUE Please rephrase that command
		put get my %CURR_WEAPON
		matchwait 15
	goto VARIABLE_ERROR
	SWAP_CHECK:
		var LAST SWAP_CHECK
		if (("%HAND" = "left") && ("$lefthand" = "Empty")) then gosub SWAP_LEFT $righthandnound
		elseif ("%SHIELD" != "NONE") then gosub EQUIP_SHIELD %SHIELD
	goto %c

#####################################
##                                 ##
##  Action initialization section  ##
##                                 ##
#####################################
GENERAL_TRIGGERS:
	action put #var standing 1 when ^You are already standing
	action (hunt) goto DONE when reaches over and holds your hand|grabs your arm and drags you|clasps your hand tenderly
	action (hunt) put #send 5 $lastcommand when You can't do that while entangled in a web.
	action (hunt) goto STUNNED when eval $stunned = 1
	action (hunt) goto BLEEDING when eval $bleeding = 1
	action (hunt) goto ABORT when eval $health < 60
	action (hunt) goto DEAD when eval $dead = 1
	action (hunt) goto DROPPED_WEAPON when Your fingers go numb as you drop|You have nothing to swap|You don't have a weapon|With your bare hands\?

	action var lastmaneuver parry when Last Combat Maneuver.*Parry
	action var lastmaneuver feint when Last Combat Maneuver.*Feint
	action var lastmaneuver draw when Last Combat Maneuver.*Draw
	action var lastmaneuver sweep when Last Combat Maneuver.*Sweep
	action var lastmaneuver slice when Last Combat Maneuver.*Slice
	action var lastmaneuver chop when Last Combat Maneuver.*Chop
	action var lastmaneuver bash when Last Combat Maneuver.*Bash
	action var lastmaneuver thrust when Last Combat Maneuver.*Thrust
	action var lastmaneuver shove when Last Combat Maneuver.*Shove
	action var lastmaneuver jab when Last Combat Maneuver.*Jab
	action var lastmaneuver dodge when Last Combat Maneuver.*Dodge
	action var lastmaneuver claw when Last Combat Maneuver.*Claw
	action var lastmaneuver dodge when Last Combat Maneuver.*Dodge
	action var lastmaneuver kick when Last Combat Maneuver.*Kick
	action var lastmaneuver weave when Last Combat Maneuver.*Weave
	action var lastmaneuver punch when Last Combat Maneuver.*Punch
	action var lastmaneuver lunge when Last Combat Maneuver.*Lunge
	action var lastmaneuver bob when Last Combat Maneuver.*Bob
	action var lastmaneuver circle when Last Combat Maneuver.*Circle
	return

RETREAT_TRIGGERS:
	var RETREATING ON
	var RETREATED NO
	action (retreat) if ("%RETREATED" = "YES") then put #queue clear;send retreat;var RETREATED YES when closes to pole weapon range
MELEE_TRIGGERS:
	action (retreat) if ("%RETREATED" = "YES") then put #queue clear;send retreat;var RETREATED YES when (^\*.*at you\..*You)|(closes to melee range on you)
	action var RETREATED NO when You retreat from combat
	action var RETREATED NO when You try to back away
	action (retreat) on
	return

RETREAT_UNTRIGGERS:
	var RETREATING OFF
	action remove closes to pole weapon range
	action remove (^\*.*at you\..*You)|(closes to melee range on you)
	action remove You retreat from combat
	action remove You try to back away
	return

#####################################
##                                 ##
##  End of Initialization section  ##
##                                 ##
#####################################
ADVANCE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ADVANCE: ***
		echo
	}
	counter set %s
	ADV_NOW:
		if "$guild" = "Necromancer" then goto ADV_NECRO
		if (($hidden = 1) && ("%guild" = "Paladin")) then put unhid
		var LAST ADV_NOW
			matchre FACE You stop advancing|You have lost sight
			match NO_MONSTERS advance towards?
			matchre ADVANCING ^You begin
			matchre ADVANCING_FURTHER ^You are already advancing
			match %c already at melee
		put advance
		matchwait 15
		goto ERROR
	ADV_NECRO:
	var LAST ADV_NECRO
			matchre NECRO_STOP_ADV You begin to advance on a .+ dirt construct\.|You are already advancing on a .+ dirt construct\.
			matchre FACE You stop advancing|You have lost sight
			match NO_MONSTERS advance towards?
			matchre ADVANCING ^You begin
			matchre ADVANCING_FURTHER ^You are already advancing
			match %c already at melee|stops you from advancing any farther\!
		put advance
		matchwait 15
		goto ERROR
	NECRO_STOP_ADV:
	send retreat
	send retreat
	goto FACE
	ADVANCING:
		if ("$GH_APPR" = "YES") then goto APPR_YES
	ADVANCING_FURTHER:
		waitforre to melee range|\[You're|You stop advancing because|You have lost sight of your target
		goto APPR_NO

APPR_YES:
	if (("%APPRAISED" = "YES") || ($Appraisal.LearningRate >= 30)) then
		{
		if ((("%MAGIC" = "ON") || (matchre("%MAGIC_TYPE","TM|PM|DEBIL")) && ("%LAST" = "MAGIC_PREP")) then return
		else goto COUNT_$GH_DANCING
		}
	else var APPRAISED YES
	var LAST APPR_YES
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** APPR_YES: ***
		echo
	}
	if matchre("$monsterlist", "\b(%nonskinnablecritters)\b") then goto APPR_CREEP
	if matchre("$monsterlist", "\b(%skinnablecritters)\b") then goto APPR_CREEP
	if matchre("$monsterlist", "\b(%invasioncritters)\b") then goto APPR_CREEP
	goto APPR_NO
APPR_CREEP:
	var Monster $0
APPRAISING:
	var LAST APPRAISING
		matchre APPR_NO Roundtime|Appraise|You can't determine|appraise|You don't see|still stunned|Mark what\?
	if ($GH_MARK = ON) then put mark all %Monster
	else
		{
		if ("%guild" == "Ranger" && $Scouting.Ranks > 15) then put scout aware %Monster
		else send appraise %Monster quick
		}
	matchwait 15
	goto APPR_ERROR

APPR_NO:
	pause
	pause
	var lastdirection none
	if ("%MAGIC" = "ON") then return
	goto COUNT_$GH_DANCING

COUNT_ON:
	var LAST COUNT_ON
	#if "%ALTEXP" != "ON" then var CURR_RATE $%WEAPON_EXP.LearningRate
	#else var CURR_RATE $%EXP2.LearningRate
COUNT_START:
	if (toupper("$GH_STANCE") = "ON")) then gosub SWITCH_STANCE
	if ((($Defending.LearningRate >= 30) && ($%ARMOR1.LearningRate >= 30) && ($%ARMOR2.LearningRate >= 30) && ($%ARMOR3.LearningRate >= 30) && ($%ARMOR4.LearningRate >= 30)) && ("$GH_COUNTSKIP" = "ON")) then goto COUNT_OFF
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_START: ***
		echo
	}
	If ($GH_COUNT = 1 && $monstercount > 1) then goto %c
	If ($GH_COUNT = 2 && $monstercount > 2) then goto %c
	If ($GH_COUNT = 3 && $monstercount > 3) then goto %c
	If ($GH_COUNT = 4 && $monstercount > 4) then goto %c
	If ($GH_COUNT = 5 && $monstercount > 5) then goto %c
	If ($GH_COUNT = 6 && $monstercount > 6) then goto %c
	else goto COUNT_WAIT_1

COUNT_OFF:
	goto %c

FACE:
	gosub clear
	if "$guild" != "Empath" && matchre("%MAGIC_TYPE","TM|PM") then gosub COMBAT_COMMAND MAGIC_WAIT
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FACE: ***
		echo
	}
	if ("$guild" = "Empath" && "$GH_CONSTRUCT" = "ON") then goto EMPATH_FACE
   	if "$guild" = "Necromancer" then goto NECRO_FACE
	var LAST FACE
		matchre APPR_$GH_APPR You turn to face|You are already
		matchre CHECK_FOR_MONSTER nothing else to|Face what
	put face next
	matchwait 15
	goto ERROR

EMPATH_FACE:
	## Construct checking ##
	if matchre ("$monsterlist", "\b(%construct)\b") then
	{
		if matchre ("$1", "\b(%construct)\b") then var Empath_Monster $1
		eval Empath_Monster replacere("%Empath_Monster",".*\s(\w+)\.?\$", "\$1")
	}
	else
	{
		var xCOUNT COUNT_ONE
		goto COUNT_WAIT_1
	}
	if matchre ("$roomobjs", "((which|that) appears dead|\(dead\))") then GOTO DEAD_MONSTER
	var LAST FACE
		matchre APPR_$GH_APPR You turn to face|You are already
		matchre CHECK_FOR_MONSTER nothing else to|Face what
		matchre FACE_RETREAT You are too closely
		matchre EMPATH_FACE What's the point in
	put face %Empath_Monster
	matchwait 15
	goto ERROR

FACE_RETREAT:
		match FACE_RETREAT You retreat back
		match EMPATH_FACE You retreat from
		match FACE_RETREAT Roundtime
	send retreat
	matchwait 15
	goto ERROR

NECRO_FACE:
	var LAST FACE
		matchre CHECK_FOR_MONSTER nothing else to|Face what|You turn to face a squat dirt construct
		match APPR_$GH_APPR You turn to face
	put face next
	matchwait 15
	goto ERROR

CHECK_FOR_MONSTER:
	var LAST CHECK_FOR_MONSTER
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** CHECK_FOR_MONSTER ***
		echo
	}
	if (($hidden = 1) && ("%guild" = "Paladin")) then put unhide
	counter set %s
	if "$guild" = "Necromancer" && "$monsterlist" = "a squat dirt construct" then goto NO_MONSTERS
	if matchre("$monsterlist", "\b(%nonskinnablecritters)\b") then goto APPR_$GH_APPR
	if matchre("$monsterlist", "\b(%skinnablecritters)\b") then goto APPR_$GH_APPR
	if matchre("$monsterlist", "\b(%invasioncritters)\b") then goto APPR_$GH_APPR
	if ("$GH_TIMER" = "ON") then gosub TIMER_ON
	goto NO_MONSTERS

NO_MONSTERS:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NO_MONSTERS: ***
		echo
	}
	if ("%RANGED" = "ON") then
	{
		if (matchre("$roomobjs", "%AMMO\b")) then gosub RANGED_CLEAN
	}
	if ("%THROWN" = "ON") then
	{
		if (matchre("$roomobjs", "%CURR_WEAPON\b")) then
		{
			put get my %CURR_WEAPON
		}
	}
	if "%SEARCHED" = "NO" &&  matchre ("$roomplayers", "Also here: (\S+)") && matchre ("$roomobjs", "((which|that) appears dead|\(dead\))") then goto DEAD_MONSTER
	if ((toupper("$GH_JUGGLE") = "ON") && ($Perception.LearningRate < 30)) then goto JUGGLE_STUFF
	if (toupper("$GH_ROAM") = "ON") then goto MOVE_ROOMS
	else
	{
		if ($hidden = 1) then put unhide
		pause 3
		waitforre \.|\?|!|pole|melee|advance
		goto FACE
	}

JUGGLE_STUFF:
	timer stop
	var LAST JUGGLE_STUFF
	if ("%SHIELD" != "NONE") then gosub UNEQUIP_SHIELD
	if ("%EMPTY_HANDED" != "ON") then
	{
		if ("%RANGED" = "ON") then gosub RANGE_SHEATHE
		else gosub SHEATHE %CURR_WEAPON
	}
	if ("%YOYO" = "OFF") then
	action goto JUGGLE_STOP when ^\*.*at you\..*You|begins to advance on you|to melee range|to polee range|You're|already at melee
	JUGGLE_TOP:
		var LAST JUGGLE_TOP
		if ("%JUGGLIE" = "pebble") then goto juggle
			match NO_JUGGLIE What were you referring to
			matchre YOYO_%YOYO You get|You are already
		put get my %JUGGLIE
		matchwait 40
		goto JUGGLE_ERROR
	YOYO_ON:
			match JUGGLING You slip the string
		put wear my %JUGGLIE
		matchwait 40
		goto JUGGLE_ERROR
	YOYO_OFF:
	JUGGLING:
		if matchre ("$monsterlist", "%critters") then goto JUGGLE_STOP
		var LAST JUGGLING
			matchre JUGGLE_ERROR Your injuries make juggling|But you're not holding|You realize that if your throw|Your wounds begin aching
			match JUGGLE_EXP Roundtime
		if ("%YOYO" = "ON") then put throw my %JUGGLIE
		else put juggle my $juggle
		matchwait 40
		goto JUGGLE_ERROR
	JUGGLE_EXP:
		if $Perception.LearningRate >= 30 then goto JUGGLE_STOP
		goto JUGGLING
	JUGGLE_ERROR:
		echo *** Juggling error ***
		put #var GH_JUGGLE OFF
		goto JUGGLE_STOP
	NO_JUGGLIE:
		echo *** Can't find your JUGGLIE ***
	JUGGLE_STOP:
		action remove ^You finish
		action remove ^\*.*at you\..*You|begins to advance on you|to melee range|to polee range|You're|already at melee
		var LAST JUGGLE_STOP
		pause
		if ("%YOYO" = "ON") then
		{
			put remove %JUGGLIE
			waitfor off of your finger
		}
		pause 0.5
		put stop play
		put stow %JUGGLIE
		waitfor You put your
		if "$righthand" != "Empty" then put stow right
		if "$lefthand" != "Empty" then put stow left
	JUGGLE_DONE:
		var LAST JUGGLE_DONE
		if ("%EMPTY_HANDED" != "ON") then gosub WIELD_WEAPON %CURR_WEAPON
		if (("%HAND" = "left") && ("$righthand" != "Empty")) then gosub SWAP_LEFT $righthandnoun
		if ("%SHIELD" != "NONE") then gosub EQUIP_SHIELD
		timer start
		goto FACE

MOVE_ROOMS:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** MOVE_ROOMS: ***
		echo
	}
	echo No monsters here, moving rooms
	pause 1

	var ROOMNUMBER 0
HUNTING_FOR_ROOM:
	var LAST HUNTING_FOR_ROOM
	action math ROOMNUMBER add 1 when ^To the .+:

	var ROOM1OCCUPIED FALSE
	var ROOM2OCCUPIED FALSE
	var ROOM3OCCUPIED FALSE
	var ROOM4OCCUPIED FALSE
	var ROOM5OCCUPIED FALSE
	var ROOM6OCCUPIED FALSE
	var ROOM7OCCUPIED FALSE
	var ROOM8OCCUPIED FALSE
	action var ROOM%ROOMNUMBEROCCUPIED TRUE when ^  \d+\)   \w+$|^  \d+\)   A hidden \w+$
	action var ROOM%ROOMNUMBEROCCUPIED TRUE when ^  --\)   Signs of something hidden from sight\.

	var ROOM1MOBS 0
	var ROOM2MOBS 0
	var ROOM3MOBS 0
	var ROOM4MOBS 0
	var ROOM5MOBS 0
	var ROOM6MOBS 0
	var ROOM7MOBS 0
	var ROOM8MOBS 0

	action math ROOM%ROOMNUMBERMOBS add 1 when ^  \d+\)   (a|an)
	action var ROOM%ROOMNUMBERTARGET $1 when ^  (\d+)\)

	put stop stalk
	waitfor stalking
	put hunt
	waitforre ^Roundtime:|You find yourself unable to

	action remove ^To the .+:
	action remove ^  \d+\)   \w+$|^  \d+\)   A hidden \w+$
	action remove ^  --\)   Signs of something hidden from sight\.
	action remove ^  \d+\)   (a|an)
	action remove ^  (\d+)\)

	if "%ROOM1OCCUPIED" = "TRUE" then var ROOM1MOBS 0
	if "%ROOM2OCCUPIED" = "TRUE" then var ROOM2MOBS 0
	if "%ROOM3OCCUPIED" = "TRUE" then var ROOM3MOBS 0
	if "%ROOM4OCCUPIED" = "TRUE" then var ROOM4MOBS 0
	if "%ROOM5OCCUPIED" = "TRUE" then var ROOM5MOBS 0
	if "%ROOM6OCCUPIED" = "TRUE" then var ROOM6MOBS 0
	if "%ROOM7OCCUPIED" = "TRUE" then var ROOM7MOBS 0
	if "%ROOM8OCCUPIED" = "TRUE" then var ROOM8MOBS 0

	var BESTMOBCOUNT 0
	var HUNTNUMBER 0
	if %ROOM1MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM1MOBS
		var HUNTNUMBER %ROOM1TARGET
	}
	if %ROOM2MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM2MOBS
		var HUNTNUMBER %ROOM2TARGET
	}
	if %ROOM3MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM3MOBS
		var HUNTNUMBER %ROOM3TARGET
	}
	if %ROOM4MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM4MOBS
		var HUNTNUMBER %ROOM4TARGET
	}
	if %ROOM5MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM5MOBS
		var HUNTNUMBER %ROOM5TARGET
	}
	if %ROOM6MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM6MOBS
		var HUNTNUMBER %ROOM6TARGET
	}
	if %ROOM7MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM7MOBS
		var HUNTNUMBER %ROOM7TARGET
	}
	if %ROOM8MOBS > %BESTMOBCOUNT then
	{
		var BESTMOBCOUNT %ROOM8MOBS
		var HUNTNUMBER %ROOM8TARGET
	}
	pause

	if %HUNTNUMBER = 0 then goto RANDOM_MOVE

	if ((toupper("$GH_BUN") = "ON") && contains("$roomobjs", "lumpy bundle")) then
	{
			match HUNT_MOVE You pick up
		put get bundle
		matchwait 16
	}
	HUNT_MOVE:
		var LAST HUNT_MOVE
			matchre RANDOM_MOVE You don't have that target currently available|Your prey seems to have completely vanished|You were unable to locate|You find yourself unable|You'll need to be in the area
			matchre MOVE_ROOMS Also here: (.*)
			matchre CHECK_OCCUPIED ^You'll need to disengage first|^While in combat?|^Obvious exits|^Obvious paths
		put hunt %HUNTNUMBER
		matchwait 60

	RANDOM_MOVE:
		var exits 0
		if $north = 1 then math exits add 1
		if $northeast = 1 then math exits add 1
		if $east = 1 then math exits add 1
		if $southeast = 1 then math exits add 1
		if $south = 1 then math exits add 1
		if $southwest = 1 then math exits add 1
		if $west = 1 then math exits add 1
		if $northwest = 1 then math exits add 1
		if $up = 1 then math exits add 1
		if $down = 1 then math exits add 1
		if (%exits = 0) then goto CHECK_OCCUPIED

		random 1 10
		var move_cycles 0
		goto MOVE_%r

	MOVE_1:
		if ($north = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "south")) then
			{
				var direction north
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction north
				goto GOOD_DIRECTION
			}
		}
	MOVE_2:
		if ($northeast = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "southwest")) then
			{
				var direction northeast
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction northeast
				goto GOOD_DIRECTION
			}
		}
	MOVE_3:
		if ($east = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "west")) then
			{
				var direction east
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction east
				goto GOOD_DIRECTION
			}
		}
	MOVE_4:
		if ($southeast = 1) then
		{
			if ((%exits > 1) and (("%lastdirection" != "northwest")) then
			{
				var direction southeast
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction southeast
				goto GOOD_DIRECTION
			}
		}
	MOVE_5:
		if ($south = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "north")) then
			{
				var direction south
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction south
				goto GOOD_DIRECTION
			}
		}
	MOVE_6:
		if ($southwest = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "northeast")) then
			{
				var direction southwest
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction southwest
				goto GOOD_DIRECTION
			}
		}
	MOVE_7:
		if ($west = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "east")) then
			{
				var direction west
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction west
				goto GOOD_DIRECTION
			}
		}
	MOVE_8:
		if ($northwest = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "southeast")) then
			{
				var direction northwest
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction northwest
				goto GOOD_DIRECTION
			}
		}
	MOVE_9:
		if ($up = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "down")) then
			{
				var direction up
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction up
				goto GOOD_DIRECTION
			}
		}
	MOVE_10:
		if ($down = 1) then
		{
			if ((%exits > 1) && ("%lastdirection" != "up")) then
			{
				var direction down
				goto GOOD_DIRECTION
			} elseif (%exits = 1) then
			{
				var direction down
				goto GOOD_DIRECTION
			}
		}
	if (%move_cycles <= 5) then
	{
		math move_cycles add 1
		goto MOVE_1
	} else goto ERROR
GOOD_DIRECTION:
	if ((toupper("$GH_BUN") = "ON") && contains("$roomobjs", "lumpy bundle")) then
	{
			match MOVING You pick up
		put get bundle
		matchwait 40
	}
	MOVING:
		var LAST MOVING
			matchre MOVE_ROOMS Also here: (.*)|^You can't go there
			matchre CHECK_OCCUPIED ^You are engaged|^Obvious exits|^Obvious paths|^While in combat
		put %direction
		matchwait 40
		goto CHECK_OCCUPIED
FOUND_ROOM:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FOUND_ROOM: ***
		echo
	}
	if (toupper("$GH_PP") = "ON") then var PP_TIME %t
	if (toupper("$GH_PILGRIM") = "ON") then var PILGRIM_TIME %t
	if (toupper("$GH_SMITE") = "ON") then var SMITE_TIME %t
	if ((toupper("$GH_BUN") = "ON")) && (("$righthandnoun" = "bundle") || ("$lefthandnoun" = "bundle"))) then
	{
		put drop bundle
		waitfor ^You drop|^What were you referring to
	}
	var lastdirection %direction
	goto FACE
CHECK_OCCUPIED:
	put search
	waitforre ^Roundtime:
	pause 1
	if ("$roomplayers" = "") then goto FOUND_ROOM
	else
	{
		put retreat
		put retreat
		goto %LAST
	}

######################################
###                                ###
### This section handles what to   ###
### do while waiting for more      ###
### creatures                      ###
###                                ###
######################################
COUNT_FACE:
	var LAST COUNT_FACE
		match COUNT_ASSESS_ADV nothing else to face
		match APPR_$GH_APPR You turn to
	put face next
	matchwait 40

COUNT_ASSESS_ADV:
	if (($hidden = 1) && ("%guild" = "Paladin")) then put unhid
		match COUNT_FACE You stop advancing|You have lost sight
		match NO_MONSTERS advance towards?
		matchre APPR_$GH_APPR begin|to melee range|\[You're|already at melee/
	put advance
	matchwait 40

COUNT_ADV:
	var LAST_COUNT_ADV
	if (($hidden = 1) && ("%guild" = "Paladin")) then put unhid
		matchre COUNT_FACE You stop advancing|You have lost sight
		match NO_MONSTER advance towards?
		matchre ADVANCING You begin|already advancing
		match %LAST already at melee
	put advance
	matchwait 40
	goto ERROR
COUNT_ADVANCING:
		waitforre to melee range|\[You're
		goto %LAST

COUNT_FATIGUE_PAUSE:
	pause
COUNT_FATIGUE:
	var LAST COUNT_FATIGUE
	if ("%GAG_ECHO" != "YES") then
		{
		echo
		echo *** COUNT_FATIGUE: ***
		echo
		}
	matchre PAUSE \[You're|You stop advancing|Roundtime
	match COUNT_FATIGUE_CHECK You cannot back away from a chance to continue your slaughter!
	match COUNT_FATIGUE_CHECK You bob
	put bob
	matchwait 40
	goto COUNT_FATIGUE

COUNT_FATIGUE_CHECK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_FATIGUE_CHECK: ***
		echo
	}
	if ($stamina < 80) then
	{
		goto COUNT_FATIGUE_WAIT
	} else
	{
		goto COUNT_START
	}

COUNT_FATIGUE_WAIT:
	echo
	echo COUNT_FATIGUE_WAIT:
	echo
		matchre COUNT_FATIGUE melee|pole|\[You're
	matchwait

#######################################
###                                 ###
### This section is for waiting for ###
### new creatures to show up.       ###
### Brawls until more creatures.    ###
###                                 ###
#######################################
COUNT_WAIT_1:
	var LAST COUNT_WAIT_1
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_WAIT_1: parry ***
		echo
	}
		matchre COUNT_WAIT_2 You are already in a position|But you are already dodging|You move into a position to|Roundtime|pointlessly hack
		matchre COUNT_FATIGUE You're beat,|You're exhausted|You're bone-tired|worn-out
		matchre COUNT_ADV aren't close enough|You must be closer to use tactical abilities on your opponent\.
		matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead
		matchre COUNT_FACE nothing else
	put parry
	matchwait 80
	goto ATTACK_ERROR

COUNT_WAIT_2:
goto COUNT_WAIT_3
	var LAST COUNT_WAIT_2
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_WAIT_2: shove ***
		echo
	}
		matchre COUNT_WAIT_3 You are already in a position|But you are already dodging|You move into a position to|Roundtime|pointlessly hack
		matchre COUNT_FATIGUE You're beat,|You're exhausted|You're bone-tired|worn-out
		matchre COUNT_ADV aren't close enough|You must be closer to use tactical abilities on your opponent\.
		matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead
		matchre COUNT_FACE nothing else
	put shove
	matchwait 80
	goto ATTACK_ERROR

COUNT_WAIT_3:
	var LAST COUNT_WAIT_3
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_WAIT_3: circle ***
		echo
	}
		matchre COUNT_WAIT_4 You are already in a position|But you are already dodging|You move into a position to|Roundtime|pointlessly hack
		matchre COUNT_FATIGUE You're beat,|You're exhausted|You're bone-tired|worn-out
		matchre COUNT_ADV aren't close enough|You must be closer to use tactical abilities on your opponent\.
		matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead
		matchre COUNT_FACE nothing else
	put circle
	matchwait 80
	goto ATTACK_ERROR

COUNT_WAIT_4:
	var LAST COUNT_WAIT_4
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_WAIT_4: weave ***
		echo
	}
		matchre COUNT_WAIT_5 You are already in a position|But you are already dodging|You move into a position to|Roundtime|pointlessly hack
		matchre COUNT_FATIGUE You're beat,|You're exhausted|You're bone-tired|worn-out
		matchre COUNT_ADV aren't close enough|You must be closer to use tactical abilities on your opponent\.
		matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead
		matchre COUNT_FACE nothing else
	put weave
	matchwait 80
	goto ATTACK_ERROR

COUNT_WAIT_5:
	var LAST COUNT_WAIT_5
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** COUNT_WAIT_5: bob ***
		echo
	}
		matchre COUNT_START You are already in a position|But you are already dodging|You move into a position to|Roundtime|pointlessly hack
		matchre COUNT_FATIGUE You're beat,|You're exhausted|You're bone-tired|worn-out
		matchre COUNT_ADV aren't close enough|You must be closer to use tactical abilities on your opponent\.
		matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead
		matchre COUNT_FACE nothing else
	put bob
	matchwait 80
	goto ATTACK_ERROR

######################################
###                                                      ###
###      KHRI SECTION!!!                 ###
###                                                      ###
######################################

KHRI.CHECK:
	if (!$SpellTimer.KhriFocus.active) && ($concentration > 20) && ("%FOCUS" = "ON") then gosub KHRI.START "focus"
	if (!$SpellTimer.KhriStrike.active) && ($concentration > 20) && ("%STRIKE" = "ON") then gosub KHRI.START "strike"
	if (!$SpellTimer.KhriProwess.active) && ($concentration > 20) && ("%PROWESS" = "ON") then gosub KHRI.START "prowess"
	if (!$SpellTimer.KhriAvoidance.active) && ($concentration > 20) && ("%AVOIDANCE" = "ON") then gosub KHRI.START "avoidance"
	if (!$SpellTimer.KhriHasten.active) && ($concentration > 30) && ("%HASTEN" = "ON") then gosub KHRI.START "hasten"
	if (!$SpellTimer.KhriElusion.active) && ($concentration > 20) && ("%ELUSION" = "ON") then gosub KHRI.START "elusion"
	if (!$SpellTimer.KhriSteady.active) && ($concentration > 20) && ("%STEADY" = "ON") then gosub KHRI.START "steady"
	if (!$SpellTimer.KhriFlight.active) && ($concentration > 30) && ("%FLIGHT" = "ON") then gosub KHRI.START "flight"
	if (!$SpellTimer.KhriDarken.active) && ($concentration > 30) && ("%DARKEN" = "ON") then gosub KHRI.START "darken"
	if (!$SpellTimer.KhriDampen.active) && ($concentration > 30) && ("%DAMPEN" = "ON") then gosub KHRI.START "dampen"
	return

KHRI.START:
	pause 0.1
	matchre KHRI.START ^\.\.\.wait
	matchre KHRI.DONE ^You have not recovered from your previous use of the \w+ meditation\.$
	matchre KHRI.DONE ^Focusing intently|Roundtime
	matchre KHRI.DONE You are not trained in the
	matchre KHRI.DONE ^You strain, but cannot focus your mind enough to manage that\.$
	matchre KHRI.DONE ^You're already using the \w+ meditation\.
	matchre KHRI.DONE ^Remembering the mantra of mind over matter, you let your dedicated focus seep into your muscles\.  The sensation of believing that your enemies will tremble at the mere thought of you translates from your every movement\.$
	matchre KHRI.DONE ^Knowing that a dose of paranoia is healthy for any aspiring Thief, your mind fixates on every possible avenue of escape available to you\.$
	matchre KHRI.DONE ^Remembering the mantra of mind over matter, you let your dedicated focus seep into your muscles, feeling a sense of heightened strength as well a deeper instinctive understanding of your weaponry\.$
	matchre KHRI.DONE ^Focusing your mind, you look around yourself to find the subtle differences lurking in the shadows nearby\. After several deep breaths, your senses have attuned themselves to finding the best hiding spots\.$
	matchre KHRI.DONE ^Willing your body to meet the heightened functionality of your mind, you feel your motions steady considerably\.$
	matchre KHRI.DONE ^With deep breaths, you recall your training and focus your mind into the most universal of meditations, improving your overall performance\.$|^With deep breaths, you recall your training and focus your mind to hone in on improving your physical dexterity\.$
	matchre KHRI.DONE ^Taking a deep breath, you focus on making your mind and body one, your mental discipline trained on quickly noticing, analyzing, and evading approaching threats\.$
	matchre KHRI.DONE ^Centering your mind, you allow your practiced discipline to spread throughout your body, making thought and motion one\.$
	matchre KHRI.DONE ^You calm your body and mind, recalling your training on how to seek the vital part of any opponent. Wrapping yourself in this cool composure, your eyes quickly become drawn to exposed weaknesses around you\.$
	matchre KHRI.DONE ^Purging yourself of all distractions and extraneous thoughts, you allow your mind and body to become one, becoming preternaturally aware of threats around you and the best ways to defend yourself\.$
	matchre KHRI.DONE ^Focusing your mind, you attempt to attune your senses to the paths between shadows\.$
	matchre KHRI.DONE ^\[Sitting, kneeling, or lying down can make starting this khri easier\.\]
	action (standup) off
	#send kneel
	send khri start $1
	matchwait

KHRI.DONE:
	pause 0.1
	pause 0.1
	action (standup) on
	matchre RETURN ^You stand|already stand
	matchre KHRI.DONE ^The weight of all your possessions prevents you from standing\.|^\[Roundtime
	send stand
	matchwait 5
	return

######################################
###                                                      ###
### THIEF AMBUSH SECTION!                ###
###                                                      ###
######################################
AMBUSH.CHECK:
	math CLOUT.LOOP add 1
	var ambush.type clout
	if (%CLOUT.LOOP > 1) then goto AMBUSH.RETURN
	if ("$Distance" != "Melee") then
	{
		put adv
		RETURN
	}

AMBUSH.HAND.CHECK:
	if "$lefthandnoun" = "shield" then put wear shield
	if matchre("$lefthandnoun","(%QUIVER.ITEMS)") then put stow left
	if "%HAND" = "left" and "$righthand" != "Empty" then put stow right
	if "%HAND" != "left" and "$lefthand" != "Empty" then put stow left
	pause 0.2

AMBUSH.DECIDE:
	pause 0.1
	if matchre("$righthandnoun","(bola|club|hhr'ata|bludgeon|maul|mace|mattock|star|cane|staff|ngalio|nightstick|khuj|stiletto)") then var ambush.type stun
	if matchre("$righthandnoun","(sabre|briquet|broadsword|sword|katar|jambiya|javelin|quarterstaff|spear)") then var ambush.type slash
	if "%BACKSTAB" == "ON" then var ambush.type clout
	if contains("$roomobjs", "tusky") then var ambush.type clout
	if $hidden = 1 then goto AMBUSH.IT
	if (($hidden = 0) && (%level < 50)) then put hide
	pause 0.1

AMBUSH.STALK:
	if %circle < 50 then put hide
	pause 0.1
	pause 0.1
	put stop stalk
	pause 0.1
	matchre ADVANCE Stalk what|trying to stalk
	matchre AMBUSH.STALK reveals|try being out of sight|discovers you|You think|You fail
	matchre AMBUSH.IT You move into position|You are already stalking|You quickly slip|You're already stalking
	put stalk
	matchwait 7
	goto AMBUSH.CLOUT

AMBUSH.IT:
	if "%ambush.type" = "clout" then goto AMBUSH.CLOUT
	if "%ambush.type" = "stun" then goto AMBUSH.STUN
	if "%ambush.type" = "slash" then goto AMBUSH.STUN
	goto AMBUSH.CLOUT

AMBUSH.STUN:
	pause 0.1
	pause 0.5
	if $hidden = 0 then goto RET.STALK
	matchre AMBUSH.STALK You must be hidden or invisible
	matchre AMBUSH.CHECK You need at least one hand
	matchre AMBUSH.CLOUT debilitated|impaired|out cold|deflect your slashing cut
	matchre AMBUSH.RETURN blocked harmlessly|You need a weapon|is stunned|isn't even standing
	matchre AMBUSH.RETURN Roundtime|it is flying|You aren't close enough to attack|There is nothing else|Stalk|suited for this type of maneuver|must be closer
	put ambush %ambush.type
	matchwait 10
	goto AMBUSH.RETURN

AMBUSH.CLOUT.HIDE:
	pause 0.1
	put stalk
	pause 0.5

AMBUSH.CLOUT:
	pause 0.1
	pause 0.5
	var ambush.type clout
	var THROW.LOOP 0
	#if matchre("$righthandnoun","(sabre|sword|katar|jambiya|quarterstaff|nightstick|khuj)") then var ambush.type stun
	matchre AMBUSH.CLOUT.HIDE You must be hidden or invisible
	matchre AMBUSH.CHECK You need at least one hand
	matchre AMBUSH.RETURN Roundtime|it is flying|You aren't close enough to attack|There is nothing else|Stalk|must be closer
	matchre AMBUSH.RETURN debilitated|impaired|out cold|deflect your slashing cut|isn't even standing|suited for this type of maneuver|You're not exactly sure
	put ambush %ambush.type
	matchwait 15

AMBUSH.RETURN:
	var CLOUT.LOOP 0
	pause 0.2
	pause 0.1
	RETURN

RET.STALK:
	pause 0.1
	pause 0.2
	put ret
	goto AMBUSH.STALK

######################################
###                                ###
### This section is for the 5-move ###
### weapon attack _COMBO            ###
###                                ###
######################################
5_COMBO:
500:
	if ("%lastmaneuver" = "none") then
	{
		put stance maneuver
		waitfor Last Combat Maneuver
	}
	var LAST 5_COMBO
	gosub clear
	counter set 500
	save 500
	if ("%lastmaneuver" = "%_COMBO5") then gosub COMBAT_COMMAND %_COMBO1
	if ("%lastmaneuver" = "%_COMBO1") then gosub COMBAT_COMMAND %_COMBO2 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO2") then gosub COMBAT_COMMAND %_COMBO3 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO3") then gosub COMBAT_COMMAND %_COMBO4 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO4") then gosub COMBAT_COMMAND %_COMBO5 %HAND $GH_TARGET
	else gosub COMBAT_COMMAND %_COMBO1
	if $GH_THIEF = ON then gosub AMBUSH.CHECK
	if (toupper("$GH_TIMER") = "ON") then goto TIMER_ON
	if (toupper("$GH_TRAIN") = "ON") then goto EXPCHECK_ON
	else goto 500

######################################
###                                ###
### This section is for the 6-move ###
### weapon attack _COMBO            ###
###                                ###
######################################
6_COMBO:
600:
	if ("%lastmaneuver" = "none") then
	{
		put stance maneuver
		waitfor Last Combat Maneuver
	}
	var LAST 6_COMBO
	gosub clear
	counter set 600
	save 600
	if ("%lastmaneuver" = "%_COMBO6") then gosub COMBAT_COMMAND %_COMBO1
	if ("%lastmaneuver" = "%_COMBO1") then gosub COMBAT_COMMAND %_COMBO2 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO2") then gosub COMBAT_COMMAND %_COMBO3 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO3") then gosub COMBAT_COMMAND %_COMBO4 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO4") then gosub COMBAT_COMMAND %_COMBO5 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO5") then gosub COMBAT_COMMAND %_COMBO6 %HAND $GH_TARGET
	else gosub COMBAT_COMMAND %_COMBO1
	if $GH_THIEF = ON then gosub AMBUSH.CHECK
	if (toupper("$GH_TIMER") = "ON") then goto TIMER_ON
	if (toupper("$GH_TRAIN") = "ON") then goto EXPCHECK_ON
	else goto 600

######################################
###                                ###
### This section is for the 7-move ###
### weapon attack _COMBO            ###
###                                ###
######################################
7_COMBO:
700:
	if ("%lastmaneuver" = "none") then
	{
		put stance maneuver
		waitfor Last Combat Maneuver
	}
	var LAST 7_COMBO
	gosub clear
	counter set 700
	save 700
	if ("%lastmaneuver" = "%_COMBO7") then gosub COMBAT_COMMAND %_COMBO1
	if ("%lastmaneuver" = "%_COMBO1") then gosub COMBAT_COMMAND %_COMBO2 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO2") then gosub COMBAT_COMMAND %_COMBO3 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO3") then gosub COMBAT_COMMAND %_COMBO4 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO4") then gosub COMBAT_COMMAND %_COMBO5 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO5") then gosub COMBAT_COMMAND %_COMBO6 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO6") then gosub COMBAT_COMMAND %_COMBO7 %HAND $GH_TARGET
	else gosub COMBAT_COMMAND %_COMBO1
	if $GH_THIEF = ON then gosub AMBUSH.CHECK
	if (toupper("$GH_TIMER") = "ON") then goto TIMER_ON
	if (toupper("$GH_TRAIN") = "ON") then goto EXPCHECK_ON
	else goto 700

######################################
###                                ###
### This section is for the 8-move ###
### weapon attack _COMBO            ###
###                                ###
######################################
8_COMBO:
800:
	if ("%lastmaneuver" = "none") then
	{
		put stance maneuver
		waitfor Last Combat Maneuver
	}
	var LAST 8_COMBO
	gosub clear
	counter set 800
	save 800
	if ("%lastmaneuver" = "%_COMBO8") then gosub COMBAT_COMMAND %_COMBO1 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO1") then gosub COMBAT_COMMAND %_COMBO2 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO2") then gosub COMBAT_COMMAND %_COMBO3 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO3") then gosub COMBAT_COMMAND %_COMBO4 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO4") then gosub COMBAT_COMMAND %_COMBO5 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO5") then gosub COMBAT_COMMAND %_COMBO6 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO6") then gosub COMBAT_COMMAND %_COMBO7 %HAND $GH_TARGET
	if ("%lastmaneuver" = "%_COMBO7") then gosub COMBAT_COMMAND %_COMBO8 %HAND $GH_TARGET
	else gosub COMBAT_COMMAND %_COMBO1
	if $GH_THIEF = ON then gosub AMBUSH.CHECK
	if (toupper("$GH_TIMER") = "ON") then goto TIMER_ON
	if (toupper("$GH_TRAIN") = "ON") then goto EXPCHECK_ON
	else goto 800

######################################
###                                ###
### This section is for the ranged ###
### weapon attack _COMBO            ###
###                                ###
######################################
RANGED:
1000:
	var LAST RANGED
	save 1000
	action var FULL_AIM YES when You think you have your best shot possible
	action var FULL_AIM NO when stop concentrating on aiming
	if ((toupper("$GH_RETREAT") = "ON") && ("%RETREATING" = "OFF") && (("%FIRE_TYPE" != "SNIPE") || ("%FIRE_TYPE" != "POACH"))) then gosub RETREAT_TRIGGERS
	if ("%lastmaneuver" = "none") then gosub COMBAT_COMMAND dodge
RANGED_COMBAT:
1010:
	action var LOADED YES when ^You reach into your backpack to load|^Your %CURR_WEAPON is already loaded
	var LAST RANGED_COMBAT
	gosub clear
	counter set 1010
	save 1010
	if (("%lastmaneuver" = "dodge") || ("%lastmaneuver" = "FIRE") || ("%lastmaneuver" = "POACH") || ("%lastmaneuver" = "SNIPE")) then
	{
		if "%RETREATING" = "ON" then action (retreat) off
		gosub LOAD
		gosub AIM
		if ($GH_THIEF = ON) then gosub AMBUSH.CHECK
		if "%RETREATING" = "ON" then action (retreat) on
		#if (toupper("$GH_SNAP") = "ON")) then gosub stun
			matchre RANGE_FIRE2 You can not poach|are not hidden
			match RETURN isn't loaded
			matchre RETURN ^I could not find what you were
		gosub COMBAT_COMMAND %FIRE_TYPE $GH_TARGET
	} else gosub COMBAT_COMMAND dodge
	goto 1010

LOAD:
	pause 0.0001
	pause 0.001
	matchre CHECK_AMMO ^You don't have the proper ammunition readily available for your
	matchre RANGE_GET ^You must|your hand jams|^You can ?not load
	matchre RANGE_REMOVE_CHECK while wearing an? (.+)
	matchre RETURN Roundtime|is already
		if ($guild = Ranger && $STW = ON && $GH_DUAL_LOAD = ON) || ($guild = Barbarian && $EAGLE = ON && $GH_DUAL_LOAD = ON) then
		{
			send load arrows
			matchwait 80
			goto RANGED_ERROR
		}
		else
		send load
		matchwait 80
	goto RANGED_ERROR

AIM:
	if (matchre("$righthand", "%AMMO\b") || matchre("$lefthand", "%AMMO\b")) then send stow %AMMO
	var AIM_TIMEOUT %t
	if $GH_PAUSE_SNAP > 0 then var SNAP_TIME_RANGED %t
	if $GH_PAUSE_SNAP > 0 then math SNAP_TIME_RANGED add $GH_PAUSE_SNAP
	math AIM_TIMEOUT add 30
		match RE_LOAD loaded
		matchre RETURN best shot possible now|already targetting|begin to target|You shift your
		matchre FACE ^There is nothing
	send aim
	matchwait 80
	goto RANGED_ERROR

RE_LOAD:
	gosub clear
	goto RANGED_COMBAT

AIMING:
	if ("%FULL_AIM" = "YES") then return
	else
	{
		if (%t > %AIM_TIMEOUT) then goto RANGED_COMBAT
		else
		{
			pause .5
			goto AIMING
		}
	}

RANGE_FIRE2:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Can't poach that, just using FIRE ***
		echo
	}
	var LAST RANGE_FIRE2
	gosub clear
		matchre RETURN ^I could not find what you were
		match RETURN isn't loaded
	gosub COMBAT_COMMAND FIRE $GH_TARGET
	goto 1010

RANGE_GET:
	var LAST RANGE_GET
	gosub clear
	if (matchre("$roomobjs", "%AMMO\b")) then
		{
		matchre CHECK_AMMO ^What were you|^You stop as
		match DEAD_MONSTER ^You pull
		matchre %c ^Stow what|^You must unload|^You get some
		matchre RANGE_GET ^You pick up|^You put|^You stow|^You get
		if "%AMMO" = "basilisk head arrow" then put stow basilisk arrow
		else
		put stow %AMMO
		matchwait 80
		goto RANGED_ERROR
	} else goto %c

RANGE_REMOVE_CHECK:
	if matchre ("$0", "shield|buckler|pavise|heater|kwarf|sipar|lid|targe\b") then goto RANGE_REMOVE
	else goto RANGED_ERROR
RANGE_REMOVE:
	var REM_SHIELD $0
	counter set %s
RANGE_REMOVING:
	var LAST RANGE_REMOVING
		matchre RANGE_STOW ^You loosen the straps securing|^You aren't wearing that
		match RANGED_ERROR ^Remove what?
	put remove my %REM_SHIELD
	matchwait 80
	goto RANGED_ERROR

RANGE_STOW:
	var LAST RANGE_STOW
		match RANGED_ERROR ^Stow What?
		match RANGE_ADJUST too
		match RETURN You put
	put stow my %REM_SHIELD
	matchwait 16
RANGE_ADJUST:
		matchre RANGED_ERROR through the straps|You can't wear any more items like that
		match RETURN You sling
	put adjust my %REM_SHIELD
	put wear my %REM_SHIELD
	matchwait  30
	goto RANGED_ERROR

CHECK_AMMO:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** No ammo on you, checking the ground ***
		echo
	}
	if contains("$roomobjs", "%AMMO") then
	{
		gosub RANGED_CLEAN
		goto 1000
	}
NO_AMMO:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** No more ammo, stopping script ***
		echo
	}
	var LAST NO_AMMO
	if ("%REM_SHIELD" != "NONE") then
	{
		gosub EQUIP_SHIELD %REM_SHIELD
	}
	gosub RANGE_SHEATHE
	goto DONE

######################################
###                                ###
### This section is for the ranged ###
### weapon attack _COMBO            ###
###                                ###
######################################
THROWING:
1200:
	save 1200
	var LAST THROWING
	if ((toupper("$GH_RETREAT") = "ON") && ("%RETREATING" = "OFF")) then gosub RETREAT_TRIGGERS
	if ("%lastmaneuver" = "none") then gosub COMBAT_COMMAND dodge
THROW_WEAPON:
1210:
	var LAST THROW_WEAPON
	gosub clear
	counter set 1210
	save 1210
	if ("%LOB" = "OFF" && "%HURL" = "OFF") then gosub COMBAT_COMMAND throw %HAND $GH_TARGET
	if ("%LOB" = "ON") then gosub COMBAT_COMMAND lob %HAND $GH_TARGET
	if ("%HURL" = "ON") then gosub COMBAT_COMMAND hurl %HAND $GH_TARGET
	if ((("%HAND" = "") && ("$righthand" = "Empty")) || (("%HAND" = "left") && ("$lefthand" = "Empty"))) then gosub GET_THROWN
	if (("%HAND" = "left") && "$righthand" = "%CURR_WEAPON")) then gosub SWAP_LEFT $righthandnoun
	if (toupper("$GH_TIMER") = "ON") then goto TIMER_ON
	if (toupper("$GH_TRAIN") = "ON") then goto EXPCHECK_ON
	goto 1210

GET_THROWN:
	if $roundtime > 0 then waiteval $roundtime = 0
		match GET_THROWN As you reach for a large frozen club
		match WEAPON_STUCK What were you
		matchre RETURN already|You need a free hand to pick that up|You get|You pick up|With a flick|You pull|suddenly leaps toward you|and flies toward you
	if %BONDED = ON then send invoke
	else
	send get my %CURR_WEAPON
	matchwait 15
	goto THROWN_ERROR

WEAPON_STUCK:
1220:
	var LAST WEAPON_STUCK
	if ("%RETREATING" = "ON") then gosub RETREAT_UNTRIGGERS
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Getting weapon back ***
		echo
	}
	gosub clear
	if !indexof ("$BW", "$") then
	{
		if "$BW" != "OFF" && "$GH_BUFF" = "ON" then
		{
			if "$righthand" = "Empty" then waitforre leaps back into your
			goto 1210
		}
	}
	send advance
	waitforre to melee range|already at melee
	if (("%lastmaneuver" = "throw") || ("%lastmaneuver" = "jab")) then
	{
		match GET_WEAPON comes free and falls to the ground.
		gosub COMBAT_COMMAND dodge
	}
	if ("%lastmaneuver" = "dodge") then
	{
		match GET_WEAPON comes free and falls to the ground.
		gosub COMBAT_COMMAND gouge
	}
	if ("%lastmaneuver" = "gouge") then
	{
		match GET_WEAPON comes free and falls to the ground.
		gosub COMBAT_COMMAND claw
	}
	if ("%lastmaneuver" = "claw") then
	{
		match GET_WEAPON comes free and falls to the ground.
		gosub COMBAT_COMMAND elbow
	}
	if ("%lastmaneuver" = "elbow") then
	{
		match GET_WEAPON comes free and falls to the ground.
		gosub COMBAT_COMMAND jab
	}
	else gosub COMBAT_COMMAND dodge
	goto 1220

GET_WEAPON:
	if ((toupper("$GH_RETREAT") = "ON") && ("%RETREATING" = "OFF")) then gosub RETREAT_TRIGGERS
	gosub clear
		matchre GET_WEAPON comes free and falls to the ground|As you reach for a large frozen club
		matchre 1210 already|You get|You pull|You pick|You need a free hand to|What were you
	put get %CURR_WEAPON
	matchwait 15
	goto THROWN_ERROR

########################################
###                                  ###
### This section is for the backstab ###
### weapon attack _COMBO              ###
###                                  ###
########################################
STABBITY:
1300:
	var LAST STABBITY
	gosub clear
	counter set 1300
	save 1300
	if ("%lastmaneuver" != "parry") then gosub COMBAT_COMMAND parry
	if ("%lastmaneuver" = "parry") then
	{
		matchre FACE Backstab what\?|Face what\?
		matchre BS_ATTACK You can't backstab that\.|political|You'll need something a little lighter
		matchre BAD_WEAPON entirely unsuitable|Backstabbing is much more effective when you use a melee weapon
		gosub COMBAT_COMMAND backstab %HAND $GH_TARGET
	}
	if (toupper("$GH_TIMER") = "ON") then goto TIMER_ON
	if (toupper("$GH_TRAIN") = "ON") then goto EXPCHECK_ON
	else goto 1300
BS_ATTACK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Can't backstab, ambushing instead ***
		echo
	}
	gosub clear
	goto 500

BAD_WEAPON:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BAD_WEAPON: ***
		echo This weapon is not suitable for this type of attack, switching to regular combat
		echo
	}
	counter set 0
	goto WEAPON_CHECK

######################################
###                                ###
###      Combat Manuever           ###
###                                ###
######################################
COMBAT_COMMAND:
	var COMMAND $0
	if ((toupper("$GH_RITUAL") = "ON") && ("$%GH_RITUALSPELL" = "OFF")) then
	{
		put stance
		waitforre ^Last Combat Maneuver
		send stance set %RITUAL_STANCE
		waitforre ^You are now set|^Setting your
		if $mana < 70 then waiteval $mana >= 70
		var rhanditem none
		var lhanditem none
		if "$righthand" != "Empty" then
			{
			var rhanditem $righthandnoun
			gosub SHEATHE $righthandnoun
			}
		if "$lefthand" != "Empty" then
			{
			var lhanditem $lefthandnoun
			gosub SHEATHE $lefthandnoun
			}
		if "%RITUAL_FOCUS_CONTAINER" = WORN then
		{
			send remove my %RITUAL_FOCUS
			waitforre ^You |^Remove what|^What were you referring to|^You aren't wearing that
		}
		else
		{
			send get %RITUAL_FOCUS from my %RITUAL_FOCUS_CONTAINER
			waitforre ^You get|^You are already holding that|^What were you referring to
		}
		if "%GH_RITUALSPELL" = "ABSOLUTION" && "$GOL" = ON then
			{
			send release gol
			waitforre ^Your increased sense of wellness|^RELEASE Options
			}
		send prepare %GH_RITUALSPELL %GH_RITUALMANA
		waitforre ^%PREP_MESSAGE
		pause .5
		send invoke my %RITUAL_FOCUS
		waitforre ^You feel fully prepared to cast your spell
		send cast
		if "%RITUAL_FOCUS_CONTAINER" = WORN then
		{
			send wear my %RITUAL_FOCUS
			waitforre ^You |^What were you referring to|^This .+ can't fit over the
		}
		else
		{
			send put my %RITUAL_FOCUS in my %RITUAL_FOCUS_CONTAINER
			waitforre ^You put|^But that is already in your inventory|^Perhaps you should be holding that first|^There isn't any more room in|^Stow what|^What were you referring to
		}
		if (%rhanditem != none) then gosub WIELD_WEAPON %CURR_WEAPON
		if (%lhanditem != none) then gosub WIELD_WEAPON %lhanditem
		send stance set %estance %pstance %sstance %ostance
		waitforre ^You are now set|^Setting your
		if ("%CURR_STANCE" = "Evasion") then put stance evasion
		elseif ("%CURR_STANCE" = "Parry_Ability") then send stance parry
		elseif ("%CURR_STANCE" = "Shield_Usage") then send stance shield
		elseif ("%CURR_STANCE" = "Custom") then send stance custom
		pause
	}
	if (("$GH_FEINT" = "ON") && (("$0" != "feint") && ("$0" != "parry") && ("$0" != "dodge"))) then var COMMAND feint
	if ("%EXP2" != "Offhand_Weapon") then var lastmaneuver $1 $2 $3
	else var lastmaneuver $1
	if "%LAST" != "RANGED_COMBAT" then
	{
		if ("%SEARCHED" = "NO") then
		{
			if matchre ("$roomplayers", "Also here: (\S+)") then goto NOT_CHECKING
			if matchre ("$roomobjs", "((which|that) appears dead|\(dead\))") then goto DEAD_MONSTER
		}
		else var SEARCHED NO
	}
	NOT_CHECKING:
	if ((toupper("$GH_HUNT") = "ON") && (%t >= %HUNT_TIME) && ($Perception.LearningRate < 30)) then
	{
		if $roundtime > 0 then waiteval $roundtime = 0
		send hunt
		var HUNT_TIME %t
		math HUNT_TIME add 75
		waitforre Roundtime|You find yourself unable
	}
	if ((toupper("$GH_MANIP") = "ON") && (%t >= %MANIP_TIME) && ($Empathy.LearningRate < 30) then
	{
		gosub MANIPULATE1
		var MANIP_TIME %t
		math MANIP_TIME add 75
	}
	if ((toupper("$GH_NISSA") = "ON") && (%t >= %nissa_time) then
	{
		gosub DEBNISSA
		var nissa_time %t
		math nissa_time add 120
	}
	If (("$GH_SCREAM" = "ON" && ("$guild" = "Bard") && ($Bardic_Lore.LearningRate < 30) && ($SCREAM_TIMER < $gametime)) then
	{
		if "%SCREAM_CONCUSSIVE" = "OFF" then
		{
			send scream conc
			waitforre ^Inhaling deeply,|^You open your mouth, then close it suddenly, looking somewhat like a fish\.|^Scream at what\?|^You scream out\!
			pause $roundtime
			var SCREAM_CONCUSSIVE ON
		}
		if "%SCREAM_HAVOC" = "OFF" then
		{
			send scream havoc
			waitforre ^Opening yourself as the conduit|^You open your mouth, then close it suddenly, looking somewhat like a fish\.|^Scream at what\?|^You scream out\!
			pause $roundtime
			var SCREAM_HAVOC ON
		}
		if "%SCREAM_DEFIANCE" = "OFF" then
		{
			send scream defiance
			#waitforre ^Opening yourself as the conduit|^You open your mouth, then close it suddenly, looking somewhat like a fish\.|^Scream at what\?
			pause $roundtime
			var SCREAM_HAVOC ON
		}
	}
	if (("$Guild" = "Warrior Mage") && ($Summoning.LearningRate < 30) && ($Circle > 3)) then
	{
		send pathway focus damage
		send pathway stop
		waitforre ^You gently relax
	}
	if ((toupper("$GH_PARALYSIS") = "ON") && ($Targeted_Magic.LearningRate < 30) && ($mana >= 30) then gosub TMPARALYSIS
	if ((toupper("$GH_PP") = "ON") && (%t >= %PP_TIME) && ($Attunement.LearningRate < 30)) then
	{
		if matchre("$guild", "Moon Mage|Trader") then
		{

			var PP_TIME %t
			math PP_TIME add 60
			if $roundtime > 0 then waiteval $roundtime = 0
			send perc yavash
			waitforre Roundtime|^Strangely, you can sense absolutely nothing
			pause .1
			pause .1
		}
		else
		{
			if $roundtime > 0 then waiteval $roundtime = 0
			send power
			var PP_TIME %t
			math PP_TIME add 60
			waitforre Roundtime|^Strangely, you can sense absolutely nothing
		}
	}
	if ((toupper("$GH_PILGRIM") = "ON") && (%t >= %PILGRIM_TIME)) then
	{
		send remove my pilgrim's badge
		waitforre ^You take off|^Remove what|^You need a free hand for that
		send pray pilgrim's badge
		wait
		pause
		send wear my pilgrim's badge
		waitforre ^You put on|^Wear what|^You are already wearing that
		pause
		var PILGRIM_TIME %t
		math PILGRIM_TIME add 2000
	}
	if ((toupper("$GH_SMITE") = "ON") && (%t >= %SMITE_TIME) && ($Conviction.LearningRate < 30)) then
	{
		send smite
		var SMITE_TIME %t
		math SMITE_TIME add 60
		waitforre Roundtime|^There is nothing else to face!$|^You aren't close enough to attack|^What are you trying to attack\?$|^\[Use SMITE HELP for more information\.\]$
	}
	if (toupper("$GH_ARMOR") = "ON" && "%EXP2" != "Stealth") then gosub GH_ARMOR_ON
	if toupper("$GH_BUFF") = "ON" and $mana > 30 then gosub GH_BUFF_ON
	if $GH_KHRI = ON && %t >= %KHRI_TIME then
	{
		gosub KHRI.CHECK
		var KHRI_TIME %t
		math KHRI_TIME add 60
	}
	if toupper("$juggernaut.orb") = "YES" then gosub DISARM_ORB

	if $standing = 0 then
	{
		send stand
		pause .5
	}
	if (("$GH_ENCHANTE" = "ON") && (%enchante_timer < %t) && ($%enchante_school.LearningRate < 30) && (matchre("%enchante_school", "Augmentation|Utility|Warding"))) then
	{
		send release cyclic
		pause .5
		send prep %enchante_name %enchante_mana
		waitfor You feel fully prepared
		send cast
		math enchante_timer add %t
	}
	if (("$GH_FLEE" = "ON") && ($gametime >= $FLEE_TIMER) && ("$GLOBAL_FLEE" = "ON") && ($Athletics.LearningRate < 30)) then
	{
		#If you want this section to work you need to #var FLEE_TIMER $gametime
		var CURR_ATHLETICS $Athletics.LearningRate
		matchre FLEE.CONTINUE ^You .* escape.*\.$|^.*burden|^A master assassin you are not but those who flee live to pillage and plunder another day
		matchre FLEE.SKIP ^You assess your combat situation and realize you don't see anything engaged with you.
		send flee direction
		matchwait

		FLEE.CONTINUE:
		put #var FLEE_TIMER $gametime
		put #math FLEE_TIMER add 350
		evalmath CURR_ATHLETICS $Athletics.LearningRate - %CURR_ATHLETICS
		if %CURR_ATHLETICS <= 0 then
		{
			put #var GH_FLEE OFF
			put #var GLOBAL_FLEE OFF
			put #echo >Log Turning off FLEE Training as these don't teach.
		}
		FLEE.SKIP:
	}
	If ("%SPELLWEAVE" = "ON" && "%PREPSPELLWEAVE" = "OFF") then
	{
		if $mana < 70 then waiteval $mana >= 70
		gosub PREPARESPELLWEAVE
	}
	if (($Augmentation.LearningRate < 30) && ("%AUGMENTATION" = "off") && ("%WARDING" = "off") && ("%guild" = "Barbarian")) then
	{
		send form monkey
		var AUGMENTATION on
		pause .5
		pause .5
	}
	if (($Augmentation.LearningRate >= 30) && ("%AUGMENTATION" = "on") && ("%guild" = "Barbarian")) then
	{
		send form stop monkey
		var AUGMENTATION off
		pause 1
	}
	if (($Warding.LearningRate < 30) && ("%AUGMENTATION" = "off") && ("%guild" = "Barbarian")) then
	{
		send bers fam
		var WARDING on
		pause .5
		pause .5
	}
	if (($Warding.LearningRate >= 30) && ("%WARDING" = "on") && ("%guild" = "Barbarian")) then
	{
		send form stop swan
		var WARDING off
	}
	if "$guild" = "Empath" && "$GH_CONSTRUCT" = "ON" && "$GH_ANALYZE" = "OFF" then
	{
		gosub ASSESS
	}
	if ("$GH_SNAP" = "OFF" && "%FULL_AIM" != "YES" && matchre("%COMMAND", "POACH|FIRE|SNIPE") then gosub AIMING
	elseif (%t < %SNAP_TIME_RANGED) then pause $GH_PAUSE_SNAP
	var FULL_AIM NO

	if ("%SPELLWEAVE" = "ON" && "%FULL_PREP" = "YES" then
	{
		gosub CASTSPELLWEAVE
	}
	if ((toupper("$GH_SLOW") = "ON") && ($stamina < 90)) then
	{
		if (("%guild" = "Barbarian")) then
		{
			send berserk avalanche
		}
		waiteval $stamina = 100
	}
	if (($Debilitation.LearningRate < 30) && ("%guild" = "Barbarian") && ($hidden != 1)) then
	{
		send roar quiet rage
		waitforre ^You have not been|^Roundtime|^\[Roundtime|^Strain though you might\,
		pause .5
		pause .5
	}
	if ((toupper("$GH_AMBUSH") = "ON") && ($hidden != 1)) then
	{
		if ("%BACKSTAB" = "ON") then gosub HIDE
		else If ("%EXP2" = "Backstab") && ("%BACKSTAB" = "OFF") then var COMMAND attack
		else gosub HIDE
		if $GH_THIEF = ON then gosub AMBUSH.CHECK
	}
	if (("%FIRE_TYPE" = "POACH") || ("%FIRE_TYPE" = "SNIPE")) then gosub HIDE
	if (($hidden = 1) && ("%guild" = "Paladin")) then
	{
		send unhide
		pause 1
	}
	if ("%COMMAND" = "MAGIC_WAIT") then return

ATTACK:
var LAST ATTACK
if ("$righthandnoun" = "fan") && ("%LAST_FAN_STATUS" = "OPENED") && ("%FAN_STATUS" = "CLOSED") then
{
	send open my $righthand
	var FAN_STATUS OPENED
	pause .2
}

if ($Tactics.LearningRate < 30 && $GH_TACTICS = ON && !matchre("%WEAPON_EXP", "Bow|Crossbow|Slings")) then gosub TACTICSTRAIN
if ($GH_ANALYZE = ON && !matchre("%WEAPON_EXP", "Bow|Crossbow|Slings")) then gosub DO_ANALYZE
else
	{
		matchre FLYING_MONSTER flying far too high to hit with|flying too high for you to attack
		matchre FATIGUE You're beat|You're exhausted|You're bone-tired|worn-out
		matchre ADVANCE help if you were closer|aren't close enough
		matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead|pointlessly hack
		matchre FACE nothing else|^Face what\?
		matchre RETURN You are already in a position|But you are already dodging|Roundtime|must be hidden|What were you|What are you
	#if ("$guild" = "Paladin") && ("$smite" = "true") && (%SMITE <= %t) && (matchre("%WEAPON_EXP", "Small_Edged|Large_Edged|Twohanded_Edged|Small_Blunt|Large_Blunt|Twohanded_Blunt|Staves|Polearms|Brawling")) then
	#{
	#	var SMITE %t
	#	math SMITE add 61
	#	var COMMAND smite
	#}
	if (%BACKSTAB = ON && !(matchre("%COMMAND", "backstab|parry|dodge")) then
	{
		random 0 8
		pause 0.3
		send %COMMAND %BODY_PART(%r)
	}
	else
	{
		if ((%COMMAND = throw) && ($righthand = Empty)) then
		{
			send get %CURR_WEAPON
			waitforre ^You
		}
		if ("$guild" = "Empath" && "$GH_CONSTRUCT" = "ON") then send %COMMAND %Empath_Monster
		else
		{
			if matchre("%COMMAND", "POACH|SNIPE") then
			{
				if $hidden = 0 then send fire
				else send %COMMAND
			}
			else send %COMMAND
		}
	}
	matchwait 5
	}
	if ("$smite" = "true") then var COMMAND %OLD_COMMAND
	return
	goto ATTACK_ERROR

TACTICSTRAIN:
         matchre FACE nothing else to face
         matchre NEXT_TACT Roundtime|You aren't close enough|flying too high for you to attack
         matchre ADVANCE must be closer
         send %TACTICS(%tact_move)
         matchwait 10
         goto TACTICSTRAIN
NEXT_TACT:
         if %tact_move < 2 then math tact_move add 1
         else var tact_move 0
         pause 0.5
         return

DO_ANALYZE:
	var LAST DO_ANALYZE
	matchre ANALYZE_DONE ^Roundtime|^You recall your combo|^Your analysis
	matchre ADVANCE ^You must be closer
	matchre FACE ^Analyze what|^You fail to find any
	matchre RETURN ^You have just recently completed that attack combination, and cannot repeat it so soon.
	action (combos) on
	send analyze %barb.tact
	matchwait 10
	goto DO_ANALYZE
ANALYZE_DONE:
	action (combos) off
	if !%ANALYZELEVEL = 10 then math ANALYZELEVEL add 1
	if %ANALYZELEVEL < %ANALYZEAMOUNT then goto DO_ANALYZE
	goto COMBOSTART
ANALYZE_FINAL:
	if (%ANALYZELEVEL = %ANALYZEAMOUNT && "%BARB" != "ON") then
	{
		send analyze
		pause 1
	}
	if (("$guild" = "Empath") && ("$GH_CONSTRUCT" = "ON")) then gosub ASSESS
	gosub MANEUVERSTART %_COMBO(%this.attack)
	math this.attack add 1
	var ANALYZELEVEL 0
COMBOSTART:
	if %this.attack > %_combocount then
	{
		var this.attack 0
		return
	}
	if ((%this.attack = %_combocount) && (%ANALYZELEVEL < %ANALYZEAMOUNT)) then goto ANALYZE_FINAL
	if (("$guild" = "Empath") && ("$GH_CONSTRUCT" = "ON")) then gosub ASSESS
	gosub MANEUVERSTART %_COMBO(%this.attack)
	math this.attack add 1
	goto ComboStart
MANEUVERSTART:
	var maneuver $1
MANEUVER:
	var LAST MANEUVER
	matchre FLYING_MONSTER flying far too high to hit with|flying too high for you to attack
	matchre FATIGUE You're beat|You're exhausted|You're bone-tired|worn-out
	matchre COMBO_ADVANCE help if you were closer|aren't close enough
	matchre DEAD_MONSTER balanced\]|balance\]|already dead|very dead|pointlessly hack
	matchre FACE nothing else|^Face what\?
	matchre RETURN You are already in a position|But you are already dodging|You move into a position to|Roundtime|must be hidden|What were you|What are you|^You can not slam
	send %maneuver
	matchwait 10
	goto %LAST
COMBO_ADVANCE:
	waitforre melee range
	goto maneuver
FLYING_MONSTER:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Monster is flying, trying attack again ***
		echo
	}
	put #beep
	pause 3
	goto ATTACK
HIDE:
	if (($Stealth.LearningRate >= 30 && %BACKSTAB != ON) then RETURN
	match HIDE fail
	matchre HIDE1_RETREAT You are too close|notices|reveals|ruining
	matchre STALK1 You melt|You blend|Eh\?
	send hide
	matchwait 15
	goto STEALTH_ERROR
HIDE1_RETREAT:
	send retreat
	waitforre ^You|^Roundtime
	goto HIDE
STALK1:
	if ("$guild" = "Paladin" then return
	if %BACKSTAB = ON then return
	matchre CIRCLE_CHECK reveals|try being out of sight|discovers you|trying to stalk|Stalking is an inherently stealthy endeavor
	match STALK1 You think|You fail
	match FACE Stalk what?
	matchre RETURN You move into position|You are already stalking|You're already stalking
	send stalk
	matchwait 15
	goto STEALTH_ERROR
CIRCLE_CHECK:
	if (("%guild" = "Thief") && (%circle >= 50)) then var circle 1
	goto HIDE

ASSESS:
	matchre SET_ASSESS are facing [?:a|an](.*)(?:\(\d\)\s)
	matchre SET_ASSESS are behind [?:a|an](.*)(?:\(\d\)\s)
	matchre SET_ASSESS are flanking [?:a|an](.*)(?:\(\d\)\s)
	send assess
	matchwait 15

SET_ASSESS:
	if matchre ("$1", "\b(%construct)\b") then var Empath_Monster $1
	else goto FACE
	eval Empath_Monster replacere("%Empath_Monster",".*\s(\w+)\.?\$", "\$1")
	return

PREPARESPELLWEAVE:
	If ("%MAGIC_TYPE" = "TM") then
	{
		if $Targeted_Magic.LearningRate < 30 then
		{
			send target $GH_SPELL $GH_MANA
			waitforre ^$PREP_MESSAGE|But you're already preparing a spell\!|You have already fully
			var PREPSPELLWEAVE ON
		}
	}
	If matchre("%MAGIC_TYPE" = "DEBIL|AUG|WARD|UTIL") then
	{
		if ("%MAGIC_TYPE" = "DEBIL") && ($Debilitation.LearningRate < 30)) then
		{
			send prep $GH_SPELL $GH_MANA
			waitforre ^$PREP_MESSAGE|But you're already preparing a spell\!|You have already fully
			var PREPSPELLWEAVE ON
		}
		if ("%MAGIC_TYPE" = "AUG") && ($Augmentation.LearningRate < 30)) then
		{
			send prep $GH_SPELL $GH_MANA
			waitforre ^$PREP_MESSAGE|But you're already preparing a spell\!|You have already fully
			var PREPSPELLWEAVE ON
		}
		if ("%MAGIC_TYPE" = "WARD") && ($Warding.LearningRate < 30)) then
		{
			send prep $GH_SPELL $GH_MANA
			waitforre ^$PREP_MESSAGE|But you're already preparing a spell\!|You have already fully
			var PREPSPELLWEAVE ON
		}
		if ("%MAGIC_TYPE" = "UTIL") && ($Utility.LearningRate < 30)) then
		{
			send prep $GH_SPELL $GH_MANA
			waitforre ^$PREP_MESSAGE|But you're already preparing a spell\!|You have already fully
			var PREPSPELLWEAVE ON
		}
	}
	return

CASTSPELLWEAVE:
	pause 0.1
	pause 0.1
	if ("$guild" = "Empath") then send cast %Empath_Monster
	else send cast
	waitforre ^You gesture|^The flames|^Tendrils of flame|^Focusing on the aethereal|^Your spell|^Your hands glow|^Your $cambrinth emits a loud|^You whisper the final word|^Roundtime|^\[Roundtime|^You don't have a spell prepared|^Your target pattern dissipates because|^You can't cast that at yourself!|The .*is already dead
	var PREPSPELLWEAVE OFF
	var FULL_PREP NO
	pause 0.1
	pause 0.1
	return

######################################
###                                ###
### This section is for Magic      ###
###                                ###
######################################
2000:
2500:
2600:
2700:
2800:
3000:
3010:
3200:
var APPRAISAL NO
if ((toupper("$GH_RETREAT") = "ON") && ("%RETREATING" = "OFF")) then gosub RETREAT_TRIGGERS
action var FULL_PREP YES when The formation of the target pattern around
save %c

MAGIC_PREP:
var LAST MAGIC_PREP
if $GH_APPR = YES then gosub APPR_YES
if toupper("$GH_TEND") = "ON" && $bleeding = 1 then gosub GH_TEND_ON
if toupper("$GH_ARMOR") = "ON" then gosub GH_ARMOR_ON
if toupper("$juggernaut.orb") = "YES" then gosub DISARM_ORB
if $mana < 20 then waiteval $mana >= 20
	echo
	echo MAGIC_PREP:
	echo
	if ("%SEARCHED" = "NO") then
	{
		if matchre ("$roomobjs", "((which|that) appears dead|\(dead\))") then goto DEAD_MONSTER
	} else var SEARCHED NO
	put #var GH_HARN_FLAG NO
		#if ("%MAGIC_TYPE" = "TM") then match MAGIC_TARGET You trace an arcane sigil in the air, shaping the pattern
	##check here

		#matchre MAGIC_TARGET fully prepared|already preparing
		#match MAGIC_COMBAT have to strain
	if "%MAGIC_TYPE" = "TM" then goto MAGIC_TARGET
	send prep $GH_SPELL $GH_MANA
	##CHANGE You close TO YOUR SPELL PREP MESSAGING
	waitforre (%PREP_MESSAGE)
	if "$1" = "You have to strain" then goto MAGIC_COMBAT
	if (($GH_HARN != 0) && (toupper("$GH_HARN_FLAG") = "NO")) then gosub MAGIC_HARNESS
	waitforre ^You feel fully prepared to cast
	goto MAGIC_CAST
	#matchwait 20
	#goto MAGIC_ERROR

MAGIC_TARGET:
	var LAST MAGIC_TARGET
	echo
	echo MAGIC_TARGET:
	echo
	if ("$guild" = "Empath" && "$GH_CONSTRUCT" = "ON" then gosub ASSESS
		matchre MAGIC_PREP You don't have a spell prepared|You must be preparing a spell
		matchre MAGIC_FACE_TM not engaged|I could not
		matchre MAGIC_TARGET_WAIT1 ^You begin to weave mana lines into|You trace a hasty sigil
		matchre MAGIC_TARGET_WAIT2 don't need to target|^Your target pattern is already formed
		matchre MAGIC_TARGET_FAIL patterns? dissipates?
	send target $GH_SPELL $GH_MANA
	matchwait 15
	goto MAGIC_ERROR

MAGIC_TARGET_WAIT1:
	if (($GH_HARN != 0) && (toupper("$GH_HARN_FLAG") = "NO")) then gosub MAGIC_HARNESS
	if ("$GH_SNAP" = "ON") then
	{
		if ($GH_PAUSE_SNAP > 0) then pause $GH_PAUSE_SNAP
		goto MAGIC_CAST
	}
	if ("%FULL_PREP" = "YES") then goto MAGIC_CAST
		matchre MAGIC_CAST ^Your formation of a targeting pattern around|^Your target pattern has finished forming around
		matchre TARGET_FAIL patterns? dissipates?
		matchre MAGIC_DEATH ^You gesture|You reach
	matchwait 30
	goto MAGIC_ERROR

MAGIC_TARGET_WAIT2:
	if ($GH_HARN != 0) then gosub MAGIC_HARNESS
	if ("$GH_SNAP" = "ON") then
	{
		if ($GH_PAUSE_SNAP > 0) then pause $GH_PAUSE_SNAP
		goto MAGIC_CAST
	}
	goto MAGIC_CAST

MAGIC_TARGET_FAIL:
	if ("%MAGIC" = "ON") then goto MAGIC_COMBAT
	send release
	goto PREP

MAGIC_HARNESS:
	echo
	echo MAGIC_HARNESS:
	echo
	put #var GH_HARN_FLAG YES
		matchre MAGIC_HARNESS_DONE ^You tap into the mana from|^You strain, but cannot harness
	send harness $GH_HARN
	matchwait 15
	goto MAGIC_ERROR

MAGIC_HARNESS_DONE:
	pause 0.5
	return

MAGIC_FACE_TM:
	pause 5
	var LAST MAGIC_FACE_TM
	echo
	echo MAGIC_FACE_TM:
	echo
	match MAGIC_TARGET You turn
	matchre MAGIC_FACE_TM There is nothing|Face what\?
	send face next
	matchwait 15
	goto MAGIC_ERROR

MAGIC_TM_ADV:
	var LAST MAGIC_TM_ADV
		match MAGIC_FACE_TM You stop advancing
		match MAGIC_FACE_TM2 advance towards
		match MAGIC_FACE_TM You have lost sight
		matchre MAGIC_TARGET to melee range|\[You're|already at melee|begin
	send advance
	matchwait 15
	goto MAGIC_ERROR

MAGIC_FACE_TM2:
	send release spell
	goto FACE

MAGIC_CAST:
	var LAST MAGIC_CAST
	echo
	echo MAGIC_CAST:
	echo
	var FULL_PREP NO
		matchre MAGIC_DEATH You gesture|You reach|Roundtime
		match MAGIC_DEATH_REL because your target is dead
		match MAGIC_COMBAT You are unable to harness
		match MAGIC_FACE_TM on yourself!
		match MAGIC_PREP You don't
		match MAGIC_FACE_TM2 There is nothing else to face!
		matchre TARGET_FAIL patterns? dissipates?
	send cast
	matchwait 15
	goto MAGIC_ERROR

TARGET_FAIL:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo ***  TARGET_FAIL:  ***
		echo Failed to target magically
		echo Re-prepping and trying again
		echo
	}
	send release
	goto %c

MAGIC_DEATH_REL:
	send release spell
	wait
	goto DEAD_MONSTER

MAGIC_DEATH:
	if ("%MAGIC" = "ON") then goto MAGIC_COMBAT
	gosub COMBAT_COMMAND MAGIC_WAIT
	var LAST MAGIC_DEATH
	if matchre ("$roomobjs", "((which|that) appears dead|\(dead\))") then goto DEAD_MONSTER
	else goto EXPCHECK_$GH_TRAIN

MAGIC_COMBAT:
	pause
	send release spell
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** MAGIC_COMBAT: ***
		echo
	}
	counter subtract 2000
	if ("%RETREATING" = "ON") then gosub RETREAT_UNTRIGGERS
	goto %c

######################################
###                                ###
### End of Magics                  ###
###                                ###
######################################

RANGED_CLEAN:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** RANGED_CLEAN ***
		echo
	}
	if (("%SHIELD" != "NONE" && ("$lefthandnoun" = "%SHIELD")) then
	{
		gosub UNEQUIP_SHIELD
	}
	if (matchre("$righthand", "%AMMO\b") || matchre("$lefthand", "%AMMO\b")) then send stow %AMMO
	send retreat
	pause
	matchre RANGED_CLEAN_DONE ^You get some
	matchre RANGED_CLEAN_DONE ^You stop as you realize
	matchre RANGED_CLEAN_DONE ^You get a
	matchre RANGED_CLEAN_DONE ^Stow what
	matchre RANGED_CLEAN_DONE ^You are already holding
	matchre RANGED_CLEAN_DONE ^You must unload
	matchre RANGED_CLEAN You pick up|You pull
	if "%AMMO" = "basilisk head arrow" then send stow basilisk arrow
	else send stow %AMMO
	matchwait 15
	goto CLEANING_ERROR

RANGED_CLEAN_DONE:
	if "%AMMO" = "basilisk head arrow" then send stow basilisk arrow
	else send stow %AMMO
	if (("%SHIELD" != "NONE" && ("$lefthand" = "Empty")) then
	{
		gosub EQUIP_SHIELD
	}
	return

THROWN_CLEAN:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** THROWN_CLEAN ***
		echo
	}
	send put my %CURR_WEAPON in my %T_SHEATH
	send retreat
	pause
		matchre THROWN_CLEAN_DONE You get some|You get a|You are already holding
		matchre THROWN_CLEAN You pick up|You pull
	send get %CURR_WEAPON
	matchwait 15
	goto CLEANING_ERROR

THROWN_CLEAN_DONE:
	send put my %CURR_WEAPON in my %T_SHEATH
	return

WEBBED:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** You have been webbed ***
		echo
	}
	var WEBBED YES
	action remove eval $webbed = 1
	action var WEBBED NO when move freely again|free yourself from the webbing\.
	put #beep
	if $webbed = 0 then
	{
	var WEBBED NO
	action goto WEBBED when eval $webbed = 1
	goto %LAST
	}
	if ("%WEBBED" = "YES") then
	{
		waitforre move freely again|free yourself from the webbing\.
	}
	action goto WEBBED when eval $webbed = 1
	goto %LAST

STAND:
	pause 1
	if ("$standing = 0") then
	{
		echo
		echo *** Knocked down, standing back up ***
		echo
	}
	var GO_BACK %LAST
STANDING:
	if ("$standing" = "0") then
	{
	var LAST STANDING
		matchre STANDING cannot manage to stand|The weight of all your possessions|still stunned
		matchre %GO_BACK ^You stand|^You are already standing
	send stand
	matchwait 15
	goto ERROR
	}

FATIGUE:
	if ("%GAG_ECHO" != "YES") then
		{
		echo
		echo *** FATIGUE: ***
		echo
		}
	if (("%THROWN" = "ON") && matchre("$roomobjs", "%CURR_WEAPON")) then
	{
		pause 1
		send get %CURR_WEAPON
		waitforre You pick up|You get|You are
	}
	var LAST FATIGUE
	matchre FATIGUE \[You're|You stop advancing
	match FATIGUE_CHECK You cannot back away from a chance to continue your slaughter!
	match FATIGUE_CHECK You bob
	send bob
	matchwait 40
	goto FATIGUE_CHECK

FATIGUE_CHECK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** FATIGUE_CHECK: ***
		echo
	}
	if ($stamina < 80) then
	{





		goto FATIGUE_WAIT
	} else
	{
		goto %c
	}

FATIGUE_WAIT:
	if ("%GAG_ECHO" != "YES") then
	{

		echo
		echo *** FATIGUE_WAIT: ***
		echo
	}
		matchre FATIGUE You feel fully rested|melee|pole|\[You're
	matchwait

MANIPULATE1:
	send manipulate friendship first $manipulate1
	matchre return ^You strain, but cannot extend your will any further|^You extend your will and attempt to Empathically manipulate .+, but you cannot find any purchase\.
	matchwait 1
	send manipulate friendship second $manipulate1
	matchre return ^You strain, but cannot extend your will any further|^You extend your will and attempt to Empathically manipulate .+, but you cannot find any purchase\.
	matchwait 1
	wait
	send manipulate friendship first $manipulate2
	matchre return ^You strain, but cannot extend your will any further|^You extend your will and attempt to Empathically manipulate .+, but you cannot find any purchase\.|^Manipulate what
	wait
	send manipulate friendship second $manipulate2
	matchre return ^You strain, but cannot extend your will any further|^You extend your will and attempt to Empathically manipulate .+, but you cannot find any purchase\.|^Manipulate what
	wait
	return

DEBNISSA:
	var nissacount 0
	action var nissadone yes when ^You feel fully prepared to cast your spell
DEBNISSACAST:
	var nissadone no
	if %nissacount > 4 then
	{
	var nissa_time %t
	math nissa_time add 120
	return
	}
	if $mana < 65 then
	{
	var nissa_time %t
	math nissa_time add 120
	return
	}
	send prep nb
	matchre DEBNISSACAST1 ^With tense movements you prepare your body for the
	matchwait 2
DEBNISSACAST1:
	send harness %nissaharness
	pause
	send harness %nissaharness
	pause
	if %nissadone = no then waiteval %nissadone = yes
	send cast creature
	waitforre ^The soothing wave sweeps over the area to encompass
	math nissacount add 1
	goto DEBNISSACAST

TMPARALYSIS:
	if $mana < 30 then waiteval $mana >= 30
	send target para %PARAMANA
	matchre TMPARALYSIS_CAST1 ^You begin to weave mana lines into a target pattern around
	matchre TMPARALYSIS_END1 ^I could not find what you were referring to
	matchwait 2
TMPARALYSIS_CAST1:
	waitforre ^Your formation of a targeting pattern
	send cast
TMPARALYSIS_END1:
	pause 1
	send release all
	return
TMPARALYSIS_CAST2:
	pause
	send harness 6
	waitforre ^The formation of the target pattern around.+has completed
	send cast
	matchre TMPARALYSIS_END2 ^A stream of translucent, golden energy shoots from the palm of your hand towards
	matchre TMPARALYSIS_NEXT ^Your secondary spell pattern dissipates because your target is dead|^Your patterns dissipate because your target is no longer in range
	matchwait 2
TMPARALYSIS_NEXT:
	math paralysis.index add 1
	pause
	goto TMPARALYSIS
TMPARALYSIS_END2:
	pause
	math paralysis.index add 1
	goto TMPARALYSIS
TMPARALYSIS_FAIL:
	send release all
	waitforre ^You aren't harnessing any mana|^You aren't holding any mana|^You aren't preparing a spell|^You have no cyclic spell active to release|^You let your concentration lapse and feel the spell's energies dissipate|^You release the mana you were holding
	return

######################################
###                                ###
###      Dead monster routines     ###
###                                ###
######################################
DEAD_MONSTER:
	if ("%PREPSPELLWEAVE" = "ON") then
	{
		put release
		waitforre ^You aren't|^You have no|^You
		var PREPSPELLWEAVE OFF
	}
	var LOADED NO
	pause 1
	gosub clear
	match clear
	var SEARCHED YES
	var APPRAISED NO
	var LAST DEAD_MONSTER
	if $GH_ANALYZE = ON then var ANALYZELEVEL 1
	if ("%BACKSTAB" = "ON") then
	{

		counter set 1300
		save 1300
	}
	if ("%RETREATING" = "ON") then gosub RETREAT_UNTRIGGERS
	if ("%THROWN" = "ON") then
	{
		if ((("%HAND" = "") && ("$righthand" = "Empty")) || (("%HAND" = "left") && ("$lefthand" = "Empty"))) then gosub GET_THROWN
	}
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** DEAD_MONSTER: ***
		echo
	}
	var LOCAL $GH_KILLS
	math LOCAL add 1
	put #var GH_KILLS %LOCAL
	if matchre ("$roomobjs", "(%ritualcritters) ((which|that) appears dead|\(dead\))") then
	{
	var Monster $1
	if ("$roomplayers" = "" && "$GH_NECRORITUAL" != "OFF") || ("$roomplayers" = "" "$GH_NECROHEAL" = "ON") then goto PERFORM_RITUAL
	}
	NECRO_RETURN:
	if ("%SHIELD" != "NONE") then
	{
		if ("$lefthand" = "Empty") then
		{
			gosub EQUIP_SHIELD
		}
	}
	if matchre ("$roomobjs", "(%skinnablecritters) ((which|that) appears dead|\(dead\))") then goto SKIN_MONSTER_$GH_SKIN
	if matchre ("$roomobjs", "(which|that) appears dead|\(dead\)") then goto SEAR_MONSTER
	goto NO_MONSTER

######################################
###                                ###
###        Skinning routines       ###
###                                ###
######################################
SKIN_MONSTER_ON:
action remove eval $bleeding = 1
	var Monster $1
	if (toupper("$GH_SKIN_RET") = "ON") && ("%RETREATING" = "OFF")) then gosub RETREAT_TRIGGERS
SKIN_MONSTER:
	var LAST SKIN_MONSTER
	pause 1
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SKIN_MONSTER: ***
		echo
	}
	if ("%SHIELD" != "NONE") then
	{
		if ("$lefthand" != "Empty") then
		{
			gosub UNEQUIP_SHIELD
		}
	}
	goto GET_KNIFE
PERFORM_RITUAL:
	var GOING_TO PERFORM_RITUAL_2
	if $mana > 80 && "$GH_NECROHEAL" = "ON" then gosub health_check
PERFORM_RITUAL_2:
	if "$GH_NECRORITUAL" = "OFF" then goto NECRO_RETURN
	if toupper("$GH_NECRORITUAL") = "HARVEST" && ("%SHIELD" != "NONE") then
	{
		if ("$lefthand" != "Empty") then
		{
			gosub UNEQUIP_SHIELD
		}
	}
	if (toupper("$GH_NECRORITUAL") = "ARISE") || (toupper("$GH_NECRORITUAL") = "HARVEST") then
	{
	put perform preserve on %Monster
	pause .5
	pause .5
	}
	put Perform $GH_NECRORITUAL on %Monster
	pause .5
	pause .5
	if "$righthandnoun" = "material" || "$lefthandnoun" = "material" then put drop material
    pause .5
	goto NECRO_RETURN

		GET_KNIFE:
		var LAST GET_KNIFE
		if ("%BELT_WORN" = "OFF") then
		{
			if ("%EMPTY_HANDED" != "ON") then
			{
				if ("%RANGED" = "ON") then gosub RANGE_SHEATHE %CURR_WEAPON
				else gosub SHEATHE %CURR_WEAPON
			}
			if ("$righthand" != "Empty") then gosub SHEATHE $righthandnoun
			if ("$lefthand" != "Empty") then gosub SHEATHE $lefthandnoun
			gosub WIELD_WEAPON knife
		}
		var LAST SKINNING
	ARRANGE_CHECK:
		if (toupper("$GH_ARRANGE") = "ON") then
		{
			var NUM_ARRANGES 0
			goto ARRANGE_KILL
		}
	SKINNING:
		pause 0.0001
		if ("$righthand" != "Empty" && "%RANGED" = "ON") then gosub RANGE_SHEATHE $righthandnoun
		else if ("$righthand" != "Empty") then gosub SHEATHE $righthandnoun
		action put #math GH_SKINS add 1 when into your bundle\.$
		matchre SKINNING ^You approach
		matchre DROPPED_SKINNER ^You'll need to have a bladed instrument
		matchre BUNDLE_OFF ^You must have one hand free to skin.
		matchre SKIN_FAIL ^Some days it just doesn't pay to wake up|^A heartbreaking slip at the last moment renders your chances|manage to slice it to dripping tatters|You bumble the attempt|but only succeed in reducing|but end up destroying|You fumble and make an improper cut|Maybe helping little old Halfling widows across a busy Crossing street|You claw|twists and slips in your grip|^There isn't another|^Living creatures often object|Skin what\?|^Somehow managing to do EVERYTHING|^You hide|cannot be skinned
		matchre SKIN_KNIFE_SHEATH into your bundle\.$
		matchre SKIN_CHECK Roundtime
		send skin
		matchwait 15
		goto SKIN_ERROR
SKIN_CHECK:
	var LAST SKIN_CHECK
	if (matchre("$lefthand","%CURR_WEAPON") && ("%EXP2" = "Offhand_Weapon")) then
	{
	gosub SHEATHE %CURR_WEAPON
	gosub SWAP_LEFT
	}
	if ("$righthand" != "Empty") then gosub SWAP_LEFT
	if ("$lefthand" != "Empty") then goto SCRAPE_$GH_SCRAPE
	if "%WEAPON_EXP" = "Brawling" && "%BELT_WORN" = "ON" && "$righthand" != "Empty" then
	{
	gosub SWAP_LEFT
	goto SCRAPE_$GH_SCRAPE
	}
SKIN_FAIL:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SKIN_FAIL ***
		echo Skinning failed
		echo
	}
	goto SKIN_KNIFE_SHEATH
DROPPED_SKINNER:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Dropped your skinning knife ***
		echo
	}
	pause 1
	put get knife
	goto SKINNING

ARRANGE_KILL:
	var ArrangeFail 0
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ARRANGE_KILL: ***
		echo
	}
ARRANGING:
	math NUM_ARRANGES add 1
	if (%NUM_ARRANGES > $MAX_ARRANGE) then goto SKINNING
	var LAST ARRANGING
ARRANGEONLY:
	matchre SKIN_FAIL corpse is worthless now|Arrange what|^You might want to kill it first|so you can't arrange it either
	matchre ARRANGING Roundtime|has already been arranged as much as you can manage|You complete arranging
	matchre ARRANGEFAIL That creature cannot produce
	if $GH_ARRANGE_ALL = ON && %ArrangeFail = 0 then send arrange all for $GH_SKINPART
	else if $GH_ARRANGE_ALL = ON && %ArrangeFail = 1 then send arrange all
	else if $GH_ARRANGE_ALL = OFF && %ArrangeFail = 0 then send arrange for $GH_SKINPART
	else if $GH_ARRANGE_ALL = OFF && %ArrangeFail = 1 then send arrange
	matchwait 4
	goto %LAST
ARRANGEFAIL:
	var ArrangeFail 1
	goto ARRANGEONLY

SCRAPE_ON:
	if ($Mechanical_Lore.LearningRate >= 30) then goto SCRAPE_OFF
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SCRAPE_ON: ***
		echo
	}
	var LAST SCRAPE_ON
	put loot $GH_SEARCH
	if matchre ("$lefthand", "skin|pelt|hide") then goto SCRAPING
	goto SCRAPE_OFF
	SCRAPING:
		var SKIN $0
		gosub SHEATHE $righthandnoun
		put loot $GH_SEARCH
	GET_SCRAPER:
		var LAST GET_SCRAPER
			matchre SCRAPE_CONT You get|You are already hold
			match SCRAPE_OFF What were you referring to?
		put get my scraper
		matchwait 15
		goto SKIN_ERROR
	SCRAPE_CONT:
		var LAST SCRAPE_CONT
			matchre SCRAPE_CONT cleaning some dirt and debris from it|you snag the scraper
			matchre SCRAPE_DONE Your %SKIN has been completely cleaned|going to help anything|looks as clean as you can make it.
		put scrape %SKIN with scraper quick
		matchwait 15
		goto SKIN_ERROR
	SCRAPE_DONE:
		put stow scraper
		waitfor You put

SCRAPE_OFF:
	goto BUNDLE_$GH_BUN

BUNDLE_ON:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BUNDLE_ON: ***
		echo
	}
	#var LOCAL $GH_SKINS
	#math LOCAL add 1
	#put #var GH_SKINS %LOCAL
	var LAST BUNDLE_ON
		match HAVE_ONE You tap
		match CHECK_ROPE I could not find what you were
	put tap bundle
	matchwait 15
	goto SKIN_ERROR
CHECK_ROPE:
	var LAST CHECK_ROPE
		match GET_ROPE You tap
		match NO_MORE_ROPE I could not find
	##CHECK HERE
	put tap bundling rope
	matchwait 15
	goto SKIN_ERROR
NO_MORE_ROPE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** No more rope for bundling ***
		echo
	}
	put #var GH_BUN OFF
	goto BUNDLE_OFF
GET_ROPE:
	var LAST GET_ROPE
	pause 1
	if ("$righthandnoun" != "Empty") then gosub SHEATHE $righthandnoun
GET_ROPE_CONT:
	##CHECK HERE
	put get my bundling rope
	waitfor You get
	put bundle
	pause 1
	if toupper("$GH_TIE") = "ON" then gosub TIE_BUNDLE
	if toupper("$GH_WEAR") = "ON" then gosub WEAR_BUNDLE
	else
	{
		put drop bundle
		waitfor You drop
	}
	goto SKIN_REEQUIP
TIE_BUNDLE:
matchre TIE_BUNDLE ^Once you've
matchre return ^Using the
put tie my bundle
matchwait
HAVE_ONE:
	if ("$lefthand" = "Empty") then goto SKIN_ERROR
	if (toupper("$GH_WEAR") = "OFF" && matchre("$roomobjs", (lumpy bundle|tight bundle)) then put get bundle
	if (toupper("$GH_WEAR") = "OFF" && !matchre("$roomobjs", (lumpy bundle|tight bundle)) then put remove bundle
	#waitforre You pick|You sling|You remove|But that is
	matchre TOO_HEAVY Time to start a new bundle|You try to stuff your
	matchre HAVE_ONE_CONT You stuff|not going to work|You carefully fit
	if toupper("$GH_WEAR") = "ON" then
	{
		put put my $lefthandnoun in my bundle
	}
	else
	{
		put put my $lefthandnoun in bundle
	}
	matchwait 15
	goto SKIN_ERROR
TOO_HEAVY:
	var LAST TOO_HEAVY
		match CHECK_ROPE You drop
		match GET_ROPE But you aren't holding that.
	put drop bundle
	matchwait 15
	goto SKIN_ERROR
HAVE_ONE_CONT:
	if toupper("$GH_WEAR") = "ON" && ("$righthandnoun" = "bundle" || "$lefthandnoun" = "bundle" then gosub WEAR_BUNDLE
	if toupper("$GH_WEAR") = "OFF" then
	{
		put drop bundle
		waitfor You drop
	}
	if ("%EMPTY_HANDED" = "ON") then goto SKIN_REEQUIP_DONE
	else goto SKIN_REEQUIP
WEAR_BUNDLE:
matchre PULL_BUNDLE ^You can't wear
matchre return ^You put|^You attach|^You sling|^You drape|^You are already wearing
put wear my bundle
matchwait 5
goto SKIN_ERROR

PULL_BUNDLE:
matchre WEAR_BUNDLE_OFF over your shoulder\.$
matchre WEAR_BUNDLE around your waist\.$|on your back\.$|attached to your belt\.$|around your shoulders\.$
put pull my bundle
matchwait 5
goto SKIN_ERROR

WEAR_BUNDLE_OFF:
echo
echo *** CAN'T FIND LOCATION TO WEAR BUNDLE
echo *** WEAR_BUNDLE_OFF ***
echo
put #var GH_WEAR OFF
put drop my bundle
return

BUNDLE_OFF:
	if ("%GAG_ECHO" != "YES") then
	{

		echo
		echo *** BUNDLE_OFF ***
		echo
	}
	#var LOCAL $GH_SKINS
	#math LOCAL add 1
	#put #var GH_SKINS %LOCAL
	if ("$lefthand" != "Empty") then put empty left
	pause 1
SKIN_KNIFE_SHEATH:
	var LAST SKIN_KNIFE_SHEATH
	action remove into your bundle\.$
	if ("$righthandnoun" = "knife") then gosub SHEATHE knife
	goto SKIN_REEQUIP

SKIN_REEQUIP:
	var LAST SKIN_REEQUIP
	if ("%EMPTY_HANDED" != "ON") then
	{
		if ("$righthand" = "Empty") then gosub WIELD_WEAPON %CURR_WEAPON
		if (("%HAND" = "left") && ("$righthand" != "Empty")) then gosub SWAP_LEFT $righthandnoun
	}
	if ("%SHIELD" != "NONE") then
	{
		if ("$lefthand" = "Empty") then
		{
			gosub EQUIP_SHIELD
		}
	}
	if ("%RETREATING" = "ON") then gosub RETREAT_UNTRIGGERS
	goto SKIN_REEQUIP_DONE

######################################
###                                ###
###        Looting routines        ###
###                                ###
######################################
SKIN_MONSTER_OFF:
SEAR_MONSTER:
	var Monster $1
SKIN_REEQUIP_DONE:
	pause 1
	gosub clear
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SEAR_MONSTER: ***
		echo
	}
	var LAST SKIN_REEQUIP_DONE
		matchre TIMER_$GH_TIMER ^I could not find what|not dead
		matchre SEARCH_OTHER_MONSTER ^Sheesh
		matchre LOOT_$GH_LOOT ^You search|^You shove your arm|^Roundtime|picked clean of anything|^You should probably wait until|has already been searched
##CHECK HERE JUST LOOT
	put loot $GH_SEARCH
	matchwait 30
	goto LOOT_ERROR

LOOT_OFF:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Not looting ***
		echo
	}
	goto LOOT_DONE

LOOT_ON:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Looting ***
		echo
	}
	var LAST LOOT_ON
	if ("%SHIELD" != "NONE") then
	{
		if ("$lefthand" != "Empty") then
		{
			gosub UNEQUIP_SHIELD
		}
	}
	goto LOOT_BOX_$GH_LOOT_BOX

LOOT_BOX_ON:
	action (LOOTBOX) on
	if matchre ("$roomobjs", "(%boxtype) (%boxes)") then goto GET_BOX
LOOT_BOX_OFF:
	action (LOOTBOX) off
	goto LOOT_GEM_$GH_LOOT_GEM

LOOT_GEM_ON:
	goto STOW_GEM
LOOT_GEM_OFF:
	goto LOOT_COLLECTIBLE_$GH_LOOT_COLL

LOOT_COLLECTIBLE_ON:
	if matchre ("$roomobjs", "\b(%collectibles)\b") then goto GET_COLLECTIBLE
LOOT_COLLECTIBLE_OFF:
	goto LOOT_COIN_$GH_LOOT_COIN

LOOT_COIN_ON:
	if matchre ("$roomobjs", "(coin|coins)") then goto GET_COIN
LOOT_COIN_OFF:
	goto LOOT_JUNK_$GH_LOOT_JUNK

LOOT_JUNK_ON:
	if matchre ("$roomobjs", "(%junkloot)") then goto GET_JUNK
LOOT_JUNK_OFF:
	goto NO_LOOT

GET_BOX:
	var BOX $0
	var LOOTED YES
STOW_BOX:
	var LAST STOW_BOX
		matchre NO_MORE_ROOM_BOX any more room in|^Stow what|^You just can't get|^But that's closed
		matchre LOOT_BOX_ON ^You put your
	put stow box
	matchwait 30
	goto LOOT_ERROR

NO_MORE_ROOM_BOX:
	action (LOOTBOX) off
	if matchre ("$righthandnoun", "(%boxes)") then put empty right
	else put empty left
	waitforre ^You drop|^What were you|is already empty
	put #var GH_LOOT_BOX OFF
	put #Beep
	goto LOOT_GEM_$GH_LOOT_GEM

STOW_GEM:
	var LAST STOW_GEM
		matchre END_GEM ^Stow what
		matchre NO_MORE_ROOM_GEM any more room in|^You just can't get|^But that's closed|^You think the|^You've already got a wealth of gems in there
		matchre LOOT_GEM_ON ^You put your|^You open your
	send stow gem
	matchwait 30
	goto LOOT_ERROR

NO_MORE_ROOM_GEM:
	if contains("$lefthand","%CURR_WEAPON") then
	{
		send drop my $righthandnoun
		waitforre ^You drop|^What were you
	}
	if contains("$righthand","%CURR_WEAPON") then
	{
		send drop my $lefthandnoun
		waitforre ^You drop|^What were you
	}
	if toupper("$GH_POUCH") = "OFF" then
	{
		put #var GH_LOOT_GEM OFF
		goto END_GEM
	}
	matchre SWAP_POUCH ^The.*gem pouch has been tied off\.
	matchre TIE_POUCH ^The.*gem pouch is made for easy storage of gems
	send look my pouch
	matchwait 15
	goto LOOT_ERROR
END_GEM:
	goto LOOT_COLLECTIBLE_$GH_LOOT_COLL

SWAP_POUCH:
put remove my %GEM_CONTAINER
wait
put put my %GEM_CONTAINER in my %POUCH_CONTAINER
wait
matchre NO_POUCH ^What were
matchre WEAR_POUCH ^You get
put get my %GEM_CONTAINER from my %DEFAULT_CONTAINER
matchwait

TIE_POUCH:
	send tie pouch
	waitforre ^You tie up
	goto STOW_GEM

WEAR_POUCH:
if "$lefthandnoun" = "pouch" then send wear left
else send wear right
goto LOOT_ON

NO_POUCH:
echo No more pouches
put #var GH_POUCH OFF
put #var GH_LOOT_GEM OFF
goto LOOT_COIN_$GH_LOOT_COIN

GET_COLLECTIBLE:
	var ITEM $0
	var LOOTED YES
STOW_COLLECTIBLE:
	var LAST STOW_COLLECTIBLE
		matchre NO_MORE_ROOM_COLLECTIBLE any more room in|^Stow what|^You just can't get|^But that's closed|^You stop as you realize
		matchre LOOT_COLLECTIBLE_ON ^You put your
	put stow %ITEM
	matchwait 30
	goto LOOT_ERROR

NO_MORE_ROOM_COLLECTIBLE:
	if matchre ("$righthandnoun", "(%collectibles)") then put empty right
	else put empty left
	waitforre ^You drop|^What were you|is already empty
	put #var GH_LOOT_COLL OFF
	goto LOOT_COIN_$GH_LOOT_COIN

GET_COIN:
	var LAST GET_COIN
	put get coin
	waitforre ^You pick up|^What were you
	goto LOOT_COIN_ON

GET_JUNK:
	var JUNK $0
	var LOOTED YES
STOW_JUNK:
	var LAST STOW_JUNK
		matchre  NO_MORE_ROOM_JUNK any more room in|^Stow what|^You just can't get|^But that's closed
		matchre LOOT_JUNK_ON ^You put your
	put stow %JUNK in %JUNK_CONTAINER
	matchwait 30
	goto LOOT_ERROR

NO_MORE_ROOM_JUNK:
	put drop %JUNK
	waitforre ^You drop|^What were you
	put #var GH_LOOT_JUNK OFF
	goto NO_LOOT

TOO_DARK:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** It's too dark to see anything ***
		echo
	}
	goto TIMER_$GH_TIMER

NO_MONSTER:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo ***        No recognizable monsters.         ***
		echo ***      If you think this is an error,      ***
		echo *** post the creature you just killed please ***
		echo ***          Or AIM IRXSwmr about it         ***
		echo
	}
##CHECK HERE just loot
	put loot $GH_SEARCH
	goto TIMER_$GH_TIMER

NO_LOOT:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** No Loot ***
		echo
	}
	if ("%LOOTED" = "YES") then
	{
		var LOCAL $GH_LOOTS
		math LOCAL add 1
		put #var GH_LOOTS %LOCAL
		var LOOTED NO
	}
LOOT_DONE:
##CHECK HERE DELETE LINE BELOW
action goto BLEEDING when eval $bleeding = 1
	var LAST LOOT_DONE
	if ("%RANGED" = "ON") then
		if matchre("$roomobjs", "%AMMO") then gosub RANGED_CLEAN
	if ("%THROWN" = "ON") then
		if matchre("$roomobjs", "%CURR_WEAPON") then gosub THROWN_CLEAN
	if ("%SHIELD" != "NONE") then
	{
		if ("$lefthand" = "Empty") then
		{
			gosub EQUIP_SHIELD
		}
	}
	if ((toupper("$GH_RETREAT") = "ON") && ("%RETREATING" = "OFF")) then gosub RETREAT_TRIGGERS
	goto TIMER_$GH_TIMER

######################################
###                                ###
###   Experience check routines    ###
###                                ###
######################################
TIMER_ON:
	if (%t > (%MAX_TRAIN_TIME)) then goto SWITCH_WEAPON
	if ("%LAST" = "CHECK_FOR_MONSTER") then return
TIMER_OFF:
	goto EXPCHECK_$GH_EXP


EXPCHECK_ON:
##CHECK HERE

	if ((("%EXP2" = "Targeted_Magic") || ("%EXP2" = "Backstab") || ("%EXP2" = "Debilitation")) || (("%WEAPON_EXP" = "Light_Thrown") || ("%WEAPON_EXP" = "Heavy_Thrown"))) then var ROUNDS 15
	else var ROUNDS 3
	if ("%EXP2" != "NONE") then put #statusbar 3 Training %EXP2 at $%EXP2.LearningRate and %WEAPON_EXP at $%WEAPON_EXP.LearningRate
	else put #statusbar 3 Training %WEAPON_EXP at $%WEAPON_EXP.LearningRate
	put #statusbar 2 Current Rounds: %current_rounds / Rounds: %ROUNDS

	if ("%ALTEXP" = "ON") then gosub ALTEXPCHECK
	else
	{
		if %current_rounds < %ROUNDS then math current_rounds add 1
		else
		{
			evalmath difference $%WEAPON_EXP.LearningRate - %CURR_RATE
			if %difference < 2 then goto SWITCH_WEAPON
			else
			{
				var current_rounds 0
				var CURR_RATE $%WEAPON_EXP.LearningRate
			}
		}
		if ($%WEAPON_EXP.LearningRate >= 30) then goto SWITCH_WEAPON
	}


EXPCHECK_OFF:

	var LAST EXPCHECK_OFF
	if (toupper("$GH_STANCE") = "ON")) then gosub SWITCH_STANCE
	if (("%MAGIC_TYPE" != "OFF") && ("%MAGIC" != "ON")) then
		{
		counter set %MAGIC_COUNT
		save %c
		}
	put #statusbar 9 GH - Kills:$GH_KILLS  Skins:$GH_SKINS  Loots:$GH_LOOTS
	if ("%SEARCHED" = "YES") then
		{
		if ("%MAGIC" = "ON") then
			{
			counter set %MAGIC_COUNT
			save %c
			goto %c
			}
		goto FACE
		}
	else goto %c

ALTEXPCHECK:
	if (("%BACKSTAB" = "ON") && ($Backstab.LearningRate >= 30)) then var BACKSTAB OFF
	{
		if ("%EXP2" = "Stealth" || "%EXP2" = "Backstab") then
		{
			if ($%WEAPON_EXP.LearningRate >= 30) then goto SWITCH_WEAPON
			if %current_rounds < %ROUNDS then math current_rounds add 1
			else
			{
				if ("%EXP2" = "Backstab") then
				{
					evalmath BackstabDifference $%EXP2.LearningRate - %CURRBACKSTABEXP
					if ((%BackstabDifference < 3) || ($Backstab.LearningRate >= 30)) then
					{
						var BACKSTAB OFF
						var ALTEXP OFF
						var current_rounds 0
						if "$EQUIPPED" != "ON" then
						{
							var CURR_RATE $%WEAPON_EXP.LearningRate
							return
						}
					}
					else var CURRBACKSTABEXP $%EXP2.LearningRate
				}

				if ("$GH_AMBUSH" = "ON" && "%EXP2" = "Stealth") then
				{
					evalmath StealthDifference $%EXP2.LearningRate - %CURRSTEALTHEXP
					if %StealthDifference < 3 then
					{
						put #var GH_AMBUSH OFF
						var ALTEXP OFF
						var current_rounds 0
						if "$EQUIPPED" != "ON" then
						{
							var CURR_RATE $%WEAPON_EXP.LearningRate
							return
						}
					}
					else var CURRSTEALTHEXP $%EXP2.LearningRate

				}

				if ("%ALTEXP" = "ON" && ("%EXP2" != "Stealth" || "%EXP2" != "Backstab")) then evalmath difference $%EXP2.LearningRate - %CURR_RATE
				else evalmath difference $%WEAPON_EXP.LearningRate - %CURR_RATE
				if %difference < 3 then goto SWITCH_WEAPON
				else
				{
					var current_rounds 0
					if ("%ALTEXP" = "ON" && ("%EXP2" != "Stealth" || "%EXP2" != "Backstab")) then var CURR_RATE $%EXP2.LearningRate
					else var CURR_RATE $%WEAPON_EXP.LearningRate
				}
			}
		}
		else
		{
			if %current_rounds < %ROUNDS then math current_rounds add 1
			else
			{

				if ("%ALTEXP" = "ON") && ("%EXP2" != "Stealth") then evalmath difference $%EXP2.LearningRate - %CURR_RATE
				else evalmath difference $%WEAPON_EXP.LearningRate - %CURR_RATE
				if %difference < 3 then goto SWITCH_WEAPON
				else
				{
					var current_rounds 0
					if ("%ALTEXP" = "ON" && "%EXP2" != "Stealth") then var CURR_RATE $%EXP2.LearningRate
					else var CURR_RATE $%WEAPON_EXP.LearningRate
				}
			}
			if ((($%WEAPON_EXP.LearningRate >= 30) && ("%EXP2" != "Targeted_Magic") && ("%EXP2" != "Stealth"))) then goto SWITCH_WEAPON
			if (("%MAGIC" = "OFF") && (("%EXP2" = "Primary_Magic") || ("%EXP2" = "Targeted_Magic") || ("%EXP2" = "Debilitation")) && ($%EXP2.LearningRate >= 30)) then goto SWITCH_WEAPON
		}
	}
	return


MIND_MURKED:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** Mind murked up, going to rest mode***
		echo
	}
	pause 1
	send sleep
	var REST ON
	goto EXPCHECK_OFF

SWITCH_STANCE:
##CHECK HERE
##if ($%CURR_STANCE.LearningRate < 30) then return
	if ($%CURR_STANCE.LearningRate < 30) then return
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo ***     SWITCH_STANCE:    ***
		echo *** Current stance locked ***
		echo
	}
	if ("%CURR_STANCE" = "Evasion") then
	{
		if ("%NOSHIELD" = "OFF") then
		{
			send stance shield
			waitfor You are now set to use
			var CURR_STANCE Shield_Usage
		} else
		{
			send stance parry
			waitfor You are now set to use
			var CURR_STANCE Parry_Ability
		}
	} elseif ("%CURR_STANCE" = "Shield_Usage") then
	{
		if ("%NOPARRY" = "OFF") then
		{
			put stance parry
			waitfor You are now set to use
			var CURR_STANCE Parry_Ability
		} else
		{
			put stance evasion
			waitfor You are now set to use
			var CURR_STANCE Evasion
		}
	} elseif ("%CURR_STANCE" = "Parry_Ability") then
	{
		if ("%NOEVADE" = "OFF") then
		{
			put stance evasion
			waitfor You are now set to use
			var CURR_STANCE Evasion
		} else
		{
			send stance shield
			waitfor You are now set to use
			var CURR_STANCE Shield_Usage
		}
	}
	return

SWITCH_WEAPON:

	if ("%EXP2" != "NONE") then put #echo >Log Green Combat - Stopped Training: %EXP2 at $%EXP2.LearningRate/34 and %WEAPON_EXP at $%WEAPON_EXP.LearningRate/34
	else put #echo >Log Green Combat - Stopped Training: %WEAPON_EXP at $%WEAPON_EXP.LearningRate/34

	if ("%PREPSPELLWEAVE" = "ON") then
	{
		put release
		waitforre ^You aren't harnessing any mana\.
	}
	action (summon) off
	var LAST SWITCH_WEAPON
	if ("%GAG_ECHO" != "YES") then
	{
			echo
			echo *** SWITCH_WEAPON
			echo *** Weapon skill locked ***
			echo
	}
	if "$BW" != "OFF" && "$GH_BUFF" = "ON" then
	{
	put #send 1 release bond
	waitforre ^You sense|^You are not|^Release what|^You are ending the bond with your
	}
	#put stance evasion
	#pause .5
	put #playsystem Open
	if ("%EMPTY_HANDED" != "ON") then
	{
			if ("%RANGED" = "ON") then
			{
				action remove You think you have your best shot possible
				action remove stop concentrating on aiming
				gosub RANGE_SHEATHE
				if (matchre("$roomobjs", "%AMMO\b")) then gosub RANGED_CLEAN
				if ("%REM_SHIELD" != "NONE") then
				{
					pause 1
					put get %REM_SHIELD
					waitfor You get a
					put wear %REM_SHIELD
					waitfor You slide
				}
			} else
			{
				gosub SHEATHE %CURR_WEAPON
			}
	}
	if ("%SHIELD" != "NONE") then
	{
			gosub UNEQUIP_SHIELD
	}
	if (toupper("$GH_MULTI") != "OFF") then
	{
			if ($GH_MULTI_CURR_NUM < $GH_MULTI_NUM) then
			{
				var TEMP $GH_MULTI_CURR_NUM
				math TEMP add 1
				put #var GH_MULTI_CURR_NUM %TEMP
			}
			else
			{
				if ("$DONTMULTIHUNT" = "ON" then goto DONE
				else put #var GH_MULTI_CURR_NUM 1
			}
			if (toupper("$GH_MULTI") = "MULTI") then put .hunt MULTIWEAPON $GH_MULTI_$GH_MULTI_CURR_NUM
			else put .hunt MULTIWEAPON $GH_MULTI_WEAPON_$GH_MULTI_CURR_NUM
	} else goto DONE

SNEAKING:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** SNEAKING: ***
		echo You are misplaced
		echo Attempintg to return to your room
		echo
	}
	send stop stalk
	waitforre ^You stop|^You're not stalking
	send #goto %starter.room
	waiteval $roomid = %starter.room
	put #echo >Log Red Returned to starting room.
	goto %c


BLEEDING:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BLEEDING: ***
		echo You are bleeding
		echo Retreating to check health
		echo
	}
	action remove eval $bleeding = 1
	action var INFECTED YES when ^You.+(infect|disease)
	pause 0.2
	var GOING_TO %c
	var INFECTED NO
	put health
	goto ABORT

STUNNED:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** STUNNED: ***
		echo You have been stunned.
		echo Retreating to check health.
		echo
	}
	action remove eval $stunned = 1
	var GOING_TO %c
HEALTH_CHECK:
	gosub clear
		matchre HEALTH_CHECK pole|still stunned
		matchre CHECKING_HEALTH ^You retreat from combat|^You try to back away|already as far away as you can get
	put retreat
	matchwait 10
CHECKING_HEALTH:
	if ("%INFECTED" = "YES") then goto INFECTED
	if ($health >= 70) then
	{
		echo
		echo Not too beat up, returning to combat
		echo Be careful!
		echo
		action goto BLEEDING when eval $bleeding = 1
		action goto STUNNED when eval $stunned = 1
		action remove ^You.+(infect|disease)
		goto %GOING_TO
	} else
	{
		echo
		echo Too beat up, aborting
		echo
		goto ABORT
	}

INFECTED:
	echo
	echo Your wounds are infected, seek medical attention!!!
	echo
	put #beep
	goto DEAD

DROPPED_WEAPON:
	pause
	put get %CURR_WEAPON
	counter set 0
	goto BEGIN

ABORT:
	gosub RETREAT_TRIGGERS
ABORTING:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** ABORT: ***
		echo
	}
	echo Injured badly, you need medical assistance
	if ($health <= 30) then goto DEAD
	put #beep
	pause 0.1
	put #parse HEALING NECESSARY
	pause 5
	goto %GOING_TO

DEAD:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** DEAD: ***
		echo
		echo You are dead, or about to be
	}
	if ("%DYING" = "ON") then
	{
		put look sword
		pause 0.5
		put look sword
	}
	put #beep
##CHECK HERE
#	put quit
	exit

NO_VALUE:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** NO_VALUE: ***
		echo
	}
	echo Basic use of script .hunta <weapon>
	goto DONE

DONE:
	if ("%REST" = "ON") then send awaken
	echo
	echo ***  DONE:  ***
	echo
	pause 1
	put glance
	put #parse HUNT DONE
	#put #play Done
	put look
	exit

##############################
##                          ##
##      Error handling      ##
##                          ##
##############################
APPR_ERROR:
	gosub clear
	echo
	echo ***                APPR_ERROR                     ***
	echo *** Something happened while appraising a critter ***
	echo
	goto ERROR_DONE

ATTACK_ERROR:
	gosub clear
	echo
	echo ***             ATTACK_ERROR               ***
	echo *** Something bad happened while attacking ***
	echo
	goto ERROR_DONE

CLEANING_ERROR:
	gosub clear
	echo
	echo ***           CLEANING_ERROR              ***
	echo *** Something bad happened while cleaning ***
	echo
	goto ERROR_DONE

DEFAULT_ERROR:
	gosub clear
	echo
	echo ***                        DEFAULT_ERROR:                          ***
	echo ***         Cannot use keyword DEFAULT with keyword multi          ***
	echo *** To use Default settings with multi-weapons, use keyword dmulti ***
	echo
	goto ERROR_DONE

LOOT_ERROR:
	gosub clear
	echo
	echo ***       LOOT_ERROR            ***
	echo *** Error occured while looting ***
	echo
	goto ERROR_DONE

MAGIC_ERROR:
	gosub clear
	echo
	echo ***         MAGIC_ERROR             ***
	echo *** Error occured while using magic ***
	echo
	goto ERROR_DONE

RANGED_ERROR:
	gosub clear
	echo
	echo ***         RANGED_ERROR             ***
	echo *** Error occured while using ranged ***
	echo
	goto ERROR_DONE

SKIN_ERROR:
	gosub clear
	echo
	echo ***          SKIN_ERROR          ***
	echo *** Error occured while skinning ***
	echo
	goto ERROR_DONE

STEALTH_ERROR:
	gosub clear
	echo
	echo ***           STEALTH_ERROR            ***
	echo *** Error occured while being stealthy ***
	echo
	goto ERROR_DONE

SWAP_ERROR:
	gosub clear
	echo
	echo ***              SWAP_ERROR:                    ***
	echo *** Something bad happened while trying to swap ***
	echo
	goto ERROR_DONE

THROWN_ERROR:
	gosub clear
	echo
	echo ***        THROWN_ERROR          ***
	echo *** Error occured while throwing ***
	echo
	goto ERROR_DONE

VARIABLE_ERROR:
	gosub clear
	echo
	echo ***                VARIABLE_ERROR:                 ***
	echo *** An error has occured with one of the variables ***
	echo
	goto ERROR_DONE

WEAPON_APPR_ERROR:
	gosub clear
	echo
	echo ***                   WEAPON_APPR_ERROR:                          ***
	echo *** Something happened while trying to discern the type of weapon ***
	echo
	goto ERROR_DONE

ERROR:
	gosub clear
	echo
	echo *** Some general ERROR occured ***
	echo
	goto DONE

ERROR_DONE:
	pause 1
	echo
	put #parse *** DONE, BUT WITH ERRORS ***
	echo
	put #beep
	put #play Error
	put stow right
	pause 1
	put stow left
	pause 1
	put #playsystem Open
	put glance
	put #parse HUNT DONE ERROR
	put look
	exit

##############################
##                          ##
##    End Error handling    ##
##                          ##
##############################

#################################
##                             ##
##  General Utility functions  ##
##                             ##
#################################
PAUSE:
	pause
	goto %LAST

RETURN:
	return

#################################
##                             ##
##  Includes and Additions     ##
##                             ##
#################################

DISARM_ORB:
put #send disarm orb
waitforre ^Roundtime
pause .5
return

GH_ARMOR_ON:
	if ($Brigandine.LearningRate >= 30 && $Chain_Armor.LearningRate < 30 && "$CURRENT.ARMOR" != "CHAIN") then
	{
		send remove scale balaclava
		waitforre ^You take|^You put|^Remove what
		send stow scale balaclava
		waitforre ^You put|^Stow what
		send get my chain balaclava
		waitforre ^You get|^But that is already in your inventory
		send wear my chain bala
		waitforre ^You put|^You are already wearing that\.?
		put #var CURRENT.ARMOR CHAIN
	}
	else
	{
		if ($Chain_Armor.LearningRate >= 30 && $Brigandine.LearningRate < 30 && "$CURRENT.ARMOR" != "BRIG") then
		{
			send remove chain balaclava
			waitforre ^You take|^You put|^Remove what
			send stow chain balaclava
			waitforre ^You put|^Stow what
			send get my scale balaclava
			waitforre ^You get|^But that is already in your inventory
			send wear my scale bala
			waitforre ^You put|^You are already wearing that\.?
			put #var CURRENT.ARMOR BRIG
		}
	}
return

GH_BUFF_ON:
action (hunt) off
	if toupper("$GH_BUFF_DANGER") = "ON" then action put #send retreat when melee range on you\!|pole weapon range on you\!
	gosub gh_buff.start
	if toupper("$GH_BUFF_DANGER") = "ON" then action remove melee range on you\!|pole weapon range on you\!
	action (hunt) on
return


####################
##                ##
##  Buff Section  ##
##                ##
####################


buff.start:
	counter set 0
	action #send 5 $lastcommand when ^You are still stunned
	action instant var buff.trace YES when ^You sense the holy power return to normal
	action var FullPrep 1 when You feel fully prepared to cast your spell.
	#error checking
	eval buff.total count("%buff.spell", "|")
	eval buff.total.prep count("%buff.prep", "|")
	if %buff.total != %buff.total.prep then goto variable.error
	eval buff.harness.increment.total count("%buff.harness.increment", "|")
	var FullPrep 0
	var buff.righthand $righthandnoun
	var buff.lefthand $lefthandnoun
	var non.RUE.weapons Bow|Crossbow|Heavy_Thrown|Light_Thrown|Slings
	var thrown.weapons Heavy_Thrown|Light_Thrown
	var buff.special.casts Benediction|Cage of Light|Rutilor's Edge|Bond Armaments|Osrel Meraud|Ignite

GH.BUFF.ROTATION:
	if %c > %buff.total then return
	if ("$guild" = "Trader" then
	{
		if ((toupper("%buff.spell(%c)") = "LGV" && (!$SpellTimer.LastGiftofVithwokIV.active)) then gosub buff.magic
		if ((toupper("%buff.spell(%c)") = "FIN" && (!$SpellTimer.Finesse.active)) then gosub buff.magic
		if ((toupper("%buff.spell(%c)") = "BLUR" && (!$SpellTimer.Blur.active)) then gosub buff.magic
		if ((toupper("%buff.spell(%c)") = "NOU" && (!$SpellTimer.Noumena.active)) then gosub buff.magic
		if ((toupper("%buff.spell(%c)") = "TURI" && (!$SpellTimer.TurmarIllumination.active)) then gosub buff.magic
		if ((toupper("%buff.spell(%c)") = "NON" && (!$SpellTimer.Nonchalance.active)) then gosub buff.magic
		if ((toupper("%buff.spell(%c)") = "MEG" && (!$SpellTimer.MembrachsGreed.active)) then gosub buff.magic
	}

	if ((toupper("%buff.spell(%c)") = "MAF" && (!$SpellTimer.ManifestForce.active)) then gosub buff.magic
	counter add 1
	goto GH.BUFF.ROTATION


buff.magic:
	if matchre("%WEAPON_EXP", "%non.RUE.weapons") then put #var RUE $righthand
	if "$RUE" != "$righthand" then put #var RUE OFF
	if toupper("%buff.ba.thrown") = "YES" then
		{
		if !matchre("%WEAPON_EXP", "%thrown.weapons") then put #var BA $righthand
		}
	if "$BA" != "$righthand" then put #var BA OFF
	if "%buff.spell(%c)" = "RUE" && "$righthand" = "Empty" then put #var RUE $righthand
	if "%buff.spell(%c)" = "BA" && "$righthand" = "Empty" then put #var BA $righthand
	# if "%buff.spell(%c)" != "OM" && toupper("$%buff.spell(%c)") != "OFF" then
	# {
		# counter add 1
		# if %c > %buff.total then return
		# goto buff.magic
	# }
	if "%buff.spell(%c)" = "OM" then
	{
		if $gametime !> $OM then
		{
			counter add 1
			goto buff.magic
		}
	}
	if toupper("%buff.spell(%c)") = "COL" && ($Time.isKatambaUp = 0 && $Time.isYavashUp = 0 && $Time.isXibarUp = 0) then
	{
		put #var COL ON
		return
	}
	if "$%buff.spell(%c)" = "" then return
	if $mana.level <= %buff.manalevel && "%buff.trace" = "YES" then gosub buff.trace
	gosub buff.release
	if "$GH_BUFF_DANGER" = "ON" then
	{
		put #send ret
		put #send ret
		pause .5
	}
	gosub buff.prepare
	if toupper("%buff.cambrinth") != "NO" && %buff.charge.total(%c) > 0 then
		{
		if toupper("%buff.worn") = "NO" then
			{
			if "%buff.righthand" != "" || "%buff.lefthand" != "" then gosub buff.empty.hands
			gosub buff.get "%buff.cambrinth"
			}
		if toupper("%buff.worn") = "YES" then
			{
			if toupper("%buff.remove") = "NO" then
				{
				if "%buff.righthand" != "" && "%buff.lefthand" != "" then
					{
					if "%buff.spell(%c)" = "RUE" || "%buff.spell(%c)" = "BA" then gosub buff.empty.hands left
					else
					gosub buff.empty.hands right
					}
				}
			if toupper("%buff.remove") = "YES" then
				{
				if "%buff.righthand" != "" || "%buff.lefthand" != "" then gosub buff.empty.hands
				gosub buff.remove "%buff.cambrinth"
				}
			}
		gosub buff.charge "%buff.cambrinth"
		pause 0.5
		gosub buff.invoke "%buff.cambrinth"
		}
		if toupper("%buff.cambrinth") != "NO" && %buff.charge.total(%c) > 0 then
			{
			if toupper("%buff.worn") = "NO" then
				{
				gosub buff.stow
				if "$righthandnoun" = "" || "$lefthandnoun" = "" then gosub buff.reequip
				}
			if toupper("%buff.worn") = "YES" then
				{
				if toupper("%buff.remove") = "NO" then
					{
					if "$righthand" = "Empty" && "%buff.righthand" != "" then gosub buff.reequip right
					if "$lefthand" = "Empty" && "%buff.lefthand" != "" then gosub buff.reequip left
					}
				if toupper("%buff.remove") = "YES" then
					{
					gosub buff.wear "%buff.cambrinth"
					if "%buff.righthand" = "" || "%buff.lefthand" = "" then gosub buff.reequip
					}
				}
			}

		pause .2

		if (toupper("%buff.secondcambrinth") != "NO" && %buff.charge.total2(%c) > 0) then
			{
			if toupper("%buff.worn") = "NO" then
				{
				if "%buff.righthand" != "" || "%buff.lefthand" != "" then gosub buff.empty.hands
				gosub buff.get "%buff.secondcambrinth"
				}
			if toupper("%buff.worn") = "YES" then
				{
				if toupper("%buff.remove") = "NO" then
					{
					if "%buff.righthand" != "" && "%buff.lefthand" != "" then
						{
						if "%buff.spell(%c)" = "RUE" || "%buff.spell(%c)" = "BA" then gosub buff.empty.hands left
						else
						gosub buff.empty.hands right
						}
					}
				if toupper("%buff.remove") = "YES" then
					{
					if "%buff.righthand" != "" || "%buff.lefthand" != "" then gosub buff.empty.hands
					gosub buff.remove %buff.secondcambrinth
					}
				}
				gosub buff.charge.2
				gosub buff.invoke.2
			}


	if toupper("%buff.harness") = "YES" && %buff.harness.total(%c) > 0 then gosub buff.harness
	gosub buff.cast
	if toupper("%buff.continue") = "YES" then return
	return

buff.trace:
	matchre buff.trace ^\.\.\.wait|^Sorry, you may
	matchre buff.trace.success ^You begin to trace the|^You trace a
	matchre buff.no.trace ^An empty feeling pervades your soul
	send glyph mana
	matchwait
	buff.no.trace:
	action remove ^You sense the holy power return to normal
	buff.trace.success:
	put #var buff.trace NO
	return

buff.prepare:
	if $humming = 1 then
		{
		send stop play
		pause .5
		}
	matchre buff.prepare ^\.\.\.wait|^Sorry, you may
	matchre buff.return %buff.prep.message
	send prep %buff.spell(%c) %buff.prep(%c)
	matchwait

buff.empty.hands:
	#if "%buff.righthand" != "Empty" && "$1" != "left" then
	if "%buff.righthand" != "" && "$1" != "left" then
		{
		if "$BA" = "$righthandnoun" then
			{
			put #send release bond
			waitforre ^You sense|^You are not|^Release what
			}
		if ("$righthandnoun" = "fan") && ("%FAN_STATUS" = "OPENED") then
			{
			var LAST_FAN_STATUS OPENED
			send close my $righthand
			var FAN_STATUS CLOSED
			pause .5
			}
		send sheath my %buff.righthand
		pause .5
		send wear my %buff.righthand
		pause .5
		send stow my %buff.righthand
		pause
		}
	if "$1" = "right" then return
	#if "%buff.lefthand" != "Empty" then
	if "%buff.lefthand" != "" then
		{
		send sheath my %buff.lefthand
		pause .5
		send wear my %buff.lefthand
		pause .5
		send stow my %buff.lefthand
		pause
		}
	return

buff.get:
	matchre buff.get ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^You get a
	send get my $1
	matchwait

buff.remove:
	matchre buff.remove ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^You remove|^You slide
	send remove my $1
	matchwait

buff.charge:
	var buff.charge.current 0

buff.charge.1:
	if %buff.charge.total(%c) > %buff.charge.current then
		{
		evalmath charge.difference %buff.charge.total(%c) - %buff.charge.current
		if %buff.charge.increment <= %charge.difference then put charge my %buff.cambrinth %buff.charge.increment
		else put charge my %buff.cambrinth %charge.difference
		waitforre (^The .+\.$|^\.\.\.wait|^Sorry, you|You strain)
		var buff.cambrinth.result $0
		if matchre ("%buff.cambrinth.result", "absorbs") then
			{
			math buff.charge.current add %buff.charge.increment
			goto buff.charge.1
			}
		if matchre ("%buff.cambrinth.result", "resists|is already") then
			{
			var buff.charge.current %buff.charge.total(%c)
			goto buff.charge.1
			}
		if matchre ("%buff.cambrinth.result", "...wait|Sorry, you") then goto buff.charge.1
		if matchre ("%buff.cambrinth.result", "You strain") then
			{
			if $mana < 15 then waiteval $mana >= 20
			goto buff.charge.1
			}
		}
	return

buff.charge.2:
	var buff.charge.current 0

buff.charge.2A:
	if %buff.charge.total2(%c) > %buff.charge.current then
		{
		evalmath charge.difference %buff.charge.total2(%c) - %buff.charge.current
		if %buff.charge.increment <= %charge.difference then put charge my %buff.secondcambrinth %buff.charge.increment
		else put charge my %buff.secondcambrinth %charge.difference
		waitforre (^The .+\.$|^\.\.\.wait|^Sorry, you|You strain)
		var buff.cambrinth.result $0
		if matchre ("%buff.cambrinth.result", "absorbs") then
			{
			math buff.charge.current add %buff.charge.increment
			goto buff.charge.2A
			}
		if matchre ("%buff.cambrinth.result", "resists|is already") then
			{
			var buff.charge.current %buff.charge.total2(%c)
			goto buff.charge.2A
			}
		if matchre ("%buff.cambrinth.result", "...wait|Sorry, you") then goto buff.charge.2
		if matchre ("%buff.cambrinth.result", "You strain") then
			{
			if $mana < 15 then waiteval $mana >= 20
			goto buff.charge.2A
			}
		}
	return

buff.invoke:
	matchre buff.invoke ^\.\.\.wait|^Sorry, you may|^You are still stunned\.
	matchre buff.return ^The .+ pulses with \w+ energy\.\s*You reach for its center and forge a magical link to it|^Your link to the .+ is intact
	send invoke my %buff.cambrinth %buff.charge.total(%c)
	matchwait

buff.invoke.2:
	if %buff.charge.total2(%c) = 0 then goto buff.return
	matchre buff.invoke.2 ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^The .+ pulses with \w+ energy\.\s*You reach for its center and forge a magical link to it|^Your link to the .+ is intact
	send invoke my %buff.secondcambrinth %buff.charge.total2(%c)
	matchwait

buff.harness:
	var buff.harness.current 0
	buff.harness.1:
	if %buff.harness.total(%c) > %buff.harness.current then
		{
		evalmath harness.difference %buff.harness.total(%c) - %buff.harness.current
		if %buff.harness.increment <= %harness.difference then put harness %buff.harness.increment
		else put harness %harness.difference
		waitforre (^The .+\.$|^\.\.\.wait|^Sorry, you|Strain though|You tap into)
		var buff.harness.result $0
		if matchre ("%buff.harness.result", "You tap into") then
			{
			math buff.harness.current add %buff.harness.increment
			goto buff.harness.1
			}

		if matchre ("%buff.harness.result", "...wait|Sorry, you") then goto buff.harness.1
		if matchre ("%buff.harness.result", "Strain though") then
			{
			if $mana < 15 then waiteval $mana >= 20
			goto buff.harness.1
			}
		}
	return

buff.cast:
	if %FullPrep != 1 then waiteval %FullPrep = 1
	if "$preparedspell" = "Quicken the Earth" then
		{
		gosub buff.cut
		gosub buff.forage dirt
		pause .5
		}

buff.cast.2:
	var FullPrep 0
	if $mana < 10 then waiteval $mana >= 15
	matchre buff.cast.2 ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^The shadows subtly deepen about you as your movements grow still|^Your words fill you with an unflagging sense of resolve and purpose|^You contribute your harnessed streams|^A soft silver glow|^Disregarding the pain, you grind the dirt brutally|^The .+ (is|are) dim, almost magically null|^You can't cast Rutilor's Edge on yourself|^You can't enhance the|^You clasp your hands|^You don't have|^You gesture|^You let your concentration|^You make a holy gesture|^You reach with both|^Your .+ emits a loud \*snap\* as it discharges all its power to aid your spell|soft silver glow that is absorbed into it\.$|Your spell backfires| You suddenly feel more confident about your skinning abilities|Your senses sharpen considerably|You close yours eyes and focus|You close your eyes and focus|You place your hands on your temples
	if "$preparedspell" = "Benediction" then put cast %buff.immortal
	if "$preparedspell" = "Cage of Light" then
		{
		if $Time.isKatambaUp = 1 then put cast Katamba
		if $Time.isYavashUp = 1 then put cast Yavash
		if $Time.isXibarUp = 1 then put cast Xibar
		if $Time.isKatambaUp = 0 && $Time.isYavashUp = 0 && $Time.isXibarUp = 0 then put release
		}
	if "$preparedspell" = "Rutilor's Edge" || "$preparedspell" = "Bond Armaments" || "$preparedspell" = "Ignite" then put cast $righthandnoun
	if "$preparedspell" = "Osrel Meraud" then put cast orb
	#if "$preparedspell" = "Bless" then
		#{
		# if "%WEAPON_EXP" = "Brawling" then put cast $charactername
		# else
		# put cast $righthandnoun
		#}
	if !matchre("$preparedspell", "%buff.special.casts") then
		{
		put cast
		}
	matchwait

buff.stow:
	matchre buff.stow ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^You put
	send stow my $1
	matchwait

buff.wear:
	var wear.item $1
	pause 0.1
	pause 0.1
	matchre buff.wear ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^You attach|^You slide|^You wear|^You hang|^Wear what
	send wear my %wear.item
	matchwait

buff.reequip:
	if (toupper("%OPTION") = "BRAWL") then return
	if "%buff.righthand" != "Empty" && "$1" != "left" then
		{
		send wield my %buff.righthand
		waitforre ^You draw|^Wield what\?|^You're already holding|^You're wearing a
		send remove my %buff.righthand
		Waitforre ^You sling|^Remove what|^You aren't wearing
		send get my %buff.righthand
		Waitforre ^You are already|^Get what\?|^Please rephrase that command\.$|^You're already holding
		}
	if "$1" = "right" then return
	if "%buff.lefthand" != "" && "$1" != "right" then
		{
		send wield my %buff.lefthand
		waitforre ^You draw|^Wield what\?|^You're already holding|^You're wearing a
		send remove my %buff.lefthand
		Waitforre ^You sling|^Remove what|^You aren't wearing
		send get my %buff.lefthand
		Waitforre ^You are already|^Get what\?|^Please rephrase that command\.$|^You're already holding
		if "%buff.lefthand" != "$lefthandnoun" then
		{
			send swap
			waitforre ^You swap|^You move|^You have nothing
		}
		}
	return

buff.forage:
	var buff.forage $1
	buff.forage.2:
	if "$righthand" = "dirt" || "$lefthand" = "dirt" then return
	send ret
	send ret
	wait
	matchre buff.forage.2 ^\.\.\.wait|^Sorry, you|^You cannot forage
	matchre buff.return some dirt\.$
	send forage %buff.forage
	matchwait
	buff.cut:
	matchre buff.cut ^\.\.\.wait|^Sorry, you
	matchre buff.return ^Roundtime|^You've already performed
	send perform cut
	matchwait

buff.release:
	pause .5
	matchre buff.release ^\.\.\.wait|^Sorry, you may
	matchre buff.return ^You aren't harnessing any mana|^You aren't preparing a spell|^You have no cyclic spell active to release
	send release spell;release mana
	matchwait
	variable.error:
	echo Something wrong with your variables. Some variable did not pass test. Check to make sure there are the proper number in each array variable
	return
	buff.return:
	action remove ^You are still stunned
	return

#################################
##                             ##
##        HELP Section         ##
##                             ##
#################################
HELP:
	gosub clear
	echo
	echo **************************************************************************************
	echo **
	echo ** Ambushing
	echo ** Appraisal
	echo ** Armor swapping
	echo ** Backstabbing
	echo ** Brawling
	echo ** Buffing
	echo ** Counting Critters (Dancing)
	echo ** Default Setting
	echo ** Empathic Brawling
	echo ** Experience Checks/Sleeping with a murked mind
	echo ** Global Variables
	echo ** HUNT verb
	echo ** Juggling
	echo ** Looting Options
	echo ** Magic
	echo ** Multi Skill Training
	echo ** Offhand Weapon Fighting
	echo ** Poaching/Sniping
	echo ** Pouch swapping
	echo ** power Perception
	echo ** Roaming a Hunting Ground
	echo ** Retreating Options
	echo ** Shields
	echo ** Skinning Options
	echo ** Snapfiring
	echo ** Stance Options
	echo ** Swappable Weapons (Bastard swords etc.)
	echo ** Syntax Full
	echo ** Targeting Body Parts
	echo ** Timer Training - training for X amount of time
	echo ** Thrown
	echo ** Weapons
	echo **
	echo ** Please type one of the above options for details.
	echo **
	echo **************************************************************************************
	echo
		match HELP_AMBUSH ambush
		match HELP_APP appr
		match HELP_ARMOR armor
		match HELP_BACK back
		matchre HELP_BRAWL brawl
		matchre HELP_BUFF buff
		matchre HELP_COUNT count|danc
		match HELP_DANGER danger
		matchre HELP_DEF defa|sett
		matchre HELP_EMPATH empath
		match HELP_EXP exp
		matchre HELP_GLOBAL glob|var
		match HELP_HUNT hunt
		match HELP_JUGGLE jugg
		match HELP_LOOT loot
		match HELP_MAGIC magic
		match HELP_MULTI multi
		match HELP_OFFHAND offh
		matchre HELP_POACH poach|snip
		matchre HELP_POUCH pouch
		match HELP_power pow
		match HELP_ROAM roam
		match HELP_RETREAT ret
		match HELP_SHIELD shield
		match HELP_SKIN skin
		match HELP_SNAP snap
		match HELP_STANCE stance
		match HELP_SWAP swap
		match HELP_SYNTAX synt
		match HELP_TARGET targ
		match HELP_THROWN throw
		match HELP_TIMER time
		match HELP_WEAPON weap
	matchwait

HELP_GENERAL:
	echo
	echo **************************************************************************************
	echo **
	echo ** The Option you chose was a "General Command"
	echo ** General commands must come before any other scripting commands,
	echo ** but can be mixed in any order with other General Commands.
	echo **
	echo ** LIST of General commands: Appraise, Arrange, Block, Bundle, Count, Custom, Dance,
	echo **                           Default, Dodge, Evade, Exp, Lootall, Lootbox, Lootcoin,
	echo **                           Lootgem, Retreat, Junk, Multi, Parry, Roam, Timer,
	echo **                           Target, Train
	echo **
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_AMBUSH:
	echo
	echo **************************************************************************************
	echo ** For anyone looking to get the drop on someone there's always ambushing.
	echo ** This function will hide/stalk an enemy and then attack from hiding.  For paladins
	echo ** it will unhide before advancing and also unhide before attacking to avoid soul hits.
	echo ** Support is in there for ambushing with ANY melee weapon in the game, as well as
	echo ** ambushing while brawling.
	echo **
	echo ** .hunt ambush {weapon} (shield)
	echo ** .hunt ambush brawl {weapon} (shield)
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_APP:
	echo
	echo **************************************************************************************
	echo ** The Script can be set-up to appraise the monsters you are fighting.
	echo **
	echo ** The script will 'appraise quick' for a 3 second RT.
	echo ** It attempts to app after a kill, and will app when a monster enters an empty room.
	echo ** Do to the limitations of the script it can ONLY app the same type of monster as the
	echo ** last monster you killed.
	echo ** This creates a sort of "hit or miss" system, but it does work most of the time.
	echo **
	echo ** .hunt APPR {weapon} (shield)
	echo **
	echo ** Note: The appraisal variable is a global variable so you can turn it on/off as you
	echo ** so desire while the script is running.  The variable is GH_APPR
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_ARMOR:
	echo
	echo **************************************************************************************
	echo ** The Script can be set-up to swap armors.
	echo **
	echo ** The script will swap armors when the learning rate becomes greater than the
	echo ** GH_ARMOR_RATE is set to.  This variable is found in the setup section at the top.
	echo ** This armor will only swap through the armors once per run of the script to keep from
	echo ** Looping endlessly through armors if they all get to the rate.  This count is restarted
	echo ** Everytime Hunt is re-run tough, such as when using the MULTI option
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_BACK:
	echo
	echo **************************************************************************************
	echo ** For all you sneaky types, backstab is supported.
	echo ** Just don't try this if you aren't a allowed!
	echo ** And if you try it with an inappropriate weapon, you will just attack like a Barbarian
	echo **
	echo ** .hunt backstab {weapon} (shield)
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_BRAWL:
	echo
	echo **************************************************************************************
	echo ** The script Brawls, no weapons allowed.  Just Fist of Fury
	echo **
	echo ** .hunt BRAWL
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_BUFF:
	echo **************************************************************************************
	echo ** The Script can be set-up to put up buffing spells, and put them back up when needed
	echo **
	echo ** The script gh_buff needs to be edited for your list of spells, preps, and what
	echo ** to charge the cambrinth at.
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_COUNT:
	echo
	echo **************************************************************************************
	echo ** It is possible to have the script Dance with a certain number of critters without
	echo ** killing them. The Script will do 'Brawling' until MORE THAN the number of critters
	echo ** you designate is in the room. (NOT at melee. NOT on you. IN THE ROOM)
	echo ** Both the Count and Dance keyword works for this function
	echo **
	echo ** .hunt COUNT/DANCE <Number of critters to dance with>
	echo **
	echo ** Example:
	echo **  .hunt COUNT/DANCE 3 Scimitar
	echo **     You will Dance until there are 4 critters, then attack until there are only
	echo **     3 again.
	echo **
	echo ** Note: The dancing variable is a global variable so you can turn it on/off as you
	echo ** so desire while the script is running.  The variable is GH_DANCING
	echo **************************************************************************************
	echo
	pause 7
	goto HELP

HELP_DANGER:
	echo **************************************************************************************
	echo ** The Script can be set-up to retreat while casting buffing spells in dangerous areas
	echo **
	echo ** This will retreat and stay retreated while buffing.  This option will enable the buff
	echo ** option too.
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_DEF:
	echo
	echo **************************************************************************************
	echo ** The script can be configured to create 1 default combat setting.
	echo ** This setting will be used when the script is started with no variables.
	echo ** It will skip all variable checks and go immediately into combat using
	echo ** the pre-configured weapon set-up created with this command.
	echo **
	echo ** Basically think of this as your "Oh crap! I need to be fighting NOW" set-up.
	echo **
	echo ** SYNTAX: .hunta DSET {weapon set-up}
	echo ** EXAMPLE: .hunta DSET loot skin scimtar shield
	echo ** USAGE: .hunta
	echo **
	echo ** A note on multi word weapons:
	echo **     If your set-up contains a multi word weapon like short.bow or bastard.sword
	echo ** there is an added step to get this to work properly. Once you create your set-up,
	echo ** since it is inside quotes the . is removed making these one word weapons two words,
	echo ** and thus two variables. To fix this do the following.
	echo **     Go into your config window and click the "Variables" tab. Find the variable
	echo ** with your multi word weapon and re-enter the period. This will make it function
	echo ** properly when default mode is used.  Default variables are all saved as
	echo ** GH_DEF_<variable name> so they are easily findable
	echo **
	echo **************************************************************************************
	echo
	pause 10
	goto HELP_DM

HELP_DM:
	echo
	echo **************************************************************************************
	echo ** To tie Default setting into a Multi-Weapon Setup use the command DMULTI
	echo ** This will make the script use your default setting as the first chain in
	echo ** Multi-weapon set-up. You must have previously set-up default settings to use this.
	echo ** Also, use DMSET to set the weapons to use
	echo **
	echo ** SYNTAX: .hunt DMSET weapon1 weapon2
	echo ** EXAMPLE: .hunt DMSET scimitar sword mace
	echo **          This sets up to use these 3 weapons with DEFAULT settings
	echo ** EXAMPLE: .hunt DMULTI 2 (this will start fighting with weapon 2)
	echo **
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_EMPATH:
	echo
	echo **************************************************************************************
	echo ** If you're an Empath, or just want to dance with a critter. There is brawling that
	echo ** doesn't hurt the critter.  No weapons allowed, just like normal brawling
	echo **
	echo ** SYNTAX: .hunt EMPATH
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_EXP:
	echo
	echo **************************************************************************************
	echo ** The script has three methods of Checking Experience.
	echo **   The Main method is using the 'MUlTI' command, where the script will check Exp
	echo ** and switch weapons to your next set-up when needed. (See the Multi-weapon section)
	echo **
	echo **	  The second method is using the 'EXP' variable. This causes the script to check the
	echo ** of the current weapon, or alternate experience (depending on the skill).  If the
	echo ** learning state of the experience is greater than 10 (dazed or mind locked) the script
	echo ** stops.
	echo **
	echo **   The third method is using the 'TRAIN' variable.  This causes the script to check
	echo ** the experience after every weapon cycle.  This method also checks after every kill.
	echo **
	echo **   The 'MULTI' command defaults to using both the 'TRAIN' and 'EXP' variable so it
	echo ** will check experience after every weapon cycle and after every kill
	echo **
	echo ** SYNTAX: .hunt EXP <weapon> (shield)
	echo ** SYNTAX: .hunt TRAIN <weapon> (shield)
	echo **
	echo ** Note: The training variables are a global variable so you can turn it on/off as you
	echo ** so desire while the script is running.  The variables are GH_EXP and GH_TRAIN
	echo ** Note2: You need the EXP plugin to make use of these functions.
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_GLOBAL:
	echo
	echo **************************************************************************************
	echo ** Hunt makes use of global variable so that you may modify your hunting without
	echo ** having to restart the script all together.  Here is a list of all the global
	echo ** variables and the allowable values
	echo **
	echo ** GH_AMBUSH    - OFF/ON  (ambushing with weapon)
	echo ** GH_APPR      - NO/YES  (appraising creatures)
	echo ** GH_ARRANGE   - OFF/ON  (arranging before skinning)
	echo ** GH_BUN       - OFF/ON  (bundling after skinning)
	echo ** GH_DANCING   - OFF/ON  (dancing with creatures)
	echo ** GH_EXP       - OFF/ON  (experience check after kills)
	echo ** GH_LOOT      - OFF/ON  (general looting, if OFF no looting is done)
	echo ** GH_LOOT_BOX  - OFF/ON  (box looting)
	echo ** GH_LOOT_COIN - OFF/ON  (coin looting)
	echo ** GH_LOOT_GEM  - OFF/ON  (gem looting)
	echo ** GH_LOOT_JUNK - OFF/ON  (junk looting)
	echo ** GH_SPELL     - <spell> (spell to cast)
	echo ** GH_MANA      - <mana>  (mana level to prepare spell at)
	echo ** GH_HARN      - <mana>  (mana level to harness after prep)
	echo ** GH_RETREAT   - OFF/ON  (retreating for ranged/magic)
	echo ** GH_ROAM      - OFF/ON  (roaming when nothing left to kill)
	echo ** GH_SKIN      - OFF/ON  (skinning creatures)
	echo ** GH_SKIN_RET  - OFF/ON  (retreating while skinning)
	echo ** GH_SNAP      - OFF/ON  (snapcasting/snapfiring)
	echo ** GH_STANCE    - OFF/ON  (stance switching)
	echo ** GH_TARGET    - <body part> (body part to target)
	echo ** GH_TIMER     - OFF/ON  (using timing function
	echo ** GH_TRAIN     - OFF/ON  (exp checks after combat cycles)
	echo **
	echo Note: Please note values are case sensitive for all variables with the options ON/OFF/NO/YES.
	echo      For all other variables, their values are case insensitive
	echo **************************************************************************************
	echo
	pause 10
	goto HELP

HELP_HUNT:
	echo
	echo **************************************************************************************
	echo ** The script will use the HUNT verb every 90 seconds to train perception, stalking
	echo ** and scouting (for the Rangers).  It will hunt before your swing your weapon during
	echo ** combat.
	echo **
	echo ** SYNTAX: .hunta HUNT {weapon} (shield)
	echo **
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_JUGGLE:
	echo
	echo **************************************************************************************
	echo ** The script can juggle while waiting for new monsters to show up for killing
	echo **
	echo ** SYNTAX: .hunt JUGGLE/YOYO {weapon} (shield)
	echo **
	echo ** You can also use yoyos as a jugglie.
	echo **
	echo ** Note:  For this to work you need to have a global variables:
	echo **                JUGGLIE = your jugglie of choice, be it standard or a yoyo
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_LOOT:
	echo
	echo **************************************************************************************
	echo ** The Script can be set-up to loot Kills. (It always searches.)
	echo **
	echo ** SYNTAX: .hunt LOOTALL {weapon} (shield)    <--- Loots everything
	echo **
	echo ** You can also set-up the script to loot specific item types, rather than everything.
	echo ** The variables for these are:
	echo **
	echo ** COLLECTIBLE - will loot collectibles (cards/diras)
	echo ** LOOTBOX - will only loot boxes until the stow container is full
	echo ** LOOTCOIN - will only loot coins
	echo ** LOOTGEM - will only loot gems until the stow container is full
	echo ** JUNK - will loot junk items (runestones/scrolls/lockpicks etc)
	echo **
	echo ** EXAMPLE: .hunt LOOTBOX {weapon} {shield}          <--- Loot boxes but not gems or coins.
	echo ** EXAMPLE: .hunt LOOTGEM LOOTCOIN {weapon} {shield} <--- Loot coins and gems but not boxes.
	echo **
	echo ** Note: The looting variables are a global variable so you can turn it on/off as you
	echo ** so desire while the script is running.  The variables are GH_LOOT,GH_LOOT_BOX,
	echo ** GH_LOOT_COIN, GH_LOOT_GEM, and GH_LOOT_JUNK
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_MAGIC:
	echo
	echo **************************************************************************************
	echo ** At long Last, the script can use magic. Both Targeted and none Targeted Magic, be
	echo **   they attack spells or buff spells. (LB or SOP)
	echo ** It is however limited to one spell, and the standard prep/target/cast routine.
	echo **	  And The script CANNOT use weapons while a spell is being preped/targeted.
	echo ** The script can also use brawling with magic.
	echo **
	echo ** Commands:  TM/PM = You will use mainly magic to hunt.
	echo **            MAGIC = You will use mainly weapons to hunt.
	echo **                 When combined with Multi, TM checks Targeted Magic, PM/MAGIC Primary.
	echo **
	echo ** SYNTAX:   .hunt TM/PM/MAGIC <spell> <mana> <harness mana> {weapon} (shield)
	echo **
	echo ** EXAMPLES: .hunt TM FB 15 3 scimitar
	echo **           .hunt MAGIC SOP 20 swap 1 b.sword targe
	echo **           .hunt PM bolt 5 5 - uses bolt spell and brawling for weapon
	echo **
	echo ** Notes: TM/PM will hunt using magic, your weapon is a back-up and is only used when
	echo **        low on mana.
	echo **        MAGIC is a single spell cast as the weapon combo repeats.
	echo **        SNAP can be used for snap casting.
	echo **************************************************************************************
	echo
	pause 10
	goto HELP

HELP_MULTI:
	echo
	echo **************************************************************************************
	echo ** To set up multi weapon simply put in SET as the first variable followed by the
	echo ** hunt set-ups you want to cycle through, each set-up must be inside a set of
	echo ** quotes (""). Multi-weapon will change set-ups when you reach Dazed in the
	echo ** current weapon.
	echo ** SYNTAX:  .hunt MSET "Set-up1" "Set-up2" "Set-up3" ... "Set-up10"
	echo **        NOTE: You don't have to use all 10 available set-up spots.
	echo ** EXAMPLE: .hunt MSET "skin loot scimitar shield" "loot app brawl"
	echo **
	echo ** USE:
	echo **     Once set-up, to use the script for multi-weapon simply use the "multi" command.
	echo ** If you want to start on a set-up that isn't your first one entered simply type in
	echo ** the number of the set-up you want to start with.
	echo **
	echo ** SYNTAX: .hunt MULTI <Set-up number you want to start with>
	echo ** EXAMPLE: .hunt MULTI - starts with Set-up1
	echo ** EXAMPLE: .hunt MULTI 3 - starts with Set-up3
	echo ** I know its a bit complex. AIM: IRXSwmr EMAIL: KllrWhle79@hotmail.com
	echo **
	echo ** A note on multi word weapons:
	echo **     If a set-up contains a multi word weapon like short.bow or bastard.sword there
	echo ** is an added step to get this to work properly.
	echo **     Once you create your set-up, since it is inside quotes the . is removed making
	echo ** these one word weapons two words, and thus two variables. To fix this do the
	echo ** following.
	echo **     Go into your config window and click the "Variables" tab. Find the variable
	echo ** with your multi word weapon and re-enter the period. This will make it function
	echo ** properly when "multi" is used.  Default variables are all saved as
	echo ** GH_MULTI_<SETUP NUMBER> so they are easily findable
	echo **
	echo **************************************************************************************
	echo
	pause 10
	goto HELP

HELP_OFFHAND:
	echo
	echo **************************************************************************************
	echo ** The script will fight with your offhand. This function is usable with all melee
	echo ** weapons and thrown weapons. You must still specify if you want to throw the weapon
	echo ** just like the throwing function. It will use the typical combat sequence, just with
	echo ** the left hand. Shields are not usable because they provide no protect when held in
	echo ** the right hand.
	echo **
	echo ** SYNTAX: .hunt OFF {weapon}
	echo ** EXAMPLE: .hunt OFF scimitar
	echo ** EXAMPLE: .hunt OFF throw hammer
	echo **
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_POACH:
	echo
	echo **************************************************************************************
	echo ** For those of you who like your stealth kills at range, Poaching and Sniping is
	echo ** fully operational.
	echo **
	echo ** SYNTAX: .hunt POACH {weapon} (shield(slings and LX only!)
	echo ** SYNTAX: .hunt SNIPE {weapon} (shield(LX only!)
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_POUCH:
	echo
	echo **************************************************************************************
	echo ** This option will remove a full worn gem pouch, place it into a specified container -
	echo ** \\$GH_CONTAINER_POUCH_CONTAINER, get another gem pouch, and wear it.
	echo **
	echo ** SYNTAX: .hunt POUCH {weapon} (shield)
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_power:
	echo
	echo **************************************************************************************
	echo ** The script will use the perceive verb to train power perception every 6 minutes
	echo **
	echo ** SYNTAX: .hunta POWERP {weapon} (shield)
	echo **
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_ROAM:
	echo
	echo **************************************************************************************
	echo ** The script will roam a hunting area if you run out of things to kill. It will move
	echo ** throughout the current hunting area and check each room for people and critters.
	echo ** It will makes sure you have your ammo first; and if you are bundling skins, it will
	echo ** pick up one bundle to take with you.
	echo **
	echo **                         !!!!!! CAUTION !!!!!!
	echo ** The script does not check to make sure you don't leave the hunting area and enter
	echo ** other, possibly more dangerous areas. Beforewarned that if there are more difficult
	echo ** creatures in an adjacent, easily accessed area, use extreme caution with this function.
	echo ** Also, there is not 100% coverage for people hunting in hiding. Be courteous of others
	echo ** so you don't get an arrow in the face.
	echo **
	echo ** SYNTAX: .hunt ROAM {weapon} (shield)
	echo **************************************************************************************
	echo
	pause 7
	goto HELP

HELP_RETREAT:
	echo
	echo **************************************************************************************
	echo ** The script defaults to not staying at a distance while using ranged weapons, thrown
	echo ** weapons and magic.  If you want to stay at a distance and retreat from combat while
	echo ** doing these actions, the script can do that with the RETREAT function
	echo **
	echo ** SYNTAX: .hunt RET {weapon} (shield)
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_SHIELD:
HELP_WEAPON:
	echo
	echo **************************************************************************************
	echo ** It works with (just about) any type of weapon in the game. Anytime you can use a
	echo ** shield, the script supports it.  The script won't even try to pull out a shield if
	echo ** you are using a two-handed weapon or bow.
	echo ** !!!WARNING!!! If you are using an arm worn shield DO NOT enter a shield name.
	echo **
	echo ** SYNTAX: .hunt {weapon} (shield)
	echo **
	echo ** Note: If you have an arm worn shield on when trying to use a bow, the script will
	echo ** remove and attempt to stow the offending shield
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_SKIN:
	echo
	echo **************************************************************************************
	echo ** Everyone has there own method of how they skin. This script therefore has several
	echo ** options on how skinning works.
	echo ** Here are the commands for skinning, and what they do:
	echo **
	echo ** SKIN     : Skins, drops the skin if you aren't bundling
	echo ** BUNDLE   : Same as 'SKIN', but bundles the skins.  If no ropes to bundle, drops skins, drops bundles
	echo ** SKINRET  : Will make the script retreat before skinning.
	echo ** SCRAPE   : Will scrape the skins before dropping/bundling them
	echo ** ARRANGE  : Same as 'SKIN' but it arranges first, also can input number of times to arrange (1-5)
	echo ** WEAR     : Wears bundles, instead of dropping them
	echo ** TIE      : Ties bundles off before either dropping or wearing them, reduces item count
	echo **
	echo ** There is no need to use 'SKIN' if you are using one of the other options, it knows
	echo ** you're skinning.  In other words, ".hunt skin bundle" is redundant, just use
	echo ** ".hunt bundle"
	echo **
	echo ** Options can be combined for full effect.
	echo **
	echo ** EXAMPLE: .hunt ARRANGE SKINRET {weapon} - this would make the script retreat,
	echo ** arrange the kill, skin it, and drop the skin.
	echo **
	echo ** Note: If you are a ranger and you do "arrange 5" (max arranges) the script will use
	echo ** "arrange all" to arrange for minimum RT
	echo **************************************************************************************
	echo
	pause 10
	goto HELP

HELP_SNAP:
	echo
	echo **************************************************************************************
	echo ** For those of us who are impatient, ALL Ranged systems can be snapfired.
	echo **   Snapfiring will cause the script to aim and fire instanly after you load until
	echo ** your target is dead.
	echo **
	echo ** SNAP also works with Magic systems. It will fully prepare the spell then Target and
	echo **   Cast at the same time.
	echo **
	echo ** EXAMPLE: .hunt SNAP {weapon} (shield)-(slings and LX only!)
	echo ** EXAMPLE: .hunt SNAP poach {weapon} (shield)-(slings and LX only!)
	echo ** EXAMPLE: .hunt SNAP TM FB 15 scimitar
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_STANCE:
	echo
	echo **************************************************************************************
	echo ** The script is able to alter your stance.
	echo ** Block - Custom - Evasion - Parry
	echo ** These commands will make the script switch to the preset Stance you enter.
	echo **
	echo ** .hunt BLOCK/CUSTOM/EVASION(or DODGE)/PARRY {weapon} (shield)
	echo **
	echo ** The script also has the function to switch stances when one is locked. It will
	echo ** determine your current stance, and then check the experience for that skill. If the
	echo ** is dazed or above, it will switch stances.  The stance switching goes in the following
	echo ** order: evasion -> shield -> parry and back
	echo **
	echo ** SYNTAX: .hunt STANCE {weapon} (shield)
	echo **
	echo ** If you would like to skip one stance, you can indicate which stance you would like to
	echo ** with the NOEVASION, NOPARRY, or NOSHIELD keywords.  This will skip the indicated
	echo ** stance.  You may only skip one stance.
	echo **
	echo ** Note: You must have the EXP plugin for this function to work
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_SWAP:
	echo
	echo **************************************************************************************
	echo ** The script can be set-up to use swappable weapons.
	echo ** "Swap X" must be followed by the weapon.
	echo **
	echo ** SYNTAX: .hunt SWAP {SE/LE/2HE/SB/LB/2HB/POLE/S} {weapon} (shield)
	echo **
	echo ** SE = Uses weapon as Small Edged
	echo ** LE = Uses weapon as Large Edged
	echo ** 2HE = Uses weapon as Two-handed Edged
	echo ** SB = Uses weapon as Small Blunt
	echo ** LB = Uses weapon as Large Blunt
	echo ** 2HB = Uses weapon as Two-handed Blunt
	echo ** POLE = Use this weapon as a Pike
	echo ** S = Use this weapon as a Stave
	echo **
	echo ** EXAMPLES: .hunt SWAP LE sword shield - uses a sword in Large Edged mode
	echo **          .hunt SWAP POLE spear - uses a spear in Polearm Mode
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_SYNTAX:
	echo
	echo **************************************************************************************
	echo **    This is a brief (for me anyway) description of how the script works
	echo ** and what order commands come in, as well as a list of all the commands
	echo ** the script has.
	echo **
	echo **    There are many options settings and methods of using the script,
	echo ** all of which have been programed in and can be called forth using the
	echo ** correct comamnds. Knowing those commands and how to use them is what
	echo ** this section is for.
	echo **
	echo **    'Command' refers to anything that follows .hunt when starting the script.
	echo ** There are several types of commands:
	echo **
	echo **    'General Commands' have to come before anything else, but can
	echo ** be placed in any order amongst themselves. These are basic systems
	echo ** that toggle on or off specific non-combat features.
	echo **
	echo **    'Combat Methods' come after 'General Commands' but before
	echo ** 'Combat Systems'. Methods alter a System in very specifc but minor
	echo ** ways, and can usually only be used with a specific System.
	echo **
	echo **    'Combat Systems' come After Methods, and Immediately before your
	echo ** Equipment. Systems decide how the script is going to fight. This is usually
	echo ** defined by your Equipment, but occasionlly a System is used that redefines
	echo ** how combat is undergone with Certain Equipment.
	echo **
	echo **    'Equipment' is always the last command. When the script finds your
	echo ** Equipment (usually a weapon) it begins combat after equiping you.
	echo ** Equipment is defined as the in game items you will be using to hunt with.
	echo **
	echo **    'Special' commands are.. special. They are usually systems that have
	echo ** nothing to do with combat itself, but were placed into the script as extras
	echo ** They are also the commands used to set-up some of the more complex features
	echo ** of the script.
	echo **
	echo ** Command List:
	echo ** General Commands: Appraise, Arrange, Block, Bundle, Count, Custom, Dance, Default,
	echo **                   Dodge, Evade, Exp, Lootall, Lootbox, Lootcoin, Lootgem, Retreat,
	echo **                   Junk, Multi, Parry, Roam, Target, Timer, Train
	echo ** Combat Methods: Ambush, Snapfire, Stack
	echo ** Combat Systems: Backstab, Brawl, Empath, Offhand, Snipe, Swap, Throw, TM/PM/Magic
	echo ** Spcl. Commands: MSET and MULTI (multi weapons), DSET (Default Setting), HELP,
	echo **                 DMSET and DMULTI (multi weapons with default settings)
	echo **
	echo ** SYNTAX ORDER: [] = Special Commands () = General Commands || = Combat Methods
	echo **               /\ = Combat Systems {} = Equipment
	echo **
	echo ** Basic: .hunt {weapon} {shield}
	echo ** Advan: .hunt () || /\ {}
	echo ** Spcl.: .hunt []
	echo **
	echo ** For more specifc information please refer to the individual HELP sections.
	echo **
	echo **************************************************************************************
	echo
	pause 20
	goto HELP

HELP_TARGET:
	echo
	echo **************************************************************************************
	echo ** So say, you want to behead all your enemies. Well hunt will help you out.
	echo ** The TARGET variable let's you specify a body part to attack. This will work with all
	echo ** types of weapons and magic.
	echo **
	echo ** SYNTAX: .hunt TARGET <body part> {weapon} (shield)
	echo ** EXAMPLE: .hunt TARGET head scimitar
	echo ** EXAMPLE: .hunt TARGET right.arm scimitar
	echo **
	echo ** Note: If the body part is multi-word (left arm), use a period (.) to separate the
	echo ** two words
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

HELP_THROWN:
	echo
	echo **************************************************************************************
	echo ** Like to throw things? hunt can satisfy your needs!
	echo ** The system is also set up to use and handle stacks of throwing weapons. It is not
	echo ** needed to specify THROW if you are using a STACK, the script knows.
	echo **
	echo ** SYNTAX: .hunt THROW {weapon} (shield)
	echo ** SYNTAX: .hunt STACK {weapon} (shield)
	echo **************************************************************************************
	echo
	pause 3
	goto HELP

HELP_TIMER:
	echo
	echo **************************************************************************************
	echo ** Hunt allows for timed hunting rounds.  With the TIMER variable you can set
	echo ** a limit to how long you want to use a weapon. The timer defaults to 10 minutes,
	echo ** or 600 seconds, so you can just use that or input your own amount of time.
	echo **
	echo ** SYNTAX: .hunt TIMER <time in seconds> {weapon} (shield)
	echo ** EXAMPLE: .hunt TIMER 900 scimitar - will kill with the scimitar for 15 minutes
	echo ** EXAMPLE: .hunt TIMER scimitar - will kill with the scimitar for 10 minutes
	echo **************************************************************************************
	echo
	pause 5
	goto HELP

DYING:
	var DYING ON
	return
