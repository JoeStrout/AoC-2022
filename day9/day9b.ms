if 1 then fname = "input.txt" else fname = "example2.txt"
f = file.open(fname)

rope = []
for i in range(9)
	rope.push [0,0]
end for

follow = function(head, tail)
	dx = head[0] - tail[0]
	dy = head[1] - tail[1]
	if abs(dx) <= 1 and abs(dy) <= 1 then return
	if dx == 0 then
		tail[1] = tail[1] + sign(dy)
	else if dy == 0 then
		tail[0] = tail[0] + sign(dx)
	else
		tail[0] = tail[0] + sign(dx)
		tail[1] = tail[1] + sign(dy)
	end if
end function

tailSet = {}

while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	dir = line[0]
	dx = 0
	dy = 0
	if dir == "R" then dx = 1
	if dir == "L" then dx = -1
	if dir == "U" then dy = 1
	if dir == "D" then dy = -1
	for i in range(1, val(line[2:]))
		rope[0][0] = rope[0][0] + dx
		rope[0][1] = rope[0][1] + dy
		for j in range(1, 9)
			follow rope[j-1], rope[j]
		end for
		tailSet.push rope[-1][:]
	end for
	//print rope; key.get
end while

print tailSet.len
