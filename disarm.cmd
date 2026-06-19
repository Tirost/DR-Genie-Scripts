#debuglevel 5
################################################################################################################################
################################################################################################################################
# Smart Disarm Script v16.1 - by Shroom
# UPDATE - 5/3/26
#
# SPECIALIZED for THIEVES - But works out of the box for ANYONE 
# - Auto removes any WORN ARMOR
# - AUTO DISARMS AND PICKS / LOOTS ALL YOUR BOXES
# - ANALYZES the appraisal DIFFICULTY of the trap compared to what TYPE of trap it is (How dangerous)
# - DYNAMICALLY changes MODE of disarm (Blind, Quick, Normal, Careful) according to the overall difficulty 
# - YOU CAN SET A DIFFICULTY MODIFIER IN VARS TO INCREASE/DECREASE DIFFICULTY IF YOU WANT TO BE RISKIER/LESS RISKY
# - TOSSES box if a trap is WAY TOO HARD FOR US (AND DANGEROUS), OR if you fail too many times in a row
# - Can AUTO-MOVE rooms to handle Area-Wide dangerous traps, if there are other people in our room 
# - Handles BLOWN TRAPS (determines what kind of trap it was, REACTS/GETS HEALED accordingly)
# - Auto Handles ALL known types of Lockpick Rings/Cases
# - Supports SKELETON KEYS 
# - Supports HARVESTING traps and SELLING any trap components (Thieves only) at end of run (Can turn OFF or ON)
# - TRACKS/LOGS total number of BOXES PICKED EACH SESSION and TOTAL BOXES PICKED OVER ALL TIME running the script
# - TRACKS/LOGS total number of TRAP TYPES you've found over all time - Keeps permanent log of how many traps you've found of each type
# - Puts on all removed armor at the end of the script, if you removed any and WEAR.ARMOR is ON
#
## NOTE!! YOU ~MUST~ SET YOUR CHARACTER SPECIFIC VARIABLES IN THE SECOND VARIABLE SCRIPT - disarm-vars.inc
## IF YOU DO NOT SETUP THE VARIABLES IN disarm-vars.inc THEN THIS SCRIPT WILL NOT WORK
## THE VARIABLES SCRIPT MUST BE NAMED  "disarm-vars.inc"  (without quotes)
#
# !!SPECIAL FEATURES!!:
# BOX POPPER BOT / PICK BOXES FOR OTHER PEOPLE 
# - Start script with .disarm NAME
# "Name" being the name of the person you are picking boxes for
# It will whisper to them Ready for a box, wait for a box, pick it and hand it back to them unlooted, until they are finished 
#
################################################################################################################################
# CHANGELOG 
# 
# - New variable for Auto Lockpick Restocking tied to Uber
# - Overhauled all variables
# - Speedups and various tweaks
# - Added double tending for bleeders in case of Internal bleeders
# - Overhauled lockpick ring check
# - Added support for decorative keyring and tailrings from Droughtmans
# - Will now loot collector's cards it finds
# - Script will now track total trap types you find each run!
# - Will also keep a GLOBAL variable for each trap type and add up on each run
# - Added support for Vardite Skeleton Keys
# - Added support for portal bags
# - Added logic to Auto switch to careful MODE when doing dangerous trap > 6 difficulty 
# - Added support for Exoskeletal Armor
# - Added gosub for stowing lockpick after filling container
# - Empaths should escape to healer if blowing a reaper box
# - Fixed issue if gem pouch was worn
# - Removed all instances of Pet Boxes and Pet Box support as no longer valid
# - Added Support for "tool box" type lockpick rings 
# - Added Support for Thieves Auto-Selling Trap Components - if KEEPCOMPONENT is ON
# - Broke out variables into a separate include - disarm-vars.inc
# - Added support for the New Ankle-Cuff lockpick case, and checking for Golden Keys as well when checking what type of lockpick ring/case
# - Added matches for EVERY box type when already disarmed, for the Pet Boxes MODE to make 100% sure a box is disarmed before picking it
# - Added TIECONTAINER / TIECONTAINER.ITEMS - For toolstraps/toolbelts etc that you always want to tie a particular item to 
# - Robustified the box matching to avoid false positives on anything that is NOT a monster box 
# - Robustified the TRAP RECOVERY section 
# - Added variable to put armor back on at the end (if it removes any at the beginning)
# - Added variable for WORN gem pouches, so script will work with worn pouches instead of pulling them from a container
# - Cleaned up/Optimized a ton of code - changed all script variable checks (toupper). Now variables don't have to be in all caps.
# - Robustified the guild check section, armor check section. Now checks for hand armor as part of the armor check
# - SPECIAL REQUEST - PICK BOXES FOR OTHERS! Simply start the script by using the player's name as a variable
# Example - .disarm Bob - will wait for boxes from Bob, disarm and pick them and give them back to Bob. (THIS IGNORES IF YOU ARE MIND LOCKED)
# - ADDED Much better multi character support - Now can easily set different variables for different characters. 
# - Added new variable <AUTOHEAL> - Set to YES by default. Set to NO if you want to skip visiting the auto-empath if you get hurt (WILL ABORT SCRIPT IF YOU ARE HURT)  
################################################################################################################################

## NOTICE!! YOU MUST SET YOUR CHARACTER SPECIFIC VARIABLES IN THE SECOND SCRIPT - disarm-vars.inc
## IF YOU DO NOT SETUP THE VARIABLES IN disarm-vars.inc THEN THIS SCRIPT WILL NOT WORK

##############################################################################
##############################################################################
# END USER VARIABLES - DO NOT TOUCH ANYTHING BELOW THIS LINE
##############################################################################
##############################################################################

