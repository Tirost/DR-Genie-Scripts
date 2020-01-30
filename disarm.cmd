#debuglevel 5
################################################################################################################################
# Smart Disarm Script v7.5 - For Dragonrealms - by Shroom
# Specialized for thieves, works for anyone
# - Analyzes the appraisal difficulty of the trap compared to what type of trap it is
# - Dynamically changes mode of disarm (Blind, Quick, Normal, Careful) according to how difficult trap is
# - Tosses box if trap is WAY too hard, or if you fail too many times in a row
# - Handles Blown Traps (determines what kind of trap it was, reacts/gets healed accordingly)
# - Handles Lockpick Rings/Cases
# - Tracks total number of boxes picked per session and total boxes picked over ALL TIME running the script
################################################################################################################################
# CHANGELOG 
# - Added matches for EVERY box type when already disarmed, for the Pet Boxes mode to make 100% sure a box is disarmed before picking it
# - Added TieContainer / TieContainer.Items - For toolstraps/toolbelts etc that you always want to tie a particular item to 
# - Robustified the box matching to avoid false positives on anything that is NOT a monster box 
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
# LAST UPDATE - 10/4/19
################################################################################################################################
#####################
## USER VARIABLES 
#####################
## YOU MUST SET YOUR CHARACTER'S NAME(S) BELOW
## IF ONLY ONE CHARACTER THEN JUST SET CHARACTER1. SET REST TO NULL 
var CHARACTER1 Shroom
var CHARACTER2 Alucios
var CHARACTER3 Valgrind
var CHARACTER4 Hvinir
var CHARACTER5 Raidboss
## MAKE SURE TO UPDATE THE VARIABLES THAT ARE SPECIFIC TO EACH DIFFERENT CHARACTER # BELOW 
if ("$charactername" = "%CHARACTER1") then
## DONT CHANGE THIS ABOVE ^^^^^ 
## CHANGE ALL THESE BELOW VVVV
     {
     ## SET YOUR BAGS WHERE BOXES CAN BE FOUND
     ## AND/OR WHERE YOUR ARMOR/HAND ITEMS CAN BE STOWED
     var container1 backpack
     var container2 rucksack
     var container3 shadow
     var sheath baldric
     ## TIE CONTAINER (If you use a toolstrap/toolbelt etc container to TIE weapons etc to) 
     ## SET THE VERB OF THE TIE CONTAINER 
     var TieContainer toolstrap
     ### SET THE ITEMS YOU WANT TO ALWAYS TIE TO IT ( in an array - item1|item2|item3  )
     var TieContainer.Items NULL 
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn NO
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch black pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container carryall
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch NO
     # ANY HAND WORN ARMOR?
     var knuckles hand claw
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage util belt
     # MAGIC SKELETON KEY? (YES OR NO) - ONLY FOR USE WITH A MAGIC LOCKPICKING SKELETON KEY
     var skeleton.key NO
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking YES
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
     ## Set the special bag to put only disarmed boxes in
     var disarmBag white.back
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
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
     var container1 backpack
     var container2 haversack
     var container3 duffel.bag
     var sheath bag
     ## TIE CONTAINER (If you use a toolstrap/toolbelt etc container to TIE weapons etc to) 
     ## SET THE VERB OF THE TIE CONTAINER 
     var TieContainer NULL
     ### SET THE ITEMS YOU WANT TO ALWAYS TIE TO IT ( in an array - item1|item2|item3  )
     var TieContainer.Items NULL 
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn NO
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch black pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container leather pouch
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch NO
     # ANY HAND WORN ARMOR?
     var knuckles knuckle
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage kit
     # MAGIC SKELETON KEY? (YES OR NO) - ONLY FOR USE WITH A MAGIC LOCKPICKING SKELETON KEY
     var skeleton.key NO
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal YES
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
     ## Set the special bag to put only disarmed boxes in
     var disarmBag white back
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
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
     var container1 carryall
     var container2 haversack
     var container3 duffel.bag
     var sheath bag
     ## TIE CONTAINER (If you use a toolstrap/toolbelt etc container to TIE weapons etc to) 
     ## SET THE VERB OF THE TIE CONTAINER 
     var TieContainer NULL
     ### SET THE ITEMS YOU WANT TO ALWAYS TIE TO IT ( in an array - item1|item2|item3  )
     var TieContainer.Items NULL 
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn NO
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch black pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container green pouch
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch NO
     # ANY HAND WORN ARMOR?
     var knuckles knuckle
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage pouch
     # MAGIC SKELETON KEY? (YES OR NO) - ONLY FOR USE WITH A MAGIC LOCKPICKING SKELETON KEY
     var skeleton.key NO
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking YES
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
     ## Set the special bag to put only disarmed boxes in
     var disarmBag white back
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
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
     ## TIE CONTAINER (If you use a toolstrap/toolbelt etc container to TIE weapons etc to) 
     ## SET THE VERB OF THE TIE CONTAINER 
     var TieContainer NULL
     ### SET THE ITEMS YOU WANT TO ALWAYS TIE TO IT ( in an array - item1|item2|item3  )
     var TieContainer.Items NULL 
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
     # MAGIC SKELETON KEY? (YES OR NO) - ONLY FOR USE WITH A MAGIC LOCKPICKING SKELETON KEY
     var skeleton.key NO
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking YES
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
     ## Set the special bag to put only disarmed boxes in
     var disarmBag white back
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
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
if ("$charactername" = "%CHARACTER5") then
     {
     ## SET YOUR BAGS WHERE BOXES CAN BE FOUND
     ## AND/OR WHERE YOUR ARMOR/HAND ITEMS CAN BE STOWED
     var container1 bag
     var container2 lootsack
     var container3 pannier
     var sheath harness
     ## TIE CONTAINER (If you use a toolstrap/toolbelt etc container to TIE weapons etc to) 
     ## SET THE VERB OF THE TIE CONTAINER 
     var TieContainer NULL
     ### SET THE ITEMS YOU WANT TO ALWAYS TIE TO IT ( in an array - item1|item2|item3  )
     var TieContainer.Items NULL 
     ## Do you WEAR your GEM POUCH or do you keep them stowed away in your bags?
     ## (YES or NO) - Yes if you wear one, NO if you do not wear a gem pouch
     var gempouchWorn NO
     ## DO YOUR GEM POUCHES HAVE SOME WEIRD SYNTAX? SET IT HERE. LEAVE AT GEM POUCH IF NORMAL
     var gempouch black pouch
     ## WHERE DO WE STORE YOUR COMPLETELY FULL, TIED UP GEM POUCHES? (CLOSABLE CONTAINER!)
     var gempouch.container thigh.pouch
     ## TIE YOUR GEM POUCHES? YES OR NO - YES WILL TIE UP ANY FULL POUCHES
     var tie.pouch NO
     # ANY HAND WORN ARMOR?
     var knuckles knuckle
     #### ARE YOU USING A LOCKPICK RING or LOCKPICK CASE? (YES OR NO) (Auto-Detects if case or ring)
     var lockpick.ring YES
     # WHERE DO YOU STORE EXTRA LOCKPICKS FOR RESTOCKING YOUR LOCKPICK RING/CASE? (IF ANY - Not necessary to set)
     var pickstorage bag
     # MAGIC SKELETON KEY? (YES OR NO) - ONLY FOR USE WITH A MAGIC LOCKPICKING SKELETON KEY
     var skeleton.key NO
     #### DO YOU WANT TO PUT YOUR ARMOR BACK ON AT THE END? (IF IT TOOK ANY OFF FIRST?)
     var wear.armor YES
     #### DO YOU WANT TO USE THE AUTO-HEALER IF YOU GET HURT?? (YES OR NO) 
     #### WARNING: SETTING TO NO WILL SKIP GETTING HEALED SO ITS UP TO YOU TO RECOVER!
     var autoheal YES
     # CONTINUE PICKING AFTER MIND LOCK? (YES OR NO) - NO WILL STOP PICKING ONCE MIND LOCKED
     # SET TO YES IF YOU WANT TO CONTINUE PICKING UNTIL ALL THE BOXES ARE GONE AND IGNORE MINDSTATE
     var keep.picking YES
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
     ## Set the special bag to put only disarmed boxes in
     var disarmBag white back
     ## PICK PET BOXES - (YES or NO) - If YES, Gets all Boxes from your "disarmBag" (var above this) 
     ## WILL ONLY PICK BLIND AND THEN PUT AWAY WHEN LOCKED
     ## NOT RESPONSIBLE FOR YOU NOT HAVING DISARMED BOXES AND BLOWING YOUR FACE OFF 
     var PET.BOXES NO
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
     var box_types (brass|copper|deobar|driftwood|iron|ironwood|mahogany|oaken|pine|steel|wooden) (?:coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|(?<!(?i)training )box)
     var component_list sealed vial|tube|needle|seal|bladder|studs|blade|\brune\b|spring|hammer|disc|dart|reservoir|face|\bpin\b|striker|cube|sphere|leg|crystal|circle|clay
     var multi_trap ON
     var multi_lock ON
     var thief_hide NO
     var ARMOR_STOW OFF
     var trap_type NULL
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
     action var trap_type acid;echo ***ACID TRAP! when As you look closely\, you notice a tiny hole right next to the lock which looks to be a trap of some kind\.|Must be an acid trap\.
     action var trap_type boomer;echo ***BOOMER TRAP! when A glistening black square\, surrounded by a tight ring of fibrous cord, catches your eye\.
     action var trap_type reaper;echo ***REAPER TRAP!! when A crust\-covered black scarab of some unidentifiable substance clings to the|^A disturbing little scarab is fastened to the front\.
     action var trap_type fire_ant;echo ***FIRE ANT TRAP!! when Within the casing of .* is a mesh bag\, a very sharp blade poised to the side just within
     action var trap_type poison_bolt;echo ***POISON BOLT TRAP when You find a series of openings on the front of the .* concealing the points of several crossbow bolts glistening with moisture\.
     action var trap_type bolt;echo ***BOLT TRAP! when concealing the points of several wickedly barbed crossbow bolts\.
     action var trap_type concussion;echo ***CONCUSSION TRAP!! when Right above the lock inside the keyhole\, you see a tiny metal tube just poking out of a small wad of brown clay\.|infamous shockwave trap
     action var trap_type cyanide;echo ***CYANIDE TRAP! when ^The glint of silver from the tip of a dart catches your attention|That tiny dart you can see means|smell of almonds
     action var trap_type disease;echo ***DISEASE TRAP! when While inspecting the .* patiently\, you see what appears to be a small\, swollen animal bladder recessed inside the keyhole\.
     action var trap_type flea;echo ***FLEA TRAP! when (Embedded|Imbedded) in the front of the .* is a small glass tube of milky-white opacity\.
     action var trap_type gas;echo ***GAS TRAP! when You notice a vial of lime green liquid just under the .* lid|^There\'s a stopper of some vial attached to the lid
     action var trap_type lightning;echo ***LIGHTNING TRAP!! when Looking closely into the keyhole\, you spy what appears to be a pulsating ball with some sort of metal lacing around it
     action var trap_type naphtha_soaker;echo ***NAPHTHA SOAKER TRAP!! when Searching the .* carefully\, you notice a small notch beside a tiny metal lever on the front\.|components of the naphtha soaker trap
     action var trap_type naphtha;echo ***NAPHTHA TRAP! when A tiny striker is cleverly concealed under the lid\, set to ignite a frighteningly large vial of naphtha\.
     action var trap_type poison_local;echo ***POISON TRAP! when You notice a tiny needle with a greenish discoloration on its tip hidden next to the keyhole\.
     action var trap_type poison_nerve;echo ***NERVE POISON TRAP! when You notice a tiny needle with a rust colored discoloration on its tip hidden next to the keyhole\.|^A rusty needle\!
     action var trap_type scythe;echo ***SCYTHE TRAP! when Out of the corner of your eye\, you notice a glint of razor sharp steel hidden within a suspicious looking seam on the|scythe trap\!
     action var trap_type shocker;echo ***SHOCKER TRAP! when You notice two silver studs right below the keyhole which look dangerously out of place there\.
     action var trap_type shrapnel;echo ***SHRAPNEL TRAP!!! when Squinting slightly to see better\, you notice the .* keyhole is packed tightly with a powder around the insides of the lock\.
     action var trap_type teleport;echo ***TELEPORT TRAP!!!! when The hinges of the .* are covered with a thin metal circle that has been lacquered with a shade of .*\.
     action var trap_type bouncer;echo ***BOUNCER TRAP when Looking into the keyhole you see what seems to be a pin lodged against the tumblers of the lock\.
     action var trap_type curse;echo ***CURSE TRAP when While checking the .* with an careful eye\, you notice a small glowing rune hidden inside the .*
     action var trap_type frog;echo ***FROG TRAP when While checking the .* with a careful eye\, you notice a lumpy green rune hidden inside the .*
     action var trap_type laughing;echo ***LAUGHING TRAP when Examining the .* for traps reveals a tiny glass tube filled with a black gaseous substance of some sort and a tiny hammer at the ready to do what it was designed for\.
     action var trap_type mana_sucker;echo ***MANA TRAP when While checking the .* for traps\, you notice a bronze seal over the .* 
     action var trap_type mime;echo ***MIME TRAP when A tiny bronze face\, Fae in appearance\, grins ridiculously from its place on the .*
     action var trap_type shadowling;echo ***SHADOWLING TRAP when While scanning the .* with a careful eye\, you notice a small black crystal deep in the shadows of the .*
     action var trap_type sleeper;echo ***SLEEPER TRAP when Two sets of six pinholes on either side of the .* lock indicate that something is awry\.
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
     if "%trap_type" = "NULL" then var trap_difficulty 0
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
     if ("$guild" = "Necromancer") then gosub JUSTICE_CHECK
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
		matchre boxes_Yes (brass|copper|deobar|driftwood|iron|ironwood|mahogany|oaken|pine|steel|wooden) (?:coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|(?<!(?i)training )box)
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
     pause 0.1
     pause 0.1
          matchre armor_Check1 ^\.\.\.wait|^Sorry, you may only type
          matchre remove_Armor helm|((?<=field|fluted|full|half|war|battle|lamellar|blue|blackened|jousting|silver|white|lunated|icesteel|goffered|fluted|polished) (\bplate\b)|steel plate(?! armor| gauntlets| gloves| greaves| helm| mask)|(?<=field|chain|leather|bone|quilted|reed|black|plate|combat|body|clay|lamellar|steel|mail|pale|polished|shadow|Suit of|suit|woven|yeehar-hide|kidskin|gladiatorial|battle|tomiek|glaes|pale|ceremonial|sinuous|trimmed|carapace|Zaulguum-skin) (\barmor\b)|armet(?! helm)|gauntlet|gloves|(?!pavise)shield|claw guards|odaj|mail gloves|platemail legs|parry stick|leggings|handwraps|\bhat\b|hand claws|armguard|jacket|torso|armwraps|footwraps|aegis|buckler|\bhood\b|\bcowl\b|\bheater(?! shield)|\bpavise(?! shield)|scutum|sipar|\btarge\b|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|longcoat|\bcoat\b|\bcowl|cuirass|fauld|greaves|hauberk|\bhood\b|jerkin|leathers|lorica|mantle|(?<!crimson leather )\bmask\b|morion|pants|handguards|bodysuit|robe|sallet|shirt|sleeves|ticivara|tabard|tasset|thorakes|\blid\b|vambraces|vest|collar|coif|mitt|\bsteel mail\b)
          matchre armor_None You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
          put inv armor
	matchwait 3
armor_Checking:
     pause 0.1
     pause 0.1
          matchre armor_Checking ^\.\.\.wait|^Sorry, you may only type
          matchre remove_Armor helm|((?<=field|fluted|full|half|war|battle|lamellar|blue|blackened|jousting|silver|white|lunated|icesteel|goffered|fluted|polished) (\bplate\b)|steel plate(?! armor| gauntlets| gloves| greaves| helm| mask)|(?<=field|chain|leather|bone|quilted|reed|black|plate|combat|body|clay|lamellar|steel|mail|pale|polished|shadow|Suit of|suit|woven|yeehar-hide|kidskin|gladiatorial|battle|tomiek|glaes|pale|ceremonial|sinuous|trimmed|carapace|Zaulguum-skin) (\barmor\b)|armet(?! helm)|gauntlet|gloves|(?!pavise)shield|claw guards|odaj|mail gloves|platemail legs|parry stick|leggings|handwraps|\bhat\b|hand claws|armguard|jacket|torso|armwraps|footwraps|aegis|buckler|\bhood\b|\bcowl\b|\bheater(?! shield)|\bpavise(?! shield)|scutum|sipar|\btarge\b|aventail|backplate|balaclava|barbute|bascinet|breastplate|\bcap\b|longcoat|\bcoat\b|\bcowl|cuirass|fauld|greaves|hauberk|\bhood\b|jerkin|leathers|lorica|mantle|(?<!crimson leather )\bmask\b|morion|pants|handguards|bodysuit|robe|sallet|shirt|sleeves|ticivara|tabard|tasset|thorakes|\blid\b|vambraces|vest|collar|coif|mitt|\bsteel mail\b)
          matchre Armor_Complete You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything
          put inv armor
	matchwait 4
	goto Armor_Complete
remove_Armor:
     var armor $0
     var LAST remove_Armor
     pause 0.1
     pause 0.1
     pause 0.1
          matchre remove_Armor ^\.\.\.wait|^Sorry, you may only type
          matchre stow_Armor You'?r?e? (?:hand|put|get|.* to|slip|quickly|switch|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel|read|reach|gingerly|come|corruption|count) .*(?:\.|\!|\?)?
          matchre stow_Armor ^Without any effort|the .* slide off|tug the .* free|Shaking your head
          matchre armor_Check ^You have nothing of that|^Remove what
          put remove %armor
     matchwait
stow_Armor:
     pause 0.1
     pause 0.1
     if !matchre("%TieContainer", "\b(?i)(NULL|NIL)\b") && matchre("$righthand $lefthand", "%TieContainer.Items") then goto Tie_Armor
stow_Armor_1:
     var armorcontainer %container1
	var LAST stow_Armor_1
     pause 0.1
		matchre stow_Armor ^\.\.\.wait|^Sorry, you may only type
          matchre stow_Armor_2 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
          matchre stow_Armor_2 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
		matchre armor_Done ^You put your|^What
		put put %armor in my %container1
	matchwait
stow_Armor_2:
     var armorcontainer %container2
	var LAST stow_Armor_2
     pause 0.1
		matchre stow_Armor_2 ^\.\.\.wait|^Sorry, you may only type
          matchre stow_Armor_3 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
          matchre stow_Armor_3 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
	     matchre armor_Done ^You put your|^What
	put put %armor in my %container2
	matchwait
stow_Armor_3:
     var armorcontainer %container2
	var LAST stow_Armor_2
     pause 0.1
		matchre stow_Armor_2 ^\.\.\.wait|^Sorry, you may only type
          matchre no_More_Stowing ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
          matchre no_More_Stowing ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
	     matchre armor_Done ^You put your|^What
	put put %armor in my %container2
	matchwait
Tie_Armor:
     var armorcontainer %container2
	var LAST stow_Armor_2
     pause 0.1
		matchre Tie_Armor ^\.\.\.wait|^Sorry, you may only type
          matchre stow_Armor_1 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you|^Where are you|^Weirdly\,
          matchre stow_Armor_1 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
	     matchre armor_Done You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
	put tie %armor to my %TieContainer
	matchwait
armor_Done:
     counter add 1
     pause 0.1
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
     var trap_type NULL
     var disarmed 0
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
     if ("$guild" = "Barbarian") then 
          {
               send meditate focus
               pause 2
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
     var trap_type NULL
     pause 0.1
	if ("$guild" = "Thief") then gosub glance_box
     gosub disarm_ID
     if (toupper("%PET.BOXES") = "YES") && (%disarmed = 0) then goto PETBOX_ERROR
     if (toupper("%PET.BOXES") = "YES") then goto lock_sub
     if ("%trap_type" = "NULL") then goto lock_sub
     gosub trap_diff_compute
     echo *** Adjusted Trap Difficulty: %total_difficulty
	if ("%mode" = "toss") then goto toss_box
     # debug 5
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
     # debug 0
	pause 0.1
	if ("$guild" = "Thief") then gosub glance_box
	if (toupper("%PET.BOXES") != "YES") then gosub pick_ID
	# if ("%mode" = "toss") then goto toss_box
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
     pause 0.1
     pause 0.01
     matchre container_Check ^\.\.\.wait|^Sorry,
     matchre get_For_Disarm %box_types
	matchre RETURN Encumbrance
	send look in my %container;-.5 enc
	matchwait
PETBOX_ERROR:
     echo =======================================
     echo ** PET BOX ERROR! BOX IS NOT DISARMED!
     echo =======================================
     pause 0.2
     send put my %disarmit in my %container1
     pause 0.5
     pause 0.2
     if !matchre("$righthand $lefthand", "%box_types") then goto main
     if matchre("$righthand $lefthand", "%box_types") then send put my %disarmit in my %container2
     pause 0.3
     if matchre("$righthand $lefthand", "%box_types") then send put my %disarmit in my %container3
     pause 0.3
     goto main
     
get_For_Disarm:
	var disarmit $0
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
     if (toupper("%PET.BOXES") = "YES") then goto %SAVE
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
     pause 0.001
     pause 0.001
     pause 0.1
	send glance my $lefthandnoun
	wait
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
     matchre Stop_Play ^You are a bit too busy performing
     matchre ID_FAIL ^You get the distinct feeling your careless|This is not likely to be a good
	matchre disarm_ID ^\.\.\.wait|^Sorry, you may only type
     matchre Not_Box ^You don't see any reason to attempt to disarm that
	matchre weapon hinders your attempt|knuckles|handwraps|hand claws
	matchre disarm_ID fails to reveal to you|^You are still stunned
	matchre HEALTH You're in no shape
     matchre DISARMED ^An incredibly sharp blade rests off to the side in the casing of the .*\, indicating the trap is no longer a danger\.
     matchre DISARMED ^A broken spring is sticking out of a hidden seam on the front of the .*\.\s+It is no longer attached to a razor\-sharp scythe blade within the gap\.
	matchre DISARMED ^A thin metal circle of .* has been peeled away from the hinges of the .*
     matchre DISARMED ^A small hole near the lock houses a tiny dart with a silver tip\.\s+It appears\, however\, that the dart has been moved too far out of position for the mechanism to function properly\.
     matchre DISARMED ^A row of concealed openings on the front of the .*\, have been bent in such a way that they no longer will function\.
     matchre DISARMED ^A tiny hammer and milky\-white tube on the front of the .* have been bent away from each other\.
     matchre DISARMED ^A bent needle sticks harmlessly out from its hidden compartment near the lock\.
     matchre DISARMED It appears\, however\, that the dart has been moved too far out of position for the mechanism to function properly\.
     matchre DISARMED ^Looking closely at the .*\, you notice a vial of lime green liquid attached to the lid\.\s+Someone has unhooked the stopper\, rendering it harmless\.
     matchre DISARMED ^Still grinning ridiculously is a tiny bronze face\, loosened from the .*\.\s+Behind this metallic visage rests a small deflated bladder\.
     matchre DISARMED ^Several small pinholes centered around the keyhole indicate that some sort of apparatus\, previously attached\, was picked apart and removed from the .*\.
     matchre DISARMED ^Several strands of wicker detonator lay inside the casement\, separated harmlessly from their charge\.\s+You guess it is already disarmed
     matchre DISARMED There is a small hole in the front of the .* and a damp stain down the front\, as if something had been poured out the hole\.
     matchre DISARMED ^There are two tiny holes in the .*\.\s+It looks like there used to be something in them\, but whatever it was has been pried out\.
     matchre DISARMED ^There is a stain near a small notch on the front of the .*\, indicating a liquid was drained out\.\s+Additionally\, a tiny metal lever has been bent away from the casing\.
     matchre DISARMED ^Two sets of six pinholes on either side of the .* lock are sealed with dirt\, blocking whatever would have come out
     matchre DISARMED ^You notice .* type of animal bladder and a disconnected string near the lock\.
     matchre DISARMED ^You notice a small hole in the side of the .* and the remnants of some type of powder\.
     matchre DISARMED ^You notice a tiny hole near the lock which has been stuffed with dirt rendering the trap harmless\.
     matchre DISARMED ^You notice a sphere with some type of lacing around it\.\s+It seems a small portion of the trap has been removed\.
     matchre DISARMED ^You see nothing of interest in the .*\.\s+It seems harmless\.
     matchre DISARMED ^You see a pin and shaft lodged into the frame of the .*\.\s+It looks safe enough\.
     matchre DISARMED ^You see a shattered glass tube with a tiny hammer inside the lock\.\s+You deem it quite safe\.
     matchre DISARMED ^You see a glowing rune pushed deep within the .*\.\s+It seems far enough away from the lock to be harmless\.
     matchre DISARMED ^You see a lumpy green rune pushed deep within the casket\.\s+It seems far enough away from the lock to be harmless\.
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
     pause 0.1
     pause 0.1
     put glance my $lefthandnoun
     pause 0.2
     if ("%trap_type" = "NULL") then var trap_type UNKNOWN
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
     pause 0.1
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
	matchre disarm_Return You are certain the %disarmit is not trapped|Roundtime|It appears\, however, that the dart has been moved too far out of position for the mechanism to function properly\.
     matchre disarm_Return You guess it is already disarmed|DISARM HELP for syntax help|It looks safe enough|^You don't see any reason
	put disarm my %disarmit %mode
	matchwait
disarmIt_Careful:
	math disarm.count add 2
     math total_difficulty add 1
	goto disarmIt_Cont
disarm_Return:
     pause 0.1
     pause 0.1
     pause 0.1
     put disarm id
     pause 0.5
     pause 0.1
     return

analyze:
	var LAST analyze
	math harvest.count add 1
     pause 0.001
     pause 0.1
	pause 0.1
     pause 0.1
	if (%harvest.count > 2) then goto RETURN
	     matchre weapon knuckles|handwraps
		matchre analyze ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre analyze You are unable to
		matchre harvest You already have made an extensive study|You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help|You\'ve already analyzed this trap
		matchre return fumbling fails to disarm|This is not likely to be a good thing
		matchre disarm what could you possibly analyze
	put disarm anal
	matchwait

harvest:
	var LAST harvest
	math harvest.count add 1
     pause 0.1
     pause 0.1
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
     pause 0.3
     pause 0.1
     pause 0.1
	if ("$righthandnoun" = "cube") then send put cube in my %container1
     if (toupper("%keepcomponent") = "YES") then
          {
               if matchre("$righthand", "(%component_list)") then gosub stow_It $0
          }
     if ("$righthand" != "Empty") then
		{
               pause 0.1
               pause 0.1
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
     if (toupper("%skeleton.key") = "YES") then goto get_Skeleton
	var LAST get_Pick
     if ((toupper("%lockpick.ring") = "YES") && ("$righthand" = "Empty")) then gosub get_Pick
		matchre get_Pick ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return You get|You are already
		matchre no_More_Picks What were you referring to|^I could not
	put get my lockpick
	matchwait

get_Skeleton:
    	var LAST get_Skeleton
		matchre get_Skeleton ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return You get|You are already|You pull
		matchre Skeleton_OFF What were you referring to|^I could not
	put get my skeleton key
	matchwait
Skeleton_OFF:
     var skeleton.key NO
     goto get_Pick

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
	if matchre("$righthand|$lefthand", "skeleton key") then put put my key in my %pickstorage
	else put put lockpick in my %pickstorage
	matchwait

pick.storage2:
	var LAST pick.storage2
	if ("$righthand" = "Empty") then return
		matchre pick.storage2 ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre return You put|What were you
     if matchre("$righthand|$lefthand", "skeleton key") then put put my key in my %container1
	else put put lockpick in my %container1
	matchwait

pick_ID:
	var LAST pick_ID
	var SAVE pick_ID
	var pickloop 0
     pause 0.1
     if ("$righthand" != "Empty") then 
          {
               put stow $righthand
               pause 0.8
          }
     if ((toupper("%lockpick.ring") != "YES") && ("$righthand" = "Empty")) || ((toupper("%skeleton.key") = "YES") && ("$righthand" = "Empty")) then gosub get_Pick
     pause 0.001
     pause 0.001
          matchre pick_ID ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
		matchre weapon hinders your attempt|knuckles|handwraps|hand claws
		matchre disarm_ERROR is not fully disarmed
		matchre pick_ID fails to teach you anything about the lock guarding it|just broke
		matchre return Roundtime|has already helpfully been analyzed|not even locked|^Pick what|^You|Somebody has
		matchre get_Pick Find a more appropriate tool
	put pick ID
	matchwait

pick:
	var LAST pick
	var SAVE pick_Cont
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
     pause 0.1
     pause 0.1
	pause 0.1
     if ($Locksmithing.LearningRate > 33) && (toupper("%PET.BOXES") = "YES") then goto LOCKED_SKILLS
	if (%pickloop > 20) && (toupper("%PET.BOXES") != "YES") then goto toss_Box
	if (%pickloop > 6) then var mode careful
	if ((%pickloop > 2) && ("%mode" = "quick")) then var mode normal
	if ((%pickloop > 2) && ("%mode" = "blind")) then var mode quick
     if (toupper("%PET.BOXES") = "YES") then var mode blind
     matchre return With a soft click|A sharp click|Roundtime|^Pick what|It\'s not even locked\, why bother\?
	matchre pick_Cont ^\.\.\.wait|^Sorry, you may only type|^You are still stunned
	matchre weapon hinders your attempt|knuckles|handwraps|hand claws
	matchre pick_cont You are unable to make
	matchre get_Pick Find a more appropriate tool
     if matchre("$righthand|$lefthand", "skeleton key") then put turn key with %disarmit
	else put pick %mode
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
	matchre main ^You|^I|^What
     if !matchre("$righthand", "\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|(?<![Tt]raining )\bbox\b") then put stow $righthand
     if !matchre("$lefthand", "\bcoffer\b|\btrunk\b|\bchest\b|\bstrongbox\b|\bskippet\b|\bcaddy\b|\bcrate\b|\bcasket\b|(?<![Tt]raining )\bbox\b") then put stow $lefthand
     pause 0.1
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
	var LAST open_Box
     pause 0.001
     pause 0.2
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
          matchre lock_sub ^It is locked
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
          matchre bad_Item \b(ruby|potency crystal|infuser stone|runestone|stone|nugget|ingot)\b
		matchre nonGem_Done In the|nothing|What
	put look in my %gempouch
	matchwait
     
bad_Item:
     var item $1
     pause 0.001
     pause 0.001
     gosub PUT get %item in my %gempouch
     pause 0.5
     gosub PUT put %item in my %container1
     pause 0.1
     pause 0.1
     if matchre("$righthand $lefthand", %item) then gosub PUT put %item in my %container2
     if matchre("$righthand $lefthand", %item) then gosub PUT put %item in my %container3
     pause 0.2
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
     gosub DUMPSTER_CHECK
     if !matchre("%dumpster", "(NULL|gelapod)") then
          {
               pause 0.001
               if matchre("$righthand", "%disarmit") then put put my %disarmit in %dumpster
               if matchre("$lefthand", "%disarmit") then put put my %disarmit in %dumpster
               pause 0.2
               return
          }
     if matchre("%dumpster", "gelapod") then
          {
               pause 0.001
               if matchre("$righthand", "%disarmit") then put feed my %disarmit to gelapod
               if matchre("$lefthand", "%disarmit") then put feed my %disarmit to gelapod
               pause 0.2
          }
     pause 0.2
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
		matchre dismantle ^\.\.\.wait|^Sorry, you may only type
          matchre dismantle next 15 seconds|something inside it
          matchre drop_box You can not dismantle
		matchre open_Box You must first open
		matchre disarm_sub You must first disarm
		matchre return Roundtime|Unable to locate|^Dismantle what\?
          matchre return ^You must be holding
	put disman my %disarmit %dismantle
	matchwait

DUMPSTER_SET:
DUMPSTER_CHECK:
     var dumpster NULL
     if matchre("$roomobjs", "a small hole") then var dumpster hole
     if matchre("$roomobjs", "a small mud puddle") then var dumpster puddle
     if matchre("$roomobjs", "a marble statue ") then var dumpster statue
     if matchre("$roomobjs", "a bucket of viscous gloop|(a|metal|iron|steel|rusted|waste) bucket") then var dumpster bucket
     if matchre("$roomobjs", "a large stone turtle") then var dumpster turtle
     if matchre("$roomobjs", "a tree hollow|darken hollow") then var dumpster hollow
     if matchre("$roomobjs", "an oak crate") then var dumpster crate
     if matchre("$roomobjs", "a driftwood log") then var dumpster log
     if matchre("$roomobjs", "a disposal bin|a waste bin|firewood bin") then var dumpster bin
     if matchre("$roomobjs", "(ivory|stone) urn") then var dumpster urn
     if matchre("$roomobjs", "a waste basket") then var dumpster basket
     if matchre("$roomobjs", "a bottomless pit") then var dumpster pit
     if matchre("$roomobjs", "trash receptacle") then var dumpster receptacle
     if matchre("$roomobjs", "domesticated gelapod") then var dumpster gelapod
     if matchre("$roomname", "^\[Garden Rooftop, Medical Pavilion\]") then var dumpster gutter
     return
     
drop_box:
     pause 0.1
     if matchre("$righthand", "training box") then put stow box
     if matchre("$lefthand", "training box") then put stow box
     gosub PUT drop my %disarmit
     pause 0.2
     return

stowDisarm:
     pause 0.3
     pause 0.2
     echo *** STOWING DISARMED BOX AWAY
     put put my %disarmit in %disarmBag
     pause 0.5
     return
stowDisarmed:
     pause 0.2
     pause 0.3
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
	if !matchre(toupper("%keep.picking"), "YES") then
          {
               if ($Locksmithing.LearningRate > 33) then goto LOCKED_SKILLS
          }
     if (toupper("%PET.BOXES") = "YES") then
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
     matchre lockpick_ring_type3 ^I could not|^What
     send tap my lockpick case
     matchwait 8
type_case:
     var lockpick.ring.type case
     goto fill_lockpick_ring
lockpick_ring_type3:
     pause 0.1
     pause 0.001
     matchre type_ankle ^You tap (.+) you are wearing
     matchre lockpick_ring_type4 ^I could not|^What
     send tap my lockpick ankle-cuff
     matchwait 8
type_ankle:
     var lockpick.ring.type ankle
     goto fill_lockpick_ring
lockpick_ring_type4:
     pause 0.1
     pause 0.001
     matchre type_key ^You tap (.+) you are wearing
     matchre no_ring ^I could not|^What
     send tap my golden key
     matchwait 8
type_key:
     var lockpick.ring.type golden key
     goto fill_lockpick_ring
no_ring:
     var lockpick.ring NO
     return


fill_lockpick_ring:
     pause 0.1
     matchre empty_lock ^The .* is empty but you think (\d+) lockpicks would probably fit\.
     matchre new_lock it might hold an additional (\d+)
     matchre lockpick_ringfull appears to be full|It looks|looks to be holding
     matchre empty_lock (empty)
     if ("$guild" = "Thief") then put glance my lockpick %lockpick.ring.type
     else put app my lockpick %lockpick.ring.type
     matchwait
empty_lock:
     var lockpickcount $1
     pause 0.1
     pause 0.1
     matchre No_Picks ^What were you|^I could not find
     matchre put_lock ^You get|already holding|^You need a free
     put get my lockpick
     matchwait
new_lock:
     var lockpickcount $1
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
     if ("%lockpickcount" != "empty") then return
     put #echo >Log Orange ******** Running low on lockpicks! Make more! *************
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
     echo *** FINISHED PICKING BOXES!
     echo
     put #echo >Log Aqua *** Finished Boxes - Locksmithing: $Locksmithing.Ranks $Locksmithing.LearningRate / 34 ***
     put #echo >Log Aqua *** %BOXES boxes this session - $Boxes boxes over all time
DONE:
     pause 0.1
     #send dump junk
     pause 0.5
     if (toupper("%PET.BOXES") = "YES") then gosub stowDisarm
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
     if $bleeding = 1 then goto HEALTH
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
     if $bleeding = 1 then goto HEALTH
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
     if $stunned = 1 then goto HEALTH_PAUSE
     if $standing = 0 then gosub stand
ENSURE_IN_CITY:
     if ("$zoneid" = "116") then gosub AUTOMOVE healer
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
PUT_STOW:
     gosub EMPTY_HANDS
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
     matchre RETURN_CLEAR You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^Brother Durantine|^Durantine|^Mags|^Ylono|^Malik|^Kilam|^Ragge|^Randal|^Catrox|^Kamze|^Unspiek|^Wyla|^Ladar|^Dagul|^Granzer|^Fekoeti|^Diwitt|(?:An|The|A) attendant|^The clerk|A Dwarven|^.*He says\,
     matchre RETURN_CLEAR ^The (?: clerk|teller|attendant|mortar|pestle|tongs|bowl|riffler|hammer|gem|book|page|lockpick|sconce|voice|waters) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre RETURN_CLEAR \[Roundtime
     matchre RETURN_CLEAR \[You're
     matchre RETURN_CLEAR ^Moving
     matchre RETURN_CLEAR too injured
     matchre RETURN_CLEAR ^.*\[Praying for \d+ sec\.\]
     matchre RETURN_CLEAR ^You cannot do that while engaged\!
     matchre RETURN_CLEAR ^I could not find
     matchre RETURN_CLEAR ^Please rephrase that command\.
     matchre RETURN_CLEAR ^Perhaps you should
     matchre RETURN_CLEAR ^That (?:is|has) already
     matchre RETURN_CLEAR ^The .* (is|are|slides)
     matchre RETURN_CLEAR ^.* is not in need
     matchre RETURN_CLEAR ^But (?:that|you|the)
     matchre RETURN_CLEAR ^What (?:were you|is it)
     matchre RETURN_CLEAR ^There (?:is|is not|isn't)
     matchre RETURN_CLEAR ^In the name of love\?|^Play on
     matchre RETURN_CLEAR ^That (?:cannot|area|can't|won't)
     matchre RETURN_CLEAR ^With a (?:keen|practiced)
     matchre RETURN_CLEAR ^.* what\?
     matchre RETURN_CLEAR ^I don\'t
     matchre RETURN_CLEAR ^Some (?:polished|people|tarnished|.* zills)
     matchre RETURN_CLEAR ^(\S+) has accepted
     matchre RETURN_CLEAR ^You sense that you are as pure of spirit as you can be\, and you are ready for whatever rituals might face you\.
     matchre RETURN_CLEAR ^Subservient type|^The shadows|^Close examination|^Try though
     matchre RETURN_CLEAR ^USAGE\:|^Using your
     matchre RETURN_CLEAR ^Smoking commands are
     matchre RETURN_CLEAR ^Allows a Moon Mage
     matchre RETURN_CLEAR ^A (?:slit|pair|shadow) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^Your (?:actions|dance|nerves) .*(?:\.|\!|\?)?
     matchre RETURN_CLEAR ^You.*analyze
     matchre RETURN_CLEAR ^Having no further use for .*\, you discard it\.
     matchre RETURN_CLEAR ^You don't have a .* coin on you\!\s*The .* spider looks at you in forlorn disappointment\.
     matchre RETURN_CLEAR ^The .* spider turns away\, looking like it's not hungry for what you're offering\.
     matchre RETURN_CLEAR ^After a moment\, .*\.
     matchre RETURN_CLEAR ^.* (?:is|are) not in need of cleaning\.
     matchre RETURN_CLEAR ^Quietly touching your lips with the tips of your fingers as you kneel\, you make the Cleric's sign with your hand\.
     matchre RETURN_CLEAR ^The .* is not damaged enough to warrant repair\.
     matchre RETURN_CLEAR \[Type INVENTORY HELP for more options\]
     matchre RETURN_CLEAR ^A vortex|^A chance for
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
     matchre RETURN_CLEAR ^Without (any|a)
     send %putaction
     matchwait 15
     put #echo >Log Crimson *** MISSING MATCH IN PUT! (%scriptname.cmd) ***
     put #echo >Log Crimson Command = %putaction
     put #log $datetime MISSING MATCH IN PUT! Command = %putaction (%scriptname.cmd)
     return
     
WEAR_ARMOR:
     if %total_armor = 0 then RETURN
     ECHO **** PUTTING YOUR ARMOR BACK ON! ****
     pause 0.5
     if "%armor1" != "null" then
          {
               ECHO *** ARMOR: %armor1 ***
               PUT get my %armor1 from %armor1Container
               pause 0.5
               PUT wear my %armor1
               pause 0.5
               pause 0.3
          }
     if "%armor2" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor2 ***
               PUT get my %armor2 from %armor2Container
               pause 0.5
               PUT wear my %armor2
               pause 0.5
               pause 0.3
          }
     if "%armor3" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor3 ***
               PUT get my %armor3 from %armor3Container
               pause 0.5
               PUT wear my %armor3
               pause 0.5
               pause 0.3
          }
     if "%armor4" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor4 ***
               PUT get my %armor4 from %armor4Container
               pause 0.5
               PUT wear my %armor4
               pause 0.5
               pause 0.3
          }
     if "%armor5" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor5 ***
               PUT get my %armor5 from %armor5Container
               pause 0.5
               PUT wear my %armor5
               pause 0.5
               pause 0.3
          }
     if "%armor6" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor6 ***
               PUT get my %armor6 from %armor6Container
               PUT wear my %armor6
               pause 0.5
               pause 0.3
          }
     if "%armor7" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor7 ***
               PUT get my %armor7 from %armor7Container
               pause 0.5
               PUT wear my %armor7
               pause 0.5
               pause 0.3
          }
     if "%armor8" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor8 ***
               PUT get my %armor8 from %armor8Container
               pause 0.5
               PUT wear my %armor8
               pause 0.5
               pause 0.3
          }
     if "%armor9" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor9 ***
               PUT get my %armor9 from %armor9Container
               pause 0.5
               PUT wear my %armor9
               pause 0.5
          }
     if "%armor10" != "null" then
          {
               gosub stowing
               ECHO *** ARMOR: %armor10 ***
               PUT get my %armor10 from %armor10Container
               pause 0.5
               PUT wear my %armor10
               pause 0.5
          }
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
### STOWING
STOWING:
     pause 0.1
     var location STOWING
     if matchre("%todo", "\b(?i)(NULL|NIL)\b") then return
     if matchre("$righthand $lefthand", "(vine|grass)") then 
          {
               put drop $1
               put drop $1
               pause 0.4
          }
     if matchre("$righthandnoun $lefthandnoun", "rope") then put coil my rope
     if matchre("$righthandnoun $lefthandnoun", "bundle")  then put wear bund;drop bun
     if matchre("$righthandnoun $lefthandnoun", "block")  then put drop block
     pause 0.001
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$lefthand","(longbow|khuj)") then 
          {
               put sheath my $1 in my %SHEATH
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
     if matchre("$righthandnoun $lefthandnoun", "bundle")  then put wear bund;drop bun
     if matchre("$righthandnoun $lefthandnoun", "block")  then put drop block
     pause 0.001
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$righthand $lefthand","(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj|tower shield)") then gosub wear my $1
     if matchre("$lefthand $righthand", "(vine|braided vine)") then gosub PUT drop my vine
     if matchre("$lefthandnoun $righthandnoun", "bundle") then gosub BUNDLE_WEAR
STOW_1:
     delay 0.0001
     pause 0.1
     matchre WAIT ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre OPEN_BAGS ^But that's closed
     matchre STOW_2 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you
     matchre STOW_2 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre STOWLEFT ^You need a free hand
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
	matchre TEND_LODGED ^That .* needs to be tended to be removed.
     matchre RETURN ^That can't be picked up
     matchre RETURN ^Wear what\?|^Stow what\?|Type 'STOW HELP'
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     matchre RETURN needs to be
     matchre GET1 ^But that is already
     put stow %todo
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW (disarm.cmd)
STOW_2:
     if matchre("%container1", "(?i)NULL") then goto STOW_3
     if matchre("$lefthand $righthand", "bundle") then gosub PUT drop bundle
     if matchre("%todo", "(?i)right") then var todo $righthandnoun
     if matchre("%todo","(?i)left") then var todo $lefthandnoun
     delay 0.0001
     pause 0.1
     var LOCATION STOW_2
     matchre STOW_2 ^Perhaps you should
     matchre OPEN_BAGS ^But that's closed
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre STOW_3 ^There\'s no room|^There isn\'t any more room|no matter how you arrange|^What were you
     matchre STOW_3 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     put put %todo in my %container1
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW2! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW2 (disarm.cmd)
STOW_3:
     delay 0.0001
     var LOCATION STOW_3
     if matchre("%container2", "(?i)NULL") then goto STOW_4
     gosub PUT open my %container2
     pause 0.1
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
     if matchre("$lefthandnoun $righthandnoun", "bundle") then gosub PUT drop bundle
     matchre OPEN_BAGS ^But that's closed
     matchre STOW_4 ^There\'s no room|any more room|no matter how you arrange|^What were you
     matchre STOW_4 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre STOW_3 ^Perhaps you should
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     put put %todo in my %container2
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW3! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW3 (disarm.cmd)
STOW_4:
     delay 0.0001
     pause 0.1
     var LOCATION STOW_4
     if matchre("%container3", "(?i)NULL") then goto STOW_5
     if ("$righthand" = "Empty") && ("$lefthand" = "Empty") then return
     if matchre("$lefthandnoun $righthandnoun", "\b(skippet|coffer|trunk|chest|strongbox|crate|box|casket|caddy)\b") then goto DROP_BOX
     if matchre("$lefthandnoun $righthandnoun", "bundle") then gosub PUT drop bundle
     matchre OPEN_BAGS ^But that's closed
     matchre CLOSEIT ^You'll need to close the
     matchre LOCATION.unload ^You (should|need to) unload
     matchre STOW_5 ^There\'s no room|any more room|no matter how you arrange|^What were you
     matchre STOW_5 ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     matchre RETURN ^As you reach for .* it slides quickly out of reach
     put put %todo in my %container3
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
     matchre REM_WEAR ^There\'s no room|any more room|no matter how you arrange|^What were you
     matchre REM_WEAR ^(That\'s|The .*) too (heavy|thick|long|wide)|not designed to carry|cannot hold any more|^(You|I) can't
     matchre RETURN ^Wear what\?|^Stow what\?
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.* to|can't|quickly|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|can\'t|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|corruption|count|secure|unload|remain|release|shield) .*(?:\.|\!|\?)?
     matchre RETURN ^But that is already in your inventory\.
     matchre RETURN ^You stop as you realize
     put put %todo in my %container4
     matchwait 15
     put #echo >Log Crimson  *** MISSING MATCH IN STOW4! (disarm.cmd) ***
     put #echo >Log Crimson  Stow = %todo
     put #log $datetime MISSING MATCH IN STOW4 (disarm.cmd)
OPEN_BAGS:
     pause 0.1
     gosub OPEN %container1
     gosub OPEN %container2
     gosub OPEN %container3
     gosub OPEN %container4
     pause 0.1
     goto STOW_1
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
     delay 0.2
     pause 0.1
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
     pause 0.2
     pause 0.2
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
BLEEDERCHECK:
BLEEDER_CHECK:
BLEEDER.CHECK:
BLEEDCHECK:
     var INFECTED NO
     delay 0.0001
     gosub stowing
     if matchre("$righthandnoun $lefthandnoun", "(spear|fragment|arrow|thorn|bolt|shard|mite|leech)") then put drop $1
     if matchre("$righthandnoun $lefthandnoun", "spear") then put drop spear
     if matchre("$righthandnoun $lefthandnoun", "fragment") then put drop fragment
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "mite") then put drop mite
     pause 0.001
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
     action var POISON YES when ^You.+(poisoned)
     action var POISON YES when ^You.+(poisoned)
BLEEDYES:
     if matchre("$righthandnoun $lefthandnoun", "(spear|fragment|arrow|thorn|bolt|shard|mite|leech)") then put drop $1
     if matchre("$righthandnoun $lefthandnoun", "fragment") then put drop fragment
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     pause 0.01
     echo [Checking for Bleeders]
     pause 0.01
     matchre yesbleeding Bleeding|arrow lodged|bolt lodged|spear lodged|fragment lodged|thorn lodged
     matchre END.OF.BLEEDER ^You pause a moment|^The THINK verb|Syntax:|^Thinking
     matchre bleedyes It\'s all a blur\!
     put -health;-2 think
     matchwait 7
     echo [No bleeder found - exiting bleeder check]
     goto END.OF.BLEEDER
YESBLEEDING:
     echo **** HEALING BLEEDER ****
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
     #if "%BLEEDING_SKIN" = "YES" then gosub tend skin
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
     goto END.OF.BLEEDER
TEND:
     var bleeder $0
     echo ***************************
     echo [Tending Bleeder: %bleeder]
     echo ***************************
     if (%Playing = 1) then send stop play
     pause 0.2
     # if $prone then gosub STAND
tend_bleeder:
     gosub PUT tend my %bleeder
     pause 0.5
     pause 0.2
     pause 0.5
     gosub DUMPSTER_CHECK
     if !matchre("$righthand","Empty") && ("%dumpster" != "NULL") then put put my $righthandnoun in %dumpster
     if !matchre("$lefthand","Empty") && ("%dumpster" != "NULL") then put put my $lefthandnoun in %dumpster
     pause 0.2
     pause 0.2
     if !matchre("$righthand","Empty") && ("%dumpster" != "NULL") then put drop my $righthand
     if !matchre("$lefthand","Empty") && ("%dumpster" != "NULL") then put drop my $lefthand
     pause 0.1
     if matchre("$righthandnoun $lefthandnoun", "spear") then put drop spear
     if matchre("$righthandnoun $lefthandnoun", "fragment") then put drop fragment
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
tend_bleeder2:
     pause 0.1
     gosub put tend my %bleeder
     pause 0.5
     gosub DUMPSTER_CHECK
     if !matchre("$righthand","Empty") && ("%dumpster" != "NULL") then put put my $righthandnoun in %dumpster
     if !matchre("$lefthand","Empty") && ("%dumpster" != "NULL") then put put my $lefthandnoun in %dumpster
     pause 0.2
     pause 0.2
     if !matchre("$righthand","Empty") && ("%dumpster" != "NULL") then put drop my $righthand
     if !matchre("$lefthand","Empty") && ("%dumpster" != "NULL") then put drop my $lefthand
     pause 0.1
     if matchre("$righthandnoun $lefthandnoun", "spear") then put drop spear
     if matchre("$righthandnoun $lefthandnoun", "fragment") then put drop fragment
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     if matchre("$righthandnoun $lefthandnoun", "arrow") then put drop arrow
     if matchre("$righthandnoun $lefthandnoun", "thorn") then put drop thorn
     if matchre("$righthandnoun $lefthandnoun", "bolt") then put drop bolt
     pause 0.1
     pause 0.1
     echo [Leaving Bleeder System]
     return
END.OF.BLEEDER:
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
     pause 0.1
     pause 0.1
     pause 0.1
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