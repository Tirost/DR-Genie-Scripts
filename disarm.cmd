debug 10
################################################################################################################################
# Smart Disarm Script v6.6 - For Dragonrealms - by Shroom
# Specialized for thieves, works for anyone
# - Analyzes the appraisal difficulty of the trap compared to what type of trap it is
# - Dynamically changes mode of disarm (Blind, Quick, Normal, Careful) according to how difficult trap is
# - Tosses box if trap is WAY too hard, or if you fail too many times in a row
# - Handles Blown Traps (determines what kind of trap it was, reacts/gets healed accordingly)
# - Handles Lockpick Rings/Cases
# - Tracks total number of boxes picked per session and total boxes picked over ALL TIME running the script
################################################################################################################################
# CHANGELOG 
# - Robustified the TRAP RECOVERY section 
# - Added variable to put armor back on at the end (if it removes any at the beginning)
# - Added variable for WORN gem pouches, so script will work with worn pouches instead of pulling them from a container
# - Cleaned up/Optimized a ton of code - changed all script variable checks (toupper). Now variables don't have to be in all caps.
# - Robustified the guild check section, armor check section. Now checks for hand armor as part of the armor check
# - SPECIAL REQUEST - Added support to ONLY Disarm boxes, if you want to make some pet boxes
# - SPECIAL REQUEST - PICK BOXES FOR OTHERS! Simply start the script by using the player's name as a variable
# Example - .disarm Bob - will wait for boxes from Bob, disarm and pick them and give them back to Bob. (THIS IGNORES IF YOU ARE MIND LOCKED)
# - ADDED Much better multi character support - Now can easily set different variables for different characters. 
# - Added new variable <autoheal> - Set to YES by default. Set to NO if you want to skip visiting the auto-empath if you get hurt (WILL ABORT SCRIPT IF YOU ARE HURT)  
# LAST UPDATE - 1/1/19
################################################################################################################################
#####################
## USER VARIABLES 
#####################
## YOU MUST SET YOUR CHARACTER'S NAME(S) BELOW
## IF ONLY ONE CHARACTER THEN JUST SET CHARACTER1. SET REST TO NULL 
var CHARACTER1 Strongbad
var CHARACTER2 Cheech
var CHARACTER3 Chong
var CHARACTER4 NULL
## MAKE SURE TO UPDATE THE VARIABLES THAT ARE SPECIFIC TO EACH DIFFERENT CHARACTER # BELOW 
if ("$charactername" = "%CHARACTER1") then
## DONT CHANGE THIS ABOVE ^^^^^ 
## CHANGE ALL THESE BELOW VVVV
     {
     ## SET YOUR BAGS WHERE BOXES CAN BE FOUND
     ## AND/OR WHERE YOUR ARMOR/HAND ITEMS CAN BE STOWED
     var container1 satchel
     var container2 rucksack
     var container3 haversack
     var sheath NULL
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn YES
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container bag
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch YES
     # ANY HAND WORN ARMOR?
     var knuckles knuckles
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage robe
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal NO
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking NO
     # MOVE.ROOMS (YES OR NO) - SET TO YES IF YOU PICK BOXES IN A ROOM WITH OTHER PLAYERS
     # THIS WILL MOVE ROOMS WHEN DISARMING AREA-WIDE TRAPS THAT CAN HURT/EFFECT OTHERS
     var MOVE.ROOMS NO
     # SET YOUR "STARTING" ROOM IN AUTOMAPPER (MAIN ROOM YOU WANT TO PICK BOXES IN OR RETURN TO)
     # THESE VARIABLES DO NOT MATTER IF YOU HAVE MOVE.ROOMS SET TO NO
     var STARTING.ROOM 45
     # SET YOUR "SAFE" ROOM (FOR DISARMING AREA-WIDE TRAPS THAT CAN HURT OTHERS)
     var SAFE.ROOM 45
     ## Special Request - Pet box CREATOR
     #DISARM ONLY?? (YES OR NO) (Skips lockpicking/looting COMPLETELY - this is ONLY for if you just want to MAKE some pet boxes)
     var disarmOnly NO
 	 if %1 = "%disarmBag" then var disarmOnly YES
    ## Set the special bag to put only disarmed boxes in
     var disarmBag bag
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
	 if %1 = "pet" then var PET.BOXES YES
     ###################################
     # THIEF ONLY VARIABLES
     ###################################
     # SET THE KHRI YOU WANT TO USE (IGNORE IF NON-THIEF)
     var khri safe focus sight avoidance
     # HARVEST TRAPS? (YES OR NO)
     # Harvesting increases overall time of picking SIGNIFICANTLY but also increases EXP per box
     var harvest NO
     # DO YOU WANT TO KEEP ALL THE COMPONENTS YOU HARVEST? (YES OR NO)
     # SCRIPT WILL ALWAYS KEEP CUBES IF SCRIPT FINDS THEM, WILL DROP ANYTHING ELSE IF NO
     var keepcomponent YES
     # NAME OF YOUR COMPONENT CONTAINER
     var componentcontainer dark.pouch
     #### BASE DIFFICULTY ADJUSTER. FOR INCREASING DIFFICULTY MANUALLY ( -5 to 5 ) DEFAULT IS 0
     #### LOWER THIS NUMBER TO MAKE TRAPS TEACH BETTER/HIGHER RISK - (USE QUICK/BLIND MORE OFTEN)
     #### RAISE THIS NUMBER TO MAKE TRAPS EASIER/LESS LIKELY TO EXPLODE - (USE CAREFUL MORE OFTEN)
     var baseline_difficulty -1
     goto INIT
     }
     
if ("$charactername" = "%CHARACTER2") then
     {
     ## SET YOUR BAGS WHERE BOXES CAN BE FOUND
     ## AND/OR WHERE YOUR ARMOR/HAND ITEMS CAN BE STOWED
     var container1 bag
     var container2 NULL
     var container3 NULL
     var sheath NULL
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn YES
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container bag
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch YES
     # ANY HAND WORN ARMOR?
     var knuckles handwraps
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage robe
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking NO
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal NO
     # MOVE.ROOMS (YES OR NO) - SET TO YES IF YOU PICK BOXES IN A ROOM WITH OTHER PLAYERS
     # THIS WILL MOVE ROOMS WHEN DISARMING AREA-WIDE TRAPS THAT CAN HURT/EFFECT OTHERS
     var MOVE.ROOMS NO
     # SET YOUR "STARTING" ROOM IN AUTOMAPPER (MAIN ROOM YOU WANT TO PICK BOXES IN OR RETURN TO)
     # THESE VARIABLES DO NOT MATTER IF YOU HAVE MOVE.ROOMS SET TO NO
     var STARTING.ROOM 45
     # SET YOUR "SAFE" ROOM (FOR DISARMING AREA-WIDE TRAPS THAT CAN HURT OTHERS)
     var SAFE.ROOM 45
     #Special Request - Pet box Creator
     #DISARM ONLY?? (YES OR NO) (Skips lockpicking/looting COMPLETELY - this is ONLY for if you just want to make some pet boxes)
     var disarmOnly NO
 	 if %1 = "%disarmBag" then var disarmOnly YES
     ## Set the special bag to put only disarmed boxes in
     var disarmBag bag
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
	 if %1 = "pet" then var PET.BOXES YES
     ###################################
     # THIEF ONLY VARIABLES
     ###################################
     # SET THE KHRI YOU WANT TO USE (IGNORE IF NON-THIEF)
     var khri safe focus sight avoidance darken
     # HARVEST TRAPS? (YES OR NO)
     # Harvesting increases overall time of picking SIGNIFICANTLY but also increases EXP per box
     var harvest NO
     # DO YOU WANT TO KEEP ALL THE COMPONENTS YOU HARVEST? (YES OR NO)
     # SCRIPT WILL ALWAYS KEEP CUBES IF SCRIPT FINDS THEM, WILL DROP ANYTHING ELSE IF NO
     var keepcomponent YES
     # NAME OF YOUR COMPONENT CONTAINER
     var componentcontainer dark.pouch
     #### BASE DIFFICULTY ADJUSTER. FOR INCREASING DIFFICULTY MANUALLY ( -5 to 5 ) DEFAULT IS 0
     #### LOWER THIS NUMBER TO MAKE TRAPS TEACH BETTER/HIGHER RISK - (USE QUICK/BLIND MORE OFTEN)
     #### RAISE THIS NUMBER TO MAKE TRAPS EASIER/LESS LIKELY TO EXPLODE - (USE CAREFUL MORE OFTEN)     
     var baseline_difficulty -1
     goto INIT
     }
     
if ("$charactername" = "%CHARACTER3") then
     {
     ## SET YOUR BAGS WHERE BOXES CAN BE FOUND
     ## AND/OR WHERE YOUR ARMOR/HAND ITEMS CAN BE STOWED
     var container1 bag
     var container2 ruck
     var container3 NULL
     var sheath NULL
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn NO
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container bag
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch YES
     # ANY HAND WORN ARMOR?
     var knuckles knuckles
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage ruck
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal NO
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking NO
     # MOVE.ROOMS (YES OR NO) - SET TO YES IF YOU PICK BOXES IN A ROOM WITH OTHER PLAYERS
     # THIS WILL MOVE ROOMS WHEN DISARMING AREA-WIDE TRAPS THAT CAN HURT/EFFECT OTHERS
     var MOVE.ROOMS NO
     # SET YOUR "STARTING" ROOM IN AUTOMAPPER (MAIN ROOM YOU WANT TO PICK BOXES IN OR RETURN TO)
     # THESE VARIABLES DO NOT MATTER IF YOU HAVE MOVE.ROOMS SET TO NO
     var STARTING.ROOM 45
     # SET YOUR "SAFE" ROOM (FOR DISARMING AREA-WIDE TRAPS THAT CAN HURT OTHERS)
     var SAFE.ROOM 45
     #Special Request - Pet box Creator
     #DISARM ONLY?? (YES OR NO) (Skips lockpicking/looting COMPLETELY - this is ONLY for if you just want to make some pet boxes)
     var disarmOnly NO
 	 if %1 = "%disarmBag" then var disarmOnly YES
     ## Set the special bag to put only disarmed boxes in
     var disarmBag bag
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
 	 if %1 = "pet" then var PET.BOXES YES
     ###################################
     # THIEF ONLY VARIABLES
     ###################################
     # SET THE KHRI YOU WANT TO USE (IGNORE IF NON-THIEF)
     var khri safe focus sight avoidance darken
     # HARVEST TRAPS? (YES OR NO)
     # Harvesting increases overall time of picking SIGNIFICANTLY but also increases EXP per box
     var harvest NO
     # DO YOU WANT TO KEEP ALL THE COMPONENTS YOU HARVEST? (YES OR NO)
     # SCRIPT WILL ALWAYS KEEP CUBES IF SCRIPT FINDS THEM, WILL DROP ANYTHING ELSE IF NO
     var keepcomponent YES
     # NAME OF YOUR COMPONENT CONTAINER
     var componentcontainer dark.pouch
     #### BASE DIFFICULTY ADJUSTER. FOR INCREASING DIFFICULTY MANUALLY ( -5 to 5 ) DEFAULT IS 0
     #### LOWER THIS NUMBER TO MAKE TRAPS TEACH BETTER/HIGHER RISK - (USE QUICK/BLIND MORE OFTEN)
     #### RAISE THIS NUMBER TO MAKE TRAPS EASIER/LESS LIKELY TO EXPLODE - (USE CAREFUL MORE OFTEN)     
     var baseline_difficulty -1
     goto INIT
     }
     