### DEFAULT SCRIPT VARIABLES - DO NOT TOUCH ANYTHING BELOW!!!
INIT:
     include disarm-vars.inc
     var version 15.5
     # ring_types should include all known lockpick ring types
     var ring_types lockpick ring|lockpick case|lockpick wrist|decorative keyring|lockpick ankle-cuff|lockpick tailband|lockpick tailring|golden key|tool case|iron keyring|locksmith strand
     var box_types \s*(brass|copper|deobar|driftwood|iron|ironwood|mahogany|oaken|pine|steel|wooden)\s*(coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|(?<!(?i)training )box)\s*(closed|open)?
     var component_list sealed vial|stoppered vial|capillary tube|short needle|broken needle|bronze seal|animal bladder|silver studs|sharp blade|curved blade|broken rune|coiled spring|metal spring|metal lever|tiny hammer|iron disc|bronze disc|glass reservoir|bronze face|steel pin|steel striker|chitinous leg|(?!cracked )black crystal|metal circle|brown clay|black cube|glass sphere
     var gemlist \b( adderstone|topaz| star-stone|\bamber(?! andalusite)| andradite| agate| alexandrite| ambergris| amethyst| anloral| aquamarine| bead| beryl|(?<!spiraling oak staff topped with a large uncut) bloodgem| bloodstone| carnelian| celeste| chakrel| chalcedony| chrysoberyl| chrysoprase| citrine| coral|(?<!sanowret) crystal| diamond| diopside| egg| eggcase| emerald| fathomstone| garnet| gem| glowstone| glossy malachite| goldstone|(chunk of|some|tiny amber(?! andalusite)|piece of)\s(silver|gold|platinum|quartz)-laced\sgranite| heartstone| hematite| ilithi emerald| iniskim| iolite| ivory| ivory tooth| jade| jadeite| jasper| jet| kuldaez crystal| kunzite| larimar| lazurite|lapis lazuli| malachite| minerals| moonstone| morganite| onyx| opal| pearl| peridot| pyrope| quartz| ruby| sapphire| sardonyx| seaglass| seordstone| saendalan emerald| spinel| sunstone| soulstone|(?<!draconian) talon| taigo| tanzanite| tiger's eye| topaz| tourmaline| tsavorite| thealstone| turquoise(?! andalusite)| zircon| wulfenite)\b
     var key_type NULL
     var multi_trap ON
     var multi_lock ON
     var thief_hide OFF
     var SKELETON.KEY OFF
     var ARMOR_STOW OFF
     var DISMANTLE.ALL ON
     var RESTOCK.LOCKPICKS OFF
     var AUTOLOOT ON
     var TRAP.TYPE NULL
     var BOXES 0
     var BOX 0
     var LOCAL 0
     var havekey 0
     var GIVEBOX OFF
     var FIRSTIME ON
     var FIREANT OFF
     var armor null
     var armor1 null
     var armor2 null
     var armor3 null
     var armor4 null
     var armor5 null
     var armor6 null
     var armor7 null
     var armor8 null
     var armor9 null
     var armor10 null
     var armor11 null
     var armor12 null
     var armor13 null
     var armor14 null
     var armor15 null
     var total_armor 0
     var yogi 0
     var shadowling 0
     var DISMANTLE
     var MAGICUSER Warrior Mage|Moon Mage|Bard|Ranger|Paladin|Empath|Cleric|Trader|Necromancer
### SET DEFAULT TRAP COUNTS
     var concussion.count 0
     var teleport.count 0
     var shrapnel.count 0
     var disease.count 0
     var reaper.count 0
     var fire_ant.count 0
     var gas.count 0
     var lightning.count 0
     var naphtha_soaker.count 0
     var naphtha.count 0
     var acid.count 0
     var boomer.count 0
     var scythe.count 0
     var shocker.count 0
     var poison_local.count 0
     var poison_nerve.count 0
     var curse.count 0
     var poison_bolt.count 0
     var bolt.count 0
     var cyanide.count 0
     var frog.count 0
     var flea.count 0
     var bouncer.count 0
     var laughing.count 0
     var sleeper.count 0
     var mime.count 0
     var mana_sucker.count 0
     var shadowling.count 0
     if matchre($Boxes, \D+) then put #var Boxes 0
     if !def(DisarmTraps_Bolt) then put #var DisarmTraps_Bolt 0
     if !def(DisarmTraps_Concussion) then put #var DisarmTraps_Concussion 0
     if !def(DisarmTraps_Teleport) then put #var DisarmTraps_Teleport 0
     if !def(DisarmTraps_Shrapnel) then put #var DisarmTraps_Shrapnel 0
     if !def(DisarmTraps_Disease) then put #var DisarmTraps_Disease 0
     if !def(DisarmTraps_Reaper) then put #var DisarmTraps_Reaper 0
     if !def(DisarmTraps_FireAnt) then put #var DisarmTraps_FireAnt 0
     if !def(DisarmTraps_Gas) then put #var DisarmTraps_Gas 0
     if !def(DisarmTraps_Lightning) then put #var DisarmTraps_Lightning 0
     if !def(DisarmTraps_Naphtha.Soak) then put #var DisarmTraps_Naphtha.Soak 0
     if !def(DisarmTraps_Naphtha) then put #var DisarmTraps_Naphtha 0
     if !def(DisarmTraps_Acid) then put #var DisarmTraps_Acid 0
     if !def(DisarmTraps_Boomer) then put #var DisarmTraps_Boomer 0
     if !def(DisarmTraps_Scythe) then put #var DisarmTraps_Scythe 0
     if !def(DisarmTraps_Shocker) then put #var DisarmTraps_Shocker 0
     if !def(DisarmTraps_Poison.Local) then put #var DisarmTraps_Poison.Local 0
     if !def(DisarmTraps_Poison.Nerve) then put #var DisarmTraps_Poison.Nerve 0
     if !def(DisarmTraps_Poison.Bolt) then put #var DisarmTraps_Poison.Bolt 0
     if !def(DisarmTraps_Cyanide) then put #var DisarmTraps_Cyanide 0
     if !def(DisarmTraps_Frog) then put #var DisarmTraps_Frog 0
     if !def(DisarmTraps_Flea) then put #var DisarmTraps_Flea 0
     if !def(DisarmTraps_Bouncer) then put #var DisarmTraps_Bouncer 0
     if !def(DisarmTraps_LaughingGas) then put #var DisarmTraps_LaughingGas 0
     if !def(DisarmTraps_Sleeper) then put #var DisarmTraps_Sleeper 0
     if !def(DisarmTraps_Mime) then put #var DisarmTraps_Mime 0
     if !def(DisarmTraps_Mana.Sucker) then put #var DisarmTraps_Mana.Sucker 0
     if !def(DisarmTraps_Shadowling) then put #var DisarmTraps_Shadowling 0
     gosub LOADVARS
##################################
## SCRIPT ACTIONS
##################################
# TRAP TYPE MATCHING~
     action (id) var TRAP.TYPE acid;echo ***ACID TRAP! when As you look closely\, you notice a tiny hole right next to the lock which looks to be a trap of some kind\.|Must be an acid trap\.
     action (id) var TRAP.TYPE boomer;echo ***BOOMER TRAP! when A glistening black square\, surrounded by a tight ring of fibrous cord, catches your eye\.
     action (id) var TRAP.TYPE reaper;echo ***REAPER TRAP!! when A crust\-covered black scarab of some unidentifiable substance clings to the|^A disturbing little scarab is fastened to the front\.
     action (id) var TRAP.TYPE fire_ant;echo ***FIRE ANT TRAP!! when Within the casing of .* is a mesh bag\, a very sharp blade poised to the side just within
     action (id) var TRAP.TYPE poison_bolt;echo ***POISON BOLT TRAP when You find a series of openings on the front of the .* concealing the points of several crossbow bolts glistening with moisture\.
     action (id) var TRAP.TYPE bolt;echo ***BOLT TRAP! when concealing the points of several wickedly barbed crossbow bolts\.
     action (id) var TRAP.TYPE concussion;echo ***CONCUSSION TRAP!! when Right above the lock inside the keyhole\, you see a tiny metal tube just poking out of a small wad of brown clay\.|infamous shockwave trap
     action (id) var TRAP.TYPE cyanide;echo ***CYANIDE TRAP! when ^The glint of silver from the tip of a dart catches your attention|That tiny dart you can see means|smell of almonds
     action (id) var TRAP.TYPE disease;echo ***DISEASE TRAP! when While inspecting the .* patiently\, you see what appears to be a small\, swollen animal bladder recessed inside the keyhole\.
     action (id) var TRAP.TYPE flea;echo ***FLEA TRAP! when (Embedded|Imbedded) in the front of the .* is a small glass tube of milky-white opacity\.
     action (id) var TRAP.TYPE gas;echo ***GAS TRAP! when You notice a vial of lime green liquid just under the .* lid|^There\'s a stopper of some vial attached to the lid
     action (id) var TRAP.TYPE lightning;echo ***LIGHTNING TRAP!! when Looking closely into the keyhole\, you spy what appears to be a pulsating ball with some sort of metal lacing around it
     action (id) var TRAP.TYPE naphtha_soaker;echo ***NAPHTHA SOAKER TRAP!! when Searching the .* carefully\, you notice a small notch beside a tiny metal lever on the front\.|components of the naphtha soaker trap
     action (id) var TRAP.TYPE naphtha;echo ***NAPHTHA TRAP! when A tiny striker is cleverly concealed under the lid\, set to ignite a frighteningly large vial of naphtha\.
     action (id) var TRAP.TYPE poison_local;echo ***POISON TRAP! when You notice a tiny needle with a greenish discoloration on its tip hidden next to the keyhole\.
     action (id) var TRAP.TYPE poison_nerve;echo ***NERVE POISON TRAP! when You notice a tiny needle with a rust colored discoloration on its tip hidden next to the keyhole\.|^A rusty needle\!
     action (id) var TRAP.TYPE scythe;echo ***SCYTHE TRAP! when Out of the corner of your eye\, you notice a glint of razor sharp steel hidden within a suspicious looking seam on the|scythe trap\!
     action (id) var TRAP.TYPE shocker;echo ***SHOCKER TRAP! when You notice two silver studs right below the keyhole which look dangerously out of place there\.
     action (id) var TRAP.TYPE shrapnel;echo ***SHRAPNEL TRAP!!! when Squinting slightly to see better\, you notice the .* keyhole is packed tightly with a powder around the insides of the lock\.
     action (id) var TRAP.TYPE teleport;echo ***TELEPORT TRAP!!!! when The hinges of the .* are covered with a thin metal circle that has been lacquered with a shade of .*\.
     action (id) var TRAP.TYPE bouncer;echo ***BOUNCER TRAP when Looking into the keyhole you see what seems to be a pin lodged against the tumblers of the lock\.
     action (id) var TRAP.TYPE curse;echo ***CURSE TRAP when While checking the .* with an careful eye\, you notice a small glowing rune hidden inside the .*
     action (id) var TRAP.TYPE frog;echo ***FROG TRAP when While checking the .* with a careful eye\, you notice a lumpy green rune hidden inside the .*
     action (id) var TRAP.TYPE laughing;echo ***LAUGHING TRAP when Examining the .* for traps reveals a tiny glass tube filled with a black gaseous substance of some sort and a tiny hammer at the ready to do what it was designed for\.
     action (id) var TRAP.TYPE mana_sucker;echo ***MANA TRAP when While checking the .* for traps\, you notice a bronze seal over the .* 
     action (id) var TRAP.TYPE mime;echo ***MIME TRAP when A tiny bronze face\, Fae in appearance\, grins ridiculously from its place on the .*
     action (id) var TRAP.TYPE shadowling;echo ***SHADOWLING TRAP when While scanning the .* with a careful eye\, you notice a small black crystal deep in the shadows of the .*
     action (id) var TRAP.TYPE sleeper;echo ***SLEEPER TRAP when Two sets of six pinholes on either side of the .* lock indicate that something is awry\.
     action (id) off
#################################################################
## THESE DETERMINE THE BASE DIFFICULTY LEVEL OF A TRAP
#################################################################
     action var APP.DIFFICULTY -9 when An aged grandmother could
     action var APP.DIFFICULTY -8 when is a laughable matter
     action var APP.DIFFICULTY -7 when is a trivially constructed
     action var APP.DIFFICULTY -4 when will be a simple matter for you to
     action var APP.DIFFICULTY -3 when should not take long with your skills
     action var APP.DIFFICULTY 0 when is precisely at your skill level
     action var APP.DIFFICULTY 1 when with only minor troubles
     action var APP.DIFFICULTY 2 when got a good shot at
     action var APP.DIFFICULTY 3 when some chance of being able
     action var APP.DIFFICULTY 5 when with persistence you believe you could
     action var APP.DIFFICULTY 6 when would be a longshot
     action var APP.DIFFICULTY 7 when minimal chance
     action var APP.DIFFICULTY 8 when You really don't have any chance
     action var APP.DIFFICULTY 9 when Prayer would be a good start
     action var APP.DIFFICULTY 11 when You could just jump off a cliff
     action var APP.DIFFICULTY 12 when You should just jump off a cliff
     action var APP.DIFFICULTY 15 when same shot as a snowball
     action var APP.DIFFICULTY 16 when pitiful snowball encased in the Flames
## MISC ACTIONS
     action (moving) var Moving 1 when Obvious (path|exits)|Roundtime
     action instant goto DROPPED_BOX when ^Your .* falls to the ground\.
     #action put #queue clear; send $lastcommand when ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     action var multi_trap ON when is not yet fully disarmed
     action var multi_lock ON when discover another lock protecting
## LOCK MODE
     action (lock) var MODE blind when ^This lock is a laughable matter|^An aged grandmother could open this
     action (lock) var MODE quick when lock's structure is relatively basic|should not take long with your skills|You can unlock the (.+) with only minor troubles|^The lock is a trivially constructed piece of junk|will be a simple matter for you
     action (lock) var MODE normal when ^You think this lock is precisely at your skill level|The lock has the edge on you
     action (lock) var MODE careful when ^The odds are against you, but with persistence you believe you could pick|You have some chance of being able to pick open|would be a longshot
     action (lock) var MODE careful when ^Prayer would be a good start for any attempt of yours at picking|amazingly mininal chance at picking|don't have any change at picking|snowball|jump off a cliff
     action (lock) off
###################################################################
## BLOWN TRAP ACTIONS
     action goto TELEPORT_OK when ^Elanthia seems to fall away from under your feet|^You experience a great wrenching in your gut and everything goes utterly black|As your vision slowly returns, you find yourself at|You find yourself curled up on the ground at
     action goto TELEPORT_DEATH when Your last painful thought before you die is the horrified realization
     action goto TELEPORT_HURT when  .* is suddenly torn apart by unseen forces in an explosive spray of splinters
     action goto CONCUSSION_DEATH when ^As soon as you look up, your entire world explodes in a crash of deafening sound and searing heat|way out of your league before oblivion takes you
     action goto DIED_TRAP when way out of your league before oblivion takes you
     action goto BLOWN_TRAP when The stinging, sandy winds have made you pause|^The sand devil spins and whirls|several very angry vykathi reapers standing right beside you
     action goto BLOWN_TRAP when A black cloud of ash and soot explodes out of the bladder
     action goto BLOWN_TRAP when With a sinister swishing noise, a deadly sharp scythe blade
     action goto BLOWN_TRAP when ^A tiny dart lodges into your skull
     action goto BLOWN_TRAP when ^You are diseased|only to be greeted with a loud "Poof" followed by a cloud of small particles
     action goto BLOWN_TRAP when Almost immediately, you grow dizzy
     action goto BLOWN_TRAP when you realize it was actually a swarm of fleas
     action goto BLOWN_TRAP when Like a Halfling blowing smoke rings
     action goto BLOWN_TRAP when You fall to your knees coughing and gagging|inhale all of the poisonous gas yourself
     action goto BLOWN_TRAP when You get the feeling that life suddenly got alot funnier|^You are completely incapacitated with laughter|^The hammer slips from its locked position and strikes the tube with a tiny "clink"
     action goto BLOWN_TRAP when you notice the world around you has gotten much bigger|^Your head is ringing so much you can't think
     action goto BLOWN_TRAP when emits a sound like tormented souls being freed
     action goto BLOWN_TRAP when You try to scream but no sound
     action goto BLOWN_TRAP when A stream of corrosive acid sprays out
     action goto BLOWN_TRAP when An acrid stream of sulfurous air
     action goto BLOWN_TRAP when With a barely audible click
     action goto BLOWN_TRAP when There is a sudden flash of greenish light
     action goto BLOWN_TRAP when You hear a snap as a bronze seal
     action goto BLOWN_TRAP when ^Nothing happened. Maybe it was a dud|begins to shake violently
     action goto BLOWN_TRAP when Just as your ears register the sound of a sharp snap
     action goto BLOWN_TRAP when You make a small hole in the side of the box and take deep breath
     action goto BLOWN_TRAP when Moving with the grace of a pregnant goat
     action goto BLOWN_TRAP when You barely have time to register a faint click before a blinding flash explodes|The liquid contents of the bladder empty, spraying you completely
     action goto BLOWN_TRAP when Before you have time to think what it might be you find
     action goto BLOWN_TRAP when To your horror, oversized, red, ant-like insects emerge and begin to race across your hands
     action goto HEAL_PAUSE when The ringing in your ears continues
     pause 0.0001
     send exp survival 0
     waitforre Overall state of mind|EXP
     pause 0.0001
     if_1 then
     {
          var user %1
          var GIVEBOX ON
          send whisper %user Give me a second to prepare. When ready I'll whisper you and then hand me a new box.
     }
     GOTO TOP
######################################################################################
## TRAP DIFFICULTY MODIFIERS
## THIS SETS A STATIC DIFFICULTY LEVEL FOR EACH TRAP TYPE
## THEN ADDS THAT TO THE APPRAISED DIFFICULTY TO COMPUTE WHAT MODE OF DISARM TO USE
## I.E - IF A TRAP IS VERY DANGEROUS IT WILL USE CAREFUL - EASY WILL USE QUICK/NORMAL
## SUPER DUPER EASY WILL USE BLIND - WAYYY TOO HARD WILL JUST TOSS THE BOX
##########################################################################################
trap_diff_compute:
var TOTAL.DIFFICULTY 0
### DEFAULT TRAP DIFFICULTIES
### Set from -5 to 5 (OR BEYOND) depending on how worried you are about blowing that particular trap
### -5 = TRAP IS LAUGHABLE, YOU DONT CARE IF YOU BLOW IT 
### 5+ = TRAP IS DANGEROUS! BE VERY CAREFUL!
### THE MOST DANGEROUS TRAPS ARE AT THE TOP AND HAVE A HIGH DEFAULT DIFFICULTY
     if ("%TRAP.TYPE" = "concussion") then var TRAP.DIFFICULTY 10
     if ("%TRAP.TYPE" = "shrapnel") then var TRAP.DIFFICULTY 10
     if ("%TRAP.TYPE" = "disease") then var TRAP.DIFFICULTY 10
     if ("%TRAP.TYPE" = "teleport") then var TRAP.DIFFICULTY 9
     if ("%TRAP.TYPE" = "reaper") then var TRAP.DIFFICULTY 9
     if ("%TRAP.TYPE" = "fire_ant") then var TRAP.DIFFICULTY 9
     if ("%TRAP.TYPE" = "gas") then var TRAP.DIFFICULTY 8
     if ("%TRAP.TYPE" = "lightning") then var TRAP.DIFFICULTY 8
     if ("%TRAP.TYPE" = "naphtha") then var TRAP.DIFFICULTY 7
     if ("%TRAP.TYPE" = "naphtha_soaker") then var TRAP.DIFFICULTY 6
     if ("%TRAP.TYPE" = "acid") then var TRAP.DIFFICULTY 5
     if ("%TRAP.TYPE" = "boomer") then var TRAP.DIFFICULTY 5
     if ("%TRAP.TYPE" = "scythe") then var TRAP.DIFFICULTY 5
     if ("%TRAP.TYPE" = "shocker") then var TRAP.DIFFICULTY 4
     if ("%TRAP.TYPE" = "poison_local") then var TRAP.DIFFICULTY 4
     if ("%TRAP.TYPE" = "poison_nerve") then var TRAP.DIFFICULTY 3
     if ("%TRAP.TYPE" = "curse") then var TRAP.DIFFICULTY 2
     if ("%TRAP.TYPE" = "poison_bolt") then var TRAP.DIFFICULTY 2
     if ("%TRAP.TYPE" = "bolt") then var TRAP.DIFFICULTY 1
     if ("%TRAP.TYPE" = "cyanide") then var TRAP.DIFFICULTY 1
     if ("%TRAP.TYPE" = "frog") then var TRAP.DIFFICULTY 0
     if ("%TRAP.TYPE" = "flea") then var TRAP.DIFFICULTY -1
     if ("%TRAP.TYPE" = "shadowling") then var TRAP.DIFFICULTY -2
     if ("%TRAP.TYPE" = "bouncer") then var TRAP.DIFFICULTY -2
     if ("%TRAP.TYPE" = "mime") then var TRAP.DIFFICULTY -2
     if ("%TRAP.TYPE" = "laughing") then var TRAP.DIFFICULTY -3
     if ("%TRAP.TYPE" = "sleeper") then var TRAP.DIFFICULTY -3
     if ("%TRAP.TYPE" = "mana_sucker") then var TRAP.DIFFICULTY -3
     if matchre("$guild", "%MAGICUSER") then
          {
          if ("%TRAP.TYPE" = "mana_sucker") then var TRAP.DIFFICULTY 5
          if ("%TRAP.TYPE" = "shadowling") then var TRAP.DIFFICULTY 3
          }
     if ("%TRAP.TYPE" = "NULL") then var TRAP.DIFFICULTY 5
# computing...
     pause 0.00001
     var MODE normal
     echo 
     echo ####################
	echo * ~Computing Trap Mode~...
	echo * Trap Type: %TRAP.TYPE
     echo * Trap Base Difficulty: %TRAP.DIFFICULTY
     echo * Appraise Difficulty:  %APP.DIFFICULTY
	echo * Baseline Difficulty:  %BASELINE.DIFFICULTY
     evalmath TOTAL.DIFFICULTY (%TOTAL.DIFFICULTY + %BASELINE.DIFFICULTY)
     evalmath TOTAL.DIFFICULTY (%TOTAL.DIFFICULTY + %TRAP.DIFFICULTY)
     evalmath TOTAL.DIFFICULTY (%TOTAL.DIFFICULTY + %APP.DIFFICULTY)
     if (%TOTAL.DIFFICULTY < -12) then var MODE blind
     if (%TOTAL.DIFFICULTY = -12) then var MODE blind
     if (%TOTAL.DIFFICULTY = -11) then var MODE quick
     if (%TOTAL.DIFFICULTY = -10) then var MODE quick
     if (%TOTAL.DIFFICULTY = -9) then var MODE quick
     if (%TOTAL.DIFFICULTY = -8) then var MODE quick
     if (%TOTAL.DIFFICULTY = -7) then var MODE quick
     if (%TOTAL.DIFFICULTY = -6) then var MODE quick
     if (%TOTAL.DIFFICULTY = -5) then var MODE quick
     if (%TOTAL.DIFFICULTY = -4) then var MODE quick
     if (%TOTAL.DIFFICULTY = -3) then var MODE quick
     if (%TOTAL.DIFFICULTY = -2) then var MODE quick
     if (%TOTAL.DIFFICULTY = -1) then var MODE normal
     if (%TOTAL.DIFFICULTY = 0) then var MODE normal
     if (%TOTAL.DIFFICULTY = 1) then var MODE normal
     if (%TOTAL.DIFFICULTY = 2) then var MODE normal
     if (%TOTAL.DIFFICULTY = 3) then var MODE normal
     if (%TOTAL.DIFFICULTY = 4) then var MODE normal
     if (%TOTAL.DIFFICULTY = 5) then var MODE normal
     if (%TOTAL.DIFFICULTY = 6) then var MODE normal
     if (%TOTAL.DIFFICULTY = 7) then var MODE careful
     if (%TOTAL.DIFFICULTY = 8) then var MODE careful
     if (%TOTAL.DIFFICULTY = 9) then var MODE careful
     if (%TOTAL.DIFFICULTY = 10) then var MODE careful
     if (%TOTAL.DIFFICULTY = 11) then var MODE careful
     if (%TOTAL.DIFFICULTY = 12) then var MODE careful
     if (%TOTAL.DIFFICULTY = 13) then var MODE careful
     if (%TOTAL.DIFFICULTY = 14) then var MODE careful
     if (%TOTAL.DIFFICULTY = 15) then var MODE careful
     if (%TOTAL.DIFFICULTY = 16) then var MODE careful
     if (%TOTAL.DIFFICULTY = 17) then var MODE careful
     if (%TOTAL.DIFFICULTY = 18) then var MODE careful
     if (%TOTAL.DIFFICULTY = 19) then var MODE toss
     if (%TOTAL.DIFFICULTY = 20) then var MODE toss
     if (%TOTAL.DIFFICULTY = 21) then var MODE toss
     if (%TOTAL.DIFFICULTY = 22) then var MODE toss
     if (%TOTAL.DIFFICULTY = 23) then var MODE toss
     if (%TOTAL.DIFFICULTY > 23) then var MODE toss
     echo ~~~~~~~~~~~~~~~~~~~~~
     echo *
     echo * FINAL DIFFICULTY: %TOTAL.DIFFICULTY 
     echo *
     echo * USING MODE: %MODE
     echo ####################
     echo
## SAVES COUNTER FOR EACH TRAP TYPE
     if ("%TRAP.TYPE" = "concussion") then math concussion.count add 1
     if ("%TRAP.TYPE" = "teleport") then math teleport.count add 1
     if ("%TRAP.TYPE" = "shrapnel") then math shrapnel.count add 1
     if ("%TRAP.TYPE" = "disease") then math disease.count add 1
     if ("%TRAP.TYPE" = "reaper") then math reaper.count add 1
     if ("%TRAP.TYPE" = "fire_ant") then math fire_ant.count add 1
     if ("%TRAP.TYPE" = "gas") then math gas.count add 1
     if ("%TRAP.TYPE" = "lightning") then math lightning.count add 1
     if ("%TRAP.TYPE" = "naphtha_soaker") then math naphtha_soaker.count add 1
     if ("%TRAP.TYPE" = "naphtha") then math naphtha.count add 1
     if ("%TRAP.TYPE" = "acid") then math acid.count add 1
     if ("%TRAP.TYPE" = "boomer") then math boomer.count add 1
     if ("%TRAP.TYPE" = "scythe") then math scythe.count add 1
     if ("%TRAP.TYPE" = "shocker") then math shocker.count add 1
     if ("%TRAP.TYPE" = "poison_local") then math poison_local.count add 1
     if ("%TRAP.TYPE" = "poison_nerve") then math poison_nerve.count add 1
     if ("%TRAP.TYPE" = "curse") then math curse.count add 1
     if ("%TRAP.TYPE" = "poison_bolt") then math poison_bolt.count add 1
     if ("%TRAP.TYPE" = "bolt") then math bolt.count add 1
     if ("%TRAP.TYPE" = "cyanide") then math cyanide.count add 1
     if ("%TRAP.TYPE" = "frog") then math frog.count add 1
     if ("%TRAP.TYPE" = "flea") then math flea.count add 1
     if ("%TRAP.TYPE" = "bouncer") then math bouncer.count add 1
     if ("%TRAP.TYPE" = "laughing") then math laughing.count add 1
     if ("%TRAP.TYPE" = "sleeper") then math sleeper.count add 1
     if ("%TRAP.TYPE" = "mime") then math mime.count add 1
     if ("%TRAP.TYPE" = "mana_sucker") then math mana_sucker.count add 1
     if ("%TRAP.TYPE" = "shadowling") then math shadowling.count add 1
     return
#################################################################################################################
TOP:
     var STARTING.ROOM $roomid
     echo
     echo ################
     echo * Initializing Script
     echo * SHROOM'S SMART DISARM
     echo * VERSION %version
     echo ################
     echo
     pause 0.01
	if ($hidden = 1) then
          {
               send shiver
               pause 0.3
          }
     pause 0.0001
     put stop play
     pause 0.1
     gosub STOWING
     pause 0.0001
     put open my %CONTAINER1
     pause 0.1
     pause 0.0001
     put open my %CONTAINER2
     pause 0.03
     pause 0.0001
     pause 0.0001
     put open my %CONTAINER3
     wait
     pause 0.001
     if ("$guild" = "Warrior") then put #var guild Warrior Mage
     if ("$guild" = "Moon") then put #var guild Moon Mage
     if (!def(guild) || !matchre("$guild","(Thief|Barbarian|Empath|Warrior Mage|Cleric|Bard|Moon Mage|Ranger|Necromancer|Trader)")) then
          {
               action var guild $1;put #var guild $1 when Guild\: (\S+)
               send info;encum
               waitforre ^\s*Encumbrance\s*\:
               action remove Guild\: (\S+)
          }
     if ("$guild" = "Thief") then var DISMANTLE thump
     if ("$guild" = "Barbarian") then
          {
               var DISMANTLE bash
               gosub MEDITATE_CHECK
          }
     if ("$guild" = "Bard") then var DISMANTLE shriek
     if ("$guild" = "Cleric") then var DISMANTLE pray
     if ("$guild" = "Warrior Mage") then var DISMANTLE fire
     if ("$guild" = "Moon Mage") then var DISMANTLE focus
     if ("$guild" = "Ranger") then var DISMANTLE whistle
     if ("$guild" = "Trader") then var DISMANTLE salvage
     if ("$guild" = "Empath") then var DISMANTLE
     if ("$guild" = "Necromancer") then var DISMANTLE
     if ("$guild" = "Necromancer") then gosub JUSTICE_CHECK
     echo
     echo ~~~~~~~~~~~~~~
     echo * Guild: $guild
     echo * Dismantle Type: %DISMANTLE
     echo ~~~~~~~~~~~~~~
     echo
     if ("$guild" = "Necromancer") then
          {
               gosub PUT release eotb
               pause 0.0001
          }
     if ("$guild" = "Thief") then
          {
               gosub PUT khri stop silence vanish
               pause 0.0001
          }
     if matchre("$guild", "(Moon Mage|Moon)") then
          {
               gosub PUT release rf
               pause 0.0001
          }
     if matchre("$guild", "Ranger") then
          {
               gosub PUT release blend
               pause 0.0001
          }
### CHECK FOR PRESENCE OF A SKELETON KEY BEFORE STARTUP
### IF SKELETON KEY EXISTS SET havekey to 1
KEY_CHECK:
     echo
     echo * Skeleton key check
     echo
     matchre KEY_CHECK ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre KEY_CHECK ^You can't do that while entangled in a web
     matchre KEY_CHECK ^You are still stunned
     matchre KEY_CHECK ^You don't seem to be able to move to do that
     matchre KEY_CHECK_ALT ^What were you|^I could not
     matchre HAVE_KEY ^You tap
     put tap my skeleton key
     matchwait 5
     goto initial_Check
KEY_CHECK_ALT:
     matchre KEY_CHECK ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre KEY_CHECK ^You can't do that while entangled in a web
     matchre KEY_CHECK ^You are still stunned
     matchre KEY_CHECK ^You don't seem to be able to move to do that
     matchre KEY_CHECK_2 ^What were you|^I could not
     matchre HAVE_KEY ^You tap
     put tap my skeleton key in my portal
     matchwait 5
     goto initial_Check
KEY_CHECK_2:
     matchre KEY_CHECK ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre KEY_CHECK ^You can't do that while entangled in a web
     matchre KEY_CHECK ^You are still stunned
     matchre KEY_CHECK ^You don't seem to be able to move to do that
     matchre initial_Check ^What were you|^I could not
     matchre KEY_CHECK_2_ALT ^You tap
     put tap my gais key
     matchwait 5
     goto initial_Check
KEY_CHECK_2_ALT:
     matchre KEY_CHECK ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre KEY_CHECK ^You can't do that while entangled in a web
     matchre KEY_CHECK ^You are still stunned
     matchre KEY_CHECK ^You don't seem to be able to move to do that
     matchre initial_Check ^What were you|^I could not
     matchre HAVE_KEY_2 ^You tap
     put tap my gais key in my portal
     matchwait 5
     goto initial_Check
HAVE_KEY:
     var havekey 1
     var key_type skeleton
     echo
     echo * Have Skeleton Key! 
     echo * Type: %key_type
     echo
     goto initial_Check
HAVE_KEY_2:
     var havekey 1
     var key_type gais
     echo
     echo * Have Skeleton Key! 
     echo * Type: %key_type
     echo
     goto initial_Check
     
initial_Check:
     pause 0.00001
     if matchre("%GIVEBOX", "(?i)(YES|ON|1)") then goto main
     gosub init_BagCheck %CONTAINER1
     pause 0.0001
     gosub init_BagCheck %CONTAINER2
     pause 0.0001
     gosub init_BagCheck %CONTAINER3
     pause 0.0001
     gosub init_BagCheck %SHEATH
     pause 0.0001
     if (%BOX = 0) then goto DONE
     goto armor_Check
init_BagCheck:
     var container $0
     pause 0.00001
     if (%BOX = 1) then goto armor_Check
          matchre init_BagCheck ^\.\.\.wait|^Sorry,
		matchre boxes_Yes (brass|copper|deobar|driftwood|iron|ironwood|mahogany|oaken|pine|steel|wooden) (?:coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|(?<!(?i)training )box)
          matchre init_BagCheckAlt ^You'll need to be holding
		matchre RETURN Encumbrance
	send rummage in my %container;enc
	matchwait
init_BagCheckAlt:
     var container eddy
     pause 0.00001
          matchre init_BagCheck ^\.\.\.wait|^Sorry,
		matchre boxes_Yes (brass|copper|deobar|driftwood|iron|ironwood|mahogany|oaken|pine|steel|wooden) (?:coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|(?<!(?i)training )box)
          matchre init_BagCheckAlt ^You'll need to be holding
		matchre RETURN Encumbrance
	send rummage in my %container;enc
	matchwait
boxes_Yes:
     var BOX 1
     return
     
armor_Check:
     counter set 0
     action var ExoShieldType $1 when ^You shake your .+ causing it to break apart into thousands of live spiders\.\s+The swarm of arachnids scuttles quickly up your arm, nestling themselves on your person until they finally melt and coagulate into a (.*)\.$
hand_Check:
     pause 0.00001
     matchre remove_Armor (hand wraps|handwraps|knuckles|hand claws|knuckleguards|claws)
     matchre armor_Check1 You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
     put inv hand weapon
     matchwait 15
     goto armor_Check1
armor_Check1:
     pause 0.0001
     pause 0.00001
     matchre remove_Armor \bhelm|((?<=field|fluted|full|half|war|battle|lamellar|Imperial|kiralan|blue|blackened|jousting|silver|white|lunated|sniper's|icesteel|goffered|fluted|polished) (\bplate\b)(?! armor| gauntlets| gloves| greaves| helm| mask| balaclava| shirt)|(?>ice)steel plate(?! armor| gauntlets| gloves| greaves| helm| mask))|(?<=field|assassin's|chain|leather|bone|quilted|reed|black|plate|combat|body|clay|lamellar|hide|steel|mail|pale|polished|shadow|Suit of|suit|woven|yeehar-hide|kidskin|gladiatorial|sniper|sniper's|battle|tomiek|glaes|pale|ceremonial|sinuous|trimmed|carapace|Zaulguum-skin|coral|dark|violet|ridged) (\barmor\b)|armet(?! helm)|abyssium skull|gauntlet|gloves|(?!pavise)shield\b|claw guards|kimono|odaj|(?<!ka'hurst )mail gloves|platemail legs|saucer|trousers|parry stick|leggings|handwraps|gown|\bhat\b|hand claws|boots|armguard|jacket|goggle|armwraps|footwraps|aegis|torso|buckler|\bhood\b|\bcowl\b|\bheater(?! shield)|\bpavise(?! shield)|scutum|sipar|sandskin spider|\btarge\b|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|longcoat|legwraps|\bcoat\b|\bcowl|cuirass|fauld|greaves|hauberk|\bhood\b|jerkin|leathers|lorica|mantle|(?<!crimson leather )\bmask\b|morion|pants|handguards|bodysuit|robe|sallet|(?<!fighting )shirt|sleeves|ticivara|tabard|tasset|thorakes|\blid\b|vambraces|vest\b|caftan|collar\b|coif|mitt\b|steel mail(?! armor| gauntlets| gloves| greaves| helm| mask| balaclava| shirt)|darkened mail|augmented mail|gais lotus|galea|velnhliwa|bamarhliwa|shalhliwa|tunic|chausses|carapace(?! armor)
     matchre armor_None You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
     put inv armor
	matchwait 3
armor_Checking:
     pause 0.0001
     matchre armor_Checking ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre remove_Armor \bhelm|((?<=field|fluted|full|half|war|battle|lamellar|Imperial|kiralan|blue|blackened|jousting|silver|white|lunated|sniper's|icesteel|goffered|fluted|polished) (\bplate\b)(?! armor| gauntlets| gloves| greaves| helm| mask| balaclava| shirt)|(?>ice)steel plate(?! armor| gauntlets| gloves| greaves| helm| mask))|(?<=field|assassin's|chain|leather|bone|quilted|reed|black|plate|combat|body|clay|lamellar|hide|steel|mail|pale|polished|shadow|Suit of|suit|woven|yeehar-hide|kidskin|gladiatorial|sniper|sniper's|battle|tomiek|glaes|pale|ceremonial|sinuous|trimmed|carapace|Zaulguum-skin|coral|dark|violet|ridged) (\barmor\b)|armet(?! helm)|abyssium skull|gauntlet|gloves|(?!pavise)shield\b|claw guards|kimono|odaj|(?<!ka'hurst )mail gloves|platemail legs|saucer|trousers|parry stick|leggings|handwraps|gown|\bhat\b|hand claws|boots|armguard|jacket|goggle|armwraps|footwraps|aegis|torso|buckler|\bhood\b|\bcowl\b|\bheater(?! shield)|\bpavise(?! shield)|scutum|sipar|sandskin spider|\btarge\b|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|longcoat|legwraps|\bcoat\b|\bcowl|cuirass|fauld|greaves|hauberk|\bhood\b|jerkin|leathers|lorica|mantle|(?<!crimson leather )\bmask\b|morion|pants|handguards|bodysuit|robe|sallet|(?<!fighting )shirt|sleeves|ticivara|tabard|tasset|thorakes|\blid\b|vambraces|vest\b|caftan|collar\b|coif|mitt\b|steel mail(?! armor| gauntlets| gloves| greaves| helm| mask| balaclava| shirt)|darkened mail|augmented mail|gais lotus|galea|velnhliwa|bamarhliwa|shalhliwa|tunic|chausses|carapace(?! armor)
     matchre Armor_Complete You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
     put inv armor
	matchwait 4
	goto Armor_Complete
remove_Armor:
     var armor $0
     var LAST remove_Armor_1
remove_Armor_1:
     pause 0.0001
     pause 0.0001
     matchre remove_Armor_1 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre stow_Armor (You'?r?e?|As|With) (?:accept|add|adjust|allow|already|are|aren't|ask|attach|attempt|.+ to|.+ fan|bash|begin|bend|blow|breathe|briefly|bundle|cannot|can't|chop|circle|close|corruption|count|combine|come|carefully|dance|decide|dodge|don't|drum|draw|effortlessly|gracefully|deftly|desire|detach|drop|drape|exhale|fade|fail|fake|feel(?! fully rested)|feint|fill|find|filter|form|fumble|gesture|gingerly|get|glance|grab|hand|hang|have|icesteel|insert|kiss|kneel|knock|leap|lean|let|lose|lift|loosen|lob|load|move|must|mind|not|now|need|offer|open|parry|place|pick|push|pout|pour|put|pull|press|quietly|quickly|raise|read|reach|ready|realize|recall|remain|release|remove|retreat|reverently|roll|rub|scan|search|secure|sense|set|sheathe|shield|shouldn't|shove|silently|sit|slide|sling|slip|slowly|spin|spread|sprinkle|stop|strap|struggle|swiftly|swing|switch|tap|take|the|though|tie|tilt|toss|trace|try|tug|turn|twist|unload|untie|vigorously|wave|wear|weave|whisper|will|wink|wring|work|yank|you|zills) .*(?:\.|\!|\?)?
     matchre stow_Armor ^Without any effort|the .* slide off|tug the .* free|Shaking your head|^Wiggling|slide themselves off|The carapace armor pulls itself into your hand|A brisk chill
     matchre get_Armor ^The .+ shakes violently
     matchre get_Armor ^You have nothing of that|^Remove what|^What|^I could|^Please
     put remove %armor
     matchwait 8
get_Armor:
     pause 0.0001
     pause 0.0001
     matchre get_Armor ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre stow_Armor (You'?r?e?|As|With) (?:accept|add|adjust|allow|already|are|aren't|ask|attach|attempt|.+ to|.+ fan|bash|begin|bend|blow|breathe|briefly|bundle|cannot|can't|chop|circle|close|corruption|count|combine|come|carefully|dance|decide|dodge|don't|drum|draw|effortlessly|gracefully|deftly|desire|detach|drop|drape|exhale|fade|fail|fake|feel(?! fully rested)|feint|fill|find|filter|form|fumble|gesture|gingerly|get|glance|grab|hand|hang|have|icesteel|insert|kiss|kneel|knock|leap|lean|let|lose|lift|loosen|lob|load|move|must|mind|not|now|need|offer|open|parry|place|pick|push|pout|pour|put|pull|press|quietly|quickly|raise|read|reach|ready|realize|recall|remain|release|remove|retreat|reverently|roll|rub|scan|search|secure|sense|set|sheathe|shield|shouldn't|shove|silently|sit|slide|sling|slip|slowly|spin|spread|sprinkle|stop|strap|struggle|swiftly|swing|switch|tap|take|the|though|tie|tilt|toss|trace|try|tug|turn|twist|unload|untie|vigorously|wave|wear|weave|whisper|will|wink|wring|work|yank|you|zills) .*(?:\.|\!|\?)?
     matchre stow_Armor ^Without any effort|the .* slide off|tug the .* free|Shaking your head|^Wiggling|slide themselves off|The carapace armor pulls itself into your hand|A brisk chill
     matchre armor_Checking ^You have nothing of that|^Remove what|^What|^I could|^Please
     put get my %armor
     matchwait 9
     put #echo >Log #ff0000 *** MISSING MATCH IN GET_ARMOR!
     put #parse MISSING MATCH IN GET_ARMOR
     goto STOW_ARMOR

stow_Armor:
     pause 0.1
     pause 0.1
     pause 0.1
     pause 0.0001
     if matchre("$righthand $lefthand" "(\w+) orb\b") then
          {
               var orbtype $1
               pause 0.3
               var armor %orbtype orb
               echo
               echo * SETTING ARMOR VAR TO: %orbtype orb
               echo
               pause 0.3
          }
     if matchre("$righthand $lefthand" "(\w+\-?\w+) ring\b$") then
          {
               var ringtype $1
               pause 0.3
               var armor %ringtype ring
               echo
               echo * SETTING ARMOR VAR TO: %ringtype ring
               echo
               pause 0.3
          }
     if !matchre("%TIECONTAINER", "\b(?i)(NULL|NIL)\b") && matchre("$righthand $lefthand", "%TIECONTAINER.ITEMS") then goto Tie_Armor
stow_Armor_1:
     var armorcontainer %CONTAINER1
	var LAST stow_Armor_1
     pause 0.0001
     pause 0.0001
	matchre stow_Armor ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre stow_Armor_2 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
     matchre stow_Armor_2 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't|As you attempt to place your
	matchre armor_Done ^You put your|^What
	put put my %armor in my %CONTAINER1
	matchwait 7
stow_Armor_2:
     var armorcontainer %CONTAINER2
	var LAST stow_Armor_2
     pause 0.0001
     pause 0.1
     pause 0.0001
	matchre stow_Armor_2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre stow_Armor_3 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
     matchre stow_Armor_3 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't|As you attempt to place your
	matchre armor_Done ^You put your|^What
	put put my %armor in my %armorcontainer
	matchwait 7
stow_Armor_3:
     var armorcontainer %CONTAINER3
	var LAST stow_Armor_3
     pause 0.0001
     pause 0.1
     pause 0.0001
	matchre stow_Armor_3 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre Tie_Armor ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
     matchre Tie_Armor ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't|As you attempt to place your
	matchre armor_Done ^You put your|^What
	put put my %armor in my %armorcontainer
	matchwait 7
Tie_Armor:
     if matchre("%TIECONTAINER", "\b(?i)(NULL|NIL|NO)\b") then goto stow_Armor_4
	var LAST stow_Armor_2
     pause 0.1
     pause 0.0001
     pause 0.0001
	matchre Tie_Armor ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre stow_Armor_4 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
     matchre stow_Armor_4 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't|As you attempt to place your
	matchre armor_Done You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
	put tie my %armor to my %TIECONTAINER
	matchwait 7
stow_Armor_4:
	var LAST stow_Armor_4
     pause 0.0001
     pause 0.1
     pause 0.0001
     matchre stow_Armor_4 ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre stow_Armor_4 ^You don't seem to be able to move to do that
     matchre stow_Armor_4 ^You can't do that while entangled in a web
     matchre stow_Armor_4 ^You are still stunned
     matchre no_More_Stowing ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
     matchre no_More_Stowing ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't|As you attempt to place your
     matchre no_More_Stowing ^You can't wear any more items like that\.
     matchre no_More_Stowing ^You can't wear that\!
     matchre no_More_Stowing ^You need at least one free hand for that\.
     matchre no_More_Stowing ^This .* can't fit over the .* you are already wearing which also covers and protects your .*\.
     matchre armor_Done You'?r?e? (?:hand|slip|put|get|.+ to|.+ fan|can't|leap|tug|quickly|dance|gracefully|reverently|breathe|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|tap|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|effortlessly|corruption|count|secure|detach|unload|briefly|zills|remain|release|shield) .*(?:\.|\!|\?)?
     matchre armor_Done ^What were you referring to\?|^Please rephrase
     matchre armor_Done ^Wear what\?
     matchre armor_Done Roundtime
     matchre armor_Done ^The .* (is|are|slides)
     matchre armor_Done ^Without (any|a)
	matchre armor_Done ^You put your|^What
	put wear my %armor
	matchwait 9
     goto armor_Done
armor_Done:
     counter add 1
     var total_armor %c
     var armor%c %armor
     var armor%cContainer %armorcontainer
     goto armor_Checking
armor_None:
     ECHO **** NO ARMOR FOUND!
     var ARMOR_STOW OFF
     goto lock.check
Armor_Complete:
     var ARMOR_STOW ON
     ECHO #######################################
     ECHO # Removed all armor
     ECHO # Saved Armor Count: %total_armor
     if (%total_armor < 1) then
          {
               ECHO # NO ARMOR FOUND
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor1: %armor1
     if (%total_armor < 2) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor2: %armor2
     if (%total_armor < 3) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor3: %armor3
     if (%total_armor < 4) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor4: %armor4
     if (%total_armor < 5) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor5: %armor5
     if (%total_armor < 6) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor6: %armor6
     if (%total_armor < 7) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor7: %armor7
     if (%total_armor < 8) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor8: %armor8
     if (%total_armor < 9) then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor9: %armor9
     if (%total_armor < 10)  then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor10: %armor10
     if (%total_armor < 11)  then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor11: %armor11
     if (%total_armor < 12)  then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor12: %armor12
     if (%total_armor < 13)  then
          {
               ECHO #######################################
               goto lock.check
          }
     ECHO # Armor13: %armor13
     ECHO #######################################
     ECHO
     pause 0.1
     goto lock.check
no_More_Stowing:
     echo
     echo ** ERROR - BAGS ARE FULL !!!!
	echo ** NO ROOM FOR STOWING ARMOR - EXITING SCRIPT! 
     echo ** MAKE ROOM IN YOUR BAGS AND/OR GET LARGER CONTAINERS!!!
	echo
     put wear %armor
     pause 0.5
	goto done
lock.check:
	if matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then gosub lockpick_ring_check
     if ("$guild" = "Barbarian") then 
          {
               if (%yogi = 0) then send kneel
               pause 0.3
               send meditate focus
               pause 2
               pause
               if (!$standing) then gosub stand
          }
	goto main

###########################################################
##
## MAIN SCRIPT LOOP HERE!
##
###########################################################

main:
     var TRAP.TYPE NULL
     var disarmed 0
	pause 0.00001
     if matchre("%GIVEBOX", "(?i)(YES|ON|1)") then
          {
               put whisper %user Ready for a box!
               put nod %user
               waitfor offers you
               pause 0.4
               send accept
               pause
          }
	if (!matchre("%KEEP.PICKING", "(?i)(YES|ON|1)") && !matchre("%GIVEBOX", "(?i)(YES|ON|1)")) then
          {
               if ($Locksmithing.LearningRate > 33) then goto LOCKED_SKILLS
          }
     if (("$guild" = "Thief") && ($concentration > 50)) then
		{
                 pause 0.0001
                 if ($Augmentation.Ranks < 180) then send kneel
                 pause 0.0001
                 send khri %KHRI
                 pause 0.4
                 pause 0.1
                 if (!$standing) then gosub stand
		}
	if (matchre("$lefthand", "Empty") && !matchre("$righthand", "%box_types")) then gosub container_Check
	if ("$lefthand" = "Empty") then
		{
			send swap
               wait
               pause 0.00001
               pause 0.00001
		}
	else
		{
			gosub STOW left
               pause 0.2
			send swap
               wait
               pause 0.00001
		}
	pause 0.00001
disarm_sub:
     action (lock) off 
     var TRAP.TYPE NULL
     var MODE normal
     if matchre("$righthand", "%box_types") then
          {
               put swap
               wait
               pause 0.0001
          }
     ## OLD OBSOLETE GLANCE RT HACK - NO LONGER WORKS
	# if ("$guild" = "Thief") then gosub glance_box
     if (matchre("%SKELETON.KEY", "(?i)(YES|ON|1)") || (($Locksmithing.LearningRate > 28) && (%havekey = 1))) then
          {
               echo
               echo ########
               echo * USING SKELETON KEY!
               echo ########
               echo
               put get my %key_type key
               wait
               pause 0.00001
               pause 0.00001
               if !matchre("$righthand $lefthand", "\bkey") then
                    {
                         put get my %key_type key from my portal
                         wait
                         pause 0.1
                    }
               if !matchre("$righthand $lefthand", "\bkey") then
                    {
                         put get my gais key
                         wait
                         pause 0.1
                    }
               if !matchre("$righthand $lefthand", "\bkey") then
                    {
                         put get my gais key from my portal
                         wait
                         pause 0.3
                    }
               if !matchre("$righthand $lefthand", "\bkey") then
                    {
                         echo
                         echo * ERROR LOCATING SKELETON KEY! REVERTING TO NORMAL DISARM
                         echo
                         var SKELETON.KEY OFF
                         var havekey 0
                         goto disarm_sub_2
                    }
               pause 0.00001
               put turn my key at my %disarmit
               wait
               pause 0.00001
               gosub put_Away_Pick
               gosub loot
               gosub DISMANTLE
               pause 0.01
               gosub exp_Check
               goto MAIN
          }
## MAIN DISARM LOGIC
disarm_sub_2:
     pause 0.00001
     gosub disarm_ID
     pause 0.00001
     if ("%TRAP.TYPE" = "UNKNOWN") then goto disarm_sub_2
     if ("%TRAP.TYPE" = "NULL") then goto lock_sub
     ## ANALYZE TRAP DIFFICULTY
     # debug 5
     gosub trap_diff_compute
	if ("%MODE" = "toss") then goto toss_box
     if matchre("$righthand", "%box_types") then
          {
               put swap
               wait
               pause 0.7
          }
	gosub disarm
	var disarm.count 0
	var harvest.count 0
	if matchre("%HARVEST", "(?i)(YES|ON|1)") then gosub analyze
	if matchre("%multi_trap", "(?i)(YES|ON|1)") then goto disarm_sub
	if (($roomid != %STARTING.ROOM) && matchre("%MOVE.ROOMS", "(?i)(YES|ON|1)")) then
		{
			gosub automove %STARTING.ROOM
			pause 0.1
		}
     if matchre("%GIVEBOX", "(?i)(YES|ON|1)") then goto GIVEBOX
lock_sub:
     gosub clear
     action (lock) on
     if matchre("$righthand", "%box_types") then
          {
               put swap
               wait
               pause 0.7
               pause 0.2
          }
     if !matchre("$righthand", "Empty") then gosub stow right
	if !matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then gosub get_Pick
	# if ("$guild" = "Thief") then gosub glance_box
     pause 0.00001
     var pickloop 0
	gosub pick_ID
     pause 0.00001
	# if ("%MODE" = "toss") then goto toss_box
	gosub pick
     pause 0.00001
	if matchre("%multi_lock", "(?i)(YES|ON|1)") then goto lock_sub
	if !matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then gosub put_Away_Pick
     if matchre("$righthand $lefthand", "key") then gosub put_Away_Pick
     action (lock) off
GIVEBOX:
     if matchre("%GIVEBOX", "(?i)(YES|ON|1)") then
          {
               if ("$righthand" = "Empty") then send swap
               pause 0.5
               pause 0.3
               put give %user
               waitfor accepts
               goto Continued
          }
     pause 0.1
     if matchre("%AUTOLOOT", "(?i)(YES|ON|1)") then gosub loot
	gosub DISMANTLE
     pause 0.01
Continued:
	if ("$guild" = "Thief") then gosub fix_Lock
     #gosub loot_Check
	gosub exp_Check
     pause 0.0001
	goto main

container_Check:
	var LAST container_Check
     gosub container_BagCheck %CONTAINER1
     pause 0.5
     pause 0.1
container_Check1:
	var LAST container_Check1
     if matchre("$righthand $lefthand", "%box_types") then return
     gosub container_BagCheck %CONTAINER2
     pause 0.5
     pause 0.1
container_Check2:
	var LAST container_Check2
     if matchre("$righthand $lefthand", "%box_types") then return
     gosub container_BagCheck %CONTAINER3
     pause 0.5
     pause 0.1
container_Check3:
	var LAST container_Check3
     if matchre("$righthand $lefthand", "%box_types") then return
     gosub container_BagCheck %SHEATH
     pause 0.5
     pause 0.1
     if matchre("$righthand $lefthand", "%box_types") then return
     goto LOCKED_SKILLS
	
petContainer_Check:
     pause 0.1
     gosub container_BagCheck %disarmBag
     if matchre("$righthand $lefthand", "%box_types") then return
     goto LOCKED_SKILLS

### CHECKING CONTAINER FOR BOXES
container_BagCheck:
     var container $0
     pause 0.1
     matchre container_Check ^\.\.\.wait|^Sorry,
     matchre get_For_Disarm %box_types
     matchre container_BagCheckAlt Assuming you mean a swirling eddy|You'll need to be holding
     matchre container_BagCheck2 Encumbrance
     matchre RETURN There's nothing inside 
	send inv my %container;-0.2 encum
	matchwait 5
container_BagCheck2:
     pause 0.4
     pause 0.1
     matchre container_BagCheck2 ^\.\.\.wait|^Sorry,
     matchre get_For_Disarm %box_types
     matchre container_BagCheckAlt Assuming you mean a swirling eddy|You'll need to be holding
	matchre container_BagCheckAlt Encumbrance
     matchre RETURN ^You rummage through .+ but there is nothing
	send rummage in my %container;-0.2 encum
	matchwait 5
container_BagCheckAlt:
     var container eddy
     pause 0.2
     pause 0.5
     pause 0.2
     matchre container_BagCheckAlt ^\.\.\.wait|^Sorry,
     matchre get_For_Disarm %box_types
	matchre RETURN Encumbrance
	send inv my %container;-1 enc
	matchwait 5
     echo
     echo *** NO BOX FOUND IN %container
     echo
     return
	
PETBOX_ERROR:
     echo
     echo =======================
     echo * PET BOX ERROR! BOX IS NOT DISARMED?
     echo =======================
     echo
     pause 0.2
     send put my %disarmit in my %CONTAINER1
     pause 0.0001
     pause 0.0001
     if !matchre("$righthand $lefthand", "%box_types") then goto main
     if matchre("$righthand $lefthand", "%box_types") then send put my %disarmit in my %CONTAINER2
     pause 0.3
     if matchre("$righthand $lefthand", "%box_types") then send put my %disarmit in my %CONTAINER3
     pause 0.3
     goto main
     
### GET BOX FROM CONTAINER
get_For_Disarm:
	var disarmit $0
     var disarm.noun $2
     if matchre("%container", "eddy") then var container portal
	get.Box:
	pause 0.0001
     pause 0.0001
		var LAST get_For_Disarm
			matchre get.Box ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
			matchre return You get|You are already
			matchre container_Check ^What were you
		send get my %disarmit from my %container
		matchwait 3
get_For_Disarm2:
	pause 0.2
     pause 0.1
	send turn my %container to 1
	pause 0.5
	pause 0.2
		var LAST get_For_Disarm2
			matchre get_For_Disarm2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
			matchre return You get|You are already|You pull
			matchre container_Check ^What were you
		send pull my %container
		matchwait 4
		goto container_Check

weapon:
     var LAST WEAPON
     pause 0.0001
     matchre weapon ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre stow_Weapon You
     matchre weapon1 Remove what?
     put remove %KNUCKLES
	matchwait
weapon1:
	var LAST weapon1
	matchre weapon1 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
	matchre stow_Weapon You|Remove
     put remove handwrap
	matchwait
stow_Weapon:
	var LAST stow_Weapon
	matchre stow_Weapon ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
	matchre stow_Weapon2 There isn't any more room
     matchre SAVE ^You|Stow
	put stow %KNUCKLES;stow handwrap
	matchwait
stow_Weapon2:
	var LAST stow_Weapon2
	matchre stow_Weapon2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
	matchre SAVE ^You|Stow
	put stow %KNUCKLES in %CONTAINER1;stow handwr in %CONTAINER1
	matchwait 5
     goto %SAVE

glance_box:
	var LAST glance_box
     var failcount 0
     pause 0.1
     pause 0.001
	send glance my $lefthandnoun
	wait
	pause 0.0001
	return

Stop_Play:
     pause 0.0001
     put stop play
     pause 0.1
disarm_ID:
     action (id) on
     var SAVE disarm_ID
	var LAST disarm_ID
	var APP.DIFFICULTY 0
	var TRAP.DIFFICULTY 0
	var disarm.count 0
     var harvest.count 0
     var disarmed 0
     pause 0.00001
     matchre Stop_Play ^You are a bit too busy performing
     matchre ID_FAIL ^You get the distinct feeling your careless|This is not likely to be a good
	matchre disarm_ID ^\.\.\.wait
     matchre disarm_ID ^Sorry\,|^I could not|^Please rephrase
     matchre Not_Box ^You don't see any reason to attempt to disarm that
	matchre weapon hinders your attempt|KNUCKLES|handwraps|hand claws
	matchre disarm_ID fails to reveal to you|^You are still stunned
	matchre HEALTH You're in no shape
     matchre DISARMED ^An incredibly sharp blade rests off to the side in the casing of the .*\, indicating the trap is no longer a danger\.
     matchre DISARMED ^A broken spring is sticking out of a hidden seam on the front of the .*\.\s+It is no longer attached to a razor\-sharp scythe blade within the gap\.
	matchre DISARMED ^A thin metal circle of .* has been peeled away from the hinges of the .*
     matchre DISARMED ^A small hole near the lock houses a tiny dart with a silver tip\.\s+It appears\, however\, that the dart has been moved too far out of position for the mechanism to function properly\.
     matchre DISARMED ^A row of concealed openings on the front of the .*, have been bent in such a way that they no longer will function\.
     matchre DISARMED ^A tiny hammer and milky\-white tube on the front of the .* have been bent away from each other\.
     matchre DISARMED ^A bent needle sticks harmlessly out from its hidden compartment near the lock\.
     matchre DISARMED It appears\, however\, that the dart has been moved too far out of position for the mechanism to function properly\.
     matchre DISARMED ^Looking closely at the .*\, you notice a vial of lime green liquid attached to the lid\.\s+Someone has unhooked the stopper\, rendering it harmless\.
     matchre DISARMED ^Still grinning ridiculously is a tiny bronze face\, loosened from the .*\.\s+Behind this metallic visage rests a small deflated bladder\.
     matchre DISARMED ^Several small pinholes centered around the keyhole indicate that some sort of apparatus\, previously attached\, was picked apart and removed from the .*\.
     matchre DISARMED ^Several strands of wicker detonator lay inside the casement\, separated harmlessly from their charge\.\s+You guess it is already disarmed
     matchre DISARMED There is a small hole in the front of the .* and a damp stain down the front\, as if something had been poured out the hole\.
     matchre DISARMED ^There are two tiny holes in the .*\.\s+It looks like there used to be something in them\, but whatever it was has been pried out\.
     matchre DISARMED ^There is a stain near a small notch on the front of the .*, indicating a liquid was drained out\.\s+Additionally\, a tiny metal lever has been bent away from the casing\.
     matchre DISARMED ^Two sets of six pinholes on either side of the .* lock are sealed with dirt\, blocking whatever would have come out
     matchre DISARMED ^You notice .* type of animal bladder and a disconnected string near the lock\.
     matchre DISARMED ^You notice a small hole in the side of the .* and the remnants of some type of powder\.
     matchre DISARMED ^You notice a tiny hole near the lock which has been stuffed with dirt rendering the trap harmless\.
     matchre DISARMED ^You notice a sphere with some type of lacing around it\.\s+It seems a small portion of the trap has been removed\.
     matchre DISARMED ^You see nothing of interest in the .*\.\s+It seems harmless\.
     matchre DISARMED ^You see a pin and shaft lodged into the frame of the .*\.\s+It looks safe enough\.
     matchre DISARMED ^You see a shattered glass tube with a tiny hammer inside the lock\.\s+You deem it quite safe\.
     matchre DISARMED ^You see a glowing rune pushed deep within the .*\.\s+It seems far enough away from the lock to be harmless\.
     matchre DISARMED ^You see a lumpy green rune pushed deep within the .*\.\s+It seems far enough away from the lock to be harmless\.
     matchre DISARMED ^You see what appears to be some sort of clay\.  The leading edge near the lock itself has been pulled away and whatever was inside\, removed\.
     matchre DISARMED ^While examining the .* for traps\, you notice a bronze seal with a glass sphere in it\.  The seal has been pried away from the lid\.
     matchre DISARMED DISARM HELP for syntax help|It looks safe enough|^You don\'t see any reason
     matchre DISARMED You guess it is already disarmed|You are certain the .* is not trapped
     matchre ID_RETURN Surely any fool|Even your memory can|Somebody has already located|Roundtime
     matchre ID_RETURN trap of some kind|glistening black square|crust\-covered black scarab|barbed crossbow bolts|crossbow bolts glistening|small wad of brown clay|slight smell of almonds
     matchre ID_RETURN swollen animal bladder|very sharp blade poised|small glass tube of milky\-white|stopper is attached so that the vial will open|pulsating ball with some sort of metal lacing
     matchre ID_RETURN small notch beside a tiny metal lever|large vial of naphtha|tiny needle with a (greenish|rust colored) discoloration|glint of razor sharp steel|two silver studs
     matchre ID_RETURN packed tightly with a powder|thin metal circle that has been lacquered|pin lodged against the tumblers of the lock|(small glowing|lumpy green) rune hidden
     matchre ID_RETURN a tiny glass tube filled with a black|seal is covered in strange runes|Some sort of fatty bladder|a small black crystal deep in the shadows|something is awry
	#matchre return coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|box
	send disarm ID
	matchwait 12
     return
ID_RETURN:
     pause 0.0001
     pause 0.0001
     action (id) off
     # put glance my $lefthandnoun
     if ("%TRAP.TYPE" = "NULL") then var TRAP.TYPE UNKNOWN
     return
Disarmed:
     var disarmed 1
     var TRAP.TYPE NULL
     return
Not_Box:
     echo *** Error: Not a trapped box: $lefthand
     pause 0.0001
     send put $lefthand in my %SHEATH
     pause 0.5
     goto container_Check

ID_FAIL:
     var failcount add 1
     if (%failcount > 4) then goto toss_box
     pause 0.0001
     pause 0.0001
     goto disarm_ID

disarm:
	var multi_trap OFF
	if (matchre("%TRAP.TYPE", "(concussion|disease|reaper|shrapnel|gas|lightning|shocker|naphtha_soaker)") && ($roomid != %SAFE.ROOM) && matchre("%MOVE.ROOMS", "(?i)(YES|ON|1)")) then
          {
               echo ###########
               echo * Dangerous Room Trap!!
               echo * MOVE.ROOMS IS ON! 
               echo * MOVING TO SAFE ROOM!
               echo ###########
               pause 0.5
               gosub automove %SAFE.ROOM
          }
disarmIt_Cont:
     var SAVE disarmIt_Cont
	var LAST disarmIt_Cont
     math disarm.count add 1
     pause 0.00001
     pause 0.00001
	if (%disarm.count > 9) then goto toss_Box
     if (%TOTAL.DIFFICULTY >= 17) then goto toss_Box
     if (("%TRAP.TYPE" = "concussion") && (%disarm.count > 4)) then goto toss_Box
     if (("%TRAP.TYPE" = "shrapnel") && (%disarm.count > 4)) then goto toss_Box
     if (("%TRAP.TYPE" = "concussion") && ("%TOTAL.DIFFICULTY" > "15")) then goto toss_Box
     if (("%TRAP.TYPE" = "shrapnel") && ("%TOTAL.DIFFICULTY" > "15")) then goto toss_Box
	if ((%disarm.count > 1) && ("%MODE" = "quick")) then var MODE normal
	if ((%disarm.count > 1) && ("%MODE" = "blind")) then var MODE normal
	if ((%disarm.count > 2) && matchre("%MODE", "(blind|quick|normal)")) then var MODE careful
     if (%disarm.count > 3) then var MODE careful
     if (matchre("%TRAP.TYPE", "(concussion|disease|reaper|shrapnel|gas|lightning|poison_bolt|shocker|naphtha_soaker|poison_nerve|teleport)") && ("%MODE" != "careful")) then
          {
               if ((%TOTAL.DIFFICULTY > 5) || (("$roomplayers" != "") && (%TOTAL.DIFFICULTY > 3) && ($charactername != "Shroom")) || (("$roomplayers" != "") && (%TOTAL.DIFFICULTY > 6))) then
                    {
                         echo ##########
                         echo * Dangerous Trap!!
                         if ("$roomplayers" != "") then echo * (AND OTHER PLAYERS IN THE ROOM!)
                         echo * USING CAREFUL MODE!!
                         echo ##########
                         var MODE careful
                         pause 0.3
                    }
          }
     pause 0.0001
     echo
     echo * Disarm Mode: %MODE
     echo
     pause 0.001
     pause 0.001
	matchre disarmIt_Cont ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
	matchre weapon hinders your attempt|KNUCKLES|handwraps|hand claws
	matchre disarmIt_Cont ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
	matchre disarmIt_Careful This is not likely to be a good thing|You get the distinct feeling your manipulation caused something to shift inside the trap mechanism
	matchre disarmIt_Cont fumbling fails to disarm|unable to make any progress|You doubt you'll be this lucky every time
	matchre disarm_Return You are certain the %disarmit is not trapped|Roundtime|It appears\, however, that the dart has been moved too far out of position for the mechanism to function properly\.
     matchre disarm_Return You guess it is already disarmed|DISARM HELP for syntax help|It looks safe enough|^You don't see any reason
	put disarm my %disarmit %MODE
	matchwait
disarmIt_Careful:
	math disarm.count add 2
     math TOTAL.DIFFICULTY add 1
	goto disarmIt_Cont
disarm_Return:
     pause 0.0001
     pause 0.0001
     put disarm id
     wait
     pause 0.0001
     pause 0.0001
     return

analyze:
	var LAST analyze
	math harvest.count add 1
     pause 0.0001
	pause 0.1
analyze_1:
     pause 0.0001
	if (%harvest.count > 2) then goto RETURN
	     matchre weapon KNUCKLES|handwraps
		matchre analyze_1 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre analyze_1 You are unable to
		matchre HARVEST You already have made an extensive study|You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help|You\'ve already analyzed this trap
		matchre return fumbling fails to disarm|This is not likely to be a good thing
		matchre disarm what could you possibly analyze
	put disarm anal
	matchwait 7

HARVEST:
	var LAST HARVEST
	math harvest.count add 1
     pause 0.1
     pause 0.1
HARVEST_1:
     pause 0.0001
	if (%harvest.count > 4) then goto RETURN
          matchre HARVEST_1 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
          matchre stow_Component Roundtime|you extract a portion|With great care|You carefully|With a gentle shake
          matchre disarm_ID what could you possibly analyze
          matchre analyse ^You will need to analyze the %disarmit before you attempt to HARVEST it\.
		matchre HARVEST Your laborious fumbling fails to HARVEST the trap component|You fumble
          matchre return It appears that none of the trap components are accessible|been completely HARVESTed|unsuitable for HARVESTing|You don't see any reason
	put disarm HARVEST
	matchwait 7

stow_Component:
     pause 0.0001
     pause 0.0001
     pause 0.1
	if ("$righthandnoun" = "cube") then send put cube in my %CONTAINER1
     if matchre("%KEEPCOMPONENT", "(?i)(YES|ON|1)") then
          {
               if matchre("$righthand", "(%component_list)") then gosub stow_It $0
          }
     gosub DUMPSTER_CHECK
     if !matchre("$righthand", "Empty") && ("%dumpster" != "NULL") then put put my $righthandnoun in %dumpster
     pause 0.3
     pause 0.2
     if !matchre("$righthand", "Empty") then put drop my $righthand
     pause 0.2
	return

stow_It:
	var component $0
	pause 0.0001
	stow_Comp:
		var LAST stow_Comp
			matchre stow_It ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
			matchre return ^You put
               matchre stow_ItAlt any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|not designed to carry anything|^But that's closed|^You can't
		put put $righthandnoun in my %COMPONENTCONTAINER
		matchwait 5
stow_ItAlt:
     put put $righthandnoun in my %COMPONENTCONTAINER in my portal
     pause 0.4
     pause 0.3
     put put $righthandnoun in my %CONTAINER1
     pause 0.5
     pause 0.3
     return

get_Skeleton:
     pause 0.0001
    	var LAST get_Skeleton
		matchre get_Skeleton ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return You get|You are already|You pull
		matchre get_Skeleton2 What were you referring to|^I could not
	put get my skeleton key
	matchwait 4
get_Skeleton2:
     pause 0.00001
    	var LAST get_Skeleton
		matchre get_Skeleton ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return You get|You are already|You pull
		matchre Skeleton_OFF What were you referring to|^I could not
	put get my gais key
	matchwait 4
Skeleton_OFF:
     var SKELETON.KEY NO
     goto get_Pick
     
get_Pick:
     pause 0.00001
     #if matchre("%SKELETON.KEY", "(?i)(YES|ON|1)") then goto get_Skeleton
	var LAST get_Pick
     if (matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") && ("$righthand" = "Empty")) then goto pull_Pick
		matchre get_Pick ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return You get|You are already
		matchre no_More_Picks What were you referring to|^I could not
	put get my lockpick
	matchwait 11
     goto no_More_Picks

pull_Pick:
	pause 0.00001
	var LAST pull_Pick
		matchre pull_Pick ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return ^You get|^You are already|^You pull
		matchre get_Pick ^What were you referring to|^But there aren't any lockpicks
          matchre no_More_Picks ^You'll need to hold 
	put pull my %lockpickring.type
	matchwait

no_More_Picks:
	echo
	echo ***  You have no more lockpicks - TIME TO RESTOCK! ***
	echo
	put #echo >Log Fuchsia *** You have run out of lockpicks! Restock! ***
	goto LOCKED_SKILLS

put_Away_Pick:
	var LAST put_Away_Pick
	if ("$righthand" = "Empty") then return
	pause 0.00001
		matchre loot It's not even locked
		matchre put_Away_Pick ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return You put|What were you
		matchre pick.storage2 There isn't any more room|That's too heavy|^I could not|heavy
	if matchre("$righthand|$lefthand", "skeleton key") then put put my key in my %pickstorage
	else put put lockpick in my %pickstorage
	matchwait 7

pick.storage2:
	var LAST pick.storage2
		matchre pick.storage2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return You put|What were you
     if matchre("$righthand|$lefthand", "skeleton key") then put put my key in my %CONTAINER1
	else put put lockpick in my %CONTAINER1
	matchwait
     
pick.storage3:
	var LAST pick.storage3
	if ("$righthand" = "Empty") then return
		matchre pick.storage2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre return You put|What were you
     if matchre("$righthand|$lefthand", "skeleton key") then put put my key in my %CONTAINER2
	else put put lockpick in my %CONTAINER2
	matchwait 5
     return

find_Pick:
     pause 0.0001
     gosub get_Pick
     var pickloop 0
pick_ID:
     math pickloop add 1
     if (%pickloop > 4) then
          {
               var pickloop 0
               return
          }
	var LAST pick_ID
	var SAVE pick_ID
     pause 0.0001
     if matchre("$righthand", "%box_types") then
          {
               put swap
               pause 0.8
               pause 0.3
          }
     if ("$righthand" != "Empty") then 
          {
               gosub stow $righthand
               pause 0.8
          }
     if (!matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") && ("$righthand" = "Empty")) then gosub get_Pick
     pause 0.0001
          matchre disarm_ERROR is not fully disarmed
          matchre pick_ID ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre weapon hinders your attempt|KNUCKLES|handwraps|hand claws
		matchre pick_ID fails to teach you anything about the lock guarding it|just broke
		matchre return Roundtime|has already helpfully been analyzed|not even locked|^Pick what|^You|Somebody has
		matchre find_Pick Find a more appropriate tool
	put pick ID
	matchwait
     
pick:
     goto pick_Cont
	var LAST pick
	var SAVE pick_Cont
     pause 0.0001
     pause 0.0001
		matchre pick ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre weapon hinders your attempt|KNUCKLES|handwraps|hand claws
		matchre pick_Cont Roundtime|has already helpfully been analyzed|not even locked|^Pick what
	put pick anal
	matchwait
     
find_Pick2:
     gosub get_Pick
pick_Cont:
     var pickloop 0
pick_Cont_1:
     var multi_lock OFF
	if (!matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") && ("$righthand" = "Empty")) then gosub get_Pick
     if !matchre("%GIVEBOX", "(?i)(YES|ON|1)") then
     	{
          if !matchre("%KEEP.PICKING", "(?i)(YES|ON|1)") then
               {
                    if ($Locksmithing.LearningRate > 33) then goto LOCKED_SKILLS
               }
          }
	var LAST pick_Cont_1
	var SAVE pick_Cont_1
	math pickloop add 1
     pause 0.0001
     pause 0.0001
	if (%pickloop > 20) then goto toss_Box
	if (%pickloop > 6) then var MODE careful
     if (%pickloop > 2) && (%pickloop < 4) then 
          {
               send get skeleton key
               wait
               pause 0.5
          }
	if ((%pickloop > 2) && ("%MODE" = "quick")) then var MODE normal
	if ((%pickloop > 2) && ("%MODE" = "blind")) then var MODE quick
     if ($Locksmithing.Ranks > 1700) then var MODE quick
     pause 0.0001
     matchre RETURN With a soft click|A sharp click|Roundtime|^Pick what|It\'s not even locked\, why bother\?
     matchre RETURN ^As you touch the lockpick to the .* lock, you suddenly notice it's already been opened somehow\.
     matchre weapon hinders your attempt|KNUCKLES|handwraps|hand claws
	matchre pick_Cont_1 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
	matchre pick_Cont_1 You are unable to make
	matchre find_Pick2 Find a more appropriate tool
     if matchre("$righthand $lefthand", "skeleton key") then put turn key with %disarmit
	else put pick %MODE
	matchwait

toss_Box:
     echo
     echo *** THIS BOX IS EITHER WAY TOO HARD FOR US
     echo *** AND/OR IS A DEADLY TRAP LIKELY TO KILL US!
     echo *** DISCARDING FOR SAFETY!!
     echo
     pause 0.5
     pause 0.0001
	var LAST toss_Box
     var failcount 0
return_Box:
     if matchre("%GIVEBOX", "(?i)(YES|ON|1)") then
          {
               if ("$righthand" = "Empty") then send swap
               pause 0.5
               pause 0.3
               put whisper %user Sorry, this box is way too hard for me, I can't open it
               put give %user
               matchre main accepts
               matchre return_Box canceled
               matchwait 30
               goto return_Box
          }
     matchre toss_Box ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
	matchre main ^You|^I|^What
     if !matchre("$righthand", "\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|(?<![Tt]raining )\bbox\b") then put stow $righthand
     if !matchre("$lefthand", "\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|(?<![Tt]raining )\bbox\b") then put stow $lefthand
     pause 0.01
     if matchre("$righthand", "training box") then put stow box
     if matchre("$lefthand", "training box") then put stow box
     pause 0.1
	if matchre("$roomobjs","bucket of viscous gloop") then put put my %disarmit in bucket
     if matchre("$roomobjs","(waste bin|firewood bin)") then put put my %disarmit in bin
     if matchre("$roomobjs","driftwood log") then put put my %disarmit in log
     if matchre("$roomobjs","tree hollow") then put put my %disarmit in hollow
	put drop my %disarmit
	matchwait 7
     goto MAIN

loot:
open_Box:
     var pouchLoop 0
	var LAST open_Box
     pause 0.00001
     pause 0.00001
     matchre get_Gem_Pouch %gemlist
	matchre open_Box ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
	matchre lock_sub It is locked|^The lid of the
     matchre get_Coin ^In the .*
	put open my %disarm.noun;-0.5 look in my %disarm.noun
	matchwait 3
     goto get_Coin
get_Gem_Pouch:
     echo * GEMS SPOTTED
     pause 0.1
	var LAST get_Gem_Pouch
     if matchre("%GEMPOUCHWORN", "(?i)(YES|ON|1)") then
          {
               put remove my %GEMPOUCH
               pause 0.7
               pause 0.2
          }
get_Gem_Pouch_1:
     pause 0.00001
     if matchre("$righthand", "pouch") then goto fill_Gem_Pouch
     if ("$righthand" != "Empty") then GOSUB STOW right
	pause 0.00001
		matchre get_Gem_Pouch ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre fill_Gem_Pouch You get|^But that is|^You remove|^You slip
          matchre get_Gem_Pouch_alt ^What were you|^I could not find
	put get my %GEMPOUCH
	matchwait 8
get_Gem_Pouch_alt:
	var LAST get_Gem_Pouch_alt
     if ("$righthand" != "Empty") then GOSUB STOW right
     pause 0.0001
     pause 0.0001
		matchre get_Gem_Pouch ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
		matchre fill_Gem_Pouch You get|^But that is
          matchre out_of_pouches ^What were you|^I could not find
	put get my %GEMPOUCH from my portal
	matchwait 8
fill_Gem_Pouch:
     math pouchLoop add 1
     if (%pouchLoop > 3) then goto stow_Pouch
	var LAST fill_Gem_Pouch
     pause 0.00001
          matchre full_Pouch anything else|pouch is too full
		matchre tied_Pouch The .+ pouch is too valuable|You'll need to tie it up
		matchre fill_Gem_Pouch ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You are still stunned
          matchre get_Gem_Pouch_1 ^What were you|You have to be holding
		matchre stow_Pouch ^You take|^There aren't any|You fill your|You open your
          matchre lock_sub ^It is locked
	put fill my %GEMPOUCH with my %disarm.noun
	matchwait 8
     goto stow_Pouch

tied_Pouch:
     if !matchre("%TIE.POUCH", "(?i)(YES|ON|1)") then goto full_Pouch
	var LAST tied_Pouch
		matchre non_gems You'll need to make sure there are only gems in there
		matchre fill_Gem_Pouch You tie up|has already been tied off
	put tie %GEMPOUCH
	matchwait 10
	goto fill_Gem_Pouch
full_Pouch:
	var LAST full_Pouch
     echo *** FILLED UP A GEM POUCH. STASHING IN %GEMPOUCH.CONTAINER
	pause 0.5
     if matchre("%GEMPOUCHWORN", "(?i)(YES|ON|1)") then
          {
          put rem my %GEMPOUCH
          pause 0.8
          }
open_thePouch:
     pause 0.0001
     gosub PUT drop my %disarmit
     pause 0.2
     gosub PUT open my %GEMPOUCH.CONTAINER
     pause 0.0001
stow_GemPouch:
     matchre open_thePouch ^But that's closed\.
     matchre close_Pouch ^You put|^You fill|^You open
     matchre sell_these_gems ^That's too heavy|too wide|too long
     send put my pouch in my %GEMPOUCH.CONTAINER
     matchwait 10
     goto sell_these_gems
close_Pouch:
     pause 0.1
     put close my %GEMPOUCH.CONTAINER
     pause 0.3
get_Pouch:
     pause 0.2
     gosub PUT get my %GEMPOUCH
     pause 0.5
     if matchre("%TIE.POUCH", "(?i)(YES|ON|1)") then gosub PUT tie my pouch
     pause 0.2
     if matchre("%GEMPOUCHWORN", "(?i)(YES|ON|1)") then put wear my %GEMPOUCH
     pause 0.3
     gosub PUT get %disarmit
     pause 0.2
     goto fill_Gem_Pouch
sell_these_gems:
     put #echo >Log Lime *** Warning! Gem pouch container full!!!! Sell your gems!!
     put #var sellGems 1
     return
     
non_gems:
     var lootcheck 0
	gosub STOW left
     pause 0.1
nonGem_Check:
     math lootcheck add 1
     if (%lootcheck > 3) then goto nonGem_Done
          matchre bad_Item \b(ruby|potency crystal|infuser stone|runestone|stone|nugget|ingot)\b
		matchre nonGem_Done In the|nothing|What
	put look in my %GEMPOUCH
	matchwait
     
bad_Item:
     var item $1
     pause 0.001
     pause 0.001
     gosub PUT get %item in my %GEMPOUCH
     pause 0.5
     gosub PUT put %item in my %CONTAINER1
     pause 0.1
     pause 0.1
     if matchre("$righthand $lefthand", %item) then gosub PUT put %item in my %CONTAINER2
     if matchre("$righthand $lefthand", %item) then gosub PUT put %item in my %CONTAINER3
     pause 0.2
	goto nonGem_Check
nonGem_Done:
     pause 0.1
     gosub PUT get my %disarmit
     pause 0.5
     goto tied_Pouch

stow_Pouch:
	var LAST stow_Pouch
     pause 0.00001
     if matchre("%GEMPOUCHWORN", "(?i)(YES|ON|1)") then
          {
               put wear my %GEMPOUCH
               wait
               pause 0.7
          }
     if !matchre("$righthand $lefthand", pouch) then goto get_Coin
		matchre stow_Pouch ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
		matchre stow_Pouch2 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide
		matchre get_Coin You|Stow|^But that is
	put stow my %GEMPOUCH
	matchwait
stow_Pouch2:
	var LAST stow_Pouch2
		matchre stow_Pouch3 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide
		matchre stow_Pouch2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
		matchre get_Coin You|Stow|^But that is
	put stow my %GEMPOUCH in my %CONTAINER2
	matchwait
stow_Pouch3:
	var LAST stow_Pouch3
		matchre stow_Pouch3 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
		matchre get_Coin You|Stow|^But that is
	put stow my %GEMPOUCH in my %CONTAINER3
	matchwait

get_Coin:
     var lootcheck 0
	var LAST get_Coin
		matchre get_Coin ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
		matchre get_Coin You pick up
		matchre map_Check What were you
	put get coin from my %disarmit
	matchwait

map_Check:
     math lootcheck add 1
     if (%lootcheck > 3) then return
	var LAST map_Check
     pause 0.0001
		matchre stow_Gear (gear|\bbolt\b|\bnut\b|glarmencoupler|spangleflange|rackensprocket|flarmencrank|page|spine|bloodlock|cover)
		matchre get_Map (tattered map|treasure map)
          matchre soap soap
          matchre card (?:an?) (.+) card\b$
          matchre get_it (\broll\b|\bscroll\b|nugget|ingot|\bbar\b|jadeite|kyanite|bark|parchment|\bdira\b|papyrus(?! roll)|tablet|vellum|ostracon|leaf|\brune\b)
		matchre return In the|nothing|What
	put look in my %disarm.noun
	matchwait

card:
     pause 0.0001
     gosub PUT get card from my %disarm.noun
     pause 0.2
     gosub STOW card
     pause 0.1
     goto map_Check
soap:
     pause 0.0001
     gosub PUT get soap from my %disarm.noun
     pause 0.2
     put drop soap
     pause 0.2
     goto map_Check
     
stow_Gear:
     var item $1
     pause 0.0001
	gosub PUT get %item from my %disarm.noun
     pause 0.2
	gosub STOW %item
	pause 0.1
	goto map_Check

get_Map:
	gosub PUT get map from my %disarm.noun
     pause 0.1
	gosub STOW map
	pause 0.2
	put #echo >Log Lime ***** FOUND TREASURE MAP IN BOX *****
	pause 0.1
     goto map_Check

get_it:
     var item $1
     gosub PUT get %item in my %disarm.noun
     gosub STOW %item
     pause 0.2
     goto map_Check

DISMANTLE:
	var LAST DISMANTLE
     pause 0.00001
     if matchre("%DISMANTLE.ALL", "(?i)(YES|ON|1)") then gosub DISMANTLE_2
     gosub DUMPSTER_CHECK
     if !matchre("%dumpster", "(NULL|gelapod)") then
          {
               pause 0.00001
               if matchre("$righthandnoun", "%disarmit") then put put my %disarmit in %dumpster
               if matchre("$lefthandnoun", "%disarmit") then put put my %disarmit in %dumpster
               pause 0.00001
               if matchre("%disarmit", "$righthandnoun") then put put my %disarmit in %dumpster
               if matchre("%disarmit", "$lefthandnoun") then put put my %disarmit in %dumpster
               return
          }
     if matchre("%dumpster", "gelapod") then
          {
               pause 0.001
               if matchre("$righthandnoun", "%disarmit") then put feed my %disarmit to gelapod
               if matchre("$lefthandnoun", "%disarmit") then put feed my %disarmit to gelapod
               pause 0.00001
               pause 0.00001
               if matchre("%disarmit", "$righthandnoun") then put feed my %disarmit to gelapod
               if matchre("%disarmit", "$lefthandnoun") then put feed my %disarmit to gelapod
          }
     gosub DISMANTLE_2
     pause 0.1
     pause 0.01
     if matchre("$righthandnoun", "%disarmit") then gosub drop_box
     if matchre("$lefthandnoun", "%disarmit") then gosub drop_box
     if contains("$righthand $lefthand", "%disarmit") then gosub drop_box
     return
DISMANTLE_2:
     pause 0.00001
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
		matchre DISMANTLE_2 ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
          matchre DISMANTLE_2 next 15 seconds|something inside it
          matchre drop_box You can not DISMANTLE
		matchre open_Box You must first open
		matchre disarm_sub You must first disarm
		matchre return Roundtime|Unable to locate|^Dismantle what\?
          matchre return ^You must be holding
	put disman my %disarm.noun %DISMANTLE
	matchwait 6
     return
MEDITATE_CHECK:
     var yogi 0
     match YOGION Yogi
     matchre YOGINO ^You have not been trained in any Masteries from the path of the Flame\.
     put mastery list
     matchwait 2
YOGINO:
     return
YOGION:
     var yogi 1
     return
     
drop_box:
     pause 0.00001
     if matchre("$righthand", "training box") then put stow box
     if matchre("$lefthand", "training box") then put stow box
     gosub PUT drop my %disarmit
     pause 0.5
     return

stowDisarm:
     pause 0.00001
     echo *** STOWING DISARMED BOX AWAY
     put put my %disarmit in %disarmBag
     pause 0.5
     return
stowDisarmed:
     pause 0.00001
     echo *** STOWING DISARMED BOX AWAY
     put put my %disarmit in %disarmBag
     pause 0.5
     goto MAIN

empty_Hand:
     pause 0.00001
	if ("$righthand" != "Empty") then GOSUB STOW right
	if ("$lefthand" != "Empty") then GOSUB STOW left
fix_Lock:
	if !matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then gosub get_Pick
	if matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then gosub fix_Ring
	if matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then goto go_On
	fixing:
	var LAST fixing
		pause 0.00001
		matchre fix_Ring You'll have to hold it|^You can't fix that
		matchre fixing ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
		matchre go_On Roundtime|look like it|^You can't figure out
	put fix my lock
	matchwait
	go_On:
	if !matchre("%LOCKPICK.RING", "(?i)(YES|ON|1)") then gosub put_Away_Pick
	return

fix_Ring:
	fixing_Ring:
	var LAST fixing_Ring
		pause 0.00001
		matchre get_Healed ^You're in no condition to be repairing
		matchre empty_Hand You must use both hands
		matchre fixing_Ring ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
		matchre return Roundtime|look like it|^You can't figure out how to fix that
	put repair my %lockpickring.type
	matchwait 20
	goto empty_Ring

get_Healed:
     echo
     echo *** You are too hurt to repair anything! Get healed!
     echo
     return

empty_Ring:
     var LOCKPICK.RING NO
     echo
     echo *** Your lockpick ring is empty! Refill it!
     echo
     put #echo >Log Red Lockpick ring empty!!! REFILL IT!
     goto go_On
     
loot_Check:
     var lootCount 0
     loot_Check1:
     math lootCount add 1
     if matchre("$roomobjs", "(tablet|vellum|scroll)") then
        {
          var item $1
          gosub Stow %item
          goto loot_Check
          if %lootCount > 2 then return
        }
     return
     
exp_Check:
     pause 0.00001
     pause 0.00001
     matchre exp_Check ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase
     matchre exp_Check1 ^Overall state of mind|EXP HELP
	send exp
     matchwait 7
exp_Check1:
	if ("$righthand" != "Empty") then
          {
               send stow right
               pause 0.7
          }
    ##################
	#BOX COUNTER HERE!
	var LOCAL $Boxes
	math LOCAL add 1
	math BOXES add 1
	put #var Boxes %LOCAL
     echo
	echo ===============
	echo * Boxes popped: %BOXES
	echo ===============
     echo
     gosub stowing
     pause 0.1
     #END BOX COUNTER
	##################
     if matchre("%KEEP.PICKING", "(?i)(NO|OFF)") then
          {
               if ($Locksmithing.LearningRate > 33) then goto LOCKED_SKILLS
          }
	return

### CHECK FOR ALL KNOWN MAJOR LOCKPICK RINGS ETC AND SET THE TYPE
lockpick_ring_check:
     var num 0
     var success 0
     eval TotalTypes count("%ring_types", "|")
lockpick_ring_loop:
     pause 0.0001
     if (%num > %TotalTypes) then
          {
               var LOCKPICK.RING NO
               return
          }
     var lockpickring.type %ring_types(%num)
     gosub lockpick_type_check
     if (%success = 1) then return
     math num add 1
     goto lockpick_ring_loop

lockpick_type_check:
     pause 0.001
     echo * Checking lockpick ring type
     pause 0.1
     matchre fill_lockpick_ring ^You tap (.+) you are wearing
     matchre return ^I could not|^What
     send tap my %lockpickring.type
     matchwait 10
     return

fill_lockpick_ring:
     var success 1
     echo
     echo * LOCKPICK RING TYPE: %lockpickring.type
     echo
     pause 0.0001
     pause 0.0001
     matchre fill_lockpick_ring ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre empty_lock ^The .* is (empty) but you think (\d+) lockpicks would probably fit\.
     matchre new_lock The .+ looks to be holding (\d+) lockpicks? and it might hold an additional (\d+)\.
     matchre lockpick_ringfull appears to be full|It looks
     matchre empty_lock (empty)
     if ("$guild" = "Thief") then put glance my %lockpickring.type
     else put app my %lockpickring.type
     matchwait 8
     goto new_lock
empty_lock:
     var lockpickcount $1
     pause 0.0001
     matchre empty_lock ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre make_more_locks ^What were you|^I could not find
     matchre put_lock ^You get|already holding|^You need a free
     put get my lockpick
     matchwait
new_lock:
     var lockpickcount $1
     pause 0.0001
     matchre new_lock ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre new_lock2 ^What were you|^I could not find
     matchre put_lock ^You get|already holding|^You need a free
     put get my lockpick
     matchwait
new_lock2:
     pause 0.0001
     if ($zoneid != 150) then goto make_more_locks
     matchre new_lock ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre make_more_locks ^What were you|^I could not find
     matchre put_lock ^You get|already holding|^You need a free
     put get lockpick from back on shelf
     matchwait
put_lock:
     pause 0.0001
     matchre put_lock ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre fill_lockpick_ring ^You put
     matchre stow_lock ^You don't think you should put different kinds|already has as many lockpicks|^What
     put put my lock in my %lockpickring.type
     matchwait
stow_lock:
     gosub STOW lock
     pause 0.1
     return
make_more_locks:
     if matchre("%lockpickcount", "empty") then
          {
               if matchre("%RESTOCK.LOCKPICKS", "(?i)(ON|YES)") then
                    {
                         echo * Turning ON Lockpick Restock on next Uber Town Run
                         put #var RestockLockpicks 1
                         put #var save
                         return
                    }
               echo
               echo ** OUT OF LOCKPICKS!! RESTOCK!!!
               echo
               return
          }
     if (%lockpickcount < 11) then
          {
               put #echo >Log Orange * LOCKPICKS RUNNING LOW! %lockpickcount left in %lockpickring.type!
          }
     return
lockpick_ringfull:
     put #var RestockLockpicks 0
     return
disarm_ERROR:
	echo
	echo *** Error while opening box
	echo *** Something bad happened
	echo
	put #beep
	gosub STOWING
	pause 1
	goto main
     
No_Picks:
EMPTY:
     put #echo >Log Red *** RAN OUT OF LOCKPICKS!!! RESTOCK!
     put #var RestockLockpicks 1
     goto LOCKED_SKILLS
out_of_pouches:
     put #echo >Log Red *** RAN OUT OF GEM POUCHES! RESTOCK!!!
     goto LOCKED_SKILLS
     
LOCKED_SKILLS:
     echo
     echo =============================
     echo * FINISHED PICKING BOXES!
     echo * Locksmithing: $Locksmithing.Ranks $Locksmithing.LearningRate/34 ***
     echo * %BOXES boxes popped this session - $Boxes boxes over all time
     echo =============================
     echo
     put #echo >Log #99ffcc * Disarm Done! Locksmithing: $Locksmithing.Ranks $Locksmithing.LearningRate/34
     put #echo >Log #99ffcc * %BOXES boxes popped this session - $Boxes boxes over all time
DONE:
     pause 0.0001
     pause 0.0001
     gosub stowing
     pause 0.0001
     if matchre("%WEAR.ARMOR", "(?i)(YES|ON|1)") then gosub WEAR_ARMOR
     gosub PUT get my %KNUCKLES
     gosub PUT wear my %KNUCKLES
     pause 0.0001
SELL_COMPONENTS:
SELLCOMPS:
     # debug 5
     var person NULL
     gosub stowing
     var Locksmiths Ragge|Kilam|Hekipe|Sephina|Ss'Thran|Cormyn|Bynari|Dorsot|Ioun|Ishh|Oweede|Paedraig|Relf|Saeru|Dumi|Ss\'Thran
     if matchre("%KEEPCOMPONENT", "(?i)(OFF|NO|NULL|NIL)") then goto DONE_DONE
     if matchre("%HARVEST", "(?i)(OFF|NO|NULL|0)") then goto DONE_DONE
     if matchre("%KEEPCOMPONENT", "(?i)(YES|ON|1)") then
     {
          echo ================
          echo *** Going to Locksmith/Pawnshop
          echo *** To Sell Trap Components
          echo ================
          pause 0.5
          if matchre("$zoneid","\b150\b") then gosub LEAVE_SEACAVE
          pause 0.2
          pause 0.2
          if matchre("$zoneid","\b(7|8|4)\b") then gosub AUTOMOVE cross
          if matchre("$zoneid","\b(124|126|127)\b") then gosub AUTOMOVE hib
          if matchre("$zoneid","\b(124|126|127)\b") then gosub AUTOMOVE hib
          if matchre("$zoneid","\b(62|58|59|60|112)\b") then gosub AUTOMOVE leth
          if matchre("$zoneid","\b(62|58|59|60|112)\b") then gosub AUTOMOVE leth
          if matchre("$zoneid","\b(34a|31|32|33)\b") then gosub AUTOMOVE river
          if matchre("$zoneid","\b(34a|31|32|33)\b") then gosub AUTOMOVE river
          if matchre("$zoneid","\b(34a|31|32|33)\b") then gosub AUTOMOVE river
          if ("$zoneid" = "40") then gosub AUTOMOVE theren
          if ("$zoneid" = "66") then gosub AUTOMOVE east
          if ("$zoneid" = "98") then gosub AUTOMOVE aesry
          if matchre("$zoneid","\b(40)\b") then gosub AUTOMOVE theren
          if matchre("$zoneid","\b(66)\b") then gosub AUTOMOVE east
          pause 0.1
          if matchre("$zoneid","\b(66)\b") then gosub AUTOMOVE east
          pause 0.1
          pause 0.1
          if !matchre("$zoneid","\b(1|30|42|47|67|90|99|107|116|150)\b") then
               {
                    echo ============================
                    echo * NOT IN A RECOGNIZED AREA TO SELL COMPONENTS
                    echo ============================
                    pause 0.5
                    goto DONE_DONE
               }
          pause
          pause
          if ($standing = 0) then gosub STAND
          pause
          gosub stowing
          if ("$guild" != "Thief") then goto PAWN_COMPONENTS
          if !matchre("$zoneid", "\b(1|30|47|67)\b") then goto PAWN_COMPONENTS
          echo =============
          echo * Selling Trap Components
          echo =============
          pause 0.6
          if matchre("$zoneid","\b(1|30|47|67)\b") then gosub AUTOMOVE locks
          pause 0.7
          if matchre("$roomobjs", "Malik") then
               {
                    put ask malik about thieves
                    wait
                    pause 0.3
                    put order lyre
                    wait
                    pause 0.2
                    pause 0.1
                    put offer 5000000
                    wait
                    put offer 5000000
                    wait
                    pause 0.5
                    pause 0.5
                    pause 0.5
                    
               }
     if ($standing = 0) then gosub STAND
     if ("$guild" = "Thief") then
          {
               if ("$roomplayers" != "") then
                    {
                         echo ** PEOPLE IN THE ROOM! WAITING TO SELL...
                         pause 10
                    }
               if ("$roomplayers" != "") then
                    {
                         echo ** PEOPLE IN THE ROOM! WAITING TO SELL...
                         pause 15
                    }
               if ("$roomplayers" != "") then
                    {
                         echo ** PEOPLE IN THE ROOM! WAITING TO SELL...
                         pause 15
                    }
               if ("$roomplayers" != "") then goto ROOM_OCCUPIED
          }
     if matchre("$roomdesc", "(%Locksmiths)") then var person $1
     if matchre("$roomobjs", "(%Locksmiths)") then var person $1
     pause 0.1
     echo ** Pouch Buyer: %person
     pause 0.1
     pause 0.1
     pause 0.1
     if ("%person" = "NULL") then goto NOT_FOUND
     pause 0.2
     put get my %COMPONENTCONTAINER
     wait
     pause 0.3
     pause 0.2
     if !matchre("$righthand $lefthand", "%COMPONENTCONTAINER") then 
          {
               put remove my %COMPONENTCONTAINER
               wait
               pause 0.1
          }
     if !matchre("$righthand $lefthand", "%COMPONENTCONTAINER") then 
          {
               put get my %COMPONENTCONTAINER from my portal
               wait
               pause 0.1
          }
     pause 0.5
     pause 0.5
     if !matchre("$righthand $lefthand", "%COMPONENTCONTAINER") then
          {
               put ask %person for pouch
               wait
               pause 0.5
               pause 0.5
               var COMPONENTCONTAINER $righthand
          }
     pause 0.2
     pause 0.4
     if ("$guild" = "Thief") then 
          {
               put give my %COMPONENTCONTAINER to %person
               pause 0.2
               put sell my %COMPONENTCONTAINER
               pause 0.5
               pause 0.3
               pause 0.2
               gosub COMPONENT_CHECK
               if ("%comp" != "NULL") then
                    {
                         pause 0.1
                         put give my %COMPONENTCONTAINER to %person
                         put sell my %COMPONENTCONTAINER
                         pause 0.5
                         pause 0.3
                         gosub COMPONENT_CHECK
                         if ("%comp" != "NULL") then
                              {
                                   put give my %COMPONENTCONTAINER to %person
                                   put sell my %COMPONENTCONTAINER
                                   pause 0.5
                                   pause 0.3
                              }
                    }
               pause 0.3
               put wear my %COMPONENTCONTAINER
               pause 0.5
               goto RETURN_TO_BANK
          }
     echo *** Checking Containers for Trap Components
     gosub COMPONENT_SELL
     pause 0.5
     }
RETURN_TO_BANK:
### RETURN TO BANK
     gosub AUTOMOVE teller
     pause 0.3
     put deposit all
     pause
     goto DONE_DONE
PAWN_COMPONENTS:
     if !matchre("$zoneid", "\b(1|30|47|67)\b") then
          {
               echo *** NO PAWNSHOP HERE!
               goto DONE_DONE
          }
     if matchre("$zoneid","\b(1|30|47|67|42|90|99|107|116)\b") then gosub AUTOMOVE pawn
     gosub COMPONENT_SELL
     goto DONE_DONE
NOT_FOUND:
     echo ========================
     echo ** LOCKSMITH/PAWN GUY NOT RECOGNIZED!!
     echo ========================
     pause
     goto DONE_DONE
ROOM_OCCUPIED:
     echo ================
     echo ** ROOM IS OCCUPIED 
     echo ** UNABLE TO SELL COMPONENTS
     echo ===============
     pause
     goto PAWN_COMPONENTS
     
##############################################################
### END OF SCRIPT
DONE_DONE:
     gosub STOWING
     if (("$guild" = "Cleric") && (%shadowling = 1)) then goto SHADOWLING
     echo
     echo ###############
     echo ** TRAP TYPES FOUND (This run):
     if (%concussion.count > 0) then
          {
               var tempadd 0
               echo * Concussion: %concussion.count
               var tempadd $DisarmTraps_Concussion
               math tempadd add %concussion.count
               pause 0.001
               put #var DisarmTraps_Concussion %tempadd
          }
     if (%teleport.count > 0) then
          {
               var tempadd 0
               echo * Teleport: %teleport.count
               var tempadd $DisarmTraps_Teleport
               math tempadd add %teleport.count
               pause 0.001
               put #var DisarmTraps_Teleport %tempadd
          }
     if (%shrapnel.count > 0) then
          {
               var tempadd 0
               echo * Shrapnel: %shrapnel.count
               var tempadd $DisarmTraps_Shrapnel
               math tempadd add %shrapnel.count
               pause 0.001
               put #var DisarmTraps_Shrapnel %tempadd
          }
     if (%disease.count > 0) then
          {
               var tempadd 0
               echo * Disease: %disease.count
               var tempadd $DisarmTraps_Disease
               math tempadd add %disease.count
               pause 0.001
               put #var DisarmTraps_Disease %tempadd
          }
     if (%gas.count > 0) then
          {
               var tempadd 0
               echo * Deadly Gas: %gas.count
               var tempadd $DisarmTraps_Gas
               math tempadd add %gas.count
               pause 0.001
               put #var DisarmTraps_Gas %tempadd
          }
     if (%lightning.count > 0) then
          {
               var tempadd 0
               echo * Lightning: %lightning.count
               var tempadd $DisarmTraps_Lightning
               math tempadd add %lightning.count
               pause 0.001
               put #var DisarmTraps_Lightning %tempadd
          }
     if (%shocker.count > 0) then
          {
               var tempadd 0
               echo * Shocker: %shocker.count
               var tempadd $DisarmTraps_Shocker
               math tempadd add %shocker.count
               pause 0.001
               put #var DisarmTraps_Shocker %tempadd
          }
     if (%reaper.count > 0) then
          {
               var tempadd 0
               echo * Reaper: %reaper.count
               var tempadd $DisarmTraps_Reaper
               math tempadd add %reaper.count
               pause 0.001
               put #var DisarmTraps_Reaper %tempadd
          }
     if (%naphtha_soaker.count > 0) then
          {
               var tempadd 0
               echo * Naphtha Soaker: %naphtha_soaker.count
               var tempadd $DisarmTraps_Naphtha.Soak
               math tempadd add %naphtha_soaker.count
               pause 0.001
               put #var DisarmTraps_Naphtha.Soak %tempadd
          }
     if (%naphtha.count > 0) then
          {
               var tempadd 0
               echo * Naphtha: %naphtha.count
               var tempadd $DisarmTraps_Naphtha
               math tempadd add %naphtha.count
               pause 0.001
               put #var DisarmTraps_Naphtha %tempadd
          }
     if (%acid.count > 0) then
          {
               var tempadd 0
               echo * Acid: %acid.count
               var tempadd $DisarmTraps_Acid
               math tempadd add %acid.count
               pause 0.001
               put #var DisarmTraps_Acid %tempadd
          }
     if (%boomer.count > 0) then
          {
               var tempadd 0
               echo * Boomer: %boomer.count
               var tempadd $DisarmTraps_Boomer
               math tempadd add %boomer.count
               pause 0.001
               put #var DisarmTraps_Boomer %tempadd
          }
     if (%scythe.count > 0) then
          {
               var tempadd 0
               echo * Scythe: %scythe.count
               var tempadd $DisarmTraps_Scythe
               math tempadd add %scythe.count
               pause 0.001
               put #var DisarmTraps_Scythe %tempadd
          }
     if (%poison_local.count > 0) then
          {
               var tempadd 0
               echo * Poison (local): %poison_local.count
               var tempadd $DisarmTraps_Poison.Local
               math tempadd add %poison_local.count
               pause 0.001
               put #var DisarmTraps_Poison.Local %tempadd
          }
     if (%poison_nerve.count > 0) then
          {
               var tempadd 0
               echo * Poison (nerve): %poison_nerve.count
               var tempadd $DisarmTraps_Poison.Nerve
               math tempadd add %poison_nerve.count
               pause 0.001
               put #var DisarmTraps_Poison.Nerve %tempadd
          }
     if (%poison_bolt.count > 0) then
          {
               var tempadd 0
               echo * Poison Bolt: %poison_bolt.count
               var tempadd $DisarmTraps_Poison.Bolt
               math tempadd add %poison_bolt.count
               pause 0.001
               put #var DisarmTraps_Poison.Bolt %tempadd
          }
     if (%cyanide.count > 0) then
          {
               var tempadd 0
               echo * Cyanide: %cyanide.count
               var tempadd $DisarmTraps_Cyanide
               math tempadd add %cyanide.count
               pause 0.001
               put #var DisarmTraps_Cyanide %tempadd
          }
     if (%curse.count > 0) then
          {
               var tempadd 0
               echo * Curse: %curse.count
               var tempadd $DisarmTraps_Curse
               math tempadd add %curse.count
               pause 0.001
               put #var DisarmTraps_Curse %tempadd
          }
     if (%bolt.count > 0) then
          {
               var tempadd 0
               echo * Crossbow Bolt: %bolt.count
               var tempadd $DisarmTraps_Bolt
               math tempadd add %bolt.count
               pause 0.001
               put #var DisarmTraps_Bolt %tempadd
          }
     if (%fire_ant.count > 0) then
          {
               var tempadd 0
               echo * Fire Ant: %fire_ant.count
               var tempadd $DisarmTraps_FireAnt
               math tempadd add %fire_ant.count
               pause 0.001
               put #var DisarmTraps_FireAnt %tempadd
          }
     if (%frog.count > 0) then
          {
               var tempadd 0
               echo * Frog: %frog.count
               var tempadd $DisarmTraps_Frog
               math tempadd add %frog.count
               pause 0.001
               put #var DisarmTraps_Frog %tempadd
          }
     if (%flea.count > 0) then
          {
               var tempadd 0
               echo * Flea: %flea.count
               var tempadd $DisarmTraps_Flea
               math tempadd add %flea.count
               pause 0.001
               put #var DisarmTraps_Flea %tempadd
          }
     if (%bouncer.count > 0) then
          {
               var tempadd 0
               echo * Bouncer: %bouncer.count
               var tempadd $DisarmTraps_Bouncer
               math tempadd add %bouncer.count
               pause 0.001
               put #var DisarmTraps_Bouncer %tempadd
          }
     if (%laughing.count > 0) then
          {
               var tempadd 0
               echo * Laughing Gas: %laughing.count
               var tempadd $DisarmTraps_LaughingGas
               math tempadd add %laughing.count
               pause 0.001
               put #var DisarmTraps_LaughingGas %tempadd
          }
     if (%sleeper.count > 0) then
          {
               var tempadd 0
               echo * Sleeper: %sleeper.count
               var tempadd $DisarmTraps_Sleeper
               math tempadd add %sleeper.count
               pause 0.001
               put #var DisarmTraps_Sleeper %tempadd
          }
     if (%mime.count > 0) then
          {
               var tempadd 0
               echo * Mime: %mime.count
               var tempadd $DisarmTraps_Mime
               math tempadd add %mime.count
               pause 0.001
               put #var DisarmTraps_Mime %tempadd
          }
     if (%mana_sucker.count > 0) then
          {
               var tempadd 0
               echo * Mime: %mana_sucker.count
               var tempadd $DisarmTraps_Mana.Sucker
               math tempadd add %mana_sucker.count
               pause 0.001
               put #var DisarmTraps_Mana.Sucker %tempadd
          }
     if (%shadowling.count > 0) then
          {
               var tempadd 0
               echo * Mime: %shadowling.count
               var tempadd $DisarmTraps_Shadowling
               math tempadd add %shadowling.count
               pause 0.001
               put #var DisarmTraps_Shadowling %tempadd
          }
     echo ###############
     echo
     echo ###############
     echo ** TOTAL TRAPS FOUND OVER ALL TIME **
     echo * (Sorted by most deadly to least)
     echo * CONCUSSION: $DisarmTraps_Concussion
     echo * SHRAPNEL: $DisarmTraps_Shrapnel
     echo * TELEPORT: $DisarmTraps_Teleport
     echo * DISEASE: $DisarmTraps_Disease
     echo * LIGHTNING: $DisarmTraps_Lightning
     echo * DEADLY GAS: $DisarmTraps_Gas
     echo * NAPHTHA: $DisarmTraps_Naphtha
     echo * NAPHTHA SOAKER: $DisarmTraps_Naphtha.Soak
     echo * POISON (NERVE): $DisarmTraps_Poison.Nerve
     echo * POISON (LOCAL): $DisarmTraps_Poison.Local
     echo * POISON BOLTS: $DisarmTraps_Poison.Bolt
     echo * CROSSBOW BOLTS: $DisarmTraps_Bolt
     echo * REAPER: $DisarmTraps_Reaper
     echo * FIRE ANT: $DisarmTraps_FireAnt
     echo * ACID: $DisarmTraps_Acid
     echo * BOOMER: $DisarmTraps_Boomer
     echo * SCYTHE: $DisarmTraps_Scythe
     echo * SHOCKER: $DisarmTraps_Shocker
     echo * CYANIDE: $DisarmTraps_Cyanide
     echo * MANA DRAINER: $DisarmTraps_Mana.Sucker
     echo * FROG: $DisarmTraps_Frog
     echo * FLEAS: $DisarmTraps_Flea
     echo * LAUGHING GAS: $DisarmTraps_LaughingGas
     echo * BOUNCER: $DisarmTraps_Bouncer
     echo * SLEEPER: $DisarmTraps_Sleeper
     echo * SHADOWLING: $DisarmTraps_Shadowling
     echo * MIME: $DisarmTraps_Mime
     echo ###############
     echo
     pause 0.5
     echo
     echo ===============
     echo * DONE PICKING BOXES!
     echo ===============
     echo
     pause 0.1
     put #parse DONE PICKING BOXES
     put #parse DONE BOXES!
     put #parse BOXES DONE!
     put #parse DONE PICKING BOXES!
     exit
SAVE:
     pause 0.1
     pause 0.0001
     pause 0.0001
     goto %SAVE
     
SHADOWLING:
     echo
     echo *** PAUSING TO LET SHADOWLING WEAR OFF 
     echo *** TYPE: "GO" to continue anyway
     echo
     matchre SHADOWLINGDONE GO
     matchwait 300
SHADOWLINGDONE:    
     var shadowling 0
     put 'oi!
     goto DONE_DONE
     
### COMPONENT POUCH SELLING TO THE LOCKSMITH 
COMPONENT_CHECK:
     var comp NULL
     if matchre("$roomdesc", "(%Locksmiths)") then var person $1
     if matchre("$roomobjs", "(%Locksmiths)") then var person $1
     pause 0.1
     echo ** Component Buyer: %person
     pause 0.1
     pause 0.1
     pause 0.1
     if ("%person" = "NULL") then goto NOT_FOUND
     pause 0.1
COMPONENT_CHECK_1:
     var comploop 0
     var LAST COMPONENT_CHECK_1
     var bag %CONTAINER1
     matchre COMPONENT_GET (%component_list)
	put rummage in my %bag
	matchwait 2
COMPONENT_CHECK_2:
     var comploop 0
     var LAST COMPONENT_CHECK_2
	var bag %CONTAINER2
     pause 0.1
     matchre COMPONENT_GET (%component_list)
	put rummage in my %bag
	matchwait 2
COMPONENT_CHECK_3:
     var comploop 0
     var LAST COMPONENT_CHECK_3
	var bag %CONTAINER3
     pause 0.1
     matchre COMPONENT_GET (%component_list)
	put rummage in my %bag
	matchwait 2
     return
COMPONENT_GET:
     var comp $1
COMPONENT_GET_1:
     math comploop add 1
     if (%comploop > 25) then goto %LAST
     if (%comploop > 10) then
          {
               put give my %COMPONENTCONTAINER to %person
          }
     pause 0.01
     pause 0.01
     pause 0.01
     put get %comp from %bag
     pause 0.2
     pause 0.1
     pause 0.01
     if (matchre("$righthand $lefthand", "(%component_list)") && !matchre("%COMPONENTCONTAINER", "(?i)(NULL|OFF)")) then
          {
               if matchre("$righthand", "%component_list") then put put $righthandnoun in %COMPONENTCONTAINER
               if matchre("$lefthand", "%component_list") then put put $lefthandnoun in %COMPONENTCONTAINER
               pause 0.3
               pause 0.2
               pause 0.1
               if !matchre("$righthand $lefthand", "(%component_list)")  then goto COMPONENT_GET_1
          }
     goto %LAST

### COMPONENT SELLING TO THE PAWNSHOP 
COMPONENT_SELL:
     var Locksmiths Ragge|Kilam|Hekipe|Sephina|Ss'thran|Cormyn|Bynari|Dorsot|Ioun|Ishh|Oweede|Paedraig|Relf|Saeru|Dumi|Ss\'thran
     var comp NULL
     if matchre("$roomdesc", "(%Locksmiths)") then var person $1
     if matchre("$roomobjs", "(%Locksmiths)") then var person $1
     pause 0.1
     pause 0.1
     pause 0.1
     echo ** Component Buyer: %person
     pause 0.1
     pause 0.1
     pause 0.1
     if ("%person" = "NULL") then goto NOT_FOUND
     pause 0.1
COMPONENT_SELL_1:
     var comploop 0
     var LAST COMPONENT_SELL_1
     var bag %CONTAINER1
     matchre COMPONENT_DO (%component_list)
	put rumm in my %bag
	matchwait 2
COMPONENT_SELL_2:
     var comploop 0
     var LAST COMPONENT_SELL_2
	var bag %CONTAINER2
     pause 0.1
     matchre COMPONENT_DO (%component_list)
	put rumm in my %bag
	matchwait 2
COMPONENT_SELL_3:
     var comploop 0
     var LAST COMPONENT_SELL_3
	var bag %CONTAINER3
     pause 0.1
     matchre COMPONENT_DO (%component_list)
	put rumm in my %bag
	matchwait 2
COMPONENT_SELL_4:
     var comploop 0
     var LAST COMPONENT_SELL_3
	var bag %COMPONENTCONTAINER
     if matchre("%COMPONENTCONTAINER", "(?i)(NULL|OFF|NO|NIL)") then return
     pause 0.1
     matchre COMPONENT_DO (%component_list)
	put rumm in my %bag
	matchwait 2
     return
COMPONENT_DO:
     var comp $1
COMPONENT_DO_1:
     math comploop add 1
     if (%comploop > 20) then goto %LAST
     pause 0.01
     pause 0.01
     pause 0.01
     put get %comp from %bag
     wait
     pause 0.1
     pause 0.1
     pause 0.01
     if matchre("$righthand $lefthand", "(%component_list)") then
          {
               send sell $righthandnoun
               send give $righthandnoun to %person
               wait
               pause 0.1
               pause 0.1
               goto COMPONENT_DO_1
          }
     goto %LAST
####################################################################
#  BLOWN TRAPS HANDLING SECTION
# THIS SECTION TELLS THE SCRIPT WHAT TO DO WHEN YOU BLOW A TRAP
####################################################################
BLOWN_TRAP_PAUSE:
     pause 5
BLOWN_TRAP:
     pause 0.0001
     pause 0.0001
     pause 0.0001
     put #echo >Log Red ** Blew a %TRAP.TYPE trap!
     pause 0.0001
     if (("$guild" = "Barbarian") && ($stunned)) then
          {
               put berserk flashflood
               pause 0.5
               pause 0.2
          }
     if ($stunned) then waiteval (!$stunned)
     echo ***
     echo *** Assessing the situation...
     echo ***
     echo
     pause 0.2
     pause 0.0001
     if (%TRAP.TYPE = "fire_ant") then goto FIREANT_TRAP
     if (%TRAP.TYPE = "acid") then goto ACID_TRAP
     if (%TRAP.TYPE = "cyanide") then goto DART_TRAP
     if (%TRAP.TYPE = "bolt") then goto BOLT_TRAP
     if (%TRAP.TYPE = "poison_bolt") then goto BOLT_TRAP
     if (%TRAP.TYPE = "flea") then goto FLEA_TRAP
     if (%TRAP.TYPE = "bouncer") then goto BOUNCER_TRAP
     if (%TRAP.TYPE = "curse") then goto CURSE_TRAP
     if (%TRAP.TYPE = "frog") then goto FROG_TRAP
     if (%TRAP.TYPE = "laughing") then goto LAUGHING_TRAP
     if (%TRAP.TYPE = "mana_sucker") then goto MANA_TRAP
     if (%TRAP.TYPE = "mime") then goto MIME_TRAP
     if (%TRAP.TYPE = "shadowling") then goto SHADOWLING_TRAP
     if (%TRAP.TYPE = "sleeper") then goto SLEEPER_TRAP
     if (%TRAP.TYPE = "reaper") then goto REAPER_TRAP
     if (%TRAP.TYPE = "poison_nerve") then goto POISON_PAUSE
     if (%TRAP.TYPE = "poison_local") then goto POISON_PAUSE
     if (%TRAP.TYPE = "concussion") then goto HEALTH
     if (%TRAP.TYPE = "disease") then goto HEALTH
     if (%TRAP.TYPE = "gas") then goto HEALTH
     if (%TRAP.TYPE = "lightning") then goto HEALTH
     if (%TRAP.TYPE = "naphtha_soaker") then goto HEALTH
     if (%TRAP.TYPE = "scythe") then goto HEALTH
     if (%TRAP.TYPE = "shocker") then goto HEALTH
     if (%TRAP.TYPE = "boomer") then goto HEALTH
     if (%TRAP.TYPE = "shrapnel") then goto HEAL_DELAY
     if (%TRAP.TYPE = "naphtha") then goto HEAL_DELAY
     goto HEALTH

BOUNCER_TRAP:
     echo
     echo *** BLEW A BOUNCER TRAP! FUCK IT! LET IT GO...
     echo *** RESTARTING SCRIPT IN 5....
     echo
     pause 5
     gosub stowing
	pause
     goto TOP

MANA_TRAP:
     echo
     echo *** BLEW A MANA ZAPPER TRAP
     if ($guild = Thief") then
          {
               echo *** NOTHING TO WORRY ABOUT! NO MANA HAHA
          }
     if ($guild != Thief") then
          {
               echo *** OH WELL... NO MANAS FOR US FOR A WHILE
          }
     echo
     pause 4
     gosub stowing
	pause
     goto TOP

MIME_TRAP:
     pause 0.1
     echo
     echo *** BLEW A MIME TRAP!
     echo *** GOOD JOB DUMBASS! NOW YOU HAVE TO WAIT!
     echo
     pause 0.1
     put dance hap
     waitfor You suddenly feel nauseous
     gosub stowing
	pause
     goto TOP

CURSE_TRAP:
     action goto DONE_CURSE when ^The eerie black radiance fades
     echo
     echo *** BLEW A CURSE TRAP!
     echo *** WAITING FOR IT TO WEAR OFF
     echo *** OR GET A CLERIC TO UNCURSE!
     echo
     matchre DONE_CURSE ^The eerie black radiance fades|The curse on the .+ breaks
     pause 3
     if !("$roomplayers" = "") then
          {
               random 1 3
               if (%r = 1) then put 'help! I be cursed from a box.. any clerics about?
               if (%r = 2) then put 'anyone able to uncurse?
               if (%r = 3) then put 'could someone assist with uncursing me?
          }
     matchwait 100
     goto CURSE_TRAP
DONE_CURSE:
     action remove ^The eerie black radiance fades|The curse on the .+ breaks
     gosub stowing
     pause
     goto TOP

FROG_TRAP:
     echo
     echo *** BLEW A FROG TRAP!
     echo *** NEED TO GET KISSED OR JUST WAIT IT OUT!
     echo
     pause 2
     put 'Help.. I'm a frog! Someone kiss me please!
     waitfor puff of green smoke
	gosub stowing
	pause
     goto TOP

SLEEPER_TRAP:
     echo
     echo *** BLEW A SLEEPER TRAP!
     echo 
     pause 0.5
     echo *** WAKING UP AUTOMATICALLY
     echo *** ~DO NOT~ INPUT ANY COMMANDS OR TOUCH THE KEYBOARD FOR 30 SECONDS!!!!
     echo
     pause 2
SLEEP_WAKE:
     put wake
     pause 32
     gosub stand
     pause 0.5
     if ($standing = 1) then goto main
     if ($standing = 0) then
          {
               echo * I TOLD YOU NOT TO TYPE ANYTHING DUMBASS!!!
               echo * RESTARTING... DO NOT FUCKING TYPE!!!!
          }
     pause 0.5
     goto SLEEP_WAKE

LAUGHING_TRAP:
     echo
     echo *** BLEW A LAUGHING GAS TRAP!
     echo *** PAUSING TO LET IT WEAR OFF...
     echo
     pause 60
     put look
     pause 30
     if ($standing = 0) then gosub stand
	pause
     goto TOP

SHADOWLING_TRAP:
     var shadowling 1
     echo
     echo *** BLEW A SHADOWLING TRAP
     echo *** YOU'RE SPEAKING SHADOWLING FOR A BIT NOW...
     echo *** GOING BACK TO BUSINESS AS USUAL..
     echo
     pause 5
     gosub stowing
	pause
     goto TOP

FLEA_TRAP:
     action goto WATER_RUN when you realize it was actually a swarm of fleas|You notice a single flea leap off of your|Something tickles under your arm
     echo
     echo *** BLEW A FLEA TRAP!
     echo *** RUNNING FOR WATER!
     echo
     pause 0.5
WATER_RUN:
     pause 0.1
     pause 0.2
     ########## EDIT THIS SECTION TO MOVE TO WATER
     if ($zoneid = 1) then GOSUB automove NTR
     pause 0.3
     if ($zoneid = 1) then GOSUB automove NTR
     pause 0.3
     if ($zoneid = 7) then GOSUB automove 551
     pause 0.2
     if ($zoneid = 7) then GOSUB automove 551
     if ($zoneid = 7) then GOSUB automove 551
     if ($zoneid = 67) then GOSUB automove west
     if ($zoneid = 66) then GOSUB automove west
     if ($zoneid = 69) then GOSUB automove 384
     if ($zoneid = 30) then GOSUB automove 176
     if ($zoneid = 42) then GOSUB automove 102
     if ($zoneid = 61) then GOSUB automove pool
     if ($zoneid = 40) then GOSUB automove 49
     if ($zoneid = 90) then GOSUB automove 342
     if ($zoneid = 99) then GOSUB automove 270
     if ($zoneid = 150) then GOSUB automove 12
     ########## EDIT THIS SECTION TO MOVE TO WATER
     action goto FLEA_LEAVE when The water washes away the fleas
     echo
     echo **** FOUND WATER! PAUSING FOR A BIT TO LET IT WASH THE NASTIES AWAY!
     echo
     pause 10
     if ("%FIREANT" = "ON") then goto FIREANT_CONTINUE
FLEA_LEAVE:
     action remove The water washes away the fleas
     put splash
     echo **** PAUSING FOR 10+ MORE SECONDS TO MAKE SURE THOSE INFERNAL FLEAS ARE GONE!
     pause 10
     put splash
     pause 2
     ######### RETURN TO YOUR STARTING LOCATION
     pause 0.5
     if ($zoneid = 7) then GOSUB automove Crossing
     if ($zoneid = 66) then GOSUB automove shard
     if ($zoneid = 69) then GOSUB automove shard
     gosub automove %STARTING.ROOM
	gosub stowing
     pause
     goto TOP

FIREANT_TRAP:
     var FIREANT ON
     pause
     pause 0.5
     if ($stunned = 1) then goto FIREANT_TRAP
     goto WATER_RUN
FIREANT_CONTINUE:
     var FIREANT OFF
     pause 12
     put splash
     pause 7
     ######### RETURN TO YOUR STARTING LOCATION
     pause 0.5
     if ($zoneid = 7) then GOSUB automove Crossing
     if ($zoneid = 66) then GOSUB automove shard
     gosub stowing
     goto HEALTH

TELEPORT_OK:
     pause 5
     if ($stunned = 1) then goto TELEPORT_OK
     put #echo >Log Lime ** Blew a teleport trap and lived!!!! You lucky bitch!
     echo
     echo *** BLEW A TELEPORT TRAP AND LIVED!!!!
     echo *** YOU ARE NOW SOMEWHERE IN ELANTHIA! FIND YOUR WAY HOME!
     echo *** ENDING DISARM SCRIPT... AND HOPEFULLY RECOVERING.....
     echo
     put #parse YOU HAVE BEEN IDLE
     put #parse DONE BOXES!
     put #parse BOXES DONE!
     exit

TELEPORT_DEATH:
     put #echo >Log Red ** Blew a bad teleport trap and DIED! FAIL!
     echo
     echo *** BLEW A TELEPORT TRAP AND DIED!! UBER FAIL!!
     echo *** YOU ARE DEAD! BETTER LUCK NEXT TIME!
     echo *** RAISE THE DIFFICULTY ON THE BASELINE VARIABLE IF THIS HAPPENS TO YOU TOO MUCH!!
     echo
     put #parse DONE BOXES!
     put #parse BOXES DONE!
     put #script abort
     exit
TELEPORT_HURT:
     put #echo >Log Red ** Blew a bad teleport trap and got blown the fuck up!
     echo
     echo *** BLEW A TELEPORT TRAP AND GOT BLOWN UP!
     echo *** RUNNING TO FIND HEALER!!!
     echo
     goto HEALTH   
CONCUSSION_DEATH:
     put #echo >Log Red ** Death via concussion trap! Ouch.
     echo
     echo *** BLEW A CONCUSSION TRAP AND DIED!
     echo
DIED:
DIED_TRAP:
     put #echo >Log Red ** FUCKING PWNED BY A BOX!
     echo
     echo *** DIED!! FAIL!!
     echo *** LOGGING OFF!
     echo
     pause
     put #parse DONE BOXES!
     put #parse BOXES DONE!
     put health
     put #script abort
     exit

BOLT_TRAP:
     pause $roundtime
     pause 0.2
          if contains("$roomobjs","driftwood log") && ("$righthand" = "crossbow bolt") || ("$lefthand" = "crossbow bolt") then
          {
          put put my bolt in log
          pause 0.1
          }
     if "$righthandnoun" = "bolt" then send drop bolt
     if "$lefthandnoun" = "bolt" then send drop bolt
     gosub stow
     pause 0.5
     gosub BLEEDCHECK
     gosub BLEEDCHECK
     pause 0.5
     BOLT.CONT:
     goto HEALTH

DART_TRAP:
     pause 0.1
     echo
     echo *** BLEW A CYANIDE TRAP
     echo
     pause
     gosub stow
     pause 0.5
     put tend my head
     pause 2
     pause 0.5
     put drop dart
     pause
     CYANIDE_PAUSE:
     echo Waiting for cyanide to wear off....
     pause 60
     goto HEALTH

ACID_TRAP:
     pause 0.5
     pause 0.5
     var ACID_TRAP ON
     echo
     echo *** WAITING FOR THE ACID TO TAKE FULL EFFECT BEFORE GETTING HEALED!
     echo
     if %health > 70 then goto HEALTH
     pause 10
     if %health > 70 then goto HEALTH
     pause 10
ACID_CHECK:
     matchre ACID_TRAP being burned|acid
     matchre HEALTH You have no|You have some|Your spirit|Your body
     put health
     matchwait 10
     goto HEAL_DELAY

REAPER_TRAP:
     gosub stowing
     if ($guild = "Empath") then goto EMPATH_RET
     pause 0.5
     echo ============================================
     echo * YOU BLEW A REAPER TRAP! GONNA BRAWL THOSE FOOLS!
     echo * HOPE YOUR COMBATS ARE UP TO SNUFF!
     echo * MIGHT WANT TO RUN AWAY IF YOU ARE A NOOB..
     echo ============================================
     pause 0.5
     send face next
     send adv
     pause
     send kick
     pause 0.5
     pause 0.5
     put punch
     pause 0.5
     put kick
     pause 0.5
     pause 0.5
     put punch
     pause 0.5
     pause 0.5
     put att
     pause
     pause 0.5
     put att
     pause
     if matchre("$roomobjs", "reaper") then goto REAPER_TRAP
     goto HEALTH
     
EMPATH_RET:
     echo ======================
     echo * BLEW A REAPER BOX! RUNNING AWAY!
     echo ======================
     goto HEALTH
     
POISON_PAUSE:
     echo
     echo *** PAUSING FOR A MINUTE TO LET THE POISON RUN ITS COURSE...
     echo
     if ($health < 75) then goto HEALTH
     if ($bleeding = 1) then goto HEALTH
     pause 20
     if ($health < 75) then goto HEALTH
     pause 10
     if ($health < 75) then goto HEALTH
     pause 10
POISONED:
     if ($health < 75) then goto HEALTH
     if ("$guild" != "Thief") then goto HEALTH
     if ("$guild" = "Thief") && ($circle > 60) && ($health > 98) then goto THIEF_POISON
     goto HEALTH
THIEF_POISON:
     if ($bleeding = 1) then goto HEALTH
     echo
     echo *** Got Posioned but toughing it out.. you're a damn thief anyway!
     echo
     put #echo >Log Yellow ** Not too hurt from the poison.. continuing 
     goto DONE_HEAL
DROPPED_BOX:
     echo
     echo *** WOOPS.. dropped a box... 
     echo *** Checking health and getting healed if needed...
     echo
     put #echo >Log Yellow ** Oh crap maybe the poison did mess us up... getting healed
     gosub stowing
     pause 0.5
     if ($health > 90) then goto HEALTH
     goto TOP
     
JUSTICE_CHECK:
     pause 0.001
     matchre NECRO_KNOWN convinced you are either a necromancer
     matchre NECRO_KNOWN some kind of sorcerer
     matchre NECRO_UNKNOWN You|You\'re
     send justice
     matchwait 4
     goto NECRO_UNKNOWN
NECRO_KNOWN:
     var Necro.Known 1
     echo * KNOWN AS A NECRO!
     return
NECRO_UNKNOWN:
     var Necro.Known 0
     echo * NOT KNOWN AS A NECRO
     return
####################################################
# END TRAP HANDLING SECTION
####################################################

###########################
# HEALING SECTION
###########################
HEAL_DELAY:
     ECHO ** PAUSING BEFORE GETTING HEALED!!
     if (%Necro.Known = 1) then goto NECRO_NOHEAL
     pause 20
HEAL_PAUSE:
     if (%Necro.Known = 1) then goto NECRO_NOHEAL
     pause 10
HEALTH:
     if (%Necro.Known = 1) then goto NECRO_NOHEAL
     pause 0.5
     gosub HEALTH_CHECK
     if ($needHealing) && matchre("%AUTOHEAL", "(?i)(NO|OFF)") then
          {
               echo ** VAR AUTOHEAL IS OFF
               echo ** Aborting Script! Go Get healed yourself!!
               put #parse GET HEALED!
               put #parse DISARM DONE!
               put #parse DONE DISARM!
               exit
          }
     if ($health < 70) then goto FIND
     if ($needHealing) then goto FIND
     if matchre("$roomobjs", "reaper") then goto FIND
     else goto DONE_HEAL
FIND:
     var loops 0
     var attempts 0
     put #echo >Log Yellow **** Blew a box! Running to get healed!
     echo
     echo *** YOU HAVE BEEN HURT BY A BOX!
     echo *** FINDING HEALER!
     echo
     if (("$guild" = "Barbarian") && ($Bleeding = 1)) then 
          {
               if (%yogi = 0) then send kneel
               pause 0.2
               send meditate staunch
               pause 2
               pause 0.5
               send berserk famine
               pause 0.5
               pause 0.2
               if (!$standing) then gosub stand
          }
     if ("$game" = "DRF") && ("$zoneid" = "150") then goto TO_ARCH_HEALER
     if ("$charactername" != "Azothy") then goto TO_AUTOEMPATH
     if !matchre("$zoneid","(66|67|69)") then goto TO_AUTOEMPATH
     goto TO_AUTOEMPATH
NECRO_NOHEAL:
     echo ============================
     echo ** YOU ARE KNOWN AS A NECRO!
     echo ** SKIPPING AUTOHEALER!
     echo ** GO GET HEALED MANUALLY
     echo ===========================
     pause
     put #parse GET HEALED!
     put #parse DISARM DONE!
     put #parse DONE DISARM!
     exit
     
TO_ARCH_HEALER:
     pause 0.1
     if ("$roomid" != "85") then gosub AUTOMOVE 85
     pause 0.3
	if matchre("$roomplayers","(Marino|Sawbones|Bedlam|Skrillex|Odium|Spinebreaker|Thad|Bayndayd)") then
		{
			send demeanor neutral
			waitforre ^You decide to take things as they come\.
               if matchre("$roomplayers", "Bayndayd") then var Empath Bayndayd
               if matchre("$roomplayers", "Thad") then var Empath Thad
               if matchre("$roomplayers", "Marino") then var Empath Marino
               if matchre("$roomplayers", "Sawbones") then var Empath Sawbones
               if matchre("$roomplayers", "Skrillex") then var Empath Skrillex
               if matchre("$roomplayers", "Bedlam") then var Empath Bedlam
               if matchre("$roomplayers", "Odium") then var Empath Odium
               if matchre("$roomplayers", "Gwyddion") then var Empath Gwyddion
               if matchre("$roomplayers", "Spinebreaker") then var Empath Spinebreaker
			gosub LEAN
               goto DONE_HEAL
		}
     echo ================================
     echo *** No Empaths Found in Room 85
     echo *** Checking Alcove
     echo ================================
     if ("$zoneid" = "150") then gosub AUTOMOVE 45
     pause 0.5
     if matchre("$roomplayers","(Gwyddion|Marino|Sawbones|Bedlam|Skrillex|Odium|Spinebreaker|Thad|Bayndayd)") then
          {
               send demeanor neutral
               waitforre ^You decide to take things as they come\.
               if matchre("$roomplayers", "Bayndayd") then var Empath Bayndayd
               if matchre("$roomplayers", "Thad") then var Empath Thad
               if matchre("$roomplayers", "Marino") then var Empath Marino
               if matchre("$roomplayers", "Sawbones") then var Empath Sawbones
               if matchre("$roomplayers", "Skrillex") then var Empath Skrillex
               if matchre("$roomplayers", "Bedlam") then var Empath Bedlam
               if matchre("$roomplayers", "Odium") then var Empath Odium
               if matchre("$roomplayers","Gwyddion") then var Empath Gwyddion
               if matchre("$roomplayers", "Spinebreaker") then var Empath Spinebreaker
               gosub LEAN
               goto DONE_HEAL
          }
     echo ================================
     echo *** No Empaths Found in Room 45
     echo *** Using NPC Empath!
     echo ================================
		{
			put #echo >Log Hotpink **** NO Empaths in Arch! Using Auto Puff****
			var Empath Yrisa
			gosub AUTOMOVE teller
               pause 0.2
			put withdraw 10 gold
			pause 0.8
			gosub AUTOMOVE healer
			send demeanor neutral
			waitforre ^You decide to take things as they come\.
			send join list
			waitforre ^Yrisa crosses $charactername\'s name from the list\.
			var Empath Yrisa
			GOSUB STAND
			pause 0.1
			goto DONE_HEAL
		}
LEAN:
	action put #parse ^%Empath nods to you. when ^%Empath whispers\, \"You have leaned on me with no wounds\.\"
LEAN_CONTINUE:
	matchre DONE_HEAL ^%Empath nods to you\.|Your wounds are healed|%Empath coughs
	send lean %Empath
	matchwait 40
	gosub HEALTH_CHECK
	if (!$needHealing) then goto DONE_HEAL
	goto LEAN_CONTINUE
    

HEALTH_PAUSE:
     echo ** STUNNED! waiting for it to wear off..
     pause 2
     pause
     goto HEALTH_CHECKZ
TO_AUTOEMPATH:
TO_AUTOHEALER:
EMPATH_CHECK:
     pause 0.5
     if ($stunned = 1) then goto HEALTH_PAUSE
     if ($standing = 0) then gosub stand
     gosub BLEEDERCHECK
ENSURE_IN_CITY:
     if ("$zoneid" = "127") then gosub AUTOMOVE hib
     if ("$zoneid" = "127") then gosub AUTOMOVE hib
     if ("$zoneid" = "116") then gosub AUTOMOVE healer
     if ("$zoneid" = "123") then gosub AUTOMOVE hib
     if ("$zoneid" = "123") then gosub AUTOMOVE hib
     if ("$zoneid" = "9b") then gosub AUTOMOVE NTR
     if ("$zoneid" = "10") then gosub AUTOMOVE NTR
     if ("$zoneid" = "14b") then gosub AUTOMOVE NTR
     if ("$zoneid" = "12a") then gosub AUTOMOVE NTR
     if ("$zoneid" = "13") then gosub AUTOMOVE NTR
     if ("$zoneid" = "11") then gosub AUTOMOVE NTR
     if ("$zoneid" = "2d") then gosub AUTOMOVE temple
     if ("$zoneid" = "2a") then gosub AUTOMOVE crossing
     if ("$zoneid" = "4a") then gosub AUTOMOVE crossing
	if ("$zoneid" = "1f") then gosub AUTOMOVE crossing
     if ("$zoneid" = "1e") then gosub AUTOMOVE crossing
     if ("$zoneid" = "1g") then gosub AUTOMOVE crossing
     if ("$zoneid" = "1h") then gosub AUTOMOVE crossing
     if ("$zoneid" = "1k") then gosub AUTOMOVE crossing
     if ("$zoneid" = "8") then gosub AUTOMOVE crossing
     if ("$zoneid" = "5") then gosub AUTOMOVE crossing
     if ("$zoneid" = "4") then gosub AUTOMOVE crossing
     if ("$zoneid" = "7") then gosub AUTOMOVE crossing
     if ("$zoneid" = "60") then gosub AUTOMOVE leth
     if ("$zoneid" = "63") then gosub AUTOMOVE leth
	if ("$zoneid" = "62") then gosub AUTOMOVE leth
     if ("$zoneid" = "33a") then gosub AUTOMOVE rossman
     if ("$zoneid" = "34a") then gosub AUTOMOVE forest
	if ("$zoneid" = "14c") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "30e") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "30f") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "30g") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "30h") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "30k") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "31") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "32") then gosub AUTOMOVE riverhaven
	if ("$zoneid" = "33") then gosub AUTOMOVE riverhaven
     if ("$zoneid" = "42") then gosub AUTOMOVE lang
	if ("$zoneid" = "65") then gosub AUTOMOVE shard
	if ("$zoneid" = "66") then gosub AUTOMOVE east
	if ("$zoneid" = "69") then gosub AUTOMOVE shard
     if ("$zoneid" = "116") then gosub AUTOMOVE healer
GO_AUTOHEALER:
     pause 0.1
     action goto AUTOPATH_LEAVE when crosses $charactername's name from the list|^Shalvard says, "Please get up|Shalvard looks around and says, "Kindly leave|Yolesi suddenly yells|^Kaiva crosses your name off|you look fine and healthy to me|^You sit up|^Arthianne nudges you|I think you don't really need healing|you are well|Quentin whispers, "Just between you and me and the Queen|^Atladene says to you, "You don't need healing
     send demeanor neutral
     waitforre ^You decide
     pause 0.1
     if ("$zoneid" != "90") then gosub automove healer
     if ("$zoneid" = "90") then gosub automove autopath
     pause 0.5
     if matchre ("$roomplayers", "Kinoko who is lying down") then goto LIE_DOWN
     if matchre ("$roomplayers", "Aksel who is lying down") then goto LIE_DOWN
     if matchre ("$roomplayers", "who is lying down") then goto HEALTH_WAIT
     goto LIE_DOWN
     
HEALTH_WAIT:
     put sit
     pause 0.5
HEALTH_WAIT1:
     echo *** WAITING FOR OTHER PLAYERS TO FINISH HEALING FIRST!!
     if ($sitting = 0) then put sit
     pause 0.2
     gosub HEALTH_CHECK
     gosub BLEEDERCHECK
     if !($needHealing) then goto DONE_AUTOEMPATH
     if matchre ("$roomplayers", "Kinoko who is lying down") then goto LIE_DOWN
     if matchre ("$roomplayers", "Aksel who is lying down") then goto LIE_DOWN
     if !matchre ("$roomplayers", "who is lying down") then goto LIE_DOWN
     if (($health < 70) && ($bleeding = 1)) then goto HEALTH_ANYWAY
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto LIE_DOWN
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto LIE_DOWN
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto LIE_DOWN
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto LIE_DOWN
     if ($health < 50) then goto HEALTH_ANYWAY
     put exp
     pause
     goto HEALTH_WAIT1
     
HEALTH_ANYWAY:
     pause 0.1
     random 1 3
     goto HEALTH_%r
HEALTH_1:
     put 'hate to cut in line.. but I'm dying sorry
     goto LIE_DOWN
HEALTH_2:
     put 'Sorry to cut but I need to lie down.. in critical condition
     goto LIE_DOWN
HEALTH_3:
     put 'Sorry, in very bad shape.. I must lie down before I die
     goto LIE_DOWN
     
LIE_DOWN:
     if matchre("$roomobjs", "(Shalvard|Dokt|Arthianna|Kaiva|Martyr Saedelthorp|Fraethis|Srela|Yrisa|Quentin|Elys)") then var Empath $1
     pause 0.3
     send fall
     pause 0.5
     send join list
     pause 0.5
     pause 0.2
     send join list
     pause 0.3
     if ($standing = 1) then send lie
     pause 0.5
     if ($standing = 1) then send lie
     pause 0.5
EMPATH_WAIT:
     if ($sitting = 1) then goto DONE_AUTOEMPATH
     gosub HEALTH_CHECK
     put look
     pause 0.2
     if !($needHealing) then goto DONE_AUTOEMPATH
     #if matchre ("$roomplayers", "who is lying down") && ($bleeding = 0) then goto HEALTH_WAIT
     matchre DONE_AUTOEMPATH ^Shalvard says, "Please get up|Shalvard looks around and says, "Kindly leave|^Kaiva crosses your name off|you look fine and healthy to me
     matchre DONE_AUTOEMPATH ^You sit up|^Arthianne nudges you|I think you don't really need healing|you are well|Quentin whispers, "Just between you and me and the Queen
     matchre DONE_AUTOEMPATH ^Srela says, "You're healthy|A little rest and exercise and you'll be good as new
     matchre DONE_AUTOEMPATH ^Dokt waves a large hand at you and says
     put exp
     matchwait 45
     goto EMPATH_WAIT

AUTOPATH_WAIT:
     if ($sitting = 1) then goto AUTOPATH_LEAVE
     pause 30
     if ($sitting = 1) then goto AUTOPATH_LEAVE
     pause 30
     if ($sitting = 1) then goto AUTOPATH_LEAVE
     pause 30
     put exp
     goto AUTOPATH_WAIT
     
DONE_AUTOEMPATH:
     if ($zoneid = 69) then gosub automove shard
     if ($zoneid = 68) then gosub automove shard
     if ($zoneid = 66) then gosub automove shard
DONE_HEAL:
AUTOPATH_LEAVE:
     action remove crosses $charactername's name from the list|^Shalvard says, "Please get up|Shalvard looks around and says, "Kindly leave|Yolesi suddenly yells|^Kaiva crosses your name off|you look fine and healthy to me|^You sit up|^Arthianne nudges you|I think you don't really need healing|you are well|Quentin whispers, "Just between you and me and the Queen|^Atladene says to you, "You don't need healing
     if ($standing = 0) then gosub STAND
     pause 0.5
	gosub automove %STARTING.ROOM
	pause 0.1
     pause 0.5
     put #echo >Log Pink ** Got healed! Continuing Disarm Script..
     gosub stowing
     goto TOP
######################
# GOSUBS
######################
LEAVE_SEACAVE:
LEAVE_SEACAVES:
     if ("$guild" = "Necromancer") then
          {
               if (($spellEOTB = 0) || ($invisible = 0)) then
                    {
                         put prep EOTB 15
                         pause 5
                    }
          }
     if (("$zoneid" = "150") && ($roomid != 85)) then gosub AUTOMOVE 85
     if (("$zoneid" = "150") && ($roomid != 85)) then gosub AUTOMOVE 85
     pause 0.4
     if (("$zoneid" = "150") && ($roomid != 85)) then gosub AUTOMOVE 85
     pause 0.2
     if ("$zoneid" = "150") then put go portal
     pause 0.3
     pause 0.2
     put look
     pause 0.2
     if ("$guild" = "Necromancer") && ("$preparedspell" != "None") then put cast
     pause
     return
PUT_STOW:
     put stow left
     put stow right
     pause
     goto PUT_1
PUT_STAND:
     gosub stand
     goto PUT_1
PUT:
     delay 0.0001
     var putaction $0
     var LOCATION PUT_1
     PUT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre PUT_STOW ^You need a free hand|^Free one of your hands
     matchre PUT_STAND ^You should stand up first\.|^Maybe you should stand up\.
     matchre WAIT ^\[Enter your command again if you want to\.\]
     matchre RETURN (^You'?r?e?|^As|^With|^Using).*(?:\.|\!|\?)?
     matchre RETURN ^You can't pick that up with your hands that damaged\.|^Both your hands are missing\!
     matchre RETURN (You'?r?e?|As|With|Using) (?:accept|adeptly|add|adjust|allow|already|are|aren't|ask|cut|attach|attempt|.+ to|.+ fan|bash|begin|bend|blow|breathe|briefly|bring|bundle|cannot|can't|carefully|cautiously|chop|circle|clasp|close|collect|collector's|concentrate|corruption|count|combine|come|dance|decide|deduce|dodge|don't|drum|draw|effortlessly|eyes|gracefully|deftly|desire|detach|drop|drape|exhale|fade|fail|fake|feel(?! fully rested)|feint|fill|find|filter|focus|form|fumble|gaze|gesture|giggle|gingerly|get|glance|grab|hand|hang|have|icesteel|inhale|insert|kiss|kneel|knock|leap|lean|let|lose|lift|loosen|lob|load|measure|move|must|mutter|mind|not|now|need|offer|open|parry|place|pick|push|pout|pour|put|pull|prepare|press|quietly|quickly|raise|read|reach|ready|realize|recall|remain|release|remove|retreat|reverently|rock|roll|rub|scan|search|secure|sense|set|SHEATHe|shield|should|shouldn't|shove|silently|sit|skin|slide|sling|slip|slow|slowly|spin|spread|sprinkle|start|stick|stop|strap|struggle|swap|swiftly|swing|switch|tap|take|the|though|touch|tie|tilt|toss|trace|try|tug|turn|twist|unload|untie|vigorously|wave|wear|weave|whisper|whistle|will|wink|wring|work|yank|yell|you|zills) .*(?:\.|\!|\?)?
     matchre RETURN ^Brother Durantine|^Durantine|^Mags|^Ylono|^Malik|^Kilam|^Ragge|^Randal|^Catrox|^Kamze|^Unspiek|^Wyla|^Ladar|^Dagul|^Granzer|^Gemsmith|^Fekoeti|^Diwitt|(?:An|The|A) attendant|clerk|Dwarven|spider|^.*He says,
     matchre RETURN ^The(.*)?(clerk|teller|attendant|mortar|pestle|tongs|bowl|riffler|hammer|gem|book|page|lockpick|sconce|voice|waters|contours|person|is|has|are|slides|fades|hinges|spell|not)
     matchre RETURN ^It('s)?(?:'s|a|and|the)?\s+?(?:would|will|is|a|already|dead|keen|practiced|graceful|stealthy|resounding|full|has)
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime|\[Roundtime
     matchre RETURN ^That('s)?\s+?(?:is|has|was|a|cannot|area|can't|won't|would|already|tool|will|cost|too|section)
     matchre RETURN ^With(?: (a|and|the))?\s+?(?:keen|practiced|graceful|stealthy|resounding)
     matchre RETURN ^This (is a .+ spell|is an exclusive|spell|ritual)
     matchre RETURN ^The .*(is|has|are|slides|fades|hinges|spell|not|vines|antique|(.+) spider|pattern)
     matchre RETURN ^There('s|is)?\s+(?:is(n't)?)?|does(n't)?|already|nothing|not?
     matchre RETURN ^But (?:that|you|you're|you've|the)
     matchre RETURN ^Obvious (?:exits|paths)
     matchre RETURN ^There's no room|any more room|no matter how you arrange|have all been used\.
     matchre RETURN ^That's too heavy|too thick|too long|too wide|not designed to carry|cannot hold any more
     matchre RETURN ^(You|I) can't|^Tie what\?|^You just can't|As you attempt to place your
     matchre RETURN suddenly leaps toward you|and flies towards you|with a flick
     matchre RETURN ^Brushing your fingers|^Sensing your intent|^Quietly touching your lips
     matchre RETURN Lucky for you\!\s*That isn't damaged\!|I will not repair something that isn't broken\.
     matchre RETURN I'm sorry, but I don't work on those|There isn't a scratch on that, and I'm not one to rob you\.
     matchre RETURN I don't work on those here\.|I don't repair those here|Please don't lose this ticket\!
     matchre RETURN ^Please rephrase that command\.|^I could not find|^Perhaps you should|^I don't|^Weirdly,|That can't
     matchre RETURN \[You're|^Your .*\.|\[This is|too injured
     matchre RETURN ^Moving|Brushing|Recalling|Unaware
     matchre RETURN ^.*\[Praying for \d+ sec\.\]
     matchre RETURN ^.+ is not in need|^That is closed\.
     matchre RETURN ^What (?:were you|is it)
     matchre RETURN ^In the name of love\?|^Play on|^(.+) what\?
     matchre RETURN ^It's kind of wet out here\.
     matchre RETURN ^Some (?:polished|people|tarnished|.* zills)
     matchre RETURN ^(\S+) has accepted
     matchre RETURN ^Subservient type|^The shadows|^Close examination|^Try though
     matchre RETURN ^USAGE\:|^Using your|^You.*analyze
     matchre RETURN ^Allows a Moon Mage|^Smoking commands are
     matchre RETURN ^A (?:slit|pair|shadow) .*(?:\.|\!|\?)?
     matchre RETURN ^Your (?:actions|dance|nerves) .*(?:\.|\!|\?)?
     matchre RETURN ^Having no further use for .*, you discard it\.
     matchre RETURN ^After a moment, .*\.
     matchre RETURN ^.* (?:is|are) not in need of cleaning\.
     matchre RETURN \[Type INVENTORY HELP for more options\]|\[Use INVENTORY HELP for more options\.\]
     matchre RETURN ^A vortex|^A chance for|^In a flash|^It is locked|^An aftershock
     matchre RETURN ^In the .* you see .*\.
     matchre RETURN .* (?:Dokoras|Kronars|Lirums)
     matchre RETURN ^You will now store .* in your .*\.
     matchre RETURN ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
     matchre RETURN ^\s\*LINK ALL CANCEL\s\*- Breaks all links
     matchre RETURN ^Stalking is an inherently stealthy endeavor, try being out of sight\.
     matchre RETURN ^You're already stalking|^There aren't any
     matchre RETURN ^An offer|shakes (his|her) head
     matchre RETURN ^Tie it off when it's empty\?
     matchre RETURN ^But the merchant can't see you|are invisible
     matchre RETURN Page|^As the world|^Obvious|^A ravenous energy
     matchre RETURN ^In the|^The attendant|^That is already open\.|^Your inner
     matchre RETURN ^(.+) hands you|^Searching methodically|^But you haven't prepared a symbiosis\!
     matchre RETURN ^Illustrations of complex,|^It is labeled|^Your nerves
     matchre RETURN ^The lockpick|^Doing that|is not required to continue crafting
     matchre RETURN ^Without (any|a|the)|^Wouldn't (it|that|you)
     matchre RETURN ^Weirdly, you can't manage
     matchre RETURN ^Hold hands with whom\?
     matchre RETURN ^Something in the area interferes
     matchre RETURN ^With a .+ to your voice,
     matchre RETURN ^You don't have a .* coin on you\!\s*The .* spider looks at you in forlorn disappointment\.
     matchre RETURN ^Quietly touching your lips with the tips of your fingers as you kneel\, you make the Cleric's sign with your hand\.
     matchre RETURN ^Maybe you should stand up\.
     matchre RETURN ^You sense a successful empathic link has been forged|^Touch what|^I could not find
     matchre RETURN ^The .+ has suffered too much damage and needs to be repaired at a crafting repair shop
     matchre RETURN ^The .* is not damaged enough to warrant repair\.
     matchre RETURN ^This spell cannot be targeted\.
     matchre RETURN ^You are already focusing your appraisal on a subject\.
     matchre RETURN ^You are already under the effects of an appraisal focus\.
     matchre RETURN ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
     matchre RETURN ^You can't seem to focus on that\.\s*Perhaps you're too mentally tired from researching similar principles recently\.
     matchre RETURN ^\s*LINK ALL CANCEL\s*\- Breaks all links
     matchre RETURN (bundle them with your logbook and then give|you trace|you just received a work order|You hand|You slide|You place)
     matchre RETURN ^(You have no idea how to craft|The book is already turned|You turn your book|You realize you have items bundled with the logbook)
     matchre RETURN (You measure out|You carefully break off|^You hand|\"There isn't a scratch on that|\"I don't repair those here\.)
     matchre RETURN (Just give it to me again if you want|completely undamaged and does not need repair|not damaged enough to warrant repair)
     matchre RETURN ^(You find your jar|The (\S+) can only hold)
     matchre RETURN ^(You .*open|You .*close|That is already open|That is already closed)
     matchre RETURN ^Turning your focus solemnly inward
     matchre RETURN ^Slow, rich tones form a somber introduction
     matchre RETURN ^Images of streaking stars falling from the heavens
     matchre RETURN ^Strangely, you don't feel like fighting right now\.
     matchre RETURN ^With .* movements you prepare your body for the .* spell\.
     matchre RETURN ^A strong wind swirls around you as you prepare the .* spell\.
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre RETURN ^Shadow and light collide wildly around you as you prepare the .* spell\.
     matchre RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
     matchre RETURN ^A soft breeze surrounds your body as you confidently prepare the .* spell\.
     matchre RETURN ^Light withdraws from around you as you speak arcane words for the .* spell\.
     matchre RETURN ^Tiny tendrils of lightning jolt between your hands as you prepare the .* spell\.
     matchre RETURN ^Low, hummed tones form a soft backdrop for the opening notes of the .* enchante\.
     matchre RETURN ^Heatless orange flames blaze between your fingertips as you prepare the .* spell\.
     matchre RETURN ^Throwing your head back, you release a savage roar and growl words for the .* spell\.
     matchre RETURN ^Entering a trance-like state, your hands begin to tremble as you prepare the .* spell\.
     matchre RETURN ^Glowing geometric patterns arc between your upturned palms as you prepare the .* spell\.
     matchre RETURN ^Focusing intently, you slice seven straight lines through the air as you invoke the .* spell.\.
     matchre RETURN ^Accompanied with a flash of light, you clap your hands sharply together in preparation of the .* spell\.
     matchre RETURN ^Icy blue frost crackles up your arms with the ferocity of a blizzard as you begin to prepare the .* spell\!
     matchre RETURN ^A radiant glow wreathes your hands as you weave lines of light into the complicated pattern of the .* spell\.
     matchre RETURN ^Kaleidoscopic ribbons of light swirl between your outstretched hands, coalescing into a spectral wildling spider\.
     matchre RETURN ^Darkly gleaming motes of sanguine light swirl briefly about your fingertips as you gesture while uttering the .* spell\.
     matchre RETURN ^As you begin to solemnly intone the .* spell a blue glow swirls about forming a nimbus that surrounds your entire being\.
     matchre RETURN ^As you slam your fists together and inhale sharply, a glowing outline begins to form and a matrix of blue and white motes surround you\.
     matchre RETURN ^In one fluid motion, you bring your palms close together and a fiery crimson mist begins to burn within them as you prepare the .* spell\.
     matchre RETURN ^The first gentle notes of .* waft from you with delicate ease, riddled with low tones that gradually give way to a higher\-pitched theme\.
     matchre RETURN ^Droplets of water coalesce around your fingertips as your arms undulate like gracefully flowing river currents to form the pattern of the .* spell\.
     matchre RETURN ^Inhaling deeply, you adopt a cyclical rhythm in your breaths to reflect the ebb and flow of the natural world and steel yourself to prepare the .* spell\.
     matchre RETURN ^Calmly reaching out with one hand, a silvery-blue beam of light descends from the sky to fill your upturned palm with radiance as you prepare the .* spell\.
     matchre RETURN ^Turning your head slightly and gazing directly ahead with a calculating stare, tiny sparks of crystalline light flash around your eyes as you prepare the .* spell\.
     matchre RETURN ^You take up a handful of dirt in your palm to prepare the .* spell\.  As you whisper arcane words, you gently blow the dust away and watch as it becomes swirling motes of
     send %putaction
     matchwait 15
     put #echo >Log Crimson *** MISSING MATCH IN PUT! (%scriptname.cmd) ***
     put #echo >Log Crimson Command = %putaction
     put #log $datetime MISSING MATCH IN PUT! Command = %putaction (%scriptname.cmd)
     return
     
WEAR_ARMOR:
     if (%total_armor = 0) then RETURN
     echo
     echo **** PUTTING YOUR ARMOR BACK ON! ****
     echo
     pause 0.4
     if ("%armor1" != "null") then
          {
               ECHO *** ARMOR: %armor1 ***
               PUT get my %armor1 from %armor1Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor1
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor2" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor2 ***
               PUT get my %armor2 from %armor2Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor2
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor3" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor3 ***
               PUT get my %armor3 from %armor3Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor3
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor4" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor4 ***
               PUT get my %armor4 from %armor4Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor4
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor5" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor5 ***
               PUT get my %armor5 from %armor5Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor5
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor6" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor6 ***
               PUT get my %armor6 from %armor6Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor6
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor7" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor7 ***
               PUT get my %armor7 from %armor7Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor7
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor8" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor8 ***
               PUT get my %armor8 from %armor8Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor8
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor9" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor9 ***
               PUT get my %armor9 from %armor9Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor9
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor10" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor10 ***
               PUT get my %armor10 from %armor10Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor10
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor11" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor11 ***
               PUT get my %armor11 from %armor11Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor11
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor12" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor12 ***
               PUT get my %armor12 from %armor12Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor12
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor13" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor13 ***
               PUT get my %armor13 from %armor10Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor13
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("%armor14" != "null") then
          {
               gosub stowing
               ECHO *** ARMOR: %armor14 ***
               PUT get my %armor14 from %armor10Container
               pause 0.5
               pause 0.3
               if matchre("$righthand", "(((violet|black|audrualm|orichalcum|bone-white|dark|white|stirring|oiled|chitinous|clouded|viscid|indigo) orb)|((glacial-blue|vermillion|kaleidoscopic) ring))") then PUT rub my $righthandnoun
               else PUT wear my %armor14
               pause 0.5
               if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
               pause 0.3
          }
     if ("$righthand" != "Empty") then gosub PUT wear my $righthandnoun
     pause 0.0001
     return

#version 1.0
	Base.ListExtract:
		var Base.ListVar $1
		var Base.NounListVar $2
		var Base.ItemCountVar $3

		eval %Base.ListVar replace("%%Base.ListVar", ", ", "|")
		eval %Base.ListVar replacere("%%Base.ListVar", "( and )(?:a |an |some )(?!.*and (a |an |some ))","|")
		var %Base.ListVar |%%Base.ListVar
		eval %Base.ItemCountVar count("%%Base.ListVar", "|")
		var %Base.NounListVar %%Base.ListVar
	Base.ListExtract.Loop.Trim:
		eval %Base.NounListVar replacere ("%%Base.NounListVar", "\|[\w'-]+ ", "|")
		if contains("%%Base.NounListVar", " ") then goto Base.ListExtract.Loop.Trim
	return

FINDTOP:
     gosub BLEEDER_CHECK
     gosub BLEEDER_CHECK
     if ($zoneid = 66) then gosub automove east
     if ($zoneid = 67) then gosub automove west
     if ($zoneid = 69) then gosub automove 383
     gosub 1find
     gosub automove shard
     gosub automove 724
     gosub 1find
     gosub automove 718
     gosub 1find
     gosub automove 701
     gosub 1find
     gosub automove 660
     gosub 1find
     gosub automove 657
     gosub 1find
     gosub automove 652
     gosub 1find
     gosub automove 648
     gosub 1find
     math loops add 1
     if %loops > 4 then goto TO_AUTOHEALER
     goto FINDTOP
1find:
    pause .0001
    pause .0001
    matchre return ^I could not find
    matchre 1find ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You.*are.*still.*stunned\.
    matchre 1found ^You see
    put look maci
    matchwait 5
    return
1found:
    pause .0001
    pause .0001
    var Empath maci
    send join maci
    matchre macifind ^\.\.\.wait|^Sorry\,|^I could not|^Please rephrase|^You.*are.*still.*stunned\.
    matchre DONE_AUTOEMPATH ^The feeling of unity with|^Maci nods to you\.|^A fiery\-cold
    put lean maci
    matchwait 30
    math attempts add 1
    if %attempts > 7 then goto TO_AUTOEMPATH
    if contains("$roomplayers" , "Maci") then goto macifound
    return

#########################################################################################################################################
#########################################################################################################################################
#### AUTOMOVEMENT - TRAVEL ROUTINES
#########################################################################################################################################
#########################################################################################################################################
##################################################
#### AUTOMOVE
AUTOMOVE:
     # action var exit $1;var webtype $2;goto websarestupid when ^As you approach (?:an?|the)\b.*? ((?:[\w'-]+) [\w'-]+|[\w'-]+), you become tangled up in the.*? \b(metallic|spidersilk|phantasmal|dew-covered|shadowy nightweaver silk)\b webbing
     # action goto ABYSS_ESCAPE when ^With lightning speed, something large and arachnid bursts from below, dragging you into a web-filled, subterranean gloom!
     delay 0.00001
     action (moving) on
     var Moving 0
     var randomloop 0
     var Destination $0
     var automovefailCounter 0
     if ($hidden = 1) then gosub UNHIDE
     if ($standing = 0) then gosub AUTOMOVE_STAND
     if ($roomid = 0) then gosub RANDOMMOVE
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     delay 0.00001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchre AUTOMOVE_FAILED ^You don't seem
     put #goto %Destination
     matchwait 3
     if (%Moving = 0) then goto AUTOMOVE_FAILED
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchwait 180
     goto AUTOMOVE_FAILED
AUTOMOVE_STAND:
     delay 0.00001
     if ($standing = 1) then goto AUTOMOVE_RETURN
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing
     send stand
     matchwait 20
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     delay 0.00001
     # put #script abort automapper
     pause 0.00001
     math automovefailCounter add 1
     if (%automovefailCounter > 5) then goto AUTOMOVE_FAIL_BAIL
     if (%automovefailCounter > 1) then send #mapper reset
     pause 0.01
     if ($roomid = 0) || (%automovefailCounter > 2) then gosub RANDOMMOVE
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     action (moving) off
     put #echo
     put #echo >Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
AUTOMOVE_RETURN:
     action (moving) off
     var automovefailCounter 0
     var randomloop 0
     delay 0.00001
     return
ABYSS_ESCAPE:
     echo * OH SHIT
     goto INIT
################################
# MOVE SINGLE
################################
MOVE:
     delay 0.00001
     var Direction $0
     var movefailCounter 0
     var moveRetreat 0
     var randomloop 0
     var lastmoved %Direction
MOVE_RESUME:
     matchre MOVE_RETRY ^\.\.\.wait|^Sorry, you may only type|^Please wait\.|You are still stunned\.
     matchre MOVE_RETURN_CHECK ^You can't (swim|move|climb) in that direction\.
     matchre MOVE_RESUME ^You make your way up the .*\.\s*Partway up, you make the mistake of looking down\.\s*Struck by vertigo, you cling to the .* for a few moments, then slowly climb back down\.
     matchre MOVE_RESUME ^You pick your way up the .*, but reach a point where your footing is questionable\.\s*Reluctantly, you climb back down\.
     matchre MOVE_RESUME ^You approach the .*, but the steepness is intimidating\.
     matchre MOVE_RESUME ^You struggle
     matchre MOVE_RESUME ^You blunder
     matchre MOVE_RESUME ^You slap
     matchre MOVE_RESUME ^You work
     matchre MOVE_RESUME make much headway
     matchre MOVE_RESUME ^You flounder around in the water\.
     matchre MOVE_RETREAT ^You are engaged to .*\!
     matchre MOVE_RETREAT ^You can't do that while engaged\!
     matchre MOVE_STAND ^You start up the .*, but slip after a few feet and fall to the ground\!\s*You are unharmed but feel foolish\.
     matchre MOVE_STAND ^Running heedlessly over the rough terrain, you trip over an exposed root and land face first in the dirt\.
     matchre MOVE_STAND ^You can't do that while lying down\.
     matchre MOVE_STAND ^You can't do that while sitting\!
     matchre MOVE_STAND ^You can't do that while kneeling\!
     matchre MOVE_STAND ^You must be standing to do that\.
     matchre MOVE_STAND ^You don't seem
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_STAND ^Stand up first.
     matchre MOVE_DIG ^You make no progress in the mud \-\- mostly just shifting of your weight from one side to the other\.
     matchre MOVE_DIG ^You find yourself stuck in the mud, unable to move much at all after your pathetic attempts\.
     matchre MOVE_DIG ^You struggle forward, managing a few steps before ultimately falling short of your goal\.
     matchre MOVE_DIG ^Like a blind, lame duck, you wallow in the mud in a feeble attempt at forward motion\.
     matchre MOVE_DIG ^The mud holds you tightly, preventing you from making much headway\.
     matchre MOVE_DIG ^You fall into the mud with a loud \*SPLUT\*\.
     matchre MOVE_FAIL_BAIL ^You can't go there
     matchre MOVE_FAILED ^Noticing your attempt
     matchre MOVE_FAILED ^I could not find what you were referring to\.
     matchre MOVE_FAILED ^What were you referring to\?
     matchre MOVE_RETURN ^It's pitch dark
     matchre MOVE_RETURN ^Obvious
     send %Direction
     matchwait 8
     goto MOVE_RETURN
MOVE_RETRY:
     pause
     goto MOVE_RESUME
MOVE_STAND:
     delay 0.00001
     matchre MOVE_STAND ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_STAND ^The weight
     matchre MOVE_STAND ^You try
     matchre MOVE_STAND ^You don't
     matchre MOVE_RETREAT ^You are already standing\.
     matchre MOVE_RETREAT ^You stand(?:\s*back)? up\.
     matchre MOVE_RETREAT ^You stand up\.
     send stand
     matchwait 8
     goto MOVE_STAND
MOVE_RETREAT:
     delay 0.00001
     math moveRetreat add 1
     if (%moveRetreat > 4) then
          {
               send search
               pause 0.5
               pause 0.3
               var moveRetreat 0
          }
     if ($invisible = 1) then gosub STOP_INVIS
     matchre MOVE_RETREAT ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_RETREAT ^You retreat back to pole range\.
     matchre MOVE_RETREAT ^You stop advancing
     matchre MOVE_RETREAT ^You try to back away
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_RESUME ^You retreat from combat\.
     matchre MOVE_RESUME ^You are already as far away as you can get\!
     send retreat
     matchwait 10
     goto MOVE_RETREAT
MOVE_DIG:
     delay 0.00001
     matchre MOVE_DIG ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_DIG ^You struggle to dig off the thick mud caked around your legs\.
     matchre MOVE_STAND ^You manage to dig enough mud away from your legs to assist your movements\.
     matchre MOVE_DIG_STAND ^Maybe you can reach better that way, but you'll need to stand up for that to really do you any good\.
     matchre MOVE_RESUME ^You will have to kneel
     send dig
     matchwait 10
     goto MOVE_DIG
MOVE_DIG_STAND:
     delay 0.00001
     matchre MOVE_DIG_STAND ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_DIG_STAND ^The weight
     matchre MOVE_DIG_STAND ^You try
     matchre MOVE_DIG_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_DIG ^You stand(?:\s*back)? up\.
     matchre MOVE_DIG ^You are already standing\.
     send stand
     matchwait 10
     goto MOVE_DIG_STAND
MOVE_FAILED:
     var moved 0
     math movefailCounter add 1
     if (%movefailCounter > 3) then goto MOVE_FAIL_BAIL
     pause 0.5
     put look
     delay 0.4
     goto MOVE_RESUME
MOVE_FAIL_BAIL:
     put #echo
     # put #echo >$Log Crimson *** MOVE FAILED. ***
     put #echo Crimson *** MOVE FAILED.  ***
     put #echo
     return
MOVE_RETURN_CHECK:
     put look
     delay 0.001
MOVE_RETURN:
     var moved 1
     var randomloop 0
     delay 0.00001
     unvar moveloop
     unvar movefailCounter
     return
FIND_MYSELF:
### OLD RANDOM MOVEMENT SUB - NO LONGER USED (MAINLY FOR POSTERITY)
MOVERANDOM:
moveRandomDirection:
     var moveloop 0
     moveRandomDirection_2:
     math moveloop add 1
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if $north then
          {
               gosub MOVE north
               return
          }
     if $northwest then
          {
               gosub MOVE northwest
               return
          }
     if $northeast then
          {
               gosub MOVE northeast
               return
          }
     if $southeast then
          {
               gosub MOVE southeast
               return
          }
     if $south then
          {
               gosub MOVE south
               return
          }
     if $west then
          {
               gosub MOVE west
               return
          }
     if $east then
          {
               gosub MOVE east
               return
          }
     if $southwest then
          {
               gosub MOVE southwest
               return
          }
     if $out then
          {
               gosub MOVE out
               return
          }
     if $up then
          {
               gosub MOVE up
               return
          }
     if $down then
          {
               gosub MOVE down
               return
          }
     if (matchre("$roomobjs $roomdesc","\barchway") && ("%lastmoved" != "go archway")) then
          {
               gosub MOVE go archway
               return
          }
     if (matchre("$roomobjs $roomdesc","\barch") && ("%lastmoved" != "go arch")) then
          {
               gosub MOVE go arch
               return
          }
     if matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") then
          {
               gosub MOVE climb stair
               return
          }
     if matchre("$roomobjs $roomdesc","\bsteps\b") then
          {
               gosub MOVE climb step
               return
          }
     if matchre("$roomobjs $roomdesc","\b(exit|curtain|arch|door|gate|hole|hatch|trapdoor|path|animal trail|tunnel|portal|docks)\b") then
          {
               gosub MOVE go $1
               return
          }
     if (matchre("$roomobjs $roomdesc","narrow hole") && ("%lastmoved" != "go hole")) then gosub MOVE go hole
     if (matchre("$roomobjs $roomdesc","bank docks") && ("%lastmoved" != "go dock")) then gosub MOVE go dock
     if (matchre("$roomobjs $roomdesc","\bcrevice") && ("%lastmoved" != "go crevice")) then gosub MOVE go crevice
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\bgate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
     if (matchre("$roomobjs $roomdesc","\barch\b") && ("%lastmoved" != "go arch")) then gosub MOVE go arch
     if (%moved = 1) then return
     if (matchre("$roomexits","\bforward") && ("%lastmoved" != "forward")) then gosub MOVE forward
     if (matchre("$roomexits","\baft\b") && ("%lastmoved" != "aft")) then gosub MOVE aft
     if (%moved = 1) then return
     if (matchre("$roomexits","\bstarboard") && ("%lastmoved" != "starboard")) then gosub MOVE starboard
     if (matchre("$roomexits","\bport\b") && ("%lastmoved" != "port")) then gosub MOVE port
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\barchway") && ("%lastmoved" != "go archway")) then gosub MOVE go archway
     if (matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit")) then gosub MOVE go exit
     if (matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path")) then gosub MOVE go path
     if (matchre("$roomobjs $roomdesc","\bledge\b") && ("%lastmoved" != "go ledge")) then gosub MOVE go ledge
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
     if (matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go curtain")) then gosub MOVE go curtain
     if (matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door")) then gosub MOVE go door
     if (matchre("$roomobjs $roomdesc","double door") && ("%lastmoved" != "go door")) then gosub MOVE go door
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal")) then gosub MOVE go portal
     if (matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
     if (matchre("$roomobjs $roomdesc","\bjagged crack\b") && ("%lastmoved" != "go crack")) then gosub MOVE go crack
     if (matchre("$roomobjs $roomdesc","\bthe street\b") && ("%lastmoved" != "go street")) then gosub MOVE go street
     if (matchre("$roomobjs $roomdesc","(?i)\ba gate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
     if (matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step")) then gosub MOVE climb step
     if (matchre("$roomobjs $roomdesc","\btrail\b") && ("%lastmoved" != "go trail")) then gosub MOVE go trail
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel")) then gosub MOVE go panel
     if (matchre("$roomobjs $roomdesc","\btent flap\b") && ("%lastmoved" != "go flap")) then gosub MOVE go flap
     if (matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track")) then gosub MOVE go track
     if (matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
     if (%moved = 1) then return
     if (matchre("$roomname", "Deadman's Confide, Beach") || matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then gosub TRUE_RANDOM
     if matchre("$roomname","Smavold's Toggery") then gosub MOVE go door
     if matchre("$roomname","Temple Hill Manor, Grounds") then gosub MOVE go gate
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then gosub MOVE climb pine branches
     if matchre("$roomname","Darkling Wood, Pine Tree") then gosub MOVE climb white pine
     if (%moved = 1) then return
     if matchre("$roomname","The Sewers, Beneath the Grate") then gosub MOVE go grate
     if matchre("$roomobjs","strong creeper") then gosub MOVE climb ladder
     if matchre("$roomobjs","the garden") then gosub MOVE go garden
     if matchre("$roomobjs","underside of the Bridge of Rooks") then gosub MOVE climb bridge
     if (%moved = 1) then return
     if matchre("$roomobjs","stone wall") then gosub MOVE climb niche
     if matchre("$roomobjs","narrow ledge") then gosub MOVE climb ledge
     if matchre("$roomobjs","craggy niche") then gosub MOVE climb niche
     if matchre("$roomobjs","double door") then gosub MOVE go door
     if matchre("$roomobjs","staircase") then gosub MOVE climb stair
     if matchre("$roomobjs","the exit") then gosub MOVE go exit
     if (%moved = 1) then return
     echo * No random direction possible?? Looking to attempt to reset room exit vars
     send search
     pause 0.4
     pause 0.2
     #might need a counter here to prevent infinite loops
     put look
     pause 0.5
     delay 0.2
     if (%moveloop > 6) then
          {
               echo * Cannot find a room exit!! Stupid fog!
               echo * ATTEMPTING RANDOM DIRECTIONS...
               gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM
               return
          }
     goto moveRandomDirection_2
###################################################################################
### NEW RANDOM MOVEMENT ENGINE BY SHROOM
### ATTEMPTS TO MOVE UNTIL AUTOMAPPER REGISTERS POSITION
### THIS IS NORMALLY CALLED WHEN AUTOMAPPER GETS LOST OR ROOMID = 0
### ALSO USED TO NAVIGATE THROUGH MAZE AREAS
### CAN BE USED AS A STANDALONE SUB
### ATTEMPTS RANDOM DIRECTIONS AND DOESN'T BACKTRACK FROM LAST KNOWN DIRECTION IF POSSIBLE
### IF IT CANNOT FIND A OBVIOUS ROOM EXIT AFTER SEVERAL LOOPS - WILL TRY ~ANY POSSIBLE EXIT~ IT CAN FIND
### WILL MOVE IN TRUE RANDOM DIRECTIONS IF IT CANNOT SEE ANY ROOM EXITS (PITCH BLACK)
###################################################################################
RANDOMMOVE:
     delay 0.00001
     var moved 0
     var moveloop 0
RANDOMMOVE_1:
     math moveloop add 1
     math randomloop add 1
     if (%randomloop = 1) then gosub DARK_CHECK
     if !($standing) then gosub STAND
## IF WE'VE DONE 20/40 LOOPS, DO A QUICK LOOK AND MAKE SURE NOT ON A FERRY
     if matchre("%moveloop", "\b(20|40)\b") then
          {
               echo * CANNOT FIND A ROOM EXIT??!
               put look
               pause 0.4
               gosub FERRY_CHECK
          }
### TRY A LIGHT SOURCE IF ROOM IS PITCH BLACK AND THEN TRY TRUE RANDOM DIRECTIONS
     if (%moveloop > 25) then
          {
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               var lastmoved null
               gosub TRUE_RANDOM
          }
### IF WE'VE DONE 50+ LOOPS - DO ALL CHECKS - LIGHT SOURCE/FERRY CHECK AND RESET BACK TO 0
     if (%moveloop > 50) then
          {
               echo ~~~~~~~~~~~~~~~~~~~
               echo * Cannot find a room exit??? Stupid fog???
               echo * ZONE: $zoneid | ROOM: $roomid
               echo * SEND THE ROOM DESCRIPTION/EXITS WHEN YOU TYPE LOOK
               echo * ATTEMPTING RANDOM DIRECTIONS...
               echo * SHOULD AUTO-RECOVER IF YOU CAN FIND AN EXIT
               echo ~~~~~~~~~~~~~~~~~~~
               pause 0.5
               gosub FERRY_CHECK
               pause 0.5
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM
               var lastmoved null
               var randomloop 0
               var moveloop 0
               return
          }
### MOVE INTO TRUE RANDOM MODE
     if (%moveloop > 55) then
          {
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               var lastmoved null
               gosub TRUE_RANDOM
          }
### HERE BEGINS CONDITIONAL CHECKS FOR VERY SPECIFIC ROOMS AND HOW TO *TRY* AND HANDLE THEM
     if matchre("$roomname", "\[Skeletal Claw\]") then
          {
               echo ~~~~~~~~~~~~~~~~~~~~~
               echo # IN THE SKELETAL CLAW! OH NO!!!
               echo # WE MIGHT DIE IF SOMEONE DOESN'T CAST UNCURSE ON IT!
               echo # ATTEMPTING TO ESCAPE.............
               echo ~~~~~~~~~~~~~~~~~~~~~
               gosub MOVE out
               return
          }
     if (matchre("$roomname", "Deadman's Confide, Beach") || matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then gosub TRUE_RANDOM
     if matchre("$roomname","Smavold's Toggery") then gosub MOVE go door
     if matchre("$roomname","Temple Hill Manor, Grounds") then gosub MOVE go gate
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then gosub MOVE climb pine branches
     if matchre("$roomname","Darkling Wood, Pine Tree") then gosub MOVE climb white pine
     if (%moved = 1) then return
     if matchre("$roomname","The Sewers, Beneath the Grate") then gosub MOVE go grate
     if matchre("$roomobjs","strong creeper") then gosub MOVE climb ladder
     if matchre("$roomobjs","the garden") then gosub MOVE go garden
     if matchre("$roomobjs","underside of the Bridge of Rooks") then gosub MOVE climb bridge
     if (%moved = 1) then return
### IF WE HAVE DONE 10 LOOPS WITH NO MATCHES - LOOK FOR AND TRY SOME OF THE MOST COMMON NON-CARDINAL EXITS
     if (%moveloop > 10) then
          {
          if matchre("$roomobjs","stone wall") then gosub MOVE climb wall
          if matchre("$roomobjs","narrow ledge") then gosub MOVE climb ledge
          if matchre("$roomobjs","craggy niche") then gosub MOVE climb niche
          if matchre("$roomobjs","double door") then gosub MOVE go door
          if matchre("$roomobjs","staircase") then gosub MOVE climb stair
          if matchre("$roomobjs","the exit") then gosub MOVE go exit
          if matchre("$roomobjs","\bdocks?") then gosub MOVE go dock
          if matchre("$roomobjs","\bdoor\b") then gosub MOVE go door
          if matchre("$roomobjs","\bledge\b") then gosub MOVE go ledge
          if matchre("$roomobjs","\barch\b") then gosub MOVE go arch
          if matchre("$roomobjs","\bgate\b") then gosub MOVE go gate
          if matchre("$roomobjs","\btrapdoor\b") then gosub MOVE go trapdoor
          if matchre("$roomobjs","\bcrevice\b") then gosub MOVE go crevice
          if matchre("$roomobjs","\bcurtain\b") then gosub MOVE go curtain
          if matchre("$roomobjs","\bportal\b") then gosub MOVE go portal
          if matchre("$roomobjs","\btrail\b") then gosub MOVE go trail
          if matchre("$roomobjs","\bpath\b") then gosub MOVE go path
          if matchre("$roomobjs","\bhole\b") then gosub MOVE go hole
          }
     if (%moved = 1) then return
### HERE BEGINS THE TRUE NORMAL CARDINAL CHECKS - HIT A RANDOM NUMBER THEN CHECK IF IT MATCHES A ROOM EXIT
### AS LONG AS THE ROOM EXIT IS VALID AND IS NOT THE OPPOSITE OF OUR LAST DIRECTION - THEN TAKE IT
     random 1 11
     if ((%r = 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 5) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 6) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 7) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r = 8) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%r = 9) && ($out) then gosub MOVE out
     if ((%r = 10) && ($up) && ("%lastmoved" != "up")) then gosub MOVE up
     if ((%r = 11) && ($down) && ("%lastmoved" != "down")) then gosub MOVE down
     if (%moved = 1) then return
### 2ND LOOP RANDOMIZED - SAME AS THE FIRST CHECK BUT THE DIRECTIONS HAVE BEEN SWITCHED UP
     if ((%r = 1) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r = 2) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r = 3) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 4) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 5) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 6) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 7) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if (%r = 8) && ($out) then gosub MOVE out
     if ((%r = 9) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 10) && ($down) && ("%lastmoved" != "up")) then gosub MOVE down
     if ((%r = 11) && ($up) && ("%lastmoved" != "down")) then gosub MOVE up
     if (%moved = 1) then return
### 3RD LOOP - NOW WE JUST HARD CHECK FOR ANY OBVIOUS EXIT IN THE SAME NUMBER
### AS LONG AS IT WASN'T OPPOSITE OUR LAST DIRECTION
     random 1 4
     if ((%r = 1) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 1) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 1) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 1) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r = 1) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if (%moved = 1) then return
     if ((%r = 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 1) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 1) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved = 1) then return
     if ((%r = 2) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 2) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 2) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%moved = 1) then return
     if ((%r = 2) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 2) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 2) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 2) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved = 1) then return
     if ((%r = 3) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r = 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 3) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 3) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r = 3) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if (%moved = 1) then return
     if ((%r = 3) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 3) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 3) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if (%moved = 1) then return
     if ((%r = 4) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 4) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 4) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%moved = 1) then return
     if ((%r = 4) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 4) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 4) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 4) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved = 1) then return
