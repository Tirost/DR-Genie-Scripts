if "$charactername" = "Dasffion" then goto CHARACTER1
if "$charactername" = "Dasbarb" then goto CHARACTER2
if "$charactername" = "Rishlu" then goto CHARACTER3
if "$charactername" = "Rult" then goto CHARACTER4
if "$charactername" = "Aerog" then goto CHARACTER5
echo You did not set your character name correctly. Please edit MC_SETUP
exit

#######################################################################
##################  CHARACTER 1 VARIABLES  ############################
#######################################################################
CHARACTER1:
#######################################################################
####################  FORGING VARIABLES  ##############################
#######################################################################
#	Variables are case sensitive
#	MC_FORGING.DISCIPLINE: OPTIONS blacksmith, weapon, armor
#	MC_FORGING.MATERIAL: Material type adjactive i.e. bronze, steel
#	MC_FORGING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_FORGING.DEED: DEED orders instead of bundling items on or off
#	MC_SMALL.ORDERS: For only working orders 5 volumes or smaller, 0 for off, 1 for on
put #var MC_FORGING.STORAGE shoulder pack
put #var MC_FORGING.DISCIPLINE weapon
put #var MC_FORGING.MATERIAL steel
put #var MC_FORGING.DIFFICULTY hard
put #var MC_FORGING.DEED off
put #var MC_SMALL.ORDERS 0
#######################################################################
###################  ENGINEERING VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_ENG.DISCIPLINE: OPTIONS carving, shaping, tinkering
#	MC_ENG.MATERIAL: Material type adjactive i.e. maple, basalt, deer-bone
#	MC_ENG.PREF: Material type noun i.e. lumber, bone, stone
#	MC_ENG.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_ENG.DEED: DEED orders instead of bundling items on or off
put #var MC_ENGINEERING.STORAGE shoulder pack
put #var MC_ENG.DISCIPLINE carving
put #var MC_ENG.MATERIAL wolf-bone
put #var MC_ENG.PREF bone
put #var MC_ENG.DIFFICULTY hard
put #var MC_ENG.DEED off
#######################################################################
########################  OUTFITTING VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_OUT.DISCIPLINE: OPTIONS tailor
#	MC_OUT.MATERIAL: Material type adjactive i.e. wool, burlap, rat-pelt
#	MC_OUT.PREF: Material type noun i.e. yarn, cloth, leather
#	MC_OUT.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_OUT.DEED: DEED orders instead of bundling items on or off
put #var MC_OUTFITTING.STORAGE satchel
put #var MC_OUT.DISCIPLINE tailor
put #var MC_OUT.MATERIAL wool
put #var MC_OUT.PREF cloth
put #var MC_OUT.DIFFICULTY hard
put #var MC_OUT.DEED off
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ALC.DISCIPLINE: OPTIONS remed NOTE: Do not do remedy or remedies. This is the only way to get the book to work for all types
#	MC_ALC.DIFFICULTY: Order difficulty easy, challenging, hard
put #var MC_ALCHEMY.STORAGE shoulder pack
put #var MC_ALC.DISCIPLINE remed
put #var MC_ALC.DIFFICULTY challenging
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ENCHANTING.DISCIPLINE: OPTIONS artif NOTE: Do not do artifcer or artificing. This is the only way to get the book to work for all types
#	MC_ENCHANTING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_IMBUE: ROD or SPELL determines if you're going to cast or use a rod. You will need to have a rod on you if you're going to use it. Needs to be all caps
# 	MC_IMBUE.MANA: Amount of mana you want to cast at if you're using MC_IMBUE SPELL
#	MC_FOCUS.WAND: The name of the wand you are using for focusing. If you are a magic user it's not needed, leave it commented. If you are using it I suggest being as descriptive as possible

