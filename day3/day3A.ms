// https://adventofcode.com/2022/day/3
f = file.open("day3-input.txt")
total = 0
while true
	line = f.readLine
	if line == null then break // end of file
	// split the line into our two compartments
	compA = line[:line.len/2]
	compB = line[line.len/2:]
	if compA.len != compB.len then
		print "?!? Uneven lines " + compA + "," + compB
		exit
	end if
	// find the item that appears in both
	for c in compA
		if compB.indexOf(c) != null then break
	end for
	// find the "priority" value of this item
	if c >= "a" then
		priority = c.code - "a".code + 1
	else
		priority = c.code - "A".code + 27
	end if
	total = total + priority
	print compA + "/" + compB + " --> " + c + " worth " + priority + ", total " + total
end while