### THIS IS THE MAJOR CHECK FAILOVER
### IF DONE 13 LOOPS WITH NO MATCH THEN CHECK FOR ~ANY POSSIBLE OBVIOUS ROOM EXIT~ (AS LONG AS THAT WASN'T OUR LAST MOVE)
     if (%moveloop > 13) then
          {
               if ($out) then gosub MOVE out
               if (%moved = 1) then return
               if (($north) && ("%lastmoved" != "south")) then gosub MOVE north
               if (($south) && ("%lastmoved" != "north")) then gosub MOVE south
               if (%moved = 1) then return
               if (($east) && ("%lastmoved" != "west")) then gosub MOVE east
               if (($west) && ("%lastmoved" != "east")) then gosub MOVE west
               if (%moved = 1) then return
               if (($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
               if (($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
               if (%moved = 1) then return
               if (($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
               if (($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","narrow hole") && ("%lastmoved" != "go hole")) then gosub MOVE go hole
               if (matchre("$roomobjs $roomdesc","large hole") && ("%lastmoved" != "go hole")) then gosub MOVE go hole
               if (matchre("$roomobjs $roomdesc","\bcrevice") && ("%lastmoved" != "go crevice")) then gosub MOVE go crevice
               if (matchre("$roomobjs $roomdesc","\bdocks") && ("%lastmoved" != "go dock")) then gosub MOVE go dock
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path")) then gosub MOVE go path
               if (matchre("$roomobjs $roomdesc","\btrail\b") && ("%lastmoved" != "go trail")) then gosub MOVE go trail
               if (matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel")) then gosub MOVE go panel
               if (matchre("$roomobjs $roomdesc","\btent flap\b") && ("%lastmoved" != "go flap")) then gosub MOVE go flap
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door")) then gosub MOVE go door
               if (matchre("$roomobjs $roomdesc","double door") && ("%lastmoved" != "go door")) then gosub MOVE go door
               if (matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
               if (matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go curtain")) then gosub MOVE go curtain
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track")) then gosub MOVE go track
               if (matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
               if (matchre("$roomobjs $roomdesc","\bgate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
               if (matchre("$roomobjs $roomdesc","\barch\b") && ("%lastmoved" != "go arch")) then gosub MOVE go arch
               if (matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit")) then gosub MOVE go exit
               if (%moved = 1) then return
               if (matchre("$roomexits","\bforward") && ("%lastmoved" != "forward")) then gosub MOVE forward
               if (matchre("$roomexits","\baft\b") && ("%lastmoved" != "aft")) then gosub MOVE aft
               if (%moved = 1) then return
               if (matchre("$roomexits","\bstarboard") && ("%lastmoved" != "starboard")) then gosub MOVE starboard
               if (matchre("$roomexits","\bport\b") && ("%lastmoved" != "port")) then gosub MOVE port
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","\bledge\b") && ("%lastmoved" != "go ledge")) then gosub MOVE go ledge
               if (matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal")) then gosub MOVE go portal
               if (matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","\bjagged crack\b") && ("%lastmoved" != "go crack")) then gosub MOVE go crack
               if (matchre("$roomobjs $roomdesc","\bthe street\b") && ("%lastmoved" != "go street")) then gosub MOVE go street
               if (matchre("$roomobjs $roomdesc","(?i)\ba gate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
               if (%moved = 1) then return
               if (matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
               if (matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step")) then gosub MOVE climb step
               if (%moved = 1) then return
          }
     if (%moved = 0) then goto RANDOMMOVE_1
     # if ($roomid = 0) then goto RANDOMMOVE
     # if $roomid == 0 then goto moveRandomDirection_2
     return
### RANDOM CARDINAL DIRECTIONS ONLY
RANDOMMOVE_CARDINAL:
     delay 0.00001
     var moved 0
     math randomloop add 1
     if (%randomloop > 50) then
          {
               var lastmoved null
               var randomloop 0
               echo * Cannot find a room exit??
               echo * Attempting to Revert back..
               echo * Trying Alternate Methods..
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname","Temple Hill Manor, Grounds") then
          {
               gosub MOVE go gate
               return
          }
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then
          {
               gosub MOVE climb pine branches
               return
          }
     if matchre("$roomname","Darkling Wood, Pine Tree") then
          {
               gosub MOVE climb white pine
               return
          }
     if matchre("$roomobjs","strong creeper") then
          {
               gosub MOVE climb ladder
               return
          }
     if matchre("$roomobjs","bank docks") then
          {
               gosub MOVE go dock
               return
          }
     if (%moved = 1) then return
     random 1 11
     if ((%r = 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 5) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 6) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 7) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r = 8) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%r = 9) && ($out) then gosub MOVE out
     if ((%r = 10) && ($up) && ("%lastmoved" != "up")) then gosub MOVE up
     if ((%r = 11) && ($down) && ("%lastmoved" != "down")) then gosub MOVE down
     if (%moved = 1) then return
     if ((%r = 1) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r = 2) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r = 3) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 4) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 5) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r = 6) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 7) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if (%r = 8) && ($out) then gosub MOVE out
     if ((%r = 9) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 10) && ($down) && ("%lastmoved" != "up")) then gosub MOVE down
     if ((%r = 11) && ($up) && ("%lastmoved" != "down")) then gosub MOVE up
     if (%moved = 1) then return
     if (%moved = 0) then goto RANDOMMOVE_CARDINAL
     # if ($roomid = 0) then goto RANDOMMOVE
     # if $roomid == 0 then goto moveRandomDirection_2
     return
### GO IN RANDOM DIRECTIONS, PREFER A SOUTHERN / WESTERN DIRECTION IF AVAILABLE
RANDOMMOVE_SOUTH:
     delay 0.0001
     var moved 0
     math randomloop add 1
     if (%randomloop > 5) then
          {
               put look
               pause 0.2
               var lastmoved null
               var randomloop 0
               return
          }
     if $south then
          {
               gosub MOVE south
               return
          }
     if $southwest then
          {
               gosub MOVE southwest
               return
          }
     if $southeast then
          {
               gosub MOVE southeast
               return
          }
     if $northwest then
          {
               gosub MOVE northwest
               return
          }
     if $west then
          {
               gosub MOVE west
               return
          }
     if $north then
          {
               gosub MOVE north
               return
          }
     if $northeast then
          {
               gosub MOVE northeast
               return
          }
     if $east then
          {
               gosub MOVE east
               return
          }

     if $out then
          {
               gosub MOVE out
               return
          }
     if $up then
          {
               gosub MOVE up
               return
          }
     if $down then
          {
               gosub MOVE down
               return
          }
     pause 0.01
     if (%moved = 0) then goto RANDOMMOVE_SOUTH
     # if $roomid == 0 then goto moveRandomDirection_2
     return
### TRUE RANDOM USED FOR MOVING IN PURE RANDOM DIRECTIONS REGARDLESS OF WHATS IN ROOM (FOG FILLED OR DARK ROOMS)
TRUE_RANDOM:
     delay 0.0001
     var moved 0
     math randomloop add 1
     if (%randomloop > 12) then
          {
               put look
               pause 0.2
               var lastmoved null
               var randomloop 0
          }
     random 1 8
     if (%r = 1) then gosub MOVE n
     if (%r = 2) then gosub MOVE ne
     if (%r = 3) then gosub MOVE e
     if (%r = 4) then gosub MOVE nw
     if (%r = 5) then gosub MOVE se
     if (%r = 6) then gosub MOVE s
     if (%r = 7) then gosub MOVE sw
     if (%r = 8) then gosub MOVE w
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit")) then gosub MOVE go exit
     if (matchre("$roomobjs $roomdesc","\bdocks\b") && ("%lastmoved" != "go dock")) then gosub MOVE go dock
     if (matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path")) then gosub MOVE go path
     if (matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
     if (matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go path")) then gosub MOVE go curtain
     if (matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door")) then gosub MOVE go door
     if (matchre("$roomobjs $roomdesc","\bgate") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
     if (matchre("$roomobjs $roomdesc","\barch") && ("%lastmoved" != "go arch")) then gosub MOVE go arch
     if (matchre("$roomobjs $roomdesc","\barchway") && ("%lastmoved" != "go archway")) then gosub MOVE go archway
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal")) then gosub MOVE go portal
     if (matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
     if (matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
     if (matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step")) then gosub MOVE climb step
     if (%moved = 1) then return
     if (matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel")) then gosub MOVE go panel
     if (matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track")) then gosub MOVE go track
     if (matchre("$roomobjs $roomdesc","\bthe garden\b") && ("%lastmoved" != "go garden")) then gosub MOVE go garden
     if (matchre("$roomobjs $roomdesc","\btent flap\b") && ("%lastmoved" != "go flap")) then gosub MOVE go flap
     if (matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
     if (%moved = 0) then goto TRUE_RANDOM
     return
RANDOMWEIGHT:
     var weight $1
     var randomweight
     if $%weight then var randomweight %randomweight|%weight
     if $north%weight then var randomweight %randomweight|north%weight
     if $south%weight then var randomweight %randomweight|south%weight
     eval randomweightcount count("%randomweight", "|")
RANDOMWEIGHT_2:
     if ("%randomweight" = "") then return
     random 1 %randomweightcount
     gosub MOVE %randomweight(%r)
     return
RANDOMNORTH:
     if (($north) && ("%lastmoved" != "south")) then
          {
               gosub MOVE north
               goto RANDOMSOUTH_RETURN
          }
     if (($northeast) && ("%lastmoved" != "southwest")) then
          {
               gosub MOVE northeast
               goto RANDOMSOUTH_RETURN
          }
     if (($northwest) && ("%lastmoved" != "southeast")) then
          {
               gosub MOVE northwest
               return
          }
     if (($west) && ("%lastmoved" != "east")) then
          {
               gosub MOVE west
               goto RANDOMSOUTH_RETURN
          }
     if (($east) && ("%lastmoved" != "west")) then
          {
               gosub MOVE east
               goto RANDOMSOUTH_RETURN
          }
     var lastmoved null
     return
RANDOMSOUTH:
     if (($south) && ("%lastmoved" != "north")) then
          {
               gosub MOVE south
               goto RANDOMSOUTH_RETURN
          }
     if (($southeast) && ("%lastmoved" != "northwest")) then
          {
               gosub MOVE southeast
               goto RANDOMSOUTH_RETURN
          }
     if (($southwest) && ("%lastmoved" != "northeast")) then
          {
               gosub MOVE southwest
               goto RANDOMSOUTH_RETURN
          }
     if (($east) && ("%lastmoved" != "west")) then
          {
               gosub MOVE east
               goto RANDOMSOUTH_RETURN
          }
     if (($west) && ("%lastmoved" != "east")) then
          {
               gosub MOVE west
               goto RANDOMSOUTH_RETURN
          }
     var lastmoved null
RANDOMSOUTH_RETURN:
     return
######################################################################################################
STAND:
     delay 0.0001
     var LOCATION STAND_1
     STAND_1:
     if ($standing = 1) then return
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre WAIT ^The weight of all your possessions prevents you from standing\.
     matchre WAIT ^You are overburdened and cannot manage to stand\.
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre STAND_RETURN ^You stand (?:back )?up\.
     matchre STAND_RETURN ^You are already standing\.
     send stand
     matchwait
     STAND_RETURN:
     pause 0.1
     pause 0.1
     if ($standing = 0) then send stand
     return
#######################################################################
DARK_CHECK:
     delay 0.0001
DARK_CHECK_1:
     var darkroom 1
     matchre DARK_CHECK_1 \s*\.\.\.wait|^Sorry,|^Please wait\.|^You are still stunned
     matchre DARK_YES pitch dark|pitch black
     matchre LIGHT_YES Obvious|I|What|You
     put look
     matchwait 5
     return
DARK_YES:
     var darkroom 1
     var darkTime $gametime
     gosub LIGHT_SOURCE
     return
LIGHT_YES:
     var darkroom 0
     var darkTime $gametime
     return
#########################################################################
### STOWING
STOWING:
     pause 0.00001
     var location STOWING
     if matchre("%todo", "\b(?i)(NULL|NIL)\b") then return
     if matchre("$righthand $lefthand", "(vine|grass)") then 
          {
               put drop $1
               put drop $1
               pause 0.4
          }
     if matchre("$righthandnoun $lefthandnoun", "rope") then put coil my rope
     if matchre("$righthandnoun $lefthandnoun", "bundle") then put wear bund;-0.7 drop bun
     if matchre("$righthandnoun $lefthandnoun", "block") then put drop block
     pause 0.01
     pause 0.00001
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$lefthand","(longbow|khuj)") then 
          {
               put SHEATH my $1 in my %SHEATH
               pause 0.4
          }
     if "$righthand" != "Empty" then GOSUB STOW right
     if "$lefthand" != "Empty" then GOSUB STOW left
     return
STOW:
     var LOCATION STOW_1
     var todo $0
     if matchre("%todo", "\b(?i)(NULL|NIL)\b") then return
     if matchre("$righthand $lefthand", "(vine|grass)") then 
          {
               put drop $1
               put drop $1
               pause 0.4
          }
     if matchre("$righthandnoun $lefthandnoun", "rope") then put coil my rope
     if matchre("$righthandnoun $lefthandnoun", "bundle")  then put wear bund;-0.7 drop bun
     if matchre("$righthandnoun $lefthandnoun", "block")  then put drop block
     pause 0.00001
     pause 0.00001
     if matchre("$lefthand $righthand", "bundle") then gosub PUT drop bundle
     pause 0.00001
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$lefthand $righthand", "(vine|braided vine)") then gosub PUT drop my vine
STOW_1:
     pause 0.00001
     pause 0.00001
     matchre WAIT ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre OPEN_BAGS ^But that's closed
     matchre STOW_2 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|As you attempt to place your
     matchre STOW_2 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre STOWLEFT ^You need a free hand
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
	matchre TEND_LODGED ^That .* needs to be tended to be removed.
     matchre RETURN ^That can't be picked up|^Perhaps you should
     matchre RETURN ^Wear what\?|^Stow what\?|Type 'STOW HELP'
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     matchre RETURN needs to be
     matchre GET1 ^But that is already
     put stow %todo
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW (disarm.cmd)
STOW_2:
     if matchre("%CONTAINER1", "(?i)NULL") then goto STOW_3
     if matchre("$lefthand $righthand", "bundle") then gosub PUT drop bundle
     if matchre("%todo", "(?i)right") then var todo $righthandnoun
     if matchre("%todo","(?i)left") then var todo $lefthandnoun
     pause 0.00001
     var LOCATION STOW_2
     matchre OPEN_BAGS ^But that's closed
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre STOW_3 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|As you attempt to place your
     matchre STOW_3 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre RETURN ^Wear what\?|^Stow what\?|^Perhaps you should
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     put put %todo in my %CONTAINER1
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW2! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW2 (disarm.cmd)
STOW_3:
     delay 0.0001
     var LOCATION STOW_3
     if matchre("%CONTAINER2", "(?i)NULL") then goto STOW_4
     gosub PUT open my %CONTAINER2
     pause 0.00001
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
     if matchre("$lefthandnoun $righthandnoun", "bundle") then gosub PUT drop bundle
     matchre OPEN_BAGS ^But that's closed
     matchre STOW_4 ^There\'s no room|any more room|no matter how you arrange|^What were you|As you attempt to place your
     matchre STOW_4 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre RETURN ^Wear what\?|^Stow what\?|^Perhaps you should
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     put put %todo in my %CONTAINER2
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW3! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW3 (disarm.cmd)
STOW_4:
     delay 0.0001
     pause 0.00001
     var LOCATION STOW_4
     if matchre("%CONTAINER3", "(?i)NULL") then goto STOW_5
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
     if matchre("$lefthandnoun $righthandnoun", "\b(skippet|coffer|trunk|chest|strongbox|crate|box|casket|caddy)\b") then goto DROP_BOX
     if matchre("$lefthandnoun $righthandnoun", "bundle") then gosub PUT drop bundle
     matchre OPEN_BAGS ^But that's closed
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre STOW_5 ^There\'s no room|any more room|no matter how you arrange|^What were you|As you attempt to place your
     matchre STOW_5 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre RETURN ^Wear what\?|^Stow what\?|^Perhaps you should
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     put put %todo in my %CONTAINER3
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW4! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW4 (disarm.cmd)
STOW_5:
     delay 0.0001
     var LOCATION STOW_4
     if matchre("%container4", "(?i)NULL") then goto REM_WEAR
     if matchre("$lefthandnoun $righthandnoun", "bundle") then gosub PUT drop bundle
     matchre OPEN_BAGS ^But that's closed
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre REM_WEAR ^There\'s no room|any more room|no matter how you arrange|^What were you|As you attempt to place your
     matchre REM_WEAR ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre RETURN ^Wear what\?|^Stow what\?|^Perhaps you should
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|SHEATHe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     put put %todo in my %container4
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW4! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW4 (disarm.cmd)
OPEN_BAGS:
     pause 0.1
     gosub OPEN %CONTAINER1
     gosub OPEN %CONTAINER2
     gosub OPEN %CONTAINER3
     gosub OPEN %container4
     pause 0.1
     goto STOW_1
OPEN:
     delay 0.0001
     var thing $0
OPEN_1:
     matchre OPEN_1 ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre RETURN ^You (?:open|hand|put|get|slip|quickly|switch|slide|raise|sling|pull|drum|pry|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|are already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|allow|have|are|wring|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel|read|reach|gingerly|come|count) .*(?:\.|\!|\?)?
     matchre RETURN ^It would be a shame|It's already open\!|^Brushing your fingers|There are already openings|Sensing your intent
     matchre RETURN ^That is already|^I could not|^What were you|^The .* (is already|has been)|^Using
     matchre RETURN ^With a practiced flick of your wrist
     put open my %thing
     matchwait 10
     put #echo >Log Red ** Missing Match in OPEN: (disarm.cmd)
     return
TEND_LODGED:
	var LODGEDLOCATION %LOCATION
	gosub BLEEDERCHECK
	goto %LODGEDLOCATION
REM_WEAR:
     pause 0.1
     send wear my %todo
     wait
     pause 0.2
     pause 0.1
     if matchre("$righthand", "%todo") || matchre("$lefthand", "%todo") then goto OUT_OF_SPACE
     return
OUT_OF_SPACE:
     echo
     echo ===================================
     echo *** NO SPACE - ALL BAGS ARE FULL!
     echo *** MAKE SOME MORE SPACE IN YOUR BAGS!
     echo *** OR GET SOME BIGGER BAGS YOU NOOB!!
     echo ===================================
     echo
     pause
     put #echo >Log DeepPink *** BAGS FULL!
     put #tvar bagsFull 1
     put #parse BAGS TOO FULL!
     put #parse DISARM DONE!
     put #parse DONE DISARM!
     exit

UNLOAD:
     if "$lefthand" != "Empty" then gosub STOW $lefthandnoun
     var LOCATION UNLOAD_1
     pause 0.0001
UNLOAD_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
	matchre UNLOADSTOW ^Your (.*) falls? from your (?:.*)\.
     matchre RETURN ^You unload .*\.
     matchre RETURN ^But your .* isn't loaded\!
     matchre UNLOADLEFTCHECK ^You don't have a ranged weapon to unload\.
     matchre RETURN ^You must be holding the weapon to do that\.
	matchre WEBBED ^You can't do that while entangled in a web
     send unload
     matchwait
	 
UNLOADSTOW:
	put stow $1
	return
	
UNLOADLEFTCHECK:
	if "$lefthand" != "Empty" then 
		{
               put swap
               goto UNLOAD
		}
	return

#### WEAR SUB
WEAR:
     delay 0.0001
     var todo $0
     var LOCATION WEAR_1
     WEAR_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre STOW_1 ^You can't wear that\!
     matchre STOW_1 ^You can't wear any more items like that\.
     matchre STOW_1 ^You need at least one free hand for that\.
     matchre STOW_1 ^This .* can't fit over the .* you are already wearing which also covers and protects your .*\.
     matchre RETURN ^You (?:sling|put|drape|slide|slip|attach|work|strap|hang|are already) .*(?:\.|\!|\?)?
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Wear what\?
     send wear %todo
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN WEAR! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN WEAR
     return
### HEALTH CHECK
HEALTH_CHECK:
     delay 0.0001
     action put #var needHealing 0 when ^You have no significant injuries\.
     put #var needHealing 0
     pause 0.00001
     matchre HEALTH_GOOD You have no significant injuries\.
     matchre HEALTH_CHECK_2 ^You have a dormant infection\.
     matchre HEALTH_BAD ^Bleeding
     matchre HEALTH_BAD ^\s*Encumbrance\s+\:
     put -health;-2 encumbrance
     matchwait 15
     goto HEALTH_CHECK
HEALTH_BAD:
     put #var needHealing 1
     delay 0.1
     pause 0.00001
     pause 0.00001
     if ($needHealing = 0) then goto HEALTH_GOOD
     action remove ^You have no significant injuries\.
     delay 0.5
     return
HEALTH_CHECK_2:
     delay 0.0001
     put #queue clear
     if ("$guild" = "Necromancer") then put #var needHealing 0
     else put #var needHealing 1
     return
HEALTH_GOOD:
     delay 0.0001
     put #queue clear
     put #var needHealing 0
     action remove ^You have no significant injuries\.
     delay 0.5
     return
BLEEDER_CHECK:
BLEEDERCHECK:
BLEEDER.CHECK:
BLEEDCHECK:
     var BLEEDING_HEAD NO
     var BLEEDING_NECK NO
     var BLEEDING_CHEST NO
     var BLEEDING_ABDOMEN NO
     var BLEEDING_BACK NO
     var BLEEDING_R_ARM NO
     var BLEEDING_L_ARM NO
     var BLEEDING_R_LEG NO
     var BLEEDING_L_LEG NO
     var BLEEDING_R_HAND NO
     var BLEEDING_L_HAND NO
     var BLEEDING_L_EYE NO
     var BLEEDING_R_EYE NO
     var BLEEDING_SKIN NO
     var INFECTED NO
     if (("$righthand" != "Empty") || ("$lefthand" != "Empty")) then gosub stowing
     # action goto BLEEDCHECK when The bandages binding your (.+) soak through with blood becoming useless and you begin bleeding again\.
     action var BLEEDING_HEAD YES when ^(?!.*\(tended\))\s*(head)\s{7}(.*)
     action var BLEEDING_NECK YES when ^(?!.*\(tended\))\s*(neck)\s{7}(.*)
     action var BLEEDING_CHEST YES when ^(?!.*\(tended\))\s*(chest)\s{7}(.*)
     action var BLEEDING_ABDOMEN YES when ^(?!.*\(tended\))\s*(abdomen)\s{7}(.*)
     action var BLEEDING_BACK YES when ^(?!.*\(tended\))\s*(back)\s{7}(.*)
     action var BLEEDING_R_ARM YES when ^(?!.*\(tended\))\s*r(?:ight|.) arm\s{7}(.*)
     action var BLEEDING_L_ARM YES when ^(?!.*\(tended\))\s*l(?:eft|.) arm\s{7}(.*)
     action var BLEEDING_R_LEG YES when ^(?!.*\(tended\))\s*r(?:ight|.) leg\s{7}(.*)
     action var BLEEDING_L_LEG YES when ^(?!.*\(tended\))\s*l(?:eft|.) leg\s{7}(.*)
     action var BLEEDING_R_HAND YES when ^(?!.*\(tended\))\s*r(?:ight|.) hand\s{7}(.*)
     action var BLEEDING_L_HAND YES when ^(?!.*\(tended\))\s*l(?:eft|.) hand\s{7}(.*)
     action var BLEEDING_L_EYE YES when ^(?!.*\(tended\))\s*l(?:eft|.) eye\s{7}(.*)
     action var BLEEDING_R_EYE YES when ^(?!.*\(tended\))\s*r(?:ight|.) eye\s{7}(.*)
     action var BLEEDING_SKIN YES when ^(?!.*\(tended\))\s*(skin)\s{7}(.*)
     action var BLEEDING_HEAD YES when (lodged\s*.*|mite|leech) (into|in|on) your head
     action var BLEEDING_NECK YES when (lodged\s*.*|mite|leech) (into|in|on) your neck
     action var BLEEDING_CHEST YES when (lodged\s*.*|mite|leech) (into|in|on) your chest
     action var BLEEDING_ABDOMEN YES when (lodged\s*.*|mite|leech) (into|in|on) your abdomen
     action var BLEEDING_BACK YES when (lodged\s*.*|mite|leech) (into|in|on) your back
     action var BLEEDING_R_ARM YES when (lodged\s*.*|mite|leech) (into|in|on) your right arm
     action var BLEEDING_L_ARM YES when (lodged\s*.*|mite|leech) (into|in|on) your left arm
     action var BLEEDING_R_LEG YES when (lodged\s*.*|mite|leech) (into|in|on) your right leg
     action var BLEEDING_L_LEG YES when (lodged\s*.*|mite|leech) (into|in|on) your left leg
     action var BLEEDING_R_HAND YES when (lodged\s*.*|mite|leech) (into|in|on) your right hand
     action var BLEEDING_L_HAND YES when (lodged\s*.*|mite|leech) (into|in|on) your left hand
     action var BLEEDING_L_EYE YES when (lodged\s*.*|mite|leech) (into|in|on) your left eye
     action var BLEEDING_R_EYE YES when (lodged\s*.*|mite|leech) (into|in|on) your right eye
     action var POISONED YES when ^You.+(poisoned)
BLEEDYES:
     echo [Checking Health / Bleeders]
     if matchre("$righthandnoun $lefthandnoun", "(spear|fragment|arrow|thorn|bolt|shard|mite|leech|axe|worm)") then
          {
               put drop $1
               pause 0.2
          }
     if matchre("$righthandnoun $lefthandnoun", "(spear|fragment|arrow|thorn|bolt|shard|mite|leech|axe|worm)") then
          {
               put drop $1
               pause 0.2
          }
     matchre BLEEDYES ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre YESBLEEDING Bleeding|bleeding|arrow lodged|bolt lodged|spear lodged|fragment lodged|thorn lodged|axe lodged|mite|blood worm
     matchre YESBLEEDING lodged (shallowly|deeply|firmly|savagely|in your)
     matchre END.OF.BLEEDER ^You pause a moment|^The THINK verb|^Syntax\:|^Thinking|Related verbs
     matchre bleedyes It\'s all a blur\!
     put -health;-0.01 think
     matchwait 20
     echo [No bleeder found - exiting bleeder check]
     goto END.OF.BLEEDER
YESBLEEDING:
     echo **** BLEEDING! ****
     echo **** TENDING BLEEDERS ****
     pause 0.001
     pause 0.001
     if ("%INFECTED" = "YES") then
          {
               echo
               echo ***********************************
               echo *** WARNING ** WOUNDS INFECTED! ***
               echo ***********************************
               echo
               pause 0.1
          }
     if ("%BLEEDING_HEAD" = "YES") then gosub tend head
     if ("%BLEEDING_NECK" = "YES") then gosub tend neck
     if ("%BLEEDING_CHEST" = "YES") then gosub tend chest
     if ("%BLEEDING_ABDOMEN" = "YES") then gosub tend abdomen
     if ("%BLEEDING_BACK" = "YES") then gosub tend back
     if ("%BLEEDING_R_ARM" = "YES") then gosub tend right arm
     if ("%BLEEDING_L_ARM" = "YES") then gosub tend left arm
     if ("%BLEEDING_R_LEG" = "YES") then gosub tend right leg
     if ("%BLEEDING_L_LEG" = "YES") then gosub tend left leg
     if ("%BLEEDING_R_HAND" = "YES") then gosub tend right hand
     if ("%BLEEDING_L_HAND" = "YES") then gosub tend left hand
     if ("%BLEEDING_L_EYE" = "YES") then gosub tend left eye
     if ("%BLEEDING_R_EYE" = "YES") then gosub tend right eye
     #if ("%BLEEDING_SKIN" = "YES") then gosub tend skin
     goto END.OF.BLEEDER
TEND:
     var bleeder $0
     echo
     echo ******************************
     echo ** Tending Bleeder: %bleeder ** 
     echo ******************************
     echo
     pause 0.001
     # if $prone then gosub STAND
tend_bleeder:
     pause 0.0001
     pause 0.0001
     send tend my %bleeder
     pause 0.8
     pause 0.5
     pause 0.001
     pause 0.001
     send tend my %bleeder
     pause 0.8
     pause 0.5
     pause 0.0001
     pause 0.0001
     gosub DUMPSTER_SET
     if !matchre("%dumpster", "(NULL|gelapod)") then
          {
               pause 0.001
               if (!matchre("$righthand", "Empty") && matchre("$righthand", "(arrow|thorn|bolt|fragment)")) then put put my $righthandnoun in %dumpster
               if (!matchre("$lefthand", "Empty") && matchre("$lefthand", "(arrow|thorn|bolt|fragment)")) then put put my $lefthandnoun in %dumpster
               pause 0.5
          }
     if matchre("%dumpster", "gelapod") then
          {
               pause 0.001
               if (!matchre("$righthand", "Empty") && matchre("$righthand", "(arrow|thorn|bolt|fragment)")) then put feed my $righthandnoun to gelapod
               if (!matchre("$lefthand", "Empty") && matchre("$lefthand", "(arrow|thorn|bolt|fragment)")) then put feed my $lefthandnoun to gelapod
               pause 0.5
          }
     if (!matchre("$righthand","Empty") && ("%dumpster" != "NULL") && matchre("$righthand", "(arrow|thorn|bolt|fragment)")) then put drop my $righthand
     if (!matchre("$lefthand","Empty") && ("%dumpster" != "NULL") && matchre("$lefthand", "(arrow|thorn|bolt|fragment)")) then put drop my $lefthand
     if matchre("$righthand $lefthand", "hurling axe") then put drop axe
     if matchre("$righthand $lefthandn", "spear") then put drop spear
     if matchre("$righthand $lefthand", "fragment") then put drop fragment
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
tend_bleeder2:
     pause 0.001
     pause 0.001
     gosub put tend my %bleeder
     pause 0.001
     pause 0.001
     pause 0.001
     gosub DUMPSTER_SET
     if !matchre("%dumpster", "(NULL|gelapod)") then
          {
               pause 0.001
               if !matchre("$righthand", "Empty") then put put my $righthandnoun in %dumpster
               if !matchre("$lefthand", "Empty") then put put my $lefthandnoun in %dumpster
               pause 0.5
          }
     if matchre("%dumpster", "gelapod") then
          {
               pause 0.001
               if !matchre("$righthand", "Empty") then put feed my $righthandnoun to gelapod
               if !matchre("$lefthand", "Empty") then put feed my $lefthandnoun to gelapod
               pause 0.5
          }
     pause 0.0001
     if !matchre("$righthand","Empty") && ("%dumpster" != "NULL") then put drop my $righthand
     if !matchre("$lefthand","Empty") && ("%dumpster" != "NULL") then put drop my $lefthand
     pause 0.0001
     if matchre("$righthandnoun $lefthandnoun", "axe") then put drop axe
     if matchre("$righthandnoun $lefthandnoun", "spear") then put drop spear
     if matchre("$righthandnoun $lefthandnoun", "fragment") then put drop fragment
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     echo [Leaving Bleeder System]
     pause 0.0001
     return
END.OF.BLEEDER:
     action remove The bandages binding your (.+) soak through with blood becoming useless and you begin bleeding again\.
     action remove ^(?!.*\(tended\))\s*(head)\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*(neck)\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*(chest)\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*(abdomen)\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*(back)\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*r(?:ight|.) arm\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*l(?:eft|.) arm\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*r(?:ight|.) leg\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*l(?:eft|.) leg\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*r(?:ight|.) hand\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*l(?:eft|.) hand\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*l(?:eft|.) eye\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*r(?:ight|.) eye\s{7}(.*)
     action remove ^(?!.*\(tended\))\s*(skin)\s{7}(.*)
     action remove (lodged\s*.*|mite|leech) (into|in|on) your head
     action remove (lodged\s*.*|mite|leech) (into|in|on) your neck
     action remove (lodged\s*.*|mite|leech) (into|in|on) your chest
     action remove (lodged\s*.*|mite|leech) (into|in|on) your abdomen
     action remove (lodged\s*.*|mite|leech) (into|in|on) your back
     action remove (lodged\s*.*|mite|leech) (into|in|on) your right arm
     action remove (lodged\s*.*|mite|leech) (into|in|on) your left arm
     action remove (lodged\s*.*|mite|leech) (into|in|on) your right leg
     action remove (lodged\s*.*|mite|leech) (into|in|on) your left leg
     action remove (lodged\s*.*|mite|leech) (into|in|on) your right hand
     action remove (lodged\s*.*|mite|leech) (into|in|on) your left hand
     action remove (lodged\s*.*|mite|leech) (into|in|on) your left eye
     action remove (lodged\s*.*|mite|leech) (into|in|on) your right eye
     action remove ^You have no significant injuries\.
     return
##############################################
## DUMPSTER SET
#############################################
DUMPSTER_SET:
DUMPSTER_CHECK:
     var dumpster NULL
     if matchre("$roomobjs", "a small hole") then var dumpster hole
     if matchre("$roomobjs", "a small mud puddle") then var dumpster puddle
     if matchre("$roomobjs", "a marble statue ") then var dumpster statue
     if matchre("$roomobjs", "(a disposal bin|a waste bin|firewood bin)") then var dumpster bin
     if matchre("$roomobjs", "(a tree hollow|darken hollow)") then var dumpster hollow
     if matchre("$roomobjs", "a bucket of viscous gloop|(a|metal|iron|steel|rusted|waste) bucket") then var dumpster bucket
     if matchre("$roomobjs", "a large stone turtle") then var dumpster turtle
     if matchre("$roomobjs", "an oak crate") then var dumpster crate
     if matchre("$roomobjs", "a driftwood log") then var dumpster log
     if matchre("$roomobjs", "(ivory|stone) urn") then var dumpster urn
     if matchre("$roomobjs", "a waste basket") then var dumpster basket
     if matchre("$roomobjs", "a bottomless pit") then var dumpster pit
     if matchre("$roomobjs", "trash receptacle") then var dumpster receptacle
     if matchre("$roomobjs", "domesticated gelapod") then var dumpster gelapod
     if matchre("$roomobjs", "large wooden barrel") then var dumpster barrel
     if matchre("$roomname", "^\[Garden Rooftop, Medical Pavilion\]") then var dumpster gutter
     return
#### CATCH AND RETRY SUBS
WAIT:
     delay 0.0001
     pause 0.1
     if (!$standing) then gosub STAND
     goto %LOCATION
WEBBED:
     delay 0.0001
     if ($webbed) then waiteval (!$webbed)
     if (!$standing) then gosub STAND
     goto %LOCATION
IMMOBILE:
     delay 0.0001
     if contains("$prompt" , "I") then pause 20
     if (!$standing) then gosub STAND
     goto %LOCATION
STUNNED:
     delay 0.0001
     if ($stunned) then waiteval (!$stunned)
     if (!$standing) then gosub STAND
     goto %LOCATION
RETRY:
     matchre location ^\.\.\.wait
     matchre location ^Sorry, you may
     matchre location ^Sorry, system is slow
     matchre location ^You don't seem to be able to move to do that
     matchre location.p ^It's all a blur
     matchre location.p ^You're unconscious\!
     matchre location.p ^You are still stunned
     matchre location.p There is no need for violence here\.
     matchre location.p ^You can't do that while entangled in a web
     matchre location.p ^You struggle against the shadowy webs to no avail\.
     matchre location.p ^You attempt that, but end up getting caught in an invisible box\.
     matchre location1 ^You should stop Playing before you do that\.
     matchre location1 ^You are a bit too busy performing to do that\.
     matchre location1 ^You are concentrating too much upon your performance to do that\.
     matchwait 22
     put #echo >Log Gold matchwait %location %todo
LOCATION.P:
     pause
LOCATION:
     pause .1
     goto %LOCATION
LOCATION.UNLOAD:
     gosub unload
     var LOCATION STOW_1
     gosub STOW_1
     return
LOCATION.UNLOAD1:
     gosub unload
     var LOCATION WEAR_1
     gosub WEAR_1
     return
LOCATION1:
     send stop play
     pause 0.1
     goto %LOCATION
#### RETURNS
CLEAR_MATCHTABLE:
  matchre CLEARED_MATCHTABLE .*
  matchwait
CLEARED_MATCHTABLE:
  return
RETURN_CLEAR:
     delay 0.0001
     put #queue clear
     pause 0.0001
     return
return_p:
     pause 0.1
RETURN:
     delay 0.0001
     return