put #var MC_ENCHANTING.STORAGE shoulder pack
put #var MC_ENCHANTING.DISCIPLINE artif
put #var MC_ENCHANTING.DIFFICULTY challenging
put #var MC_IMBUE ROD
put #var MC_IMBUE.MANA 50
#put #var MC_FOCUS.WAND wood wand
#######################################################################
##########################  MISC VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_TOOL.STORAGE: Where you want to store your tools
# 	MC_REPAIR: For repairing your tools, if MC_AUTO.REPAIR is off you will go to the repair shop, on or off
#	MC_AUTO.REPAIR: For repairing your own tools, on or off
#	MC_GET.COIN: For getting more coin if you run out while purchasing, on or off
#	MC_REORDER: For repurchasing mats, on or off
#	MC_REMNANT.STORAGE: Where small items will go. This needs to be different from your discipline storage
#	MC_MARK: For Marking your working on or off
#	MC_BLACKLIST: Orders that you don't want to take, must be the noun of the items
#	MC_WORK.OUTSIDE: If you want to work outside of the order hall set to 1 if not leave as 0, must set MC_PREFERRED.ROOM if set to 1
#	MC_PREFERRED.ROOM: Set as the roomid of where you want to work on your orders
#	MC_FRIENDLIST: Names of people you want to ignore when looking for an empty room i.e. Johnny|Tim|Barney
#	MC_ENDEARLY: Set to 1 if you want to stop mastercraft when your mindstate is above 30. Will check after each item. 0 if you don't
#	MC_NOWO: Set to 1 if you don't want to do work orders. This will still ask the master for a work order to get an item name, it just won't bundle
#	MC_MAX.ORDER: Maximum number of items to craft, will get a new work order if above this number
# 	MC_MIN.ORDER: Minimum number of items to craft, will get a new work order if below this number
put #var MC_TOOL.STORAGE shoulder pack
put #var MC_REPAIR on
put #var MC_AUTO.REPAIR on
put #var MC_GET.COIN on
put #var MC_REORDER on
put #var MC_REMNANT.STORAGE canvas sack
put #var MC.Mark off
put #var MC_BLACKLIST none
put #var MC_WORK.OUTSIDE 0
#put #var MC_PREFERRED.ROOM 
#put #var MC_FRIENDLIST
put #var MC_NOWO 0
put #var MC_END.EARLY 0
put #var MC_MAX.ORDER 4
put #var MC_MIN.ORDER 3
#######################################################################
##########################  TOOL VARIABLES  ###########################
#######################################################################
## These should match what is shown in your hands. If you're having trouble knowing what to put hold it in your right
## hand and #echo $righthand copy what is shown and paste that.
#FORGING
put #var MC_HAMMER silversteel mallet
put #var MC_SHOVEL glaes-edged shovel
put #var MC_TONGS muracite tongs
put #var MC_PLIERS hooked pliers
put #var MC_BELLOWS leather bellows
put #var MC_STIRROD stirring rod
#ENGINEERING
put #var MC_CHISEL iron chisel
put #var MC_SAW bone saw
put #var MC_RASP iron rasp
put #var MC_RIFFLER square riffler
put #var MC_TINKERTOOL tools
put #var MC_CARVINGKNIFE carving knife
put #var MC_SHAPER wood shaper
put #var MC_DRAWKNIFE metal drawknife
put #var MC_CLAMP metal clamps
#OUTFITTING
put #var MC_NEEDLES sewing needles
put #var MC_SCISSORS ka'hurst scissors
put #var MC_SLICKSTONE slickstone
put #var MC_YARDSTICK silversteel yardstick
put #var MC_AWL uthamar awl
#ALCHEMY
put #var MC_BOWL purpleheart bowl
put #var MC_MORTAR stone mortar
put #var MC_STICK mixing stick
put #var MC_PESTLE belzune pestle
put #var MC_SIEVE wirework sieve
#ENCHANTING
put #var MC_BURIN burin
put #var MC_LOOP loop
goto endsetup

