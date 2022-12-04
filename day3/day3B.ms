// https://adventofcode.com/2022/day/3
f = file.open("day3-input.txt")
total = 0
while true
	// read the next three lines (one "group of elves")
	lineA = f.readLine
	if lineA == null then break // end of file
	lineB = f.readLine
	lineC = f.readLine
	// find the item that appears in all three
	for c in lineA
		if lineB.indexOf(c) != null and lineC.indexOf(c) != null then break
	end for
	// find the "priority" value of this item
	if c >= "a" then
		priority = c.code - "a".code + 1
	else
		priority = c.code - "A".code + 27
	end if
	total = total + priority
	print lineA + "/" + lineB + "/" + lineC + " --> " + c + 
	  " worth " + priority + ", total " + total
end while