if ("$charactername" = "%CHARACTER4") then
     {
     ## SET YOUR BAGS WHERE BOXES CAN BE FOUND
     ## AND/OR WHERE YOUR ARMOR/HAND ITEMS CAN BE STOWED
     var container1 carryall
     var container2 duffel.bag
     var container3 oil.bag
     var sheath harness
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn NO
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch black pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container satin.pouch
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch NO
     # ANY HAND WORN ARMOR?
     var knuckles knuckle
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage bag
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking NO
     # MOVE.ROOMS (YES OR NO) - SET TO YES IF YOU PICK BOXES IN A ROOM WITH OTHER PLAYERS
     # THIS WILL MOVE ROOMS WHEN DISARMING AREA-WIDE TRAPS THAT CAN HURT/EFFECT OTHERS
     var MOVE.ROOMS NO
     # SET YOUR "STARTING" ROOM IN AUTOMAPPER (MAIN ROOM YOU WANT TO PICK BOXES IN OR RETURN TO)
     # THESE VARIABLES DO NOT MATTER IF YOU HAVE MOVE.ROOMS SET TO NO
     var STARTING.ROOM 45
     # SET YOUR "SAFE" ROOM (FOR DISARMING AREA-WIDE TRAPS THAT CAN HURT OTHERS)
     var SAFE.ROOM 45
     #Special Request - Pet box Creator
     #DISARM ONLY?? (YES OR NO) (Skips lockpicking/looting COMPLETELY - this is ONLY for if you just want to make some pet boxes)
     var disarmOnly NO
  	 if %1 = "%disarmBag" then var disarmOnly YES
    ## Set the special bag to put only disarmed boxes in
     var disarmBag white back
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
	 if %1 = "pet" then var PET.BOXES YES
      ###################################
     # THIEF ONLY VARIABLES
     ###################################
     # SET THE KHRI YOU WANT TO USE (IGNORE IF NON-THIEF)
     var khri safe focus sight avoidance darken
     # HARVEST TRAPS? (YES OR NO)
     # Harvesting increases overall time of picking SIGNIFICANTLY but also increases EXP per box
     var harvest NO
     # DO YOU WANT TO KEEP ALL THE COMPONENTS YOU HARVEST? (YES OR NO)
     # SCRIPT WILL ALWAYS KEEP CUBES IF SCRIPT FINDS THEM, WILL DROP ANYTHING ELSE IF NO
     var keepcomponent YES
     # NAME OF YOUR COMPONENT CONTAINER
     var componentcontainer dark.pouch
     #### BASE DIFFICULTY ADJUSTER. FOR INCREASING DIFFICULTY MANUALLY ( -5 to 5 ) DEFAULT IS 0
     #### LOWER THIS NUMBER TO MAKE TRAPS TEACH BETTER/HIGHER RISK - (USE QUICK/BLIND MORE OFTEN)
     #### RAISE THIS NUMBER TO MAKE TRAPS EASIER/LESS LIKELY TO EXPLODE - (USE CAREFUL MORE OFTEN)     
     var baseline_difficulty -1
     goto INIT
     }
     echo **** ERROR! YOU DID NOT SET YOUR VARIABLES PROPERLY!!
     echo **** Edit the script and make sure to add your character's name to: var CHARACTER1
     echo **** If you use the script with different characters you can set them under CHARACTER2, CHARACTER3, CHARACTER4
     exit
##############################################################################
##############################################################################
# END USER VARIABLES - DO NOT TOUCH ANYTHING BELOW
##############################################################################
##############################################################################

### DEFAULT SCRIPT VARIABLES - DO NOT TOUCH
INIT:
     var box_types \bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|\bbox\b
     var component_list sealed vial|tube|needle|seal|bladder|studs|blade|\brune\b|spring|hammer|disc|dart|reservoir|face|\bpin\b|striker|cube|sphere|leg|crystal|circle|clay
     var multi_trap ON
     var multi_lock ON
     var thief_hide NO
     var ARMOR_STOW OFF
     var trap_type null
     var BOXES 0
     var BOX 0
     var LOCAL 0
     var GIVEBOX NO
     var FIRSTIME YES
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
     var total_armor 0
     var dismantle
     if matchre($Boxes, \D+) then put #var Boxes 0
##################################
## SCRIPT ACTIONS
##################################
# TRAP TYPE MATCHING~
     action var trap_type acid;echo ***ACID TRAP! when As you look closely, you notice a tiny hole right next to the lock which looks to be a trap of some kind.
     action var trap_type boomer;echo ***BOOMER TRAP! when A glistening black square, surrounded by a tight ring of fibrous cord, catches your eye.
     action var trap_type reaper;echo ***REAPER TRAP!! when A crust-covered black scarab of some unidentifiable substance clings to the
     action var trap_type fire_ant;echo ***FIRE ANT TRAP!! when The bag twitches on occasion, leading you to believe the blade's presence likely to be a very bad thing.
     action var trap_type poison_bolt;echo ***POISON BOLT TRAP when concealing the points of several crossbow bolts glistening with moisture.
     action var trap_type bolt;echo ***BOLT TRAP! when concealing the points of several wickedly barbed crossbow bolts.
     action var trap_type concussion;echo ***CONCUSSION TRAP!! when you see a tiny metal tube just poking out of a small wad of brown clay|infamous shockwave trap
     action var trap_type cyanide;echo ***CYANIDE TRAP! when The glint of silver from the tip of a dart
     action var trap_type disease;echo ***DISEASE TRAP! when swollen animal bladder recessed inside the keyhole.
     action var trap_type flea;echo ***FLEA TRAP! when small glass tube of milky-white opacity
     action var trap_type gas;echo ***GAS TRAP! when You notice a vial of lime green liquid just under the
     action var trap_type lightning;echo ***LIGHTNING TRAP!! when Looking closely into the keyhole, you spy what appears to be a pulsating ball
     action var trap_type naphtha_soaker;echo ***NAPHTHA SOAKER TRAP!! when Though it's hard to see, there also appears to be a liquid-filled bladder inside the notch.
     action var trap_type naphtha;echo ***NAPHTHA TRAP! when A tiny striker is cleverly concealed under the lid, set to ignite a frighteningly large vial of naphtha.
     action var trap_type poison_local;echo ***POISON TRAP! when You notice a tiny needle with a greenish discoloration on its tip hidden next to the keyhole.
     action var trap_type poison_nerve;echo ***NERVE POISON TRAP! when You notice a tiny needle with a rust colored discoloration on its tip hidden next to the keyhole.
     action var trap_type scythe;echo ***SCYTHE TRAP! when Out of the corner of your eye, you notice a glint of razor sharp steel hidden within a suspicious looking seam on the
     action var trap_type shocker;echo ***SHOCKER TRAP! when You notice two silver studs right below the keyhole which look dangerously out of place there.
     action var trap_type shrapnel;echo ***SHRAPNEL TRAP!!! when keyhole is packed tightly with a powder around the insides of the lock|means this is the shrapnel trap
     action var trap_type teleport;echo ***TELEPORT TRAP!!!! when are covered with a thin metal circle that has been lacquered with a shade of
     action var trap_type bouncer;echo ***BOUNCER TRAP when Connected to the pin is a small shaft that runs downward into a shadow.
     action var trap_type curse;echo ***CURSE TRAP when you notice a small glowing rune hidden
     action var trap_type frog;echo ***FROG TRAP when with a careful eye, you notice a lumpy green rune hidden inside the
     action var trap_type laughing;echo ***LAUGHING TRAP when tiny glass tube filled with a black gaseous substance of some sort and a tiny hammer|^That tiny vial filled with a black liquid
     action var trap_type mana_sucker;echo ***MANA TRAP when The seal is covered in strange runes and a glass sphere is embedded within it.
     action var trap_type mime;echo ***MIME TRAP when A tiny bronze face, Fae in appearance, grins ridiculously from its place on the
     action var trap_type shadowling;echo ***SHADOWLING TRAP when with a careful eye, you notice a small black crystal deep in the shadows of the
     action var trap_type sleeper;echo ***SLEEPER TRAP when Two sets of six pinholes on either side of the
#################################################################
## THESE DETERMINE THE BASE DIFFICULTY LEVEL OF A TRAP
#################################################################
     action var app_difficulty -8 when An aged grandmother could
     action var app_difficulty -7 when is a laughable matter
     action var app_difficulty -5 when is a trivially constructed
     action var app_difficulty -4 when will be a simple matter for you to
     action var app_difficulty -3 when should not take long with your skills
     action var app_difficulty 0 when is precisely at your skill level
     action var app_difficulty 1 when with only minor troubles
     action var app_difficulty 2 when got a good shot at
     action var app_difficulty 3 when some chance of being able
     action var app_difficulty 5 when with persistence you believe you could
     action var app_difficulty 6 when would be a longshot
     action var app_difficulty 7 when minimal chance
     action var app_difficulty 8 when You really don't have any chance
     action var app_difficulty 9 when Prayer would be a good start
     action var app_difficulty 11 when You could just jump off a cliff
     action var app_difficulty 13 when same shot as a snowball
     action var app_difficulty 15 when pitiful snowball encased in the Flames
## MISC ACTIONS
     action instant goto DROPPED_BOX when ^Your .* falls to the ground\.
     #action put #queue clear; send $lastcommand when ^\.\.\.wait|^Sorry, you may only type
     action var multi_trap ON when is not yet fully disarmed
     action var multi_lock ON when discover another lock protecting
## LOCK MODE
     action var mode blind when ^This lock is a laughable matter|^An aged grandmother could open this
     action var mode quick when lock's structure is relatively basic|should not take long with your skills|You can unlock the (.+) with only minor troubles|^The lock is a trivially constructed piece of junk|will be a simple matter for you
     action var mode normal when ^You think this lock is precisely at your skill level|The lock has the edge on you
     action var mode careful when ^The odds are against you, but with persistence you believe you could pick|You have some chance of being able to pick open|would be a longshot
     action var mode careful when ^Prayer would be a good start for any attempt of yours at picking|amazingly mininal chance at picking|don't have any change at picking|snowball|jump off a cliff
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
     pause 0.2
     put exp survival 0
     waitfor Overall state of mind
     pause 0.001
     if_1 then
     {
		if (matchre("%1", "pet|PET|Pet|%disarmbag")) then GOTO TOP
          var user %1
          var GIVEBOX YES
          send whisper %user Give me a second to prepare. When ready I'll whisper you and then hand me a new box.
     }
     GOTO TOP
######################################################################################
##### TRAP DIFFICULTY MODIFIERS
##### THIS SETS A STATIC DIFFICULTY LEVEL FOR EACH TRAP TYPE
##### THEN ADDS THAT TO THE APPRAISED DIFFICULTY TO DETERMINE WHAT MODE OF DISARM TO USE
##########################################################################################
trap_diff_compute:
### setting trap difficulties...
### set from -5 to 5 (OR BEYOND) depending on how worried you are about blowing that particular trap
     if "%trap_type" = "concussion" then var trap_difficulty 8
     if "%trap_type" = "teleport" then var trap_difficulty 8
     if "%trap_type" = "shrapnel" then var trap_difficulty 7
     if "%trap_type" = "disease" then var trap_difficulty 7
     if "%trap_type" = "reaper" then var trap_difficulty 7
     if "%trap_type" = "fire_ant" then var trap_difficulty 7
     if "%trap_type" = "gas" then var trap_difficulty 6
     if "%trap_type" = "lightning" then var trap_difficulty 6
     if "%trap_type" = "naphtha_soaker" then var trap_difficulty 5
     if "%trap_type" = "naphtha" then var trap_difficulty 5
     if "%trap_type" = "acid" then var trap_difficulty 4
     if "%trap_type" = "boomer" then var trap_difficulty 4
     if "%trap_type" = "scythe" then var trap_difficulty 4
     if "%trap_type" = "shocker" then var trap_difficulty 3
     if "%trap_type" = "poison_local" then var trap_difficulty 3
     if "%trap_type" = "poison_nerve" then var trap_difficulty 3
     if "%trap_type" = "curse" then var trap_difficulty 3
     if "%trap_type" = "poison_bolt" then var trap_difficulty 2
     if "%trap_type" = "bolt" then var trap_difficulty 2
     if "%trap_type" = "cyanide" then var trap_difficulty 2
     if "%trap_type" = "frog" then var trap_difficulty -1
     if "%trap_type" = "flea" then var trap_difficulty -2
     if "%trap_type" = "bouncer" then var trap_difficulty -3
     if "%trap_type" = "laughing" then var trap_difficulty -3
     if "%trap_type" = "sleeper" then var trap_difficulty -3
     if "%trap_type" = "mime" then var trap_difficulty -4
     if "%trap_type" = "mana_sucker" then var trap_difficulty -5
     if "%trap_type" = "shadowling" then var trap_difficulty -5