#######################################################################
##################  CHARACTER 2 VARIABLES  ############################
#######################################################################
CHARACTER2:
#######################################################################
####################  FORGING VARIABLES  ##############################
#######################################################################
#	Variables are case sensitive
#	MC_FORGING.DISCIPLINE: OPTIONS blacksmith, weapon, armor
#	MC_FORGING.MATERIAL: Material type adjactive i.e. bronze, steel
#	MC_FORGING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_FORGING.DEED: DEED orders instead of bundling items on or off
#	MC_SMALL.ORDERS: For only working orders 5 volumes or smaller, 0 for off, 1 for on
put #var MC_FORGING.STORAGE shoulder pack
put #var MC_FORGING.DISCIPLINE weapon
put #var MC_FORGING.MATERIAL steel
put #var MC_FORGING.DIFFICULTY hard
put #var MC_FORGING.DEED off
put #var MC_SMALL.ORDERS 0
#######################################################################
###################  ENGINEERING VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_ENG.DISCIPLINE: OPTIONS carving, shaping, tinkering
#	MC_ENG.MATERIAL: Material type adjactive i.e. maple, basalt, deer-bone
#	MC_ENG.PREF: Material type noun i.e. lumber, bone, stone
#	MC_ENG.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_ENG.DEED: DEED orders instead of bundling items on or off
put #var MC_ENGINEERING.STORAGE shoulder pack
put #var MC_ENG.DISCIPLINE carving
put #var MC_ENG.MATERIAL wolf-bone
put #var MC_ENG.PREF bone
put #var MC_ENG.DIFFICULTY hard
put #var MC_ENG.DEED off
#######################################################################
########################  OUTFITTING VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_OUT.DISCIPLINE: OPTIONS tailor
#	MC_OUT.MATERIAL: Material type adjactive i.e. wool, burlap, rat-pelt
#	MC_OUT.PREF: Material type noun i.e. yarn, cloth, leather
#	MC_OUT.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_OUT.DEED: DEED orders instead of bundling items on or off
put #var MC_OUTFITTING.STORAGE satchel
put #var MC_OUT.DISCIPLINE tailor
put #var MC_OUT.MATERIAL wool
put #var MC_OUT.PREF cloth
put #var MC_OUT.DIFFICULTY hard
put #var MC_OUT.DEED off
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ALC.DISCIPLINE: OPTIONS remed NOTE: Do not do remedy or remedies. This is the only way to get the book to work for all types
#	MC_ALC.DIFFICULTY: Order difficulty easy, challenging, hard
put #var MC_ALCHEMY.STORAGE shoulder pack
put #var MC_ALC.DISCIPLINE remed
put #var MC_ALC.DIFFICULTY challenging
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ENCHANTING.DISCIPLINE: OPTIONS artif NOTE: Do not do artifcer or artificing. This is the only way to get the book to work for all types
#	MC_ENCHANTING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_IMBUE: ROD or SPELL determines if you're going to cast or use a rod. You will need to have a rod on you if you're going to use it. Needs to be all caps
# 	MC_IMBUE.MANA: Amount of mana you want to cast at if you're using MC_IMBUE SPELL
#	MC_FOCUS.WAND: The name of the wand you are using for focusing. If you are a magic user it's not needed, leave it commented. If you are using it I suggest being as descriptive as possible

put #var MC_ENCHANTING.STORAGE shoulder pack
put #var MC_ENCHANTING.DISCIPLINE artif
put #var MC_ENCHANTING.DIFFICULTY challenging
put #var MC_IMBUE ROD
put #var MC_IMBUE.MANA 50
put #var MC_FOCUS.WAND wood wand
#######################################################################
##########################  MISC VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_TOOL.STORAGE: Where you want to store your tools
# 	MC_REPAIR: For repairing your tools, if MC_AUTO.REPAIR is off you will go to the repair shop, on or off
#	MC_AUTO.REPAIR: For repairing your own tools, on or off
#	MC_GET.COIN: For getting more coin if you run out while purchasing, on or off
#	MC_REORDER: For repurchasing mats, on or off
#	MC_REMNANT.STORAGE: Where small items will go. This needs to be different from your discipline storage
#	MC_MARK: For Marking your working on or off
#	MC_BLACKLIST: Orders that you don't want to take, must be the noun of the items
#	MC_WORK.OUTSIDE: If you want to work outside of the order hall set to 1 if not leave as 0, must set MC_PREFERRED.ROOM if set to 1
#	MC_PREFERRED.ROOM: Set as the roomid of where you want to work on your orders
#	MC_FRIENDLIST: Names of people you want to ignore when looking for an empty room i.e. Johnny|Tim|Barney
#	MC_ENDEARLY: Set to 1 if you want to stop mastercraft when your mindstate is above 30. Will check after each item. 0 if you don't
#	MC_NOWO: Set to 1 if you don't want to do work orders. This will still ask the master for a work order to get an item name, it just won't bundle
#	MC_MAX.ORDER: Maximum number of items to craft, will get a new work order if above this number
# 	MC_MIN.ORDER: Minimum number of items to craft, will get a new work order if below this number
put #var MC_TOOL.STORAGE shoulder pack
put #var MC_REPAIR on
put #var MC_AUTO.REPAIR on
put #var MC_GET.COIN on
put #var MC_REORDER on
put #var MC_REMNANT.STORAGE canvas sack
put #var MC.Mark off
put #var MC_BLACKLIST none
put #var MC_WORK.OUTSIDE 0
#put #var MC_PREFERRED.ROOM 
#put #var MC_FRIENDLIST
put #var MC_NOWO 1
put #var MC_END.EARLY 0
put #var MC_MAX.ORDER 4
put #var MC_MIN.ORDER 3
#######################################################################
##########################  TOOL VARIABLES  ###########################
#######################################################################
#FORGING
put #var MC_HAMMER silversteel mallet
put #var MC_SHOVEL wide shovel
put #var MC_TONGS box-jaw tongs
put #var MC_PLIERS hooked pliers
put #var MC_BELLOWS corrugated-hide bellows
put #var MC_STIRROD stirring rod
#ENGINEERING
put #var MC_CHISEL iron chisel
put #var MC_SAW bone saw
put #var MC_RASP iron rasp
put #var MC_RIFFLER square riffler
put #var MC_TINKERTOOL tools
put #var MC_CARVINGKNIFE carving knife
put #var MC_SHAPER wood shaper
put #var MC_DRAWKNIFE metal drawknife
put #var MC_CLAMP metal clamps
#OUTFITTING
put #var MC_NEEDLES sewing needles
put #var MC_SCISSORS ka'hurst scissors
put #var MC_SLICKSTONE slickstone
put #var MC_YARDSTICK silversteel yardstick
put #var MC_AWL uthamar awl
#ALCHEMY
put #var MC_BOWL alabaster bowl
put #var MC_MORTAR stone mortar
put #var MC_STICK mixing stick
put #var MC_PESTLE grooved pestle
put #var MC_SIEVE wire sieve
#ENCHANTING
put #var MC_BURIN burin
put #var MC_LOOP loop
goto endsetup

