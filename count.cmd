var object %1
var container %2

action var container.contents $1 when ^You rummage through .+ and see (.+)\.
action var container contents $1 when ^You rummage around on .+ and see (.+)\.
action var container.contents $1 when ^In the .+ you see (.+)\.

put rummage in my %container
waitforre ^You rummage|^In the .+ you see
pause .1

eval object.count count("%container.contents","%object")
echo
echo
echo %object.count %objects in %container
echo