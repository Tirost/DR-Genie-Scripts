#Javascript function tests.
debug 10

include js_arrays.js

pause 0.5

var testarray Beta|Gamma|Epsilon|Alpha|Omega|Theta

echo Pre-testing state.
echo Array: %testarray

echo Starting testing.

pause 0.5

js doSort("testarray",0);

echo Array should be Ascending.
echo Array: %testarray

pause 0.5

jscall index findIndex("testarray","Gamma");

echo Index should be 3.
echo Index: %index

pause 0.5

js doSort("testarray",1);

echo Array should be Descending.
echo Array: %testarray

pause 0.5

jscall index findIndex("testarray","Gamma");

echo Index should be 2.
echo Index: %index

pause 0.5

js doSort("testarray",0);

echo Array should be Ascending.
echo Array: %testarray

pause 0.5

js doInsert("testarray", "Phi|Psy", 5);

echo Entries Phi and Psy should be after entry Omega.
echo Array: %testarray

pause 0.5

js doRemove("testarray", "Gamma", 1);

echo Entry Gamma should be removed.
echo Array: %testarray

pause 0.5

js doConcat("testarray", "Upsilon|Zeta");

echo Entries Upsion and Zeta should be added to the array at the end.
echo Array: %testarray

exit