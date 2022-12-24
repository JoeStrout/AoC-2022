import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
grid = file.readLines(fname)
if not grid[-1] then grid.pop

instruction = grid.pop
grid.pop

//pprint grid

gridAt = function(pos)
	if pos[1] < 0 or pos[1] >= grid.len then return " "
	line = grid[pos[1]]
	if pos[0] < 0 or pos[0] >= line.len then return " "
	return line[pos[0]]
end function

pos = [0,0]	// column, row
dir = 0		// 0-3 = right, down, left, up
dpos = [[1,0], [0,1], [-1,0], [0,-1]]

advanceToMap = function(pos)
	while gridAt(pos) == " "
		pos.add dpos[dir]
	end while
end function
advanceToMap pos
print "Starting pos: " + pos

i = 0
while i < instruction.len
	// get a number
	d = instruction[i]
	i = i + 1
	while i < instruction.len and instruction[i] >= "0" and instruction[i] <= "9"
		d = d + instruction[i]
		i = i + 1
	end while
	d = d.val
	//print "Move " + d + " at " + pos

	// move forward
	for j in range(1, d)
		prevPos = pos[:]
		pos.add dpos[dir]
		if gridAt(pos) == " " then
			// wrap around!
			if dir == 0 then
				pos[0] = 0
			else if dir == 1 then
				pos[1] = 0
			else if dir == 2 then
				pos[0] = grid[pos[1]].len - 1
			else if dir == 3 then
				pos[1] = grid.len - 1
			end if
			advanceToMap pos
			if gridAt(pos) == "#" then
				pos = prevPos
				break
			end if
		else if gridAt(pos) == "#" then
			// hit wall
			pos = prevPos
			break
		end if
	end for
	if i >= instruction.len then break
	
	// now turn
	//print "Turn " + instruction[i]
	if instruction[i] == "R" then
		dir = (dir + 1) % 4
	else if instruction[i] == "L" then
		dir = (dir + 3) % 4
	else
		print "WTF?!?"
		exit
	end if
	i = i + 1
end while
	
pwd = 1000 * (pos[1]+1) + 4 * (pos[0]+1) + dir
print "Password: " + pwd
