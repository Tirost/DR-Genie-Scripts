include js_arrays.js
debug 10

test:
gosub magic chaos prepare mef 5 1 0 full self

magic:
var line $0
js doPush("spell_array", "%line")
echo spell_array: %spell_array
magic_loop:
jscall spell_name doShift("spell_array")
echo spell_name:%spell_name
exit