#######################################################################
##################  CHARACTER 3 VARIABLES  ############################
#######################################################################
CHARACTER3:
#######################################################################
####################  FORGING VARIABLES  ##############################
#######################################################################
#	Variables are case sensitive
#	MC_FORGING.DISCIPLINE: OPTIONS blacksmith, weapon, armor
#	MC_FORGING.MATERIAL: Material type adjactive i.e. bronze, steel
#	MC_FORGING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_FORGING.DEED: DEED orders instead of bundling items on or off
#	MC_SMALL.ORDERS: For only working orders 5 volumes or smaller, 0 for off, 1 for on
put #var MC_FORGING.STORAGE shoulder pack
put #var MC_FORGING.DISCIPLINE weapon
put #var MC_FORGING.MATERIAL steel
put #var MC_FORGING.DIFFICULTY hard
put #var MC_FORGING.DEED off
put #var MC_SMALL.ORDERS 0
#######################################################################
###################  ENGINEERING VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_ENG.DISCIPLINE: OPTIONS carving, shaping, tinkering
#	MC_ENG.MATERIAL: Material type adjactive i.e. maple, basalt, deer-bone
#	MC_ENG.PREF: Material type noun i.e. lumber, bone, stone
#	MC_ENG.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_ENG.DEED: DEED orders instead of bundling items on or off
put #var MC_ENGINEERING.STORAGE shoulder pack
put #var MC_ENG.DISCIPLINE carving
put #var MC_ENG.MATERIAL wolf-bone
put #var MC_ENG.PREF bone
put #var MC_ENG.DIFFICULTY hard
put #var MC_ENG.DEED off
#######################################################################
########################  OUTFITTING VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_OUT.DISCIPLINE: OPTIONS tailor
#	MC_OUT.MATERIAL: Material type adjactive i.e. wool, burlap, rat-pelt
#	MC_OUT.PREF: Material type noun i.e. yarn, cloth, leather
#	MC_OUT.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_OUT.DEED: DEED orders instead of bundling items on or off
put #var MC_OUTFITTING.STORAGE shoulder pack
put #var MC_OUT.DISCIPLINE tailor
put #var MC_OUT.MATERIAL wool
put #var MC_OUT.PREF cloth
put #var MC_OUT.DIFFICULTY hard
put #var MC_OUT.DEED off
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ALC.DISCIPLINE: OPTIONS remed NOTE: Do not do remedy or remedies. This is the only way to get the book to work for all types
#	MC_ALC.DIFFICULTY: Order difficulty easy, challenging, hard
put #var MC_ALCHEMY.STORAGE shoulder pack
put #var MC_ALC.DISCIPLINE remed
put #var MC_ALC.DIFFICULTY challenging
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ENCHANTING.DISCIPLINE: OPTIONS artif NOTE: Do not do artifcer or artificing. This is the only way to get the book to work for all types
#	MC_ENCHANTING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_IMBUE: ROD or SPELL determines if you're going to cast or use a rod. You will need to have a rod on you if you're going to use it. Needs to be all caps
# 	MC_IMBUE.MANA: Amount of mana you want to cast at if you're using MC_IMBUE SPELL
#	MC_FOCUS.WAND: The name of the wand you are using for focusing. If you are a magic user it's not needed, leave it commented. If you are using it I suggest being as descriptive as possible

