#Checking conditions with Javascript array functions.

debug 10

include js_arrays.js

var testarray One|Two|Three|Four|Five

pause 0.5

echo Checking for string 'One' in array.
echo Array: %testarray
echo Result should be True.
jscall exists checkExists("testarray","One")
if (%exists) then echo Result: True
else echo Result: False
	
pause 0.5
echo Checking for string 'Six' in array.
echo Array: %testarray
echo Result should be False.
jscall exists checkExists("testarray","Six")
if (%exists) then echo Result: True
else echo Result: False
	
exit