# computing...
	echo **** Computing Overall Trap Difficulty.....
	pause 0.2
	echo
     var total_difficulty 0
	# echo **** Trap Type Difficulty.. %trap_difficulty
	# echo **** Baseline addition.. %baseline_difficulty
	# echo **** Appraised Difficulty.. %app_difficulty
	echo
	pause 0.1
     math total_difficulty add %baseline_difficulty
     math total_difficulty add %trap_difficulty
     math total_difficulty add %app_difficulty
     pause 0.1
     var mode normal
     if %total_difficulty < -2 then var mode blind
     if %total_difficulty = -2 then var mode quick
     if %total_difficulty = -1 then var mode quick
     if %total_difficulty = 0 then var mode quick
     if %total_difficulty = 1 then var mode quick
     if %total_difficulty = 2 then var mode quick
     if %total_difficulty = 3 then var mode quick
     if %total_difficulty = 4 then var mode normal
     if %total_difficulty = 5 then var mode normal
     if %total_difficulty = 6 then var mode normal
     if %total_difficulty = 7 then var mode normal
     if %total_difficulty = 8 then var mode normal
     if %total_difficulty = 9 then var mode careful
     if %total_difficulty = 10 then var mode careful
     if %total_difficulty = 11 then var mode careful
     if %total_difficulty = 12 then var mode careful
     if %total_difficulty = 13 then var mode careful
     if %total_difficulty = 14 then var mode careful
     if %total_difficulty = 15 then var mode careful
     if %total_difficulty = 16 then var mode toss
     if %total_difficulty = 17 then var mode toss
     if %total_difficulty = 18 then var mode toss
     if %total_difficulty = 19 then var mode toss
     if %total_difficulty = 20 then var mode toss
     if %total_difficulty = 21 then var mode toss
     if %total_difficulty = 22 then var mode toss
     if %total_difficulty = 23 then var mode toss
     if %total_difficulty > 23 then var mode toss
     return
#################################################################################################################
TOP:
     echo **********************************
     echo * Shroom's Smart Disarm Script 
     echo * Discord: Shroom#0046
     echo **********************************
     pause
	if ($hidden = 1) then
          {
               send shiver
               pause 0.3
          }
     pause 0.0001
     pause 0.0001
     pause 0.0001
     gosub STOWING
     pause 0.1
     if ("$guild" = "Warrior") then put #var guild Warrior Mage
     if ("$guild" = "Moon") then put #var guild Moon Mage
     pause 0.2
     pause 0.2
     if !def(guild) || !matchre("$guild","(Thief|Barbarian|Empath|Warrior Mage|Cleric|Bard|Moon Mage|Ranger|Necromancer|Trader)") then
          {
               action var guild $1;put #var guild $1 when Guild\: (\S+)
               send info;encum
               waitforre ^\s*Encumbrance\s*\:
               action remove Guild\: (\S+)
               put #var save
               pause 0.2
          }
     if ("$guild" = "Thief") then var dismantle thump
     if ("$guild" = "Barbarian") then var dismantle bash
     if ("$guild" = "Bard") then var dismantle shriek
     if ("$guild" = "Cleric") then var dismantle pray
     if ("$guild" = "Warrior Mage") then var dismantle fire
     if ("$guild" = "Moon Mage") then var dismantle focus
     if ("$guild" = "Ranger") then var dismantle whistle
     if ("$guild" = "Trader") then var dismantle salvage
     if ("$guild" = "Empath") then var dismantle
     if ("$guild" = "Necromancer") then var dismantle
     echo
     echo * Guild: $guild
     echo * Dismantle Type: %dismantle
     echo
     goto initial_Check

initial_Check:
     pause 0.1
     if (toupper("%PET.BOXES") != "YES") then
          {
               gosub init_BagCheck %container1
               gosub init_BagCheck %container2
               gosub init_BagCheck %container3
          }
     if (toupper("%PET.BOXES") = "YES") then gosub init_BagCheck %disarmBag
     if (%BOX = 0) then goto DONE
     if (toupper("%PET.BOXES") = "YES") then goto lock.check
     goto armor_Check
init_BagCheck:
     var container $1
     if (%BOX = 1) then goto armor_Check
          matchre init_BagCheck ^\.\.\.wait|^Sorry,
		matchre boxes_Yes (\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|\bbox\b)
		matchre RETURN Encumbrance
	send look in my %container;enc
	matchwait
boxes_Yes:
     pause 0.1
     var BOX 1
     return
     
armor_Check:
counter set 0
hand_Check:
     pause 0.1
          matchre remove_Armor (hand wraps|handwraps|knuckles|hand claws|knuckleguards)
          matchre armor_Check1 You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
          put inv hand weapon
     matchwait 15
     goto armor_Check1
armor_Check1:
          matchre armor_Check1 ^\.\.\.wait|^Sorry, you may only type
          matchre remove_Armor (armet|gauntlet|gloves|shield|claw guards|mail gloves|platemail legs|parry stick|handwraps|\bhat\b|hand claws|jacket|armwraps|footwraps|aegis|buckler|\bhood\b|\bcowl\b|\bheater|pavise|scutum|shield|sipar|\btarge\b|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|coat|\bcowl|cuirass|fauld|greaves|hauberk|helm|\bhood\b|jerkin|leathers|lorica|mantle|(?<!crimson leather )mask|morion|pants|steel plate(?! armor| gauntlets| gloves| greaves| helm)|(field|fluted|full|half) \bplate\b|handguards|robe|sallet|shirt|sleeves|ticivara|tabard|tasset|thorakes|\blid\b|vambraces|vest|collar|coif|mitt|steel mail|(field|chain|leather|bone|quilted|reed|black|plate|combat|body|clay|lamellar|steel|mail|pale|polished|shadow|Suit of|suit|woven|yeehar-hide|kidskin|gladiatorial|battle|tomiek|glaes|pale|ceremonial|Sinuous|trimmed|carapace|Zaulguum-skin) \barmor\b)
          matchre armor_None You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
          put inv armor
	matchwait 3
armor_Checking:
          matchre armor_Check1 ^\.\.\.wait|^Sorry, you may only type
          matchre remove_Armor (armet|gauntlet|gloves|shield|claw guards|mail gloves|platemail legs|parry stick|handwraps|\bhat\b|hand claws|jacket|armwraps|footwraps|aegis|buckler|\bhood\b|\bcowl\b|\bheater|pavise|scutum|shield|sipar|\btarge\b|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|coat|\bcowl|cuirass|fauld|greaves|hauberk|helm|\bhood\b|jerkin|leathers|lorica|mantle|(?<!crimson leather )mask|morion|pants|steel plate(?! armor| gauntlets| gloves| greaves| helm)|(field|fluted|full|half) \bplate\b|handguards|robe|sallet|shirt|sleeves|ticivara|tabard|tasset|thorakes|\blid\b|vambraces|vest|collar|coif|mitt|steel mail|(field|chain|leather|bone|quilted|reed|black|plate|combat|body|clay|lamellar|steel|mail|pale|polished|shadow|Suit of|suit|woven|yeehar-hide|kidskin|gladiatorial|battle|tomiek|glaes|pale|ceremonial|Sinuous|trimmed|carapace|Zaulguum-skin) \barmor\b)
          matchre Armor_Complete You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
          put inv armor
	matchwait 4
	goto Armor_Complete
remove_Armor:
     var armor $0
     var LAST remove_Armor
     pause 0.1
          matchre stow_Armor ^\.\.\.wait|^Sorry, you may only type
          matchre stow_Armor ^You work|^You remove|^You pull|^You take|^You loosen|^You sling|^You slip|^You slide
          matchre armor_Check ^You have nothing of that|^Remove what
          put remove %armor
     matchwait
stow_Armor:
	var LAST stow_Armor_1
     pause 0.1
		matchre stow_Armor ^\.\.\.wait|^Sorry, you may only type
          matchre stow_Armor_2 any more room in|closed|no matter how you arrange
		matchre armor_Done ^You put your
		put put %armor in my %container1
	matchwait
stow_Armor_2:
	var LAST stow_Armor_2
		matchre stow_Armor_2 ^\.\.\.wait|^Sorry, you may only type
          matchre no_More_Stowing any more room in|closed|no matter how you arrange
	     matchre armor_Done ^You put your
	put put %armor in my %container2
	matchwait
armor_Done:
     counter add 1
     pause 0.1
     var total_armor %c
     var armor%c %armor
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
     ECHO #######################################
     ECHO
     pause 0.2
     goto lock.check
no_More_Stowing:
	echo **   No more room for stowing armor! Exiting script   **
     echo **   Make some more room in your bags! Or choose larger containers!
	put wear %armor
     pause 0.5
	goto done
lock.check:
	if (toupper("%lockpick.ring") = "YES") then gosub lockpick_ring_check
	goto main

###########################################################
##
## MAIN SCRIPT LOOP HERE!
##
###########################################################

main:
	pause 0.1
     if (toupper("%GIVEBOX") = "YES") then
          {
               put whisper %user Ready for a box!
               put nod %user
               waitfor offers you
               pause 0.4
               send accept
               pause
          }
	if ((toupper("%keep.picking") != "YES") && (toupper("%GIVEBOX") != "YES")) then
          {
               if $Locksmithing.LearningRate > 33 then goto LOCKED_SKILLS
          }
     if (("$guild" = "Thief") && ($concentration > 50)) then
		{
            pause 0.1
            if ($Augmentation.Ranks < 180) then send kneel
			send khri %khri
			pause 0.5
               pause 0.1
            if (!$standing) then gosub stand
		}
	pause 0.2
     if (toupper("%PET.BOXES") = "YES") then gosub petContainer_Check
	if (toupper("%GIVEBOX") != "YES") && (toupper("%PET.BOXES") != "YES") then gosub container_Check
	if ("$lefthand" = "Empty") then
		{
			send swap
               pause 0.2
		}
	else
		{
			gosub STOW left
               pause 0.2
			send swap
		}
	pause 0.5
	pause 0.1
disarm_sub:
	pause 0.1
	if ("$guild" = "Thief") then gosub glance_box
     gosub disarm_ID
     if (toupper("%PET.BOXES") = "YES") && (%Disarmed = 0) then goto PETBOX_ERROR
     if (toupper("%PET.BOXES") = "YES") then goto lock_sub
     gosub trap_diff_compute
     echo *** Adjusted Trap Difficulty: %total_difficulty
	if ("%mode" = "toss") then goto toss_box
	gosub disarm
	var disarm.count 0
	var harvest.count 0
	if (toupper("%harvest") = "YES") then gosub analyze
	if (toupper("%multi_trap") = "ON") then goto disarm_sub
	if (($roomid != %STARTING.ROOM) && ("%MOVE.ROOMS" = "YES")) then
		{
			gosub automove %STARTING.ROOM
			pause 0.1
		}
     if ((toupper("%disarmOnly") = "YES") && (toupper("%GIVEBOX") = "YES")) then goto GIVEBOX
     if (toupper("%disarmOnly") = "YES") then goto stowDisarmed
	if (toupper("%lockpick.ring") != "YES") then gosub get_Pick
lock_sub:
	pause 0.1
	if ("$guild" = "Thief") then gosub glance_box
	if (toupper("%PET.BOXES") != "YES") then gosub pick_ID
	if ("%mode" = "toss") then goto toss_box
	pause 0.1
	if (toupper("%PET.BOXES") != "YES") then gosub pick
     if (toupper("%PET.BOXES") = "YES") then gosub pick_Cont
     pause 0.1
	if (toupper("%multi_lock") = "ON") then goto lock_sub
	if (toupper("%lockpick.ring") != "YES") then gosub put_Away_Pick
     if (toupper("%PET.BOXES") = "YES") then gosub exp_Check