put #var MC_ENCHANTING.STORAGE shoulder pack
put #var MC_ENCHANTING.DISCIPLINE artif
put #var MC_ENCHANTING.DIFFICULTY challenging
put #var MC_IMBUE ROD
put #var MC_IMBUE.MANA 50
#put #var MC_FOCUS.WAND wood wand
#######################################################################
##########################  MISC VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_TOOL.STORAGE: Where you want to store your tools
# 	MC_REPAIR: For repairing your tools, if MC_AUTO.REPAIR is off you will go to the repair shop, on or off
#	MC_AUTO.REPAIR: For repairing your own tools, on or off
#	MC_GET.COIN: For getting more coin if you run out while purchasing, on or off
#	MC_REORDER: For repurchasing mats, on or off
#	MC_REMNANT.STORAGE: Where small items will go. This needs to be different from your discipline storage
#	MC_MARK: For Marking your working on or off
#	MC_BLACKLIST: Orders that you don't want to take, must be the noun of the items
#	MC_WORK.OUTSIDE: If you want to work outside of the order hall set to 1 if not leave as 0, must set MC_PREFERRED.ROOM if set to 1
#	MC_PREFERRED.ROOM: Set as the roomid of where you want to work on your orders
#	MC_FRIENDLIST: Names of people you want to ignore when looking for an empty room i.e. Johnny|Tim|Barney
#	MC_ENDEARLY: Set to 1 if you want to stop mastercraft when your mindstate is above 30. Will check after each item. 0 if you don't
#	MC_NOWO: Set to 1 if you don't want to do work orders. This will still ask the master for a work order to get an item name, it just won't bundle
#	MC_MAX.ORDER: Maximum number of items to craft, will get a new work order if above this number
# 	MC_MIN.ORDER: Minimum number of items to craft, will get a new work order if below this number
put #var MC_TOOL.STORAGE shoulder pack
put #var MC_REPAIR on
put #var MC_AUTO.REPAIR on
put #var MC_GET.COIN on
put #var MC_REORDER on
put #var MC_REMNANT.STORAGE canvas sack
put #var MC.Mark off
put #var MC_BLACKLIST none
put #var MC_WORK.OUTSIDE 0
#put #var MC_PREFERRED.ROOM 
#put #var MC_FRIENDLIST
put #var MC_NOWO 1
put #var MC_END.EARLY 0
put #var MC_MAX.ORDER 4
put #var MC_MIN.ORDER 3
#######################################################################
##########################  TOOL VARIABLES  ###########################
#######################################################################
#FORGING
put #var MC_HAMMER silversteel mallet
put #var MC_SHOVEL wide shovel
put #var MC_TONGS box-jaw tongs
put #var MC_PLIERS hooked pliers
put #var MC_BELLOWS corrugated-hide bellows
put #var MC_STIRROD stirring rod
#ENGINEERING
put #var MC_CHISEL iron chisel
put #var MC_SAW bone saw
put #var MC_RASP iron rasp
put #var MC_RIFFLER square riffler
put #var MC_TINKERTOOL tools
put #var MC_CARVINGKNIFE carving knife
put #var MC_SHAPER wood shaper
put #var MC_DRAWKNIFE metal drawknife
put #var MC_CLAMP metal clamps
#OUTFITTING
put #var MC_NEEDLES sewing needles
put #var MC_SCISSORS ka'hurst scissors
put #var MC_SLICKSTONE slickstone
put #var MC_YARDSTICK silversteel yardstick
put #var MC_AWL uthamar awl
#ALCHEMY
put #var MC_BOWL alabaster bowl
put #var MC_MORTAR stone mortar
put #var MC_STICK mixing stick
put #var MC_PESTLE grooved pestle
put #var MC_SIEVE wire sieve
#ENCHANTING
put #var MC_BURIN burin
put #var MC_LOOP loop
goto endsetup

