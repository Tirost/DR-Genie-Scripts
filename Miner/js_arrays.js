function doSort(arrayname, sorting)	{
	/*Function: Receives an array from a calling statement, format: js doSort("<arrayname>", 0/1);
		       	  The function will sort the array in the following orders: 0 - ascending, 1 - descending
	pre: arrayname as a String, sorting as an Integer - 0 or 1
	post: Variable array with arrayname will be sorted in either ascending or descending order
	*/
	var list = getVar(arrayname).toString().split("|");
	switch(sorting)
	{
  case 0:
  	for(i = 0; i < list.length() - 1; i++)
	   {
	   if(list[i].localeCompare(list[i+1]) == 1) {
	        var temp = list[i];
	        list[i] = list[i+1];
	        list[i+1] = temp;
	        i = -1;
	   }
	  }
	  break;
	case 1:
		for(i = 0; i < list.length() - 1; i++)
	   {
	   if(list[i].localeCompare(list[i+1]) == -1) {
	        var temp = list[i];
	        list[i] = list[i+1];
	        list[i+1] = temp;
	        i = -1;
	   }
	  }
	  break;
	}
 	setVar(arrayname,list.join("|"));
  }
  
function findIndex(arrayname, srch)	{
	/*Function: Receives an array from a calling statement, format: jscall <variable> findIndex("<arrayname>", "search string");
	      	    The function will search the array for the matching string and return its index or -1 if not found
	pre: arrayname as a String, srch as a String
	post: function will return the index of the search string in the variable array with array name or -1 if string is not found
	*/
	var list = getVar(arrayname).toString().split("|");
	if (srch[0] == "%")
		{
		srch = getVar(srch.replace(/%/,""));
		}
	for(i = 0; i < list.length();i++)
		{
		if(list[i].localeCompare(srch) == 0)
			{
			return i;
			}
		}
	return -1;
	}

function checkExists(arrayname, srch) {
	/*Function: Receives an array from a calling statement, format: jscall <variable> checkExists("<arrayname>", "search string");
	      	    The function will search the array for the matching string and return 1 if it exists or 0 if it does not.
	pre: arrayname as a String, srch as a String
	post: function will return 1 if the search string exists in the variable array with arrayname or 0 if string is not found
	*/
	var list = getVar(arrayname).toString().split("|");
	if (srch[0] == "%")
		{
		srch = getVar(srch.replace(/%/,""));
		}
	for(i = 0; i < list.length();i++)
		{
		if(list[i].localeCompare(srch) == 0)
			{
			return 1;
			}
		}
	return 0;
	}

function doInsert(arrayname, items, position) {
	/*Function: Receives an array from a calling statement, format: js doInsert("<arrayname>", "item(s) to insert", position to insert);
	    	      The function will insert items into the array at the specified position.
	pre: arrayname as a String, items as a String or List (separated by |), position as Integer
	post: function will insert all items starting at specified index into the array and store the list in the variable array called arrayname.
	*/
	var list = getVar(arrayname).toString().split("|");
	items = items.toString().split("|");
	var temp = list.slice(0,position);
	for(i = 0; i < items.length();i++)
		{
		temp.push(items[i]);
		}
	for(i = position; i < list.length();i++)
		{
		temp.push(list[i]);
		}
	list = temp;
	setVar(arrayname,list.join("|"));
}

function doRemove(arrayname, srch, amount) {
	/*Function: Receives an array from a calling statement, format: js doRemove("<arrayname>", String to remove, number of items to remove);
	 		        The function will remove the specified number of items starting at the specified string (the first occurance of that string!).
	pre: arrayname as a String, srch as  String, amount as Integer
	post: function will remove the specified number of items starting at index of the search string from array and store list in the variable array called arrayname.
	*/
	var index = findIndex(arrayname, srch);
	var list = getVar(arrayname).toString().split("|");
	if(srch[0] == "%")
		{
		srch = getVar(srch.replace(/%/,""));
		}
	if(index == 0 && list.length() > 1)
		{
		list = list.slice(1,list.length());
		} else if(index == 0) {
			setVar(arrayname,"");
			return;
		}
		else if(index == -1){
			return;
		} else {
		var temp = list.slice(0,index);
		for(i = index + 1; i < list.length();i++)
			{
			temp.push(list[i]);
			}
		list = temp;
	}
	setVar(arrayname,list.join("|"));
	}
	
function doConcat(arrayname, array) {
	/*Function: Receives two arrays from a calling statement, format: js doConcat("<arrayname>", "<array>");
	 		        The function concat the second array onto the first and save it in the array variable with arrayname 1. The second array can be an array or a list string.
	pre: arrayname as a String, array as  String
	post: the second array will be concatenated onto the first array and stored in the array variable with arrayname
	*/
	var list = getVar(arrayname).toString().split("|");
	array = array.toString().split("|");
	list = list.concat(array);
	setVar(arrayname,list.join("|"));
	}