GIVEBOX:
     if (toupper("%GIVEBOX") = "YES") then
          {
               if ("$righthand" = "Empty") then send swap
               pause 0.5
               pause 0.3
               put give %user
               waitfor accepts
               goto Continued
          }
	gosub loot
	gosub dismantle
Continued:
	if ("$guild" = "Thief") then gosub fix_Lock
     #gosub loot_Check
	gosub exp_Check
	goto main

container_Check:
     pause 0.1
     gosub container_BagCheck %container1
     if matchre("$righthand $lefthand", "%box_types") then return
     gosub container_BagCheck %container2
     if matchre("$righthand $lefthand", "%box_types") then return
     gosub container_BagCheck %container3
     if matchre("$righthand $lefthand", "%box_types") then return
     goto LOCKED_SKILLS
petContainer_Check:
     pause 0.1
     gosub container_BagCheck %disarmBag
     if matchre("$righthand $lefthand", "%box_types") then return
     goto LOCKED_SKILLS
container_BagCheck:
     var container $1
     pause 0.001
     matchre container_Check ^\.\.\.wait|^Sorry,
     matchre get_For_Disarm (\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|\bbox\b)
	matchre RETURN Encumbrance
	send look in my %container;enc
	matchwait

get_For_Disarm:
	var disarmit $1
	get.Box:
	pause 0.1
	pause 0.1
	pause 0.1
		var LAST container_Check
			matchre get.Box ^\.\.\.wait|^Sorry, you may only type
			matchre return You get|You are already
			matchre container_Check ^What were you
		send get my %disarmit from my %container
		matchwait

weapon:
    if (toupper("%PET.BOXES") = "YES") then GOTO pick_Cont
     var LAST WEAPON
     pause 0.2
     pause 0.1
     pause 0.1
     matchre weapon ^\.\.\.wait|^Sorry, you may only type
     matchre stow_Weapon You
     matchre weapon1 Remove what?
     put remove %knuckles
	matchwait
weapon1:
	var LAST weapon1
	matchre weapon1 ^\.\.\.wait|^Sorry, you may only type
	matchre stow_Weapon You|Remove
     put remove handwrap
	matchwait
stow_Weapon:
	var LAST stow_Weapon
	matchre stow_Weapon ^\.\.\.wait|^Sorry, you may only type
	matchre stow_Weapon2 There isn't any more room
     matchre SAVE ^You|Stow
	put stow %knuckles;stow handwrap
	matchwait
stow_Weapon2:
	var LAST stow_Weapon2
	matchre stow_Weapon2 ^\.\.\.wait|^Sorry, you may only type
	matchre SAVE ^You|Stow
	put stow %knuckles in %container1;stow handwr in %container1
	matchwait 5
     goto %SAVE

glance_box:
	var LAST glance_box
     var failcount 0
     pause 0.0001
	send glance my $lefthandnoun
	pause 0.2
	pause 0.1
     pause 0.0001
	return

Stop_Play:
     pause 0.5
     put stop play
     pause 0.5
disarm_ID:
     var SAVE disarm_ID
	var LAST disarm_ID
	var app_difficulty 0
	var trap_difficulty 0
	var disarm.count 0
     var harvest.count 0
     var disarmed 0
     pause 0.001
     pause 0.001
	pause 0.1
     pause 0.1

	if (toupper("%PET.BOXES") = "YES") then GoSub RETREAT 
		matchre Stop_Play ^You are a bit too busy performing
		matchre ID_FAIL ^You get the distinct feeling your careless|This is not likely to be a good
		matchre disarm_ID ^\.\.\.wait|^Sorry, you may only type
		matchre Not_Box ^You don't see any reason to attempt to disarm that
		matchre weapon hinders your attempt|knuckles|handwraps|hand claws
		matchre disarm_ID fails to reveal to you|^You are still stunned
		matchre HEALTH You're in no shape
		matchre Disarmed You guess it is already disarmed
		matchre RETURN Surely any fool|Even your memory can|Roundtime|Somebody has already located
		#matchre return coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|box
	send disarm ID
	matchwait 12
     return

Disarmed:
     var disarmed 1
     return
Not_Box:
     echo *** Error: Not a trapped box: $lefthand
     pause 0.1
     send put $lefthand in my %sheath
     pause 0.5
     goto container_Check

ID_FAIL:
     var failcount add 1
     if (%failcount > 4) then goto toss_box
     pause 0.3
     goto disarm_ID

disarm:
	var multi_trap OFF
	if matchre("%trap_type", "(concussion|disease|reaper|shrapnel|gas|lightning)") && ($roomid != %SAFE.ROOM) && (toupper(%MOVE.ROOMS) = "YES") then gosub automove %SAFE.ROOM
disarmIt_Cont:
     var SAVE disarmIt_Cont
	var LAST disarmIt_Cont
     math disarm.count add 1
     pause 0.001
     pause 0.001
	pause 0.1
	pause 0.1
	if (%disarm.count > 9) then goto toss_Box
     if (%total_difficulty >= 14) then goto toss_Box
     if ("%trap_type" = "concussion") && (%disarm.count > 4) then goto toss_Box
     if ("%trap_type" = "shrapnel") && (%disarm.count > 4) then goto toss_Box
     if ("%trap_type" = "concussion") && ("%total_difficulty" > "11") then goto toss_Box
     if ("%trap_type" = "shrapnel") && ("%total_difficulty" > "11") then goto toss_Box
	if (%disarm.count > 2) then var mode careful
	if ((%disarm.count > 1) && ("%mode" = "quick")) then var mode normal
		matchre disarmIt_Cont ^\.\.\.wait|^Sorry, you may only type
		matchre weapon hinders your attempt|knuckles|handwraps|hand claws
		matchre disarmIt_Cont ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre disarmIt_Careful This is not likely to be a good thing|You get the distinct feeling your manipulation caused something to shift inside the trap mechanism
		matchre disarmIt_Cont fumbling fails to disarm|unable to make any progress|You doubt you'll be this lucky every time
		matchre return You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help|It looks safe enough|^You don't see any reason
	put disarm my %disarmit %mode
	matchwait
disarmIt_Careful:
	math disarm.count add 2
     math total_difficulty add 1
	goto disarmIt_Cont

analyze:
	var LAST analyze
	math harvest.count add 1
     pause 0.001
     pause 0.001
	pause 0.1
     pause 0.1
	if (%harvest.count > 2) then goto RETURN
	    matchre weapon knuckles|handwraps
		matchre analyze ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre analyze You are unable to
		matchre harvest You already have made an extensive study|You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help
		matchre return fumbling fails to disarm|This is not likely to be a good thing|You've already analyzed this trap
		matchre disarm what could you possibly analyze
	put disarm anal
	matchwait

harvest:
	var LAST harvest
	math harvest.count add 1
     pause 0.001
     pause 0.001
	pause 0.1
     pause 0.1
	if (%harvest.count > 4) then goto RETURN
		matchre harvest ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre disarm_ID what could you possibly analyze
		matchre return It appears that none of the trap components are accessible|been completely harvested|unsuitable for harvesting|You don't see any reason
		matchre harvest Your laborious fumbling fails to harvest the trap component|You fumble
		matchre stow_Component Roundtime
	put disarm harvest
	matchwait

stow_Component:
     pause 0.001
     pause 0.001
     pause 0.1
	if ("$righthandnoun" = "cube") then send put cube in my %container1
     if (toupper("%keepcomponent") = "YES") then
          {
               if matchre("$righthand", "(%component_list)") then gosub stow_It $0
          }
     if ("$righthand" != "Empty") then
		{
			put empty right hand
			pause 0.5
		}
	goto return

stow_It:
	var component $0
	pause 0.1
	stow_Comp:
		var LAST stow_Comp
			matchre stow_It ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
			matchre return ^You put
               matchre stow_ItAlt any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|not designed to carry anything|^But that's closed
		put put %component in my %componentcontainer
		matchwait
stow_ItAlt:
     put put %component in my %container1
     pause 0.5
     return

get_Pick:
     pause 0.1
	var LAST get_Pick
		matchre get_Pick ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return You get|You are already
		matchre no_More_Picks What were you referring to
	put get my lockpick
	matchwait

pull_Pick:
	pause 0.1
	var LAST pull_Pick
		matchre pull_Pick ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return ^You get|^You are already|^You pull
		matchre get_Pick ^What were you referring to|^But there aren't any lockpicks
	put pull my lockpick ring
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
	pause 0.1
		matchre loot It's not even locked
		matchre put_Away_Pick ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return You put|What were you
		matchre pick.storage2 There isn't any more room|That's too heavy|^I could not|heavy
	put put lockpick in my %pickstorage
	matchwait

pick.storage2:
	var LAST pick.storage2
	if ("$righthand" = "Empty") then return
		matchre pick.storage2 ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return You put|What were you
	put put lockpick in my %container1
	matchwait

pick_ID:
	var LAST pick_ID
	var SAVE pick_ID
	var pickloop 0
     pause 0.1
     if ((toupper("%lockpick.ring") != "YES") && ("$righthand" = "Empty")) then gosub get_Pick
     pause 0.001
     pause 0.001
          matchre pick_ID ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre weapon hinders your attempt|knuckles|handwraps|hand claws
		matchre disarm_ERROR is not fully disarmed
		matchre pick_ID fails to teach you anything about the lock guarding it|just broke
		matchre return Somebody has already inspected|not even locked|Roundtime|^Pick what
		matchre get_Pick Find a more appropriate tool
	put pick ID
	matchwait

pick:
	var LAST pick
	var SAVE pick
	var multi_lock OFF
     pause 0.001
	pause 0.1
		matchre pick ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre weapon hinders your attempt|knuckles|handwraps|hand claws
		matchre pick_Cont Roundtime|has already helpfully been analyzed|not even locked|^Pick what
	put pick anal
	matchwait
pick_Cont:
	var multi_lock OFF
	if ((toupper("%lockpick.ring") != "YES") && ("$righthand" = "Empty")) then gosub get_Pick
     if (toupper("%GIVEBOX") != "YES") then
     	{
          if !matchre(toupper("%keep.picking"), "YES") then
               {
                    if ($Locksmithing.LearningRate > 33) then goto LOCKED_SKILLS
               }
          }
	var LAST pick_Cont
	var SAVE pick_Cont
	math pickloop add 1
     pause 0.001
     pause 0.001
	pause 0.1
	if ((%pickloop > 15) && (toupper("%GIVEBOX") = "NO")) then goto toss_Box
	if ((%pickloop > 6) && (toupper("%GIVEBOX") = "NO")) then var mode careful
	if ((%pickloop > 2) && ("%mode" = "quick") && (toupper("%GIVEBOX") = "NO")) then var mode normal
	if ((%pickloop > 2) && ("%mode" = "blind") && (toupper("%GIVEBOX") = "NO")) then var mode quick
    if (toupper("%PET.BOXES") = "YES") then {
		var mode blind
		GoSub RETREAT 
	}
		matchre pick_Cont ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre weapon hinders your attempt|knuckles|handwraps|hand claws
		matchre pick_cont You are unable to make
		matchre get_Pick Find a more appropriate tool
		matchre return With a soft click|Roundtime|^Pick what|not even locked
	put pick %mode
	matchwait

toss_Box:
     echo
     echo *** THIS BOX IS EITHER WAY TOO HARD FOR US
     echo *** AND/OR IS A DEADLY TRAP LIKELY TO KILL US!
     echo *** DISCARDING FOR SAFETY!!
     echo
     pause 0.5
     pause 0.5
	var LAST toss_Box
     var failcount 0
