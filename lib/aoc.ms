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

runUnitTests = function
	errorCount = 0
	assertEqual = function(actual, expected, note)
		if actual != expected then
			print "Unit test failure (" + testing + "): expected " + expected + ", got " + actual
			outer.errorCount = errorCount + 1
		end if
	end function
		
	testing = "swap"
	d = {"one":"ichi", "two":"ni", "three":"san", "four":"shi", "five":"go"}
	d.swap "one", "two"
	assertEqual d.one, "ni"
	assertEqual d.two, "ichi"

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