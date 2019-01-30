  #debug 10      
		var temparray $weaponlist
		eval temparray replacere("%temparray", "^\|", "")
		eval temparray replacere("%temparray", "\|$", "")
		var weaponlist %temparray
		var lowarray
		var total.count 0
		eval total.number count("%weaponlist", "|")
lowcheckstart:
		if %total.count > %total.number then goto lowrankcheckdone
		var count.number 0
        eval weapons.number count("%temparray","|")
		var low.weapon %temparray(0)
lowweaponcheck:
        if %count.number <= %weapons.number then
          {
          if $%temparray(%count.number).Ranks < $%low.weapon.Ranks then var low.weapon %temparray(%count.number)
          math count.number add 1
          goto lowweaponcheck
          }
	if "%lowarray" = "" then var lowarray %low.weapon
	else var lowarray %lowarray|%low.weapon	  
	eval temparray replace("%temparray", "%low.weapon", "|")
	eval temparray replacere("%temparray", "\|+", "|")
	eval temparray replacere("%temparray", "^\|", "")
	eval temparray replacere("%temparray", "\|$", "")
	math total.count add 1
	goto lowcheckstart

lowrankcheckdone:
	put #var weaponlist %lowarray
	put #echo >CombatTest $weaponlist