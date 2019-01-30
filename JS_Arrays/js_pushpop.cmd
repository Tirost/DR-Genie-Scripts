#Push/Pop test.

debug 10

include js_arrays.js

pause 0.5

echo Starting testing.
echo Array is currently empty.
echo Adding 'One' to the array.

js doPush("array","One")

echo Array should now have 'One' in the first index.
echo Array: %array

pause 0.5

echo Adding 'Two' to the array.

js doPush("array","Two")

echo Array should now have 'Two' in the second index.
echo Array: %array

pause 0.5

echo Adding 'Three' to the array.

js doPush("array","Three")

echo Array should now have 'Three' in the third index.
echo Array: %array

pause 0.5

echo Popping 'Three' from the array, storing in 'popped'.

jscall popped doPop("array")

echo Array should now have 'Three' removed. The value 'Three' should be stored in 'popped'.
echo Array: %array
echo Variable: %popped

pause 0.5

echo Popping 'Two' from the array, storing in 'popped'.

jscall popped doPop("array")

echo Array should now have 'Two' removed. The value 'Two' should be stored in 'popped'.
echo Array: %array
echo Variable: %popped

pause 0.5

echo Popping 'One' from the array, storing in 'popped'.

jscall popped doPop("array")

echo Array should now have all items removed. The value 'One' should be stored in 'popped'.
echo Array: %array
echo Variable: %popped

pause 0.5

echo Popping from empty array, storing in 'popped'.

jscall popped doPop("array")

echo Array should still be empty. The value '0' should be stored in 'popped'.
echo Array: %array
echo Variable: %popped

exit