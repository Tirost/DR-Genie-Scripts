ECHO
ECHO ** SYNTAX IS .getdrop <item> from my <bag>
ECHO
ECHO
if_1 then goto Loop
exit

Loop:
pause 0.1
matchre Loop ^\.\.\.wait|^Sorry\,
matchre DONE ^What were|^I could not
matchre DROP ^You get
matchre DROP ^You are already
put get my %1 
matchwait 3
goto DONE

DROP:
put drop my %1
pause 0.1
goto Loop

DONE:
echo *** DONE! ***
put #parse DONE
exit