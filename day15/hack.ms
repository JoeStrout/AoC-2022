// Utilities made for the Advent of Code challenges

string.match = function(pattern)
	// Start by splitting this pattern into literal and field parts.
	parts = []
	p = 0
	while p < pattern.len
		// find the end of a literal part
		nextp = pattern.indexOf("{", p-1)
		if nextp == null then
			parts.push pattern[p:]
			break
		end if
		if nextp > p then parts.push pattern[p:nextp]
		p = nextp
		// find the end of a field part
		nextp = pattern.indexOf("}", p)
		if p == null then
			parts[-1] = parts[-1] + pattern[p:]
			break
		end if
		parts.push pattern[p:nextp+1]
		p = nextp + 1
	end while
	// Now, find each literal parts in this string,
	// and fill in the variable parts (fields) in between.
	result = {}
	p = 0
	lastStartPos = 0
	for i in parts.indexes
		part = parts[i]
		if part[0] == "{" and part[-1] == "}" then
			lastStartPos = p
			if i == parts.len-1 then result[part[1:-1]] = self[p:]
			continue
		end if
		p = self.indexOf(part, p-1)
		if p == null then return null  // literal part not found
		if i > 0 then
			result[parts[i-1][1:-1]] = self[lastStartPos:p]
		end if
		lastStartPos = p
		p = p + part.len
	end for
	return result
end function

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

list.maxElementLen = function(self)
	m = 0
	for i in self.indexes
		m = max(m, self[i].len)
	end for
	return m
end function

list.pad = function(length, padValue=null, cutIfTooLong=true)
	if self.len > length then
		if cutIfTooLong then return self[:length]
	else if self.len < length then
		return self + [padValue] * (length - self.len)
	end if
	return self
end function

list.padToUniform = function(self)
	maxLen = self.maxElementLen
	for i in self.indexes
		self[i] = self[i].pad(maxLen)
	end for
end function

// Given a list of strings, which we can think of like a 2D
// block of characters, rotate it clockwise.
list.blockRotateCW = function(self)
	src = self[:]
	src.padToUniform
	for destRow in range(0, src.len-1)
		if src[0] isa string then
			s = ""
			for srcRow in range(src.len-1)
				s = s + src[srcRow][destRow]
			end for
		else
			s = []
			for srcRow in range(src.len-1)
				s.push src[srcRow][destRow]
			end for
		end if
		self[destRow] = s
	end for
end function

// Given a list of strings, which we can think of like a 2D
// block of characters, rotate it counter-clockwise.
list.blockRotateCCW = function(self)
	src = self[:]
	src.padToUniform
	for destRow in range(0, src.len-1)
		if src[0] isa string then
			s = ""
			for srcRow in range(0, src.len-1)
				s = s + src[srcRow][src.len - 1 - destRow]
			end for
		else
			s = []
			for srcRow in range(0, src.len-1)
				s.push src[srcRow][src.len - 1 - destRow]
			end for
		end if
		self[destRow] = s
	end for
end function

list.blockPrint = function(self)
	for item in self
		print item
	end for
end function

list.select = function(indexes)
	result = []
	for i in indexes
		result.push self[i]
	end for
	if self isa string then return result.join("")
	return result
end function
string.select = @list.select

// list.sortWithFunction: give it a comparison function that
// takes two items, and returns 0 if they are equal,
// any value < 0 if the first is less than the second,
// and any value > 0 if the first is greater than the second.
list.sortWithFunction = function(compareFunc, fromIndex=null, toIndex=null)
	if fromIndex == null then fromIndex = 0
	if toIndex == null then toIndex = self.len - 1
    if fromIndex >= toIndex then return self
    // find a pivot value
	pivot = self[(fromIndex + toIndex) / 2]

	leftPtr = fromIndex - 1
	rightPtr = toIndex + 1
//	print self + " (from " + fromIndex + " to " + toIndex + ") Pivot value: " + pivot
	while leftPtr < rightPtr
		// move left index forward at least once, until the element
		// at the left index is >= the pivot
		while true
			leftPtr = leftPtr + 1
			if compareFunc(self[leftPtr], pivot) >= 0 then break
		end while
		// move the right index to the left at least once, until
		// the element at the right index is <= the pivot
		while true
			rightPtr = rightPtr - 1
			if compareFunc(self[rightPtr], pivot) <= 0 then break
		end while
		// if the indices crossed or met, we're done
