#Javascript - Finding Max and Min

debug 10

include js_arrays.js

var a 0
var b 1
var c %a|%b

var array1 1|2|3|4|5
var array2 1|6|3|98|2|5

pause 0.5

echo Testing out max on Array 1: %array1
echo Max should be 5.

jscall max findMax("array1");

echo Max: %max

pause 0.5

echo Testing out min on Array 1: %array1
echo Min should be 1.

jscall min findMin("array1");

echo Min: %min

pause 0.5

echo Testing out max on Array 2: %array2
echo Max should be 98.

jscall max findMax("array2");

echo Max: %max

pause 0.5

echo Testing out min on Array 2: %array2
echo Min should be 1.

jscall min findMin("array2");

echo Min: %min

pause 0.5

echo Testing out max on Array c: %c
echo Max should be 1.

jscall max findMax("c");

echo Max: %max

pause 0.5

echo Testing out min on Array c: %c
echo Min should be 0.

jscall min findMin("c");

echo Min: %min