return_Box:
     if (toupper("%GIVEBOX") = "YES") then
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
     matchre toss_Box ^\.\.\.wait|^Sorry, you may only type
	matchre main ^You
	if matchre("$roomobjs","bucket of viscous gloop") then put put my %disarmit in bucket
     if matchre("$roomobjs","(waste bin|firewood bin)") then put put my %disarmit in bin
     if matchre("$roomobjs","driftwood log") then put put my %disarmit in log
     if matchre("$roomobjs","tree hollow") then put put my %disarmit in hollow
	put drop my %disarmit
	matchwait

loot:
open_Box:
	var LAST open_Box
     pause 0.001
	pause 0.2
		matchre loot ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre get_Gem_Pouch open
		matchre pick_ID It is locked
	put open my %disarmit
	matchwait
get_Gem_Pouch:
	var LAST get_Gem_Pouch
     if (toupper("%gempouchWorn") = "YES") then goto fill_Gem_Pouch
     if ("$righthand" != "Empty") then GOSUB STOW right
     pause 0.001
	pause 0.2
		matchre get_Gem_Pouch ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre fill_Gem_Pouch You get|^But that is
          matchre out_of_pouches ^What were you|^I could not find
	put get my %gempouch
	matchwait
fill_Gem_Pouch:
	var LAST fill_Gem_Pouch
     pause 0.001
	pause 0.2
		matchre tied_Pouch The gem pouch is too valuable|You'll need to tie it up
		matchre fill_Gem_Pouch ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre stow_Pouch ^You take|^There aren't any|You fill your|You open your|You have to be holding
		matchre full_Pouch anything else|pouch is too full
	put fill my %gempouch with my %disarmit
	matchwait

tied_Pouch:
	var LAST tied_Pouch
		matchre non_gems You'll need to make sure there are only gems in there
		matchre fill_Gem_Pouch You tie up|has already been tied off
	put tie %gempouch
	matchwait 10
	goto fill_Gem_Pouch
full_Pouch:
	var LAST full_Pouch
     echo *** FILLED UP A GEM POUCH. STASHING IN %gempouch.container
	pause 0.5
     gosub PUT open my %gempouch.container
     if (toupper("%gempouchWorn") = "YES") then
          {
          put rem my %gempouch
          pause 0.8
          }
open_thePouch:
     pause 0.1
     pause 0.1
stow_GemPouch:
     matchre open_thePouch ^But that's closed\.
     matchre close_Pouch ^You put|^You fill|^You open
     matchre sell_these_gems ^That's too heavy|too wide|too long
     send put my pouch in my %gempouch.container
     matchwait 10
     goto sell_these_gems
close_Pouch:
     pause 0.1
     put close my %gempouch.container
     pause 0.3
get_Pouch:
     pause 0.2
     gosub PUT get my gem pouch
     pause 0.5
     if (toupper("%tie.pouch") = "YES") then gosub PUT tie my pouch
     pause 0.2
     if (toupper("%gempouchWorn") = "YES") then put wear my %gempouch
     pause 0.3
     goto fill_Gem_Pouch
sell_these_gems:
     put #echo >Log Lime *** Warning! Gem pouch container full!!!! Sell your gems!!
     put #var sellGems 1
     return
     
non_gems:
	gosub STOW left
     pause 0.1
nonGem_Check:
          matchre bad_Item (potency crystal|infuser stone|runestone|\bstone\b|nugget|ingot)
		matchre nonGem_Done In the|nothing|What
	put look in my %gempouch
	matchwait
     
bad_Item:
     var item $1
     pause 0.001
     pause 0.001
     gosub PUT get %item in my %gempouch
     gosub STOW %item
     pause 0.1
     pause 0.1
	goto nonGem_Check
nonGem_Done:
     pause 0.1
     gosub PUT get my %disarmit
     pause 0.5
     goto tied_Pouch

stow_Pouch:
	var LAST stow_Pouch
		matchre stow_Pouch ^\.\.\.wait|^Sorry, you may only type
		matchre stow_Pouch2 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide
		matchre get_Coin You|Stow|^But that is
	put stow my %gempouch
	matchwait
stow_Pouch2:
	var LAST stow_Pouch2
		matchre stow_Pouch3 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide
		matchre stow_Pouch2 ^\.\.\.wait|^Sorry, you may only type
		matchre get_Coin You|Stow|^But that is
	put stow my %gempouch in my %container2
	matchwait
stow_Pouch3:
	var LAST stow_Pouch3
		matchre stow_Pouch3 ^\.\.\.wait|^Sorry, you may only type
		matchre get_Coin You|Stow|^But that is
	put stow my %gempouch in my %container3
	matchwait

get_Coin:
     var lootcheck 0
	var LAST get_Coin
		matchre get_Coin ^\.\.\.wait|^Sorry, you may only type
		matchre get_Coin You pick up
		matchre map_Check What were you
	put get coin from my %disarmit
	matchwait

map_Check:
     math lootcheck add 1
     if (%lootcheck > 3) then return
	var LAST map_Check
     pause 0.1
		matchre stow_Gear (gear|\bbolt\b|\bnut\b|glarmencoupler|spangleflange|rackensprocket|flarmencrank)
		matchre get_Map (map|treasure map|Treasure map)
          matchre soap soap
          matchre get_it (\broll\b|\bscroll\b|nugget|ingot|\bbar\b|jadeite|kyanite|bark|parchment|\bdira\b|papyrus|tablet|vellum|ostracon|leaf|\brune\b)
		matchre return In the|nothing|What
	put look in my %disarmit
	matchwait

soap:
     pause 0.1
     pause 0.1
     gosub PUT get soap from my %disarmit
     pause 0.2
     put drop soap
     pause 0.2
     goto map_Check
     
stow_Gear:
     var item $1
     pause 0.001
     pause 0.001
	gosub PUT get %item from my %disarmit
     pause 0.2
	gosub STOW %item
	pause 0.1
	goto map_Check

get_Map:
     pause 0.001
     pause 0.001
	gosub PUT get map from my %disarmit
     pause 0.1
	gosub STOW map
	pause 0.2
	put #echo >Log Lime ***** FOUND TREASURE MAP IN BOX *****
	pause 0.1
     goto map_Check

get_it:
     var item $1
     pause 0.001
     pause 0.001
     gosub PUT get %item in my %disarmit
     gosub STOW %item
     pause 0.2
     goto map_Check

dismantle:
	var LAST dismantle
     pause 0.1
	if matchre("$roomobjs","bucket of viscous gloop") then put put my %disarmit in bucket
     if matchre("$roomobjs","(waste bin|firewood bin)") then put put my %disarmit in bin
     if matchre("$roomobjs","driftwood log") then put put my %disarmit in log
     if matchre("$roomobjs","tree hollow") then put put my %disarmit in hollow
     pause 0.5
     pause 0.4
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
    if (toupper("%PET.BOXES") = "YES") then GoSub RETREAT 
		matchre dismantle ^\.\.\.wait|^Sorry, you may only type
        matchre dismantle next 15 seconds|something inside it
        matchre drop_box You can not dismantle
		matchre open_Box You must first open
		matchre disarm_sub You must first disarm
		matchre return Roundtime|Unable to locate|^Dismantle what\?
        matchre return ^You must be holding
	put disman my %disarmit %dismantle
	matchwait

drop_box:
     pause 0.1
     gosub PUT drop my %disarmit
     pause 0.2
     return

stowDisarmed:
     pause 0.1
     echo *** STOWING DISARMED BOX AWAY
     put put my %disarmit in %disarmBag
     pause 0.5
     goto MAIN

empty_Hand:
     pause 0.1
	if ("$righthand" != "Empty") then GOSUB STOW right
	if ("$lefthand" != "Empty") then GOSUB STOW left
fix_Lock:
	if (toupper("%lockpick.ring") != "YES") then gosub get_Pick
	if (toupper("%lockpick.ring") = "YES") then gosub fix_Ring
	if (toupper("%lockpick.ring") = "YES") then goto go_On
	fixing:
	var LAST fixing
		pause 0.5
		matchre fix_Ring You'll have to hold it|^You can't fix that
		matchre fixing ^\.\.\.wait|^Sorry, you may only type
		matchre go_On Roundtime|look like it|^You can't figure out
	put fix my lock
	matchwait
	go_On:
	if (toupper("%lockpick.ring") != "YES") then gosub put_Away_Pick
	return

fix_Ring:
	fixing_Ring:
	var LAST fixing_Ring
		pause 0.1
          pause 0.1
		matchre get_Healed ^You're in no condition to be repairing
		matchre empty_Hand You must use both hands
		matchre fixing_Ring ^\.\.\.wait|^Sorry, you may only type
		matchre return Roundtime|look like it|^You can't figure out how to fix that
	put repair my lockpick %lockpick.ring.type
	matchwait 20
	goto empty_Ring

get_Healed:
     echo
     echo *** You are too hurt to repair anything! Get healed!
     echo
     return

empty_Ring:
     var lockpick.ring NO
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
	put exp
	waitfor Overall state of mind
	if ("$righthand" != "Empty") then send stow right
    ##################
	#BOX COUNTER HERE!
	var LOCAL $Boxes
	math LOCAL add 1
	math BOXES add 1
	put #var Boxes %LOCAL
	echo
	echo **** Boxes popped: %BOXES
	echo
     #END BOX COUNTER
	##################
	if !matchre(toupper("%keep.picking"), "YES") || (toupper("%PET.BOXES") != "YES") then
          {
               if ($Locksmithing.LearningRate > 33) then goto LOCKED_SKILLS
          }
	return

lockpick_ring_check:
     pause 0.1
     pause 0.001
     matchre type_ring ^You tap (.+) you are wearing
     matchre lockpick_ring_type2 ^I could not|^What|^You tap
     send tap my lockpick ring
     matchwait 3
     goto lockpick_ring_type2
type_ring:
     var lockpick.ring.type ring
     goto fill_lockpick_ring
lockpick_ring_type2:
     pause 0.1
     pause 0.001
     matchre type_case ^You tap (.+) you are wearing
     matchre no_ring ^I could not|^What
     send tap my lockpick case
     matchwait 8
no_ring:
     var lockpick.ring NO
     return
type_case:
     var lockpick.ring.type case
     goto fill_lockpick_ring

fill_lockpick_ring:
     pause 0.1
     matchre new_lock looks to be holding 9 lockpicks|looks to be holding 8 lockpicks|looks to be holding 7 lockpicks|looks to be holding 6 lockpicks|looks to be holding 5 lockpicks
     matchre new_lock looks to be holding 4 lockpicks|looks to be holding 3 lockpicks|looks to be holding 2 lockpicks|looks to be holding 1 lockpicks
     matchre RETURN appears to be full|It looks|looks to be holding
     matchre No_Picks empty
     put glance my lockpick %lockpick.ring.type
     matchwait
new_lock:
     pause 0.1
     pause 0.1
     matchre make_more_locks ^What were you|^I could not find
     matchre put_lock ^You get|already holding|^You need a free
     put get my lockpick
     matchwait
put_lock:
     pause 0.1
     matchre fill_lockpick_ring ^You put
     matchre stow_lock ^You don't think you should put different kinds|already has as many lockpicks|^What
     put put my lock in my lock %lockpick.ring.type
     matchwait
stow_lock:
     put stow lock
     pause 0.1
     return
make_more_locks:
     put #echo >Log Orange ******** Running low on lockpicks! Make more! *************
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
     goto LOCKED_SKILLS
out_of_pouches:
     put #echo >Log Red *** RAN OUT OF GEM POUCHES! RESTOCK!!!
     goto LOCKED_SKILLS
     
LOCKED_SKILLS:
     echo
     echo *** FINISHED PICKING BOXES!
     echo
     put #echo >Log Aqua *** Finished Boxes - Locksmithing: $Locksmithing.Ranks $Locksmithing.LearningRate / 34 ***
     put #echo >Log Aqua *** %BOXES boxes this session - $Boxes boxes over all time
