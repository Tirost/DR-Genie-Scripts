#Javascript Max/Min global

debug 10

include js_arrays.js

var array bleeding|concentration

pause 0.5

echo Testing Global Max.
echo Result should be: concentration

jscall maxskill findMaxGlobal("array");

echo Max skill: %maxskill

pause 0.5

echo Testing Global Min.
echo Result should be: bleeding

jscall minskill findMinGlobal("array");

echo Min skill: %minskill