//		print "leftPtr: " + leftPtr + "  rightPtr: " + rightPtr
		if leftPtr >= rightPtr then break
		self.swap leftPtr, rightPtr
//		print "swapped to get: " + self + " (from " + fromIndex + " to " + toIndex + ")"
	end while

//	print self + ", now sort " + fromIndex + "-" +(rightPtr) + " and " + (rightPtr+1) + "-" + toIndex
	if fromIndex < rightPtr then self.sortWithFunction @compareFunc, fromIndex, rightPtr
	if rightPtr+1 < toIndex then self.sortWithFunction @compareFunc, rightPtr+1, toIndex
	return self
end function

// compareNumeric: a comparison function based on the val() of each element
compareNumeric = function(a,b); return val(a) - val(b); end function

// compareCaseSensitive: unlike standard sort, which puts "A" and "a" together
// before "B" and "b", this one puts all the capitalized words first, followed
// by all the lowercase words.
compareCaseSensitive = function(a,b)
	if a > b then return 1
	if a < b then return -1
	return 0
end function

testone = function(nums)
	copy = nums[:]
	nums.sortWithFunction @compareNumeric
	copy.sort
	if copy == nums then
		print "OK: " + nums
	else
		print "FAILURE:"
		print "  built-in sort: " + copy
		print "      quicksort: " + nums
		exit
	end if
end function
testmany = function(n=100)
	for i in range(n-1)
		arr = []
		for j in range(0, 4+rnd*5)
			arr.push floor(100*rnd)
		end for
		testone arr
	end for
end function
	

// list.combinations: get all combinations (where order does
// not matter) of 'k' items from this list.
// Reference: https://stackoverflow.com/questions/29910312
list.combinations = function(k)
	result = []
	s = range(0, k-1)	// index sequence (what items we select from self)
	result.push self.select(s)
	while true
		// find position of last item that can be incremented
		for i in range(k-1, -1)
			if i < 0 then return result
			if s[i] < self.len - k + i then break
		end for
		s[i] = s[i] + 1		// increment this item
		if i < k-1 then
			for i in range(i+1, k-1)	// fill up remaining items
				s[i] = s[i-1] + 1
			end for
		end if
		// now, grab the selected subset
		result.push self.select(s)
	end while
end function	
string.combinations = @list.combinations // works for both! :)

// list.permutations: return all permutations of this list,
// optionally of a smaller size.
list.permutations = function(ofLength=null)
	if self.len < 2 then return [self]
	if ofLength == null then ofLength = self.len
	result = []
	if ofLength < self.len then
		// handle this by first finding all combinations
		// of the specified length, and then permuting those
		for combo in self.combinations(ofLength)
			result = result + combo.permutations
		end for
		return result
	end if
	// permuting the entire list is easy to do recursively:
	for i in self.indexes
		item = self[i]
		remainder = self[:i] + self[i+1:]
		for rest in remainder.permutations
			result.push [item] + rest
		end for
	end for
	return result
end function

// string.permutations: return all permutations of this string,
// optionally of a smaller size.
string.permutations = function(ofLength=null)
	if self.len < 2 then return [self]
	result = []
	if ofLength == null then ofLength = self.len
	if ofLength < self.len then
		// handle this by first finding all combinations
		// of the specified length, and then permuting those
		for combo in self.combinations(ofLength)
			result = result + combo.permutations
		end for
		return result
	end if
	for i in self.indexes
		item = self[i]
		remainder = self[:i] + self[i+1:]
		for rest in remainder.permutations
			result.push item + rest
		end for
	end for
	return result
end function

factorial = function(n)
	result = 2
	for i in range(3,n)
		result = result * n
	end for
	return result
end function

// list.nthPermutation: print the Nth permutation of the
// items of this list.  You'll get unique permutations
// from 0 through factorial(self.len)-1.
list.nthPermutation = function(n)
	result = []
	copy = self[:]
	while copy
		i = n % copy.len
		result.push copy[i]
		copy.remove i
	end while
	return result
end function

// Given a tree (maps that contain further maps), apply
// the function f to each node (map), recursively, and 
// return a list of those maps for which f returns true.
map.treeSearch = function(f)
	result = []
	if f(self) then result.push self
	for value in self.values
		if value isa map then
			result = result + value.treeSearch(@f)
		end if
	end for
	return result
end function

