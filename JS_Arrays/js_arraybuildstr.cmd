#Array bulding - JS

debug 10

include js_arrays.js

action js buildArrayStr("array","$1","nugget") when ^(?:In the|You rummage) .* see (.*)\.$

pause 0.5

send #parse In the traveler's haversack you see a forging logbook, a flask of oil, some articulated tongs, a ball-peen hammer, a leather bellows, an iron ingot, a master weaponsmithing book, a small platinum nugget, a large platinum nugget, a small platinum nugget, a large platinum nugget, a small platinum nugget, a small platinum nugget, a large platinum nugget, a small platinum nugget, a tiny platinum nugget, a small platinum nugget, a small platinum nugget, a medium platinum nugget, a medium platinum nugget, a small platinum nugget, a small platinum nugget, a small platinum nugget, some borax flux, a cleaning cloth, a wire brush, some stamp instructions, some stamp instructions, some borax flux, a forked stirring rod, a flask of oil, a weighted pickaxe, a medium iron nugget, a medium iron nugget, a massive iron nugget, a large iron nugget, a small iron nugget, a tiny iron nugget, a tiny iron nugget, a medium iron nugget, a medium iron nugget, a small iron nugget, a medium iron nugget, a tiny gold nugget, a medium iron nugget, a tiny iron nugget, a tiny iron nugget, a large iron nugget, a medium iron nugget, a small iron nugget, a steel-handled shovel, a leather bank book, an arm knife and a steel arm knife.

pause 0.5

echo %array

pause 0.5

send #parse You rummage through a scuffed leather traveler's haversack and see a darkened steel arm knife with a silk-wrapped handle, a crystal-pommeled arm knife, a leather bank book, a steel-handled shovel with a wide darkened blade, a small iron nugget, a medium iron nugget, a large iron nugget, a tiny iron nugget, a tiny iron nugget, a medium iron nugget, a tiny gold nugget, a medium iron nugget, a small iron nugget, a medium iron nugget, a medium iron nugget, a tiny iron nugget, a tiny iron nugget, a small iron nugget, a large iron nugget, a massive iron nugget, a medium iron nugget, a medium iron nugget, a weighted darkstone pickaxe, a flask of oil, a forked limestone stirring rod, some borax flux, some basic stamp instructions, some basic stamp instructions, an iron wire brush, a cleaning cloth, some borax flux, a small platinum nugget, a small platinum nugget, a small platinum nugget, a medium platinum nugget, a medium platinum nugget, a small platinum nugget, a small platinum nugget, a tiny platinum nugget, a small platinum nugget, a large platinum nugget, a small platinum nugget, a small platinum nugget, a large platinum nugget, a small platinum nugget, a large platinum nugget, a small platinum nugget, a book of master weaponsmithing instructions, an iron ingot, a leather bellows, a steel ball-peen hammer, some articulated covellite tongs with a tempered finish, a flask of oil and a forging work order logbook.

pause 0.5

echo %array

exit