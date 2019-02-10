#debuglevel 10
var break 0
var count %2
LOOP:
math break add 1
pause 0.01
pause 0.01
pause 0.01
pause 0.1
send break my %1
pause 0.01
pause 0.1
send stow left in my bac
pause 0.1
echo %break
pause 0.001
pause 0.001
if %break > %count then goto DONE
goto LOOP

DONE:
echo DONE!! Broke off: %count
put #parse FIN
exit