// Given a tree (maps that contain further maps), recursively
// remove all nodes (maps) for which f returns true.
// (Note that this cannot apply to the root, because what
// would you remove it FROM?)
map.prune = function(f)
	for key in self.indexes
		value = self[key]
		if value isa map then
			if f(value) then
				self.remove key
			else
				value.prune @f
			end if
		end if
	end for
end function

LineParser = {}
LineParser.make = function(linesOrFilename)
	if linesOrFilename isa string then
		lines = file.readLines(linesOrFilename)
		if lines == null then
			print "Unable to read file: " + linesOrFilename
			return null
		end if
		linesOrFilename = lines
	end if
	parser = new LineParser
	parser.lines = linesOrFilename
	parser.index = 0
	return parser
end function
LineParser.atEnd = function
	return self.index >= self.lines.len
end function
LineParser.advance = function
	if self.index < self.lines.len then
		self.index = self.index + 1
	end if
end function
LineParser.backup = function
	if self.index > 0 then self.index = self.index - 1
end function
LineParser.get = function(pattern, default=null)
	if self.index >= self.lines.len then return default
	m = self.lines[self.index].match(pattern)
	self.advance
	if m == null then return default
	for kv in m
		if kv.key == "" then continue
		id = kv.key
		if id[0] == "n" then return kv.value.val	// number
		if id[0] == "s" then return kv.value		// string
		if id[0] == "l" then		// list
			elems = kv.value.split(",")
			elems.apply @val
			return elems
		end if
		print "Unknown field type: " + id
		exit
	end for
end function
	

// function to grab the example data
globals.getExampleData = function(dayNum)
	if dayNum == null then dayNum = file.curdir[8:].val
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

resultB = []

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

if fname == "example.txt" then maxY = 20 else maxY = 4000000

compareSpans = function(a,b)
	if a.startVal == b.startVal then
		return a.endVal - b.endVal
	else
		return a.startVal - b.startVal
	end if
end function

clear
scale = 320 / maxY
observations = []
for line in lines
	m = line.match("Sensor at x={sx}, y={sy}: closest beacon is at x={bx}, y={by}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.applyToValues @val
	m.stuffInto @locals
	distToSensor = abs(bx-sx) + abs(by-sy)
	gfx.drawPoly [
		[400 + (sx - distToSensor) * scale, 220 + sy * scale],
		[400 + sx * scale, 220 + (sy - distToSensor) * scale],
		[400 + (sx + distToSensor) * scale, 220 + sy * scale],
		[400 + sx * scale, 220 + (sy + distToSensor) * scale]]
	gfx.drawRect 400, 220, maxY*scale, maxY*scale, color.blue
	observations.push m
end for
exit
for yOfInterest in range(1000000,maxY)
	if yOfInterest % 1000 == 0 then print yOfInterest + "..."
	resultA = []
	spans = []
	for m in observations
		m.stuffInto @locals
		distToSensor = abs(bx-sx) + abs(by-sy)
		ydiff = abs(sy - yOfInterest)
		if ydiff > distToSensor then continue
		radiusAtY = distToSensor - ydiff
		span = Span.make(sx - radiusAtY, sx + radiusAtY)
		
		found = false
		for i in spans.indexes
			if spans[i].overlaps(span) then
				spans[i] = spans[i].union(span)
				found = true
				break
			end if
		end for
		if not found then spans.push span
	end for
	
	while spans.len > 1
		didAny = false
		for i in range(spans.len-1, 1)
			for j in range(i-1)
				if spans[j].overlaps(spans[i]) then
					spans[j] = spans[j].union(spans[i])
					spans.remove i
					didAny = true
					break
				end if
			end for
			if didAny then break
		end for
		if not didAny then break
	end while
	
	if spans.len > 1 then spans.sortWithFunction @compareSpans
	for s in spans
		resultA.push s.str
	end for
	if spans[0].startVal > 0 then
		print "y:" + yOfInterest + "  spans: " + resultA.join("; ")
		exit
	end if
	if spans.len == 1 then
		if spans[0].endVal < maxY then
			print "y:" + yOfInterest + "  spans: " + resultA.join("; ")
			exit
		end if
		continue
	else
		x = spans[0].endVal
		for i in range(1, spans.len-1)
			if spans[i].startVal > x+1 then
				print "y:" + yOfInterest + "  spans: " + resultA.join("; ")
				exit
			end if
			x = spans[i].endVal
		end for
	end if
end for
