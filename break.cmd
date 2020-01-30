#debuglevel 5
#####################################
# BREAK utility script by Shroom
# Usage: .break <number of items>
# .break 50 - will break off 50 of the items in your right hand and stow
#####################################
var break 0
var count %2
LOOP:
math break add 1
pause 0.01
pause 0.01
pause 0.1
pause 0.1
send break my %1
pause 0.01
pause 0.1
send stow left
pause 0.1
echo %break
pause 0.1
pause 0.1
if %break > %count then goto DONE
goto LOOP

DONE:
echo DONE!! Broke off: %count
put #parse FIN
exit