#######################################################################
##################  CHARACTER 4 VARIABLES  ############################
#######################################################################
CHARACTER4:
#######################################################################
####################  FORGING VARIABLES  ##############################
#######################################################################
#	Variables are case sensitive
#	MC_FORGING.DISCIPLINE: OPTIONS blacksmith, weapon, armor
#	MC_FORGING.MATERIAL: Material type adjactive i.e. bronze, steel
#	MC_FORGING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_FORGING.DEED: DEED orders instead of bundling items on or off
#	MC_SMALL.ORDERS: For only working orders 5 volumes or smaller, 0 for off, 1 for on
put #var MC_FORGING.STORAGE bag
put #var MC_FORGING.DISCIPLINE blacksmith
put #var MC_FORGING.MATERIAL bronze
put #var MC_FORGING.DIFFICULTY easy
put #var MC_FORGING.DEED off
put #var MC_SMALL.ORDERS 0
#######################################################################
###################  ENGINEERING VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_ENG.DISCIPLINE: OPTIONS carving, shaping, tinkering
#	MC_ENG.MATERIAL: Material type adjactive i.e. maple, basalt, deer-bone
#	MC_ENG.PREF: Material type noun i.e. lumber, bone, stone
#	MC_ENG.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_ENG.DEED: DEED orders instead of bundling items on or off
put #var MC_ENGINEERING.STORAGE bag
put #var MC_ENG.DISCIPLINE carving
put #var MC_ENG.MATERIAL wolf-bone
put #var MC_ENG.PREF bone
put #var MC_ENG.DIFFICULTY challenging
put #var MC_ENG.DEED off
#######################################################################
########################  OUTFITTING VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_OUT.DISCIPLINE: OPTIONS tailor
#	MC_OUT.MATERIAL: Material type adjactive i.e. wool, burlap, rat-pelt
#	MC_OUT.PREF: Material type noun i.e. yarn, cloth, leather
#	MC_OUT.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_OUT.DEED: DEED orders instead of bundling items on or off
put #var MC_OUTFITTING.STORAGE bag
put #var MC_OUT.DISCIPLINE tailor
put #var MC_OUT.MATERIAL wool
put #var MC_OUT.PREF cloth
put #var MC_OUT.DIFFICULTY challenging
put #var MC_OUT.DEED off
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ALC.DISCIPLINE: OPTIONS remed NOTE: Do not do remedy or remedies. This is the only way to get the book to work for all types
#	MC_ALC.DIFFICULTY: Order difficulty easy, challenging, hard
put #var MC_ALCHEMY.STORAGE shoulder pack
put #var MC_ALC.DISCIPLINE remed
put #var MC_ALC.DIFFICULTY challenging
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ENCHANTING.DISCIPLINE: OPTIONS artif NOTE: Do not do artifcer or artificing. This is the only way to get the book to work for all types
#	MC_ENCHANTING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_IMBUE: ROD or SPELL determines if you're going to cast or use a rod. You will need to have a rod on you if you're going to use it. Needs to be all caps
# 	MC_IMBUE.MANA: Amount of mana you want to cast at if you're using MC_IMBUE SPELL
#	MC_FOCUS.WAND: The name of the wand you are using for focusing. If you are a magic user it's not needed, leave it commented. If you are using it I suggest being as descriptive as possible


put #var MC_ENCHANTING.STORAGE shoulder pack
put #var MC_ENCHANTING.DISCIPLINE artif
put #var MC_ENCHANTING.DIFFICULTY challenging
put #var MC_IMBUE ROD
put #var MC_IMBUE.MANA 50
#put #var MC_FOCUS.WAND wood wand
#######################################################################
##########################  MISC VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_TOOL.STORAGE: Where you want to store your tools
# 	MC_REPAIR: For repairing your tools, if MC_AUTO.REPAIR is off you will go to the repair shop, on or off
#	MC_AUTO.REPAIR: For repairing your own tools, on or off
#	MC_GET.COIN: For getting more coin if you run out while purchasing, on or off
#	MC_REORDER: For repurchasing mats, on or off
#	MC_REMNANT.STORAGE: Where small items will go. This needs to be different from your discipline storage
#	MC_MARK: For Marking your working on or off
#	MC_BLACKLIST: Orders that you don't want to take, must be the noun of the items
#	MC_WORK.OUTSIDE: If you want to work outside of the order hall set to 1 if not leave as 0, must set MC_PREFERRED.ROOM if set to 1
#	MC_PREFERRED.ROOM: Set as the roomid of where you want to work on your orders
#	MC_FRIENDLIST: Names of people you want to ignore when looking for an empty room i.e. Johnny|Tim|Barney
#	MC_ENDEARLY: Set to 1 if you want to stop mastercraft when your mindstate is above 30. Will check after each item. 0 if you don't
#	MC_NOWO: Set to 1 if you don't want to do work orders. This will still ask the master for a work order to get an item name, it just won't bundle
#	MC_MAX.ORDER: Maximum number of items to craft, will get a new work order if above this number
# 	MC_MIN.ORDER: Minimum number of items to craft, will get a new work order if below this number
put #var MC_TOOL.STORAGE shoulder pack
put #var MC_REPAIR on
put #var MC_AUTO.REPAIR off
put #var MC_GET.COIN on
put #var MC_REORDER on
put #var MC_REMNANT.STORAGE haversack
put #var MC.Mark off
put #var MC_BLACKLIST none
put #var MC_WORK.OUTSIDE 0
#put #var MC_PREFERRED.ROOM 
#put #var MC_FRIENDLIST
put #var MC_NOWO 0
put #var MC_END.EARLY 0
put #var MC_MAX.ORDER 3
put #var MC_MIN.ORDER 1
#######################################################################
##########################  TOOL VARIABLES  ###########################
#######################################################################
#FORGING
put #var MC_HAMMER silversteel mallet
put #var MC_SHOVEL wide shovel
put #var MC_TONGS box-jaw tongs
put #var MC_PLIERS hooked pliers
put #var MC_BELLOWS corrugated-hide bellows
put #var MC_STIRROD stirring rod
#ENGINEERING
put #var MC_CHISEL iron chisel
put #var MC_SAW bone saw
put #var MC_RASP iron rasp
put #var MC_RIFFLER square riffler
put #var MC_TINKERTOOL tools
put #var MC_CARVINGKNIFE carving knife
put #var MC_SHAPER wood shaper
put #var MC_DRAWKNIFE metal drawknife
put #var MC_CLAMP metal clamps
#OUTFITTING
put #var MC_NEEDLES sewing needles
put #var MC_SCISSORS ka'hurst scissors
put #var MC_SLICKSTONE slickstone
put #var MC_YARDSTICK silversteel yardstick
put #var MC_AWL uthamar awl
#ALCHEMY
put #var MC_BOWL alabaster bowl
put #var MC_MORTAR stone mortar
put #var MC_STICK mixing stick
put #var MC_PESTLE grooved pestle
put #var MC_SIEVE wire sieve
#ENCHANTING
put #var MC_BURIN burin
put #var MC_LOOP loop
goto endsetup