DONE:
     pause 0.1
     #send dump junk
     pause 0.5
     gosub STOWING
     pause 0.1
     if (toupper("%wear.armor") = "YES") then gosub WEAR_ARMOR
     gosub PUT get my %knuckles
     gosub PUT wear my %knuckles
     pause 0.1
     gosub STOWING
     echo *** DONE PICKING BOXES!
     put #parse DONE PICKING BOXES
     put #parse DONE BOXES!
     put #parse BOXES DONE!
     put #parse DONE PICKING BOXES!
     exit
SAVE:
     pause 0.2
     pause 0.1
     goto %SAVE
####################################################################
#  BLOWN TRAPS HANDLING SECTION
# THIS SECTION TELLS THE SCRIPT WHAT TO DO WHEN YOU BLOW A TRAP
####################################################################
BLOWN_TRAP_PAUSE:
     pause 5
BLOWN_TRAP:
     pause 0.5
     put #echo >Log Red ** Blew a %trap_type trap!
     if ($stunned) then waiteval (!$stunned)
     echo ***
     echo *** Assessing the situation...
     echo ***
     echo
     pause 0.2
     if %trap_type = "fire_ant" then goto FIREANT_TRAP
     if %trap_type = "acid" then goto ACID_TRAP
     if %trap_type = "cyanide" then goto DART_TRAP
     if %trap_type = "bolt" then goto BOLT_TRAP
     if %trap_type = "poison_bolt" then goto BOLT_TRAP
     if %trap_type = "flea" then goto FLEA_TRAP
     if %trap_type = "bouncer" then goto BOUNCER_TRAP
     if %trap_type = "curse" then goto CURSE_TRAP
     if %trap_type = "frog" then goto FROG_TRAP
     if %trap_type = "laughing" then goto LAUGHING_TRAP
     if %trap_type = "mana_sucker" then goto MANA_TRAP
     if %trap_type = "mime" then goto MIME_TRAP
     if %trap_type = "shadowling" then goto SHADOWLING_TRAP
     if %trap_type = "sleeper" then goto SLEEPER_TRAP
     if %trap_type = "reaper" then goto REAPER_TRAP
     if %trap_type = "poison_nerve" then goto POISON_PAUSE
     if %trap_type = "poison_local" then goto POISON_PAUSE
     if %trap_type = "concussion" then goto HEALTH
     if %trap_type = "disease" then goto HEALTH
     if %trap_type = "gas" then goto HEALTH
     if %trap_type = "lightning" then goto HEALTH
     if %trap_type = "naphtha_soaker" then goto HEALTH
     if %trap_type = "scythe" then goto HEALTH
     if %trap_type = "shocker" then goto HEALTH
     if %trap_type = "boomer" then goto HEALTH
     if %trap_type = "shrapnel" then goto HEAL_DELAY
     if %trap_type = "naphtha" then goto HEAL_DELAY
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
     matchre DONE_CURSE ^The eerie black radiance fades
     if !("$roomplayers" = "") then put 'help! I be cursed.. any clerics about?
     matchwait 100
     goto CURSE_TRAP
DONE_CURSE:
     action remove ^The eerie black radiance fades
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
     pause
     echo *** WAKING UP AUTOMATICALLY
     echo *** ~DO NOT~ INPUT ANY COMMANDS OR TOUCH THE KEYBOARD FOR 30 SECONDS!!!!
     echo
     pause 2
SLEEP_WAKE:
     put wake
     pause 32
     gosub stand
     pause 0.5
     if $standing = 1 then goto main
     if $standing = 0 then
          {
               echo *** I TOLD YOU NOT TO TYPE ANYTHING DUMBASS!!!
               echo *** RESTARTING... DO NOT FUCKING TYPE!!!!
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
     if $standing = 0 then gosub stand
	pause
     goto TOP

SHADOWLING_TRAP:
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
     if $zoneid = 1 then GOSUB automove NTR
     pause 0.3
     if $zoneid = 1 then GOSUB automove NTR
     pause 0.3
     if $zoneid = 7 then GOSUB automove 551
     pause 0.2
     if $zoneid = 7 then GOSUB automove 551
     if $zoneid = 7 then GOSUB automove 551
     if $zoneid = 67 then GOSUB automove north
     if $zoneid = 66 then GOSUB automove 153
     if $zoneid = 30 then GOSUB automove 176
     if $zoneid = 42 then GOSUB automove 102
     if $zoneid = 61 then GOSUB automove pool
     if $zoneid = 40 then GOSUB automove 49
     if $zoneid = 90 then GOSUB automove 342
     if $zoneid = 99 then GOSUB automove 270
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
     if $zoneid = 7 then GOSUB automove Crossing
     if $zoneid = 66 then GOSUB automove shard
     gosub automove %STARTING.ROOM
	gosub stowing
     pause
     goto TOP

FIREANT_TRAP:
     var FIREANT ON
     pause
     pause 0.5
     if $stunned = 1 then goto FIREANT_TRAP
     goto WATER_RUN
FIREANT_CONTINUE:
     var FIREANT OFF
     pause 12
     put splash
     pause 7
     ######### RETURN TO YOUR STARTING LOCATION
     pause 0.5
     if $zoneid = 7 then GOSUB automove Crossing
     if $zoneid = 66 then GOSUB automove shard
     gosub stowing
     goto HEALTH

TELEPORT_OK:
     pause 5
     if $stunned = 1 then goto TELEPORT_OK
     put #echo >Log Lime ** Blew a teleport trap and lived!!!! You lucky bitch!
     echo
     echo *** BLEW A TELEPORT TRAP AND LIVED!!!!
     echo *** YOU ARE NOW SOMEWHERE IN ELANTHIA! FIND YOUR WAY HOME!
     echo *** ENDING DISARM SCRIPT... AND HOPEFULLY RECOVERING.....
     echo
     put #parse YOU HAVE BEEN IDLE
     exit

TELEPORT_DEATH:
     put #echo >Log Red ** Blew a bad teleport trap and DIED! FAIL!
     echo
     echo *** BLEW A TELEPORT TRAP AND DIED!! UBER FAIL!!
     echo *** YOU ARE DEAD! BETTER LUCK NEXT TIME!
     echo *** RAISE THE DIFFICULTY ON THE BASELINE VARIABLE IF THIS HAPPENS TO YOU TOO MUCH!!
     echo
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
     if %health > 50 then goto HEALTH
     pause 20
ACID_CHECK:
     matchre ACID_TRAP being burned|acid
     matchre HEALTH You have no|You have some|Your spirit|Your body
     put health
     matchwait 10
     goto HEAL_DELAY

REAPER_TRAP:
     gosub stowing
     pause 0.5
     echo *******************************************************
     echo * YOU BLEW A REAPER TRAP! GONNA BRAWL THOSE FOOLS!
     echo * HOPE YOUR COMBATS ARE UP TO SNUFF!
     echo * MIGHT WANT TO RUN AWAY IF YOU ARE A NOOB..
     echo *******************************************************
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
     if $monstercount > 0 then goto REAPER_TRAP
     goto HEALTH

POISON_PAUSE:
     echo
     echo *** PAUSING FOR A MINUTE TO LET THE POISON RUN ITS COURSE...
     echo
     if $health < 75 then goto HEALTH
     pause 20
     if $health < 75 then goto HEALTH
     pause 10
     if $health < 75 then goto HEALTH
     pause 10
POISONED:
     if $health < 75 then goto HEALTH
     if ("$guild" != "Thief") then goto HEALTH
     if ("$guild" = "Thief") && ($Circle > 60) && ($health > 98) then goto THIEF_POISON
     goto HEALTH
THIEF_POISON:
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
####################################################
# END TRAP HANDLING SECTION
####################################################

###########################
# HEALING SECTION
###########################
HEAL_DELAY:
     ECHO ** PAUSING BEFORE GETTING HEALED!!
     pause 20
HEAL_PAUSE:
     pause 10
HEALTH:
     pause 0.5
     gosub HEALTH_CHECK
     if ($needHealing) && toupper("%autoheal") = "NO") then
          {
               echo ** AUTOHEAL: OFF
               echo ** Aborting Script! Go Get healed!!
               put #parse GET HEALED!
               put #parse DISARM DONE!
               put #parse DONE DISARM!
               exit
          }
     if ($health < 70) then goto FIND
     if ($needHealing) then goto FIND
     else goto DONE_HEAL
FIND:
     var loops 0
     var attempts 0
     put #echo >Log Yellow **** Blew a box! Running to get healed!
     echo
     echo *** YOU HAVE BEEN HURT BY A BOX!
     echo *** FINDING HEALER!
     echo
     if ("game" = "DRF") && ("$zoneid" = "150") then goto TO_ARCH_HEALER
     if ("$charactername" != "Azothy") then goto TO_AUTOEMPATH
     if !matchre("$zoneid","(66|67|69)") then goto TO_AUTOEMPATH
     goto TO_AUTOEMPATH
    
TO_ARCH_HEALER:
     pause 0.1
     if ("$roomid" != "85") then gosub AUTOMOVE 85
     pause 0.3
	if matchre("$roomplayers","(Gwyddion|Marino|Sawbones|Bedlam|Skrillex|Odium|Spinebreaker)") then
		{
			send demeanor neutral
			waitforre ^You decide to take things as they come\.
			if contains("$roomplayers","Gwyddion") then var Empath Gwyddion
			if contains("$roomplayers", "Marino") then var Empath Marino
			if contains("$roomplayers", "Sawbones") then var Empath Sawbones
			if contains("$roomplayers", "Skrillex") then var Empath Skrillex
			if contains("$roomplayers", "Bedlam") then var Empath Bedlam
			if contains("$roomplayers", "Odium") then var Empath Odium
			if contains("$roomplayers", "Spinebreaker") then var Empath Spinebreaker
			gosub LEAN
               goto DONE_HEAL
		}
	else
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
	matchre HEAL_DONE ^%Empath nods to you\.|Your wounds are healed|%Empath coughs
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
     if $stunned = 1 then goto HEALTH_PAUSE
     if $standing = 0 then gosub stand
ENSURE_IN_CITY:
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
     if !($needHealing) then goto DONE_AUTOEMPATH
     if matchre ("$roomplayers", "Kinoko who is lying down") then goto LIE_DOWN
     if matchre ("$roomplayers", "Aksel who is lying down") then goto LIE_DOWN
     if !matchre ("$roomplayers", "who is lying down") then goto AUTO_HEALER
     if (($health < 70) && ($bleeding = 1)) then goto HEALTH_ANYWAY
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto AUTO_HEALER
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto AUTO_HEALER
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto AUTO_HEALER
     if ($health < 50) then goto HEALTH_ANYWAY
     pause 2
     if !matchre ("$roomplayers", "who is lying down") then goto AUTO_HEALER
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
     if $sitting = 1 then goto AUTOPATH_LEAVE
     pause 30
     if $sitting = 1 then goto AUTOPATH_LEAVE
     pause 30
     if $sitting = 1 then goto AUTOPATH_LEAVE
     pause 30
     put exp
     goto AUTOPATH_WAIT
     
DONE_AUTOEMPATH:
     if $zoneid = 69 then gosub automove shard
     if $zoneid = 68 then gosub automove shard
     if $zoneid = 66 then gosub automove shard
DONE_HEAL:
AUTOPATH_LEAVE:
     action remove crosses $charactername's name from the list|^Shalvard says, "Please get up|Shalvard looks around and says, "Kindly leave|Yolesi suddenly yells|^Kaiva crosses your name off|you look fine and healthy to me|^You sit up|^Arthianne nudges you|I think you don't really need healing|you are well|Quentin whispers, "Just between you and me and the Queen|^Atladene says to you, "You don't need healing
     if $standing = 0 then gosub STAND
     pause 0.5
     gosub automove %STARTING.ROOM
     pause 0.5
     put #echo >Log Pink ** Got healed! Continuing Disarm Script..
     gosub stowing
     goto TOP
