#Javascript arrays Shift test

debug 10

include js_arrays.js

pause 0.5

echo Starting test.
echo Array is currently empty.
echo Adding 'Three' to the array.

js doUnshift("array","Three")

echo String 'Three' should be added to the array in the first position.
echo Array: %array

pause 0.5

echo Adding 'Two' to the array.

js doUnshift("array","Two")

echo String 'Two' should be added to the array in the first position.
echo Array: %array

pause 0.5

echo Adding 'One' to the array.

js doUnshift("array","One")

echo String 'One' should be added to the array in the first position.
echo Array: %array

pause 0.5

echo Shifting 'One' from the array, storing in 'shifted'.

jscall shifted doShift("array")

echo String 'One' should be removed from the array. The value of 'shifted' should be 'One'.
echo Array: %array
echo Variable: %shifted

pause 0.5

echo Shifting 'One' from the array, storing in 'shifted'.

jscall shifted doShift("array")

echo String 'One' should be removed from the array. The value of 'shifted' should be 'One'.
echo Array: %array
echo Variable: %shifted
pause 0.5

echo Shifting 'Two' from the array, storing in 'shifted'.

jscall shifted doShift("array")

echo String 'Two' should be removed from the array. The value of 'shifted' should be 'Two'.
echo Array: %array
echo Variable: %shifted
pause 0.5

echo Shifting 'Three' from the array, storing in 'shifted'.

jscall shifted doShift("array")

echo String 'Three' should be removed from the array. The value of 'shifted' should be 'Three'.
echo Array: %array
echo Variable: %shifted

pause 0.5

echo Shifting from empty array, storing in 'shifted'.

jscall shifted doShift("array")

echo Array should still be empty. The value '0' should be stored in 'shifted'.
echo Array: %array
echo Variable: %shifted

exit