function doXCompare(arraysrc, arraytrg, srch) {
	/*Function: Receives two arrays from a calling statement and a search string, format: jscall <variable> doXCompare("<arraysrc>", "<arraytrg>", "search string");
	 		        The function will search the first array for the search string and set return the matching result from the target array to be stored in the specified variable.
	 		        The funtion returns -1 if the search string does not exist.
	pre: arraysrc as a String, arraytrg as String, srch as String
	post: the value returned will be the position in the second array that corresponds to the position of the search string in the first array
	*/
	var list = getVar(arraysrc).toString().split("|");
	var targ = getVar(arraytrg).toString().split("|");
	if (srch[0] == "%")
		{
		srch = getVar(srch.replace(/%/,""));
		}
	for(i = 0; i < list.length();i++)
		{
		if(list[i].localeCompare(srch) == 0)
			{
			return targ[i];
			}
		}
	return -1;
	}
	
function doPush(arrayname, item) {
	/*Function: Receives an array and a string, format: js doPush("<arrayname>", "new item")
	 		        The function will add the item string to the end of the array and store the new list in the variable with the name arrayname
	pre: arrayname as a String, item as a String or Local Variable (i.e.: %<varname>)
	post: the string item will be added to the array in the last position
	*/
	var list = getVar(arrayname).toString().split("|");
	if (item[0] == "%")
		{
		item = getVar(item.replace(/%/,""));
		}
	if (list[0] == "undefined")
		{
			list[0] = item;
		} else {
			list.push(item);
		}
	setVar(arrayname,list.join("|"));
	}
	
function doPop(arrayname) {
	/*Function: Receives an array, format: jscall <variable> doPop("<arrayname>");
	 		        The function will remove the last item from the array and return the value to be stored in the specified variable.
	 		        The function will return 0 if the array is already empty.
	pre: arrayname as a String
	post: the last item removed from the array and stored in the variable from the calling statement
	*/
	var list = getVar(arrayname).toString().split("|");
	if (list.length() > 0 && list[0] != "")
		{
			var temp = list[list.length() - 1];
			list.pop();
			setVar(arrayname,list.join("|"));
			return temp;
		} else {
			return 0;
		}
	}
	
function doUnshift(arrayname, item) {
	/*Function: Receives an array and a string, format: js doUnshift("<arrayname>", "new item")
	 		        The function will add the item string to the beginning of the array and store the new list in the variable with the name arrayname
	pre: arrayname as a String, item as a String or Local Variable (i.e.: %<varname>)
	post: the string item will be added to the array in the first position
	*/
	var list = getVar(arrayname).toString().split("|");
	if (item[0] == "%")
		{
		item = getVar(item.replace(/%/,""));
		}
	if (list[0] == "undefined")
		{
			list[0] = item;
		} else {
			list.unshift(item);
		}
	setVar(arrayname,list.join("|"));
	}
	
function doShift(arrayname) {
	/*Function: Receives an array, format: jscall <variable> doShift("<arrayname>");
	 		        The function will remove the first item from the array and return the value to be stored in the specified variable.
	 		        The function will return 0 if the array is already empty.
	pre: arrayname as a String
	post: the first item removed from the array and stored in the variable from the calling statement
	*/
	var list = getVar(arrayname).toString().split("|");
	if (list.length() > 0 && list[0] != "")
		{
			var temp = list[0];
			list.shift();
			setVar(arrayname,list.join("|"));
			return temp;
		} else {
			return 0;
		}
	}

function buildArray(arrayname, raw) {
	/*Function: Receives string separated by commas, 'a's, 'an's and ands to build array, format: js buildArray("<arrayname>", "list");
	 		        *Note* To build from action data you -must- capture the whole string at the same time to be sent to the function!
	 		        Actions with Javascript in them will only trigger -once- per instance of the pattern in a line.
	pre: arrayname as a String, list as a String
	post: the list is returned as a Genie formatted array stored in the array with arrayname
	*/
	raw = raw.toString().replace(/, /g , "|").replace(/ and (a|an) /, "|").replace(/\ban? /g, "");
	setVar(arrayname,raw);
	}

function buildArrayStr(arrayname, raw, pattern) {
	/*Function: Receives string separated by commas, 'a's, 'an's and ands to build array and a string, format: js buildArrayStr("<arrayname>", "list", "pattern")
	 		        *Note* To build from action data you -must- capture the whole string at the same time to be sent to the function!
	 		        Actions with Javascript in them will only trigger -once- per instance of the pattern in a line.
	 		        Function will return an array of only the items that contain the target string.
	pre: arrayname as a String, list as a String, pattern as a String or Regular Expression
	post: the list of items with the selected string is returned as a Genie formatted array stored in the array with arrayname
	*/

	raw = raw.toString().replace(/, /g , "|").replace(/ and (a|an) /, "|").replace(/\ban? /g, "");
	raw = raw.split("|");
	var list = [];
	if (pattern[0] == "%")
		{
		pattern = getVar(pattern.replace(/%/,""));
		}
	pattern = new RegExp(pattern,"i");
	for(i = 0; i < raw.length();i++)
		{
		if(pattern.test(raw[i]))
			{
			list.push(raw[i]);
			}
		}
	setVar(arrayname,list.join("|"));
	}
	
function findMax(arrayname) {
	/*Function: Receives an array, format: jscall <variable> findMax("<arrayname>");
	 		        The function will search the array for the Max value and store it in the specified variable.
	 		        Note: The array must be an array of numbers! Strings will not work.
	pre: arrayname as a String
	post: the variable recieves the max value in the array
	*/
	var list = getVar(arrayname).toString().split("|");
	var m = list[0];
	for(i = 1; i < list.length(); i++)
		{
		if(list[i] > m) {
			m = list[i];
			}
		}
	return m;
}

function findMin(arrayname) {
	/*Function: Receives an array, format: jscall <variable> findMin("<arrayname>");
	 		        The function will search the array for the Min value and store it in the variable with variablename.
	 		        Note: The array must be an array of numbers! Strings will not work.
	pre: arrayname as a String
	post: the variable with variable name recieves the min value in the array
	*/
	var list = getVar(arrayname).toString().split("|");
	var m = list[0];
	for(i = 1; i < list.length(); i++)
		{
		if(list[i] < m) {
			m = list[i];
			}
		}
	return m;
}

function findMaxIndex(arrayname) {
	/*Function: Receives an array, format: jscall <variable> findMaxIndex("<arrayname>");
	 		        The function will search the array for the Max value and store its index in the array in the specified variable.
	 		        Note: The array must be an array of numbers! Strings will not work.
	pre: arrayname as a String
	post: the variable recieves the index of the max value in the array
	*/
	var list = getVar(arrayname).toString().split("|");
	var m = list[0];
	var index = 0;
	for(i = 1; i < list.length(); i++)
		{
		if(list[i] > m) {
			m = list[i];
			index = i;
			}
		}
	return index;
}

function findMinIndex(arrayname) {
	/*Function: Receives an array, format: jscall <variable> findMinIndex("<arrayname>");
	 		        The function will search the array for the Min value and store its index in the array in the specified variable.
	 		        Note: The array must be an array of numbers! Strings will not work.
	pre: arrayname as a String
	post: the variable name recieves the index of the min value in the array
	*/
	var list = getVar(arrayname).toString().split("|");
	var m = list[0];
	var index = 0;
	for(i = 1; i < list.length(); i++)
		{
		if(list[i] < m) {
			m = list[i];
			index = i;
			}
		}
	return m;
}

function findMaxGlobal(arrayname) {
	/*Function: Receives an array, format: jscall <variable> findMaxGlobal("<arrayname>");
	 		        The function will search the array for the Max Global value and store its name in the specified variable.
	 		        Note: The array must be a list of valid Global variable names.
	pre: arrayname as a String
	post: the variable recieves the name of the Global with the max value in the array
	*/
	var list = getVar(arrayname).toString().split("|");
	var values = [];
	for(i = 0; i < list.length();i++)
		{
		values.push(getGlobal(list[i]));
		}
	var m = values[0];
	var index = 0;
	for(i = 0; i < values.length(); i++)
		{
		if(values[i] > m) {
			m = values[i];
			index = i;
			}
		}
	return list[index];
}

function findMinGlobal(arrayname) {
	/*Function: Receives an array, format: jscall <variable> findMinGlobal("<arrayname>");
	 		        The function will search the array for the Min Global value and store its name in the specified variable.
	 		        Note: The array must be a list of valid Global variable names.
	pre: arrayname as a String
	post: the variable recieves the name of the Global with the min value in the array
	*/
	var list = getVar(arrayname).toString().split("|");
	var values = [];
	for(i = 0; i < list.length();i++)
		{
		values.push(getGlobal(list[i]));
		}
	var m = values[0];
	var index = 0;
	for(i = 0; i < values.length(); i++)
		{
		if(values[i] < m) {
			m = values[i];
			index = i;
			}
		}
	return list[index];
}