######################
# GOSUBS
######################
PUT:
     delay 0.0001
     var command $0
     var LOCATION PUT_1
     PUT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre PUT_STOW ^You need a free hand
     matchre PUT_STAND ^You should stand up first\.|^Maybe you should stand up\.
     matchre WAIT ^\[Enter your command again if you want to\.\]
     matchre RETURN_CLEAR ^.*Roundtime\s*\:?
     matchre RETURN_CLEAR ^.*\[Roundtime\s*\:?
     matchre RETURN_CLEAR ^.*\(Roundtime\s*\:?
     matchre RETURN_CLEAR ^.*\[Praying for \d+ sec\.\]
     matchre RETURN_CLEAR ^You cannot do that while engaged\!
     matchre RETURN_CLEAR ^I could not find what you were referring to\.
     matchre RETURN_CLEAR ^Please rephrase that command\.
     matchre RETURN_CLEAR ^Perhaps you should
     matchre RETURN_CLEAR ^That (?:is|has) already
     matchre RETURN_CLEAR ^But (?:that|you)
     matchre RETURN_CLEAR ^What were you referring to\?
     matchre RETURN_CLEAR ^In the name of love\?
     matchre RETURN_CLEAR ^That (?:cannot|can't|won't)
     matchre RETURN_CLEAR ^.* what\?
     matchre RETURN_CLEAR ^I don\'t
     matchre RETURN_CLEAR ^(\S+) has accepted
     matchre RETURN_CLEAR ^You (?:hand|hang|push|move|put|whisper|lean|tap|tilt|cannot|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|slip|weave|shove|try|must|wave|sit|fail|turn|are already|can\'t|glance|bend|kneel|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|open|fumble|exhale|allow|have|are|wring|aren\'t|scan|vigorously|adjust|bundle|ask|form|get|lose|remove|pull|accept|slide|wear|sling|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel|read|reach|gingerly|come|count) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^The (?: clerk|teller|attendant|mortar|pestle|tongs|bowl|gem|book|page|lockpick|sconce|voice|waters) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^You sense that you are as pure of spirit as you can be\, and you are ready for whatever rituals might face you\.
     matchre RETURN_CLEAR ^Subservient type|^The shadows|^Close examination|^Try though
     matchre RETURN_CLEAR ^USAGE\:
     matchre RETURN_CLEAR ^Smoking commands are
     matchre RETURN_CLEAR ^Allows a Moon Mage
     matchre RETURN_CLEAR ^A slit across the door
     matchre RETURN_CLEAR ^Your (?:actions|dance|nerves) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^You.*analyze
     matchre RETURN_CLEAR ^Having no further use for .*\, you discard it\.
     matchre RETURN_CLEAR ^You don't have a .* coin on you\!\s*The .* spider looks at you in forlorn disappointment\.
     matchre RETURN_CLEAR ^The .* spider turns away\, looking like it's not hungry for what you're offering\.
     matchre RETURN_CLEAR ^Brother Durantine|^Durantine|^Mags|^Ylono|^Malik|^Kilam|^Ragge|^(?:An|The) attendant|^The clerk|^.*He says\,
     matchre RETURN_CLEAR ^After a moment\, .*\.
     matchre RETURN_CLEAR ^.* (?:is|are) not in need of cleaning\.
     matchre RETURN_CLEAR ^Quietly touching your lips with the tips of your fingers as you kneel\, you make the Cleric's sign with your hand\.
     matchre RETURN_CLEAR ^The .* is not damaged enough to warrant repair\.
     matchre RETURN_CLEAR ^There is no more room in .*\.
     matchre RETURN_CLEAR \[Type INVENTORY HELP for more options\]
     matchre RETURN_CLEAR ^There is nothing in there\.
     matchre RETURN_CLEAR ^A vortex
     matchre RETURN_CLEAR ^In a flash
     matchre RETURN_CLEAR ^An aftershock
     matchre RETURN_CLEAR ^In the .* you see .*\.
     matchre RETURN_CLEAR .* (?:Dokoras|Kronars|Lirums)
     matchre RETURN_CLEAR ^That is closed\.
     matchre RETURN_CLEAR ^This spell cannot be targeted\.
     matchre RETURN_CLEAR ^You cannot figure out how to do that\.
     matchre RETURN_CLEAR ^You will now store .* in your .*\.
     matchre RETURN_CLEAR ^That tool does not seem suitable for that task\.
     matchre RETURN_CLEAR ^There isn't any more room in .* for that\.
     matchre RETURN_CLEAR ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
     matchre RETURN_CLEAR ^\s*LINK ALL CANCEL\s*\- Breaks all links
     matchre RETURN_CLEAR ^This ritual may only be performed on a corpse\.
     matchre RETURN_CLEAR ^There is nothing else to face\!
     matchre RETURN_CLEAR ^Stalking is an inherently stealthy endeavor\, try being out of sight\.
     matchre RETURN_CLEAR ^You're already stalking
     matchre RETURN_CLEAR ^There aren't any .*\.
     matchre RETURN_CLEAR ^You don't think you have enough focus to do that\.
     matchre RETURN_CLEAR ^You have no idea how to cast that spell\.
     matchre RETURN_CLEAR ^An offer
     matchre RETURN_CLEAR ^Tie it off when it's empty\?
     matchre RETURN_CLEAR ^Obvious (?:exits|paths)
     matchre RETURN_CLEAR ^But the merchant can't see you|are invisible
     matchre RETURN_CLEAR Page|^As the world|^Obvious|^A ravenous energy
     matchre RETURN_CLEAR ^In the|^The attendant|^That is already open\.|^Your inner
     matchre RETURN_CLEAR ^(\S+) hands you|^Searching methodically|^But you haven\'t prepared a symbiosis\!
     matchre RETURN_CLEAR ^Illustrations of complex\,|^It is labeled|^Your nerves
     matchre RETURN_CLEAR ^The lockpick|^Doing that|is not required to continue crafting
     send %command
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT! (%scriptname.cmd) ***
     put #echo >$Log Crimson $datetime Command = %command
     put #log $datetime MISSING MATCH IN PUT! Command = %command (%scriptname.cmd)
     RETURN
PUT_STOW:
     gosub EMPTY_HANDS
     goto PUT_1
     
WEAR_ARMOR:
     if %total_armor = 0 then RETURN
     ECHO **** PUTTING YOUR ARMOR BACK ON! ****
     pause 0.5
     if "%armor1" != "null" then
          {
               ECHO *** ARMOR: %armor1 ***
               PUT get my %armor1
               pause 0.5
               PUT wear my %armor1
               pause 0.5
               pause 0.3
          }
     if "%armor2" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor2 ***
               PUT get my %armor2
               pause 0.5
               PUT wear my %armor2
               pause 0.5
               pause 0.3
          }
     if "%armor3" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor3 ***
               PUT get my %armor3
               pause 0.5
               PUT wear my %armor3
               pause 0.5
               pause 0.3
          }
     if "%armor4" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor4 ***
               PUT get my %armor4
               pause 0.5
               PUT wear my %armor4
               pause 0.5
               pause 0.3
          }
     if "%armor5" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor5 ***
               PUT get my %armor5
               pause 0.5
               PUT wear my %armor5
               pause 0.5
               pause 0.3
          }
     if "%armor6" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor6 ***
               PUT get my %armor6
               PUT wear my %armor6
               pause 0.5
               pause 0.3
          }
     if "%armor7" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor7 ***
               PUT get my %armor7
               pause 0.5
               PUT wear my %armor7
               pause 0.5
               pause 0.3
          }
     if "%armor8" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor8 ***
               PUT get my %armor8
               pause 0.5
               PUT wear my %armor8
               pause 0.5
               pause 0.3
          }
     if "%armor9" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor9 ***
               PUT get my %armor9
               pause 0.5
               PUT wear my %armor9
               pause 0.5
          }
     if "%armor10" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor10 ***
               PUT get my %armor10
               pause 0.5
               PUT wear my %armor10
               pause 0.5
          }
     return
#### HEALTH CHECKING
HEALTH_CHECK:
     delay 0.0001
     put #tvar needHealing 0
     delay 0.5
     matchre HEALTH_GOOD ^You have no significant injuries\.
     matchre HEALTH_BAD ^\s*Encumbrance\s+\:
     put -health;-2 encumbrance
     matchwait 15
     goto HEALTH_CHECK
HEALTH_BAD:
     delay 0.0001
     put #tvar needHealing 1
     delay 0.5
     return
HEALTH_GOOD:
     delay 0.0001
     put #queue clear
     put #tvar needHealing 0
     delay 0.5
     return
BLEEDCHECK:
BLEEDER_CHECK:
     delay 0.0001
     pause 0.1
     pause 0.01
     if ("$righthandnoun" = "arrow") then put drop arrow
     if ("$lefthandnoun" = "arrow") then put drop arrow
     if ("$righthandnoun" = "dart") then put drop dart
     if ("$lefthandnoun" = "dart") then put drop dart
     if ("$righthand" = "crossbow bolt") then put drop bolt
     if ("$lefthand" = "crossbow bolt") then put drop bolt
     pause 0.1
     pause 0.2
     pause 0.1
     action goto BLEEDCHECK when The bandages binding your (.+) soak through with blood becoming useless and you begin bleeding again\.
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
     action var BLEEDING_HEAD YES when lodged\s*.* into your head
     action var BLEEDING_HEAD YES when lodged\s*.* in your head
     action var BLEEDING_NECK YES when lodged\s*.* into your neck
     action var BLEEDING_NECK YES when lodged\s*.* in your neck
     action var BLEEDING_CHEST YES when lodged\s*.* into your chest
     action var BLEEDING_CHEST YES when lodged\s*.* in your chest
     action var BLEEDING_ABDOMEN YES when lodged\s*.* into your abdomen
     action var BLEEDING_ABDOMEN YES when lodged\s*.* in your abdomen
     action var BLEEDING_BACK YES when lodged\s*.* into your back
     action var BLEEDING_BACK YES when lodged\s*.* in your back
     action var BLEEDING_R_ARM YES when lodged\s*.* into your right arm
     action var BLEEDING_R_ARM YES when lodged\s*.* in your right arm
     action var BLEEDING_L_ARM YES when lodged\s*.* into your left arm
     action var BLEEDING_L_ARM YES when lodged\s*.* in your left arm
     action var BLEEDING_R_LEG YES when lodged\s*.* into your right leg
     action var BLEEDING_R_LEG YES when lodged\s*.* in your right leg
     action var BLEEDING_L_LEG YES when lodged\s*.* into your left leg
     action var BLEEDING_L_LEG YES when lodged\s*.* into your left leg
     action var BLEEDING_R_HAND YES when lodged\s*.* into your right hand
     action var BLEEDING_R_HAND YES when lodged\s*.* in your right hand
     action var BLEEDING_L_HAND YES when lodged\s*.* into your left hand
     action var BLEEDING_L_HAND YES when lodged\s*.* in your left hand
     action var BLEEDING_L_EYE YES when lodged\s*.* into your left eye
     action var BLEEDING_L_EYE YES when lodged\s*.* in your left eye
     action var BLEEDING_R_EYE YES when lodged\s*.* into your right eye
     action var BLEEDING_R_EYE YES when lodged\s*.* in your right eye
     action var POISON YES when ^You.+(poisoned)
     action var POISON YES when ^You.+(poisoned)
BLEEDYES:
     pause 0.1
     if "$righthandnoun" = "arrow" then send drop arrow
     if "$lefthandnoun" = "arrow" then send drop arrow
     if "$righthandnoun" = "bolt" then send drop bolt
     if "$lefthandnoun" = "bolt" then send drop bolt
     pause 0.0001
     echo [Checking for Bleeders]
     matchre yesbleeding Bleeding|arrow lodged|bolt lodged
     matchre END_OF_BLEEDER You pause a moment|^The THINK verb|THINK
     match bleedyes It's all a blur!
     put health;think
     matchwait 20
     echo [No bleeder found - exiting bleeder check]
     goto END_OF_BLEEDER
