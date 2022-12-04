// Utilities made for the Advent of Code challenges

import "stringUtil"

min = function(a, b)
	if a <= b then return a else return b
end function

max = function(a, b)
	if a >= b then return a else return b
end function

// map.applyToValues: applies a function to all values, in place.
map.applyToValues = function(func)
	for kv in self
		self[kv.key] = func(kv.value)
	end for
end function

// map.swap: swap the values of two keys
map.swap = function(key1, key2)
	temp = self[key1]
	self[key1] = self[key2]
	self[key2] = temp
end function

// stuffInto: stuff all pairs in this map into some other
map.stuffInto = function(otherMap)
	for kv in self
		otherMap[kv.key] = kv.value
	end for
end function

// list.swap: swap two values in place, by their indexes
list.swap = function(index1, index2)
	temp = self[index1]
	self[index1] = self[index2]
	self[index2] = temp
end function

// string.between: find a string between two substrings
string.between = function(startTag, endTag)
	if startTag == "" then
		pos0 = 0
	else
		pos0 = self.indexOf(startTag)
	end if
	if pos0 == null then return null
	pos0 = pos0 + startTag.len
	if endTag == "" then
		pos1 = self.len
	else
		pos1 = self.indexOf(endTag, pos0-1)
	end if
	if pos1 == null then return null
	return self[pos0:pos1]
end function

// Span: an interval between two values.
globals.Span = {}
Span.startVal = 0
Span.endVal = 0

// Make a span from two values, or from a single string
// which we will parse as "start-end" numeric values.
Span.make = function(startVal, endVal)
	if startVal isa string and endVal == null then
		parts = startVal.split("-")
		startVal = parts[0].trim.val
		endVal = parts[1].trim.val
	end if
	result = new Span
	result.startVal = startVal
	result.endVal = endVal
	return result
end function

Span.str = function
	return self.startVal + " - " + self.endVal
end function

Span.isEmpty = function
	return self.startVal >= self.endVal
end function

Span.normalize = function
	if self.startVal > self.endVal then
		self.swap "startVal", "endVal"
	end if
end function

Span.overlaps = function(other)
	return self.startVal <= other.endVal and
	  self.endVal >= other.startVal
end function

Span.contains = function(other)
	return other.startVal >= self.startVal and
	  other.endVal <= self.endVal
end function

Span.union = function(other)
	return Span.make(min(self.startVal, other.startVal),
	  max(self.endVal, other.endVal))
end function

Span.intersection = function(other, returnNullIfEmpty=false)
	result = Span.make(max(self.startVal, other.startVal),
	  min(self.endVal, other.endVal))
	if result.isEmpty and returnNullIfEmpty then return null
	return result
end function

// function to grab the example data
globals.getExampleData = function(dayNum)
	if dayNum == null then dayNum = file.curdir[-1].val
	if dayNum == 0 then dayNum = input("Day number? ").val
	url = "https://adventofcode.com/2022/day/" + dayNum
	data = http.get(url)
	print "Read " + data.len + " bytes from " + url
	sampleData = data.between("<pre><code>", "</code></pre>")
	if not sampleData then
		print "Unable to find sample data in " + url
	else
		lines = sampleData.split(char(10))
		file.writeLines "example.txt", lines
		print "Wrote " + lines.len + " lines to example.txt"
		view "example.txt"
	end if
end function
globals.getSampleData = @getExampleData

runUnitTests = function
	errorCount = 0
	assertEqual = function(actual, expected, note)
		if actual != expected then
			print "Unit test failure (" + testing + "): expected " + expected + ", got " + actual
			outer.errorCount = errorCount + 1
		end if
	end function
		
	testing = "map.swap"
	d = {"one":"ichi", "two":"ni", "three":"san", "four":"shi", "five":"go"}
	d.swap "one", "two"
	assertEqual d.one, "ni"
	assertEqual d.two, "ichi"

	testing = "list.swap"
	a = ["zero", "one", "two"]
	a.swap 1, 2
	assertEqual a, ["zero", "two", "one"]

	testing = "string.between"
	s = "foobarbaz"
	assertEqual s.between("foo","baz"), "bar"
	assertEqual s.between("oba","rba"), ""
	assertEqual s.between("foo",""), "barbaz"
	assertEqual s.between("","baz"), "foobar"
		

	testing = "applyToValues"
	d = {"one":"ichi", "two":"ni", "three":"san", "four":"shi", "five":"go"}
	d.applyToValues @upper
	assertEqual d.one, "ICHI"
	d = {"one":"1", "two":"2"}
	d.applyToValues @val
	assertEqual d.one, 1
	assertEqual d.two, 2	
	
	testing = "Span"
	a = Span.make(3,7)
	assertEqual a.startVal, 3
	assertEqual a.endVal, 7
	b = Span.make("5 - 9")
	assertEqual b.startVal, 5
	assertEqual b.endVal, 9
	assertEqual a.overlaps(b), true
	assertEqual a.contains(b), false
	assertEqual b.contains(a), false
	assertEqual a.union(b), Span.make(3,9)
	assertEqual a.intersection(b), Span.make(5,7)
	c = Span.make(5,5)
	assertEqual c.isEmpty, true
	assertEqual a.isEmpty, false
	c = Span.make(8,5)
	assertEqual c.isEmpty, true
	c.normalize
	assertEqual c, Span.make(5,8)
	d = Span.make("10-12")
	assertEqual d.intersection(a), Span.make(10,7)
	assertEqual d.intersection(a, true), null
	
end function

if locals == globals then runUnitTests