#######################################################################
##################  CHARACTER 5 VARIABLES  ############################
#######################################################################
CHARACTER5:
#######################################################################
####################  FORGING VARIABLES  ##############################
#######################################################################
#	Variables are case sensitive
#	MC_FORGING.DISCIPLINE: OPTIONS blacksmith, weapon, armor
#	MC_FORGING.MATERIAL: Material type adjactive i.e. bronze, steel
#	MC_FORGING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_FORGING.DEED: DEED orders instead of bundling items on or off
#	MC_SMALL.ORDERS: For only working orders 5 volumes or smaller, 0 for off, 1 for on
put #var MC_FORGING.STORAGE shoulder pack
put #var MC_FORGING.DISCIPLINE weapon
put #var MC_FORGING.MATERIAL steel
put #var MC_FORGING.DIFFICULTY hard
put #var MC_FORGING.DEED off
put #var MC_SMALL.ORDERS 0
#######################################################################
###################  ENGINEERING VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_ENG.DISCIPLINE: OPTIONS carving, shaping, tinkering
#	MC_ENG.MATERIAL: Material type adjactive i.e. maple, basalt, deer-bone
#	MC_ENG.PREF: Material type noun i.e. lumber, bone, stone
#	MC_ENG.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_ENG.DEED: DEED orders instead of bundling items on or off
put #var MC_ENGINEERING.STORAGE shoulder pack
put #var MC_ENG.DISCIPLINE carving
put #var MC_ENG.MATERIAL wolf-bone
put #var MC_ENG.PREF bone
put #var MC_ENG.DIFFICULTY hard
put #var MC_ENG.DEED off
#######################################################################
########################  OUTFITTING VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_OUT.DISCIPLINE: OPTIONS tailor
#	MC_OUT.MATERIAL: Material type adjactive i.e. wool, burlap, rat-pelt
#	MC_OUT.PREF: Material type noun i.e. yarn, cloth, leather
#	MC_OUT.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_OUT.DEED: DEED orders instead of bundling items on or off
put #var MC_OUTFITTING.STORAGE shoulder pack
put #var MC_OUT.DISCIPLINE tailor
put #var MC_OUT.MATERIAL wool
put #var MC_OUT.PREF cloth
put #var MC_OUT.DIFFICULTY hard
put #var MC_OUT.DEED off
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ALC.DISCIPLINE: OPTIONS remed NOTE: Do not do remedy or remedies. This is the only way to get the book to work for all types
#	MC_ALC.DIFFICULTY: Order difficulty easy, challenging, hard
put #var MC_ALCHEMY.STORAGE shoulder pack
put #var MC_ALC.DISCIPLINE remed
put #var MC_ALC.DIFFICULTY challenging
#######################################################################
########################  ALCHEMY VARIABLES  #######################
#######################################################################
#	Variables are case sensitive
#	MC_ENCHANTING.DISCIPLINE: OPTIONS artif NOTE: Do not do artifcer or artificing. This is the only way to get the book to work for all types
#	MC_ENCHANTING.DIFFICULTY: Order difficulty easy, challenging, hard
#	MC_IMBUE: ROD or SPELL determines if you're going to cast or use a rod. You will need to have a rod on you if you're going to use it. Needs to be all caps
# 	MC_IMBUE.MANA: Amount of mana you want to cast at if you're using MC_IMBUE SPELL
#	MC_FOCUS.WAND: The name of the wand you are using for focusing. If you are a magic user it's not needed, leave it commented. If you are using it I suggest being as descriptive as possible


put #var MC_ENCHANTING.STORAGE backpack
put #var MC_ENCHANTING.DISCIPLINE artif
put #var MC_ENCHANTING.DIFFICULTY easy
put #var MC_IMBUE ROD
put #var MC_IMBUE.MANA 50
#put #var MC_FOCUS.WAND wood wand
#######################################################################
##########################  MISC VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
#	MC_TOOL.STORAGE: Where you want to store your tools
# 	MC_REPAIR: For repairing your tools, if MC_AUTO.REPAIR is off you will go to the repair shop, on or off
#	MC_AUTO.REPAIR: For repairing your own tools, on or off
#	MC_GET.COIN: For getting more coin if you run out while purchasing, on or off
#	MC_REORDER: For repurchasing mats, on or off
#	MC_REMNANT.STORAGE: Where small items will go. This needs to be different from your discipline storage
#	MC_MARK: For Marking your working on or off
#	MC_BLACKLIST: Orders that you don't want to take, must be the noun of the items
#	MC_WORK.OUTSIDE: If you want to work outside of the order hall set to 1 if not leave as 0, must set MC_PREFERRED.ROOM if set to 1
#	MC_PREFERRED.ROOM: Set as the roomid of where you want to work on your orders
#	MC_FRIENDLIST: Names of people you want to ignore when looking for an empty room i.e. Johnny|Tim|Barney
#	MC_ENDEARLY: Set to 1 if you want to stop mastercraft when your mindstate is above 30. Will check after each item. 0 if you don't
#	MC_NOWO: Set to 1 if you don't want to do work orders. This will still ask the master for a work order to get an item name, it just won't bundle
#	MC_MAX.ORDER: Maximum number of items to craft, will get a new work order if above this number
# 	MC_MIN.ORDER: Minimum number of items to craft, will get a new work order if below this number
put #var MC_TOOL.STORAGE shoulder pack
put #var MC_REPAIR on
put #var MC_AUTO.REPAIR on
put #var MC_GET.COIN on
put #var MC_REORDER on
put #var MC_REMNANT.STORAGE canvas sack
put #var MC.Mark off
put #var MC_BLACKLIST none
put #var MC_WORK.OUTSIDE 0
#put #var MC_PREFERRED.ROOM 
#put #var MC_FRIENDLIST
put #var MC_NOWO 0
put #var MC_END.EARLY 0
put #var MC_MAX.ORDER 4
put #var MC_MIN.ORDER 3
#######################################################################
##########################  TOOL VARIABLES  ###########################
#######################################################################
#FORGING
put #var MC_HAMMER silversteel mallet
put #var MC_SHOVEL wide shovel
put #var MC_TONGS box-jaw tongs
put #var MC_PLIERS hooked pliers
put #var MC_BELLOWS corrugated-hide bellows
put #var MC_STIRROD stirring rod
#ENGINEERING
put #var MC_CHISEL iron chisel
put #var MC_SAW bone saw
put #var MC_RASP iron rasp
put #var MC_RIFFLER square riffler
put #var MC_TINKERTOOL tools
put #var MC_CARVINGKNIFE carving knife
put #var MC_SHAPER wood shaper
put #var MC_DRAWKNIFE metal drawknife
put #var MC_CLAMP metal clamps
#OUTFITTING
put #var MC_NEEDLES sewing needles
put #var MC_SCISSORS ka'hurst scissors
put #var MC_SLICKSTONE slickstone
put #var MC_YARDSTICK silversteel yardstick
put #var MC_AWL uthamar awl
#ALCHEMY
put #var MC_BOWL alabaster bowl
put #var MC_MORTAR stone mortar
put #var MC_STICK mixing stick
put #var MC_PESTLE grooved pestle
put #var MC_SIEVE wire sieve
#ENCHANTING
put #var MC_BURIN burin
put #var MC_LOOP loop
goto endsetup

endsetup:
### DONT MODIFY THIS
if !def(lastToolRepair) then put #var lastToolRepair 0