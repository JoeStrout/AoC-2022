if 1 then fname = "input.txt" else fname = "example.txt"

f = file.open(fname)

head = [0,0]
tail = [0,0]

tailSet = {}

while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	print line
	dir = line[0]
	dx = 0
	dy = 0
	if dir == "R" then dx = 1
	if dir == "L" then dx = -1
	if dir == "U" then dy = 1
	if dir == "D" then dy = -1
	for i in range(1, val(line[2:]))
		head[0] = head[0] + dx
		head[1] = head[1] + dy
		if head[0] > tail[0]+1 then
			tail[0] = tail[0]+1
			tail[1] = head[1]
		end if
		if head[0] < tail[0]-1 then
			tail[0] = tail[0]-1
			tail[1] = head[1]
		end if
		if head[1] > tail[1]+1 then
			tail[1] = tail[1]+1
			tail[0] = head[0]
		end if
		if head[1] < tail[1]-1 then
			tail[1] = tail[1]-1
			tail[0] = head[0]
		end if
		//print "head: " + head + "  tail: " + tail
		tailSet.push tail[:]
	end for
end while

print tailSet.len