YESBLEEDING:
     echo **** HEALING BLEEDER ****
     pause 0.1
     if "%INFECTED" = "YES" then
     {
     echo *************************************
     echo **** WARNING ** YOU ARE INFECTED ****
     echo *************************************
     }
     if "%BLEEDING_HEAD" = "YES" then gosub tend head
     if "%BLEEDING_NECK" = "YES" then gosub tend neck
     if "%BLEEDING_CHEST" = "YES" then gosub tend chest
     if "%BLEEDING_ABDOMEN" = "YES" then gosub tend abdomen
     if "%BLEEDING_BACK" = "YES" then gosub tend back
     if "%BLEEDING_R_ARM" = "YES" then gosub tend right arm
     if "%BLEEDING_L_ARM" = "YES" then gosub tend left arm
     if "%BLEEDING_R_LEG" = "YES" then gosub tend right leg
     if "%BLEEDING_L_LEG" = "YES" then gosub tend left leg
     if "%BLEEDING_R_HAND" = "YES" then gosub tend right hand
     if "%BLEEDING_L_HAND" = "YES" then gosub tend left hand
     if "%BLEEDING_L_EYE" = "YES" then gosub tend left eye
     if "%BLEEDING_R_EYE" = "YES" then gosub tend right eye
     if "%BLEEDING_SKIN" = "YES" then gosub tend skin
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
     goto END_OF_BLEEDER
TEND:
     var bleeder $0
     echo ***************************
     echo [Tending Bleeder: %bleeder]
     echo ***************************
     if $prone then gosub stand
tend_bleeder:
     send tend my %bleeder
     pause 0.2
     pause 0.2
     pause 0.2
          if contains("$roomobjs","driftwood log") && ("$righthand" = "crossbow bolt") || ("$lefthand" = "crossbow bolt") then
          {
          put put my bolt in log
          pause 0.1
          }
     pause 0.2
     if "$righthandnoun" = "arrow" then put drop arrow
     if "$lefthandnoun" = "arrow" then put drop arrow
     if "$righthand" = "crossbow bolt" then put drop bolt
     if "$lefthand" = "crossbow bolt" then put drop bolt
tend_bleeder2:
     pause 0.1
     send tend my %bleeder
     pause 0.1
          if contains("$roomobjs","driftwood log") && ("$righthand" = "crossbow bolt") || ("$lefthand" = "crossbow bolt") then
          {
          put put my bolt in log
          pause 0.1
          }
     pause 0.2
     if "$righthandnoun" = "arrow" then put drop arrow
     if "$lefthandnoun" = "arrow" then put drop arrow
     if "$righthand" = "crossbow bolt" then put drop bolt
     if "$lefthand" = "crossbow bolt" then put drop bolt
     pause 0.1
     pause 0.1
     echo [Leaving Bleeder System]
     return
END_OF_BLEEDER:
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
     action remove The bandages binding your (.+) soak through with blood becoming useless and you begin bleeding again\.
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
     if $zoneid = 66 then gosub automove east
     if $zoneid = 67 then gosub automove west
     if $zoneid = 69 then gosub automove 383
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
    matchre 1find ^\.\.\.wait|^Sorry, you may only type|^You.*are.*still.*stunned\.
    matchre 1found ^You see
    put look maci
    matchwait 5
    return
1found:
    pause .0001
    pause .0001
    var Empath maci
    send join maci
    matchre macifind ^\.\.\.wait|^Sorry, you may only type|^You.*are.*still.*stunned\.
    matchre DONE_AUTOEMPATH ^The feeling of unity with|^Maci nods to you\.|^A fiery\-cold
    put lean maci
    matchwait 30
    math attempts add 1
    if %attempts > 7 then goto TO_AUTOEMPATH
    if contains("$roomplayers" , "Maci") then goto macifound
    return
    
AUTOMOVE:
     delay 0.0001
     var Destination $0
     var automovefailCounter 0
     if (!$standing) then gosub AUTOMOVE_STAND
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     delay 0.0001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     put #goto %Destination
     matchwait
AUTOMOVE_STAND:
     pause 0.1
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry\,
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing\.
     send stand
     matchwait
AUTOMOVE_FAILED:
     evalmath automovefailCounter (automovefailCounter + 1)
     if (%automovefailCounter > 5) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.5
     pause 0.1
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     put #echo
     put #echo >$Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >$Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
     exit
AUTOMOVE_RETURN:
     return

STAND:
     delay 0.0001
     var LOCATION STAND_1
     STAND_1:
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
     if (!$standing) then goto STAND
     return

stowAmmo:
     pause 0.1
     if matchre("$righthand","(partisan|shield|light crossbow|buckler|lumpy bundle|halberd|mistwood longbow|gloomwood khuj|halberd)") && ("$lefthand" != "Empty") then gosub wear my $1
     if matchre("$lefthand","(partisan|shield|light crossbow|buckler|lumpy bundle|halberd|mistwood longbow|gloomwood khuj|halberd)") && ("$righthand" != "Empty") then gosub wear my $1
     if matchre("$roomobjs","(basilisk head arrow\b|cane arrow\b|bone-tipped arrow\b|barbed arrow\b|stone-tipped arrow\b|serrated-bodkin arrow\b|razor-edged arrow|razor-tipped arrow\b)") then gosub stow $1
     if contains("$roomobjs","(double-stringed crossbow|repeating crossbow|bloodwood dako'gi crossbow|forester's crossbow|bamboo crossbow|forester's bow|battle bow|assassin's crossbow") then gosub stow $1
     if contains("$roomobjs","(ironwood shield|wooden shield)") then gosub stow $1
     if matchre("$roomobjs","(elongated stones|granite stone)") then gosub stow stone
     if matchre("$roomobjs","(river rock|river rocks|small rock)") then gosub stow rock
     if matchre("$roomobjs","(leafhead bolt|barbed bolt|crossbow bolt)") then gosub stow bolt
     if contains("$roomobjs","throwing blade") then gosub stowblade
     if contains("$roomobjs","sleek quadrello") then gosub stow quadrello
     if contains("$roomobjs","stones") then gosub stow stones
     if contains("$roomobjs","hand claws") then gosub stow hand claw
     if contains("$roomobjs","T'Kashi mirror flamberge") then gosub stow mirror flamberge
     if contains("$roomobjs","T'Kashi mirror flail") then gosub stow mirror flail
     if contains("$roomobjs","mirror blade") then gosub stow mirror blade
     if contains("$roomobjs","mirror knife") then gosub stow mirror knife
     if contains("$roomobjs","Nisha short bow") then gosub stow nisha bow
     if contains("$roomobjs","razor-sharp damascus steel sabre") then gosub stow sabre
     if contains("$roomobjs","glaes and kertig-alloy katana capped with an ornate dragonfire amber pommel") then gosub stow katana
     if !matchre("$roomobjs","(mirror axe|stonebow|briquet|battle bow|akabo|throwing spike|steel scimitar|thrusting blade|flail|kneecapper|spear|hammer|throwing hammer|bone club|javelin|tago|staff sling|bludgeon|quarrel|short bow|telo|flamberge|flail|nightstick|khuj|iltesh|ngalio|hirdu bow|halberd|mirror blade|katana|morning star|war club|shadowy-black sling|staff sling|mattock|leathers|balaclava|helmet|helm|gauntlets|mail gloves|sniper's crossbow|light crossbow|targe\b|great helm|throwing axe|throwing club|bastard sword|jambiya|katar|throwing blade|composite bow|bola|short bow)") then return
     gosub stow $1
     goto stowAmmo

STOWING:
     pause 0.1
     var location STOWING
     if "$righthand" = "vine" then put drop vine
     if "$lefthand" = "vine" then put drop vine
     if "$righthandnoun" = "rope" then put coil my rope
     if "$righthand" = "bundle" || "$lefthand" = "bundle" then put wear bund;drop bun
     #if matchre("$righthandnoun","(crossbow|bow|short bow)") then gosub unload
     if matchre("$righthandnoun","(block|granite block)") then put drop block
     if matchre("$lefthandnoun","(block|granite block)") then put drop block
     if matchre("$righthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj)") then gosub wear my $1
     if matchre("$lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj)") then gosub wear my $1
     if matchre("$lefthand","(longbow|khuj)") then gosub stow my $1 in my %SHEATH
     if "$righthand" != "Empty" then GOSUB STOW right
     if "$lefthand" != "Empty" then GOSUB STOW left
     return

STOW:
     var LOCATION STOW_1
     var todo $0
STOW_1:
     delay 0.0001
     if "$righthand" = "vine" then put drop vine
     if "$lefthand" = "vine" then put drop vine
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre STOW_2 not designed to carry anything|any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|^But that's closed|I can't find your container|^You can't 
     matchre RETURN ^Wear what\?|^Stow what\?  Type 'STOW HELP' for details\.
     matchre RETURN ^You put
     matchre RETURN ^You open
     matchre RETURN needs to be
     matchre RETURN ^You stop as you realize
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^That can't be picked up
     matchre LOCATION_unload ^You should unload the
     matchre LOCATION_unload ^You need to unload the
     put stow %todo
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW
     return
STOW_2:
     delay 0.0001
     var LOCATION STOW_2
     matchre OPEN_THING ^But that's closed
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN ^You put
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre STOW_3 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|not designed to carry anything|^But that's closed
     matchre LOCATION_unload ^You should unload the
     matchre LOCATION_unload ^You need to unload the
     put stow %todo in my %container1
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW2! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW2
     return
STOW_3:
     delay 0.0001
     var LOCATION STOW_3
     if "$lefthandnoun" = "bundle" then put drop bun
     if "$righthandnoun" = "bundle" then put drop bun
     matchre OPEN_THING ^But that's closed
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN ^You put
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre STOW_4 any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide|not designed to carry anything|^But that's closed
     matchre LOCATION_unload ^You should unload the
     matchre LOCATION_unload ^You need to unload the
     put stow %todo in my %container2
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW3!  ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW3 
     return
STOW_4:
     delay 0.0001
     var LOCATION STOW_4
     var bagsFull 1
     if "$lefthandnoun" = "bundle" then put drop bun
     if "$righthandnoun" = "bundle" then put drop bun
     matchre OPEN_THING ^But that's closed
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN ^You put your
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre REM_WEAR any more room|no matter how you arrange|^That's too heavy|too thick|too long|too wide
     matchre LOCATION_unload ^You should unload the
     matchre LOCATION_unload ^You need to unload the
     put stow %todo in my %container3
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW4! ***
     put #echo >$Log Crimson $datetime Stow = %todo
     put #log $datetime MISSING MATCH IN STOW4
     return
OPEN_THING:
     pause 0.1
     send open %container1
     send open %container2
     pause 0.5
     goto STOWING
REM_WEAR:
     put rem bund
     put drop bund
     wait
     pause 0.5
     goto WEAR_1
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
     matchre location_p ^It's all a blur
     matchre location_p ^You're unconscious\!
     matchre location_p ^You are still stunned
     matchre location_p There is no need for violence here\.
     matchre location_p ^You can't do that while entangled in a web
     matchre location_p ^You struggle against the shadowy webs to no avail\.
     matchre location_p ^You attempt that, but end up getting caught in an invisible box\.
     matchre location1 ^You should stop playing before you do that\.
     matchre location1 ^You are a bit too busy performing to do that\.
     matchre location1 ^You are concentrating too much upon your performance to do that\.
     matchwait 22
     put #echo >Log yellow matchwait %location %todo
location_p:
     pause
location:
     pause 0.1
     goto %location

LOCATION_unload:
     gosub unload
     var location stow1
     gosub stow1
     return

LOCATION_unload1:
     gosub unload
     var location wear.1
     gosub wear.1
     return

location1:
     gosub stop.humming1
     goto %location
     
#### RETURNS
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
	 
	 
	 
## **********
RETREAT:
		matchre RETURN ^You should stop practicing
		matchre RETURN ^You retreat from combat.|^You are already as far away as you can get!
		matchre RETREAT ^\.\.\.wait|^Sorry\,
	send retreat
	matchwait 1
	GOTO RETREAT 
