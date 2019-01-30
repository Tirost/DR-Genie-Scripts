## Gem Seller by Dasffion. Much of the code actually written by Copernicus and Saet

var total.value 0

action (contents) on
action (contents) var contents $1 when ^You rummage through .+ and see (.*)\.
action math total.value add $1;var coin.type $2;pause 0.5 when hands you (\d+) (\w+)
 
put rummage my %1 
waitforre ^You rummage
action (contents) off 
 
eval contents replace("%contents", ", ", "|")  
eval contents replace("%contents", " and ", "|")  
var contents |%contents| 
eval total count("%contents", "|")  
 
Loop:  
        eval item element("%contents", 1)  
        eval number count("%contents", "|%item")  
        var count 0 
        gosub RemoveLoop 
        action setvariable item $1 when ^@a .* (\S+)$
        put #parse @%item
        counter set %count
        gosub sellgem
        if %contents != "|" then goto Loop
	echo Total gem value: %total.value %coin.type
	exit  
           
RemoveLoop: 
        eval number count("%contents", "|%item|") 
        eval contents replace("%contents", "|%item|", "|") 
        eval contents replace("%contents", "||" "|") 
        evalmath count %count + %number 
        if !contains("%contents", "|%item|") then return 
        goto RemoveLoop
 
sellgem:
	counter subtract 1
	put get my %item in my %1
	pause 0.5
	put sell my %item
	pause 0.5
	if %c = 0 then return
	goto sellgem
