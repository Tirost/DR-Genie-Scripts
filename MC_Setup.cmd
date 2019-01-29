
#######################################################################
####################  FORGING VARIABLES  ##############################
#######################################################################
#	Variables are case sensitive
#	MC_FORGING.DISCIPLINE: OPTIONS blacksmith, weapon, armor
#	MC_FORGING.MATERIAL: Material type adjactive i.e. bronze, steel
#	MC_FORGING.DIFFICULTY: Order difficulty east, challenging, hard
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
#	MC_ENG.DIFFICULTY: Order difficulty east, challenging, hard
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
#	MC_OUT.DIFFICULTY: Order difficulty east, challenging, hard
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
#	MC_OUT.DISCIPLINE: OPTIONS remed NOTE: Do not do remedy or remedies. This is the only way to get the book to work for all types
#	MC_OUT.MATERIAL: Material type adjactive i.e. wool, burlap, rat-pelt
#	MC_OUT.PREF: Material type noun i.e. yarn, cloth, leather
#	MC_OUT.DIFFICULTY: Order difficulty east, challenging, hard
#	MC_OUT.DEED: DEED orders instead of bundling items on or off
put #var MC_ALCHEMY.STORAGE shoulder pack
put #var MC_ALC.DISCIPLINE remed
put #var MC_ALC.DIFFICULTY easy
#######################################################################
##########################  MISC VARIABLES  ###########################
#######################################################################
#	Variables are case sensitive
# 	MC_REPAIR: For repairing your tools, if MC_AUTO.REPAIR is off you will go to the repair shop, on or off
#	MC_AUTO.REPAIR: For repairing your own tools, on or off
#	MC_GET.COIN: For getting more coin if you run out while purchasing, on or off
#	MC_REORDER: For repurchasing mats, on or off
#	MC_REMNANT.STORAGE: Where small items will go. This needs to be different from your discipline storage
#	MC_MARK: For Marking your working on or off
#	blacklist: Orders that you don't want to take, must be the noun of the items
#	MC_WORK.OUTSIDE: If you want to work outside of the order hall set to 1 if not leave as 0, must set MC_PREFERRED.ROOM if set to 1
#	MC_PREFERRED.ROOM: Set as the roomid of where you want to work on your orders
#	MC_FRIENDLIST: Names of people you want to ignore when looking for an empty room i.e. Johnny|Tim|Barney
#	MC_ENDEARLY: Set to 1 if you want to stop mastercraft when your mindstate is above 30. Will check after each item. 0 if you don't
put #var MC_REPAIR on
put #var MC_AUTO.REPAIR on
put #var MC_GET.COIN on
put #var MC_REORDER on
put #var MC_REMNANT.STORAGE canvas sack
put #var MC.Mark off
put #var blacklist none
#put #var MC_WORK.OUTSIDE 0
#put #var MC_PREFERRED.ROOM 
#put #var MC_FRIENDLIST
put #var MC_END.EARLY 0
put #var MC_MAX.ORDER 4
put #var MC_MIN.ORDER 3

### DONT MODIFY THIS
put #var lastToolRepair $gametime