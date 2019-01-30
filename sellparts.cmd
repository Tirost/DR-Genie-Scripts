## Gem Seller by Dasffion. Much of the code actually written by Copernicus and Saet

#debug 10

action (contents) on
action (contents) var contents $1 when ^You rummage through .+ and see (.*)\.

var buyers (Ragge)

put rummage %1  
waitforre ^You rummage
action (contents) off 
 
eval contents replace("%contents", ", ", "|")  
eval contents replace("%contents", " and ", "|")  
var contents |%contents| 
eval total count("%contents", "|")  
if !matchre("$roomobjs", "%buyers") then
	{
		echo No buyer!
	exit
	}
	
var buyer $1
 
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
	pause 0.2
	put give my %item to %buyer
	pause 0.5
	if %c = 0 then return
	goto sellgem
