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
RIGHT=0; DOWN=1; LEFT=2; UP=3
dpos = [[1,0], [0,1], [-1,0], [0,-1]]

advanceToMap = function(pos)
	while gridAt(pos) == " "
		pos.add dpos[dir]
	end while
end function
advanceToMap pos
print "Starting pos: " + pos

tested = {}

wrapAround = function
	// first, determine what face we're on
	faceRow = mathUtil.clamp(floor(pos[1] / 50), 0, 3)
	faceCol = mathUtil.clamp(floor(pos[0] / 50), 0, 2)
	s = "Wrap dir " + dir + " at " + pos + " (face " + faceCol + "," + faceRow + ")"
	testkey = faceCol + "," + faceRow + "," + dir
	if dir == RIGHT then	// move right
		if faceRow == 0 then
			pos[1] = 3*50 - pos[1]
			globals.dir = LEFT
		else if faceRow == 1 then
			pos[0] = 2*50 + (pos[1] - 50)
			pos[1] = 50
			globals.dir = UP
		else if faceRow == 2 then
			pos[0] = 3*50
			pos[1] = 50 - (pos[1] - 2*50)
			globals.dir = LEFT
		else
			pos[0] = 50 + (pos[1] - 3*50)
			pos[1] = 3*50
			globals.dir = UP
		end if
	else if dir == LEFT then 	// move left
		if faceRow == 0 then
			pos[0] = 0
			pos[1] = 3*50 - pos[1]
			globals.dir = RIGHT
		else if faceRow == 1 then
			pos[0] = pos[1] - 50
			pos[1] = 2*50
			globals.dir = DOWN
		else if faceRow == 2 then
			pos[1] = 3*50 - pos[1]
			globals.dir = RIGHT
		else
			pos[0] = 2*50 - (4*50 - pos[1])
			pos[1] = 0
			globals.dir = DOWN
		end if
	else if dir == DOWN then	// move down
		if faceCol == 0 then
			pos[0] = 2*50 + pos[0]
			pos[1] = 0
		else if faceCol == 1 then
			pos[1] = 3*50 + (pos[0] - 50)
			pos[0] = 50
			globals.dir = LEFT
		else
			pos[1] = 50 + (pos[0] - 2*50)
			pos[0] = 2*50
			globals.dir = LEFT
		end if
	else if dir == UP then	// move up
		if faceCol == 0 then
			pos[1] = 50 + pos[0]
			pos[0] = 50
			globals.dir = RIGHT
		else if faceCol == 1 then
			pos[1] = 4*50 - (2*50 - pos[0])
			pos[0] = 0
			globals.dir = RIGHT
		else
			pos[0] = pos[0] - 2*50
			pos[1] = 4*50
		end if
	end if
	
	advanceToMap pos
	s = s + " --> dir " + globals.dir + " at " + pos + "(" + gridAt(pos) + ")"
	if not tested.hasIndex(testkey) then
		print s
		//key.get
		tested.push testkey
	end if
	if gridAt(pos) == "#" then return false
	return true
end function

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
		prevDir = dir
		pos.add dpos[dir]
		if gridAt(pos) == " " then
			// wrap around!
			if not wrapAround then
				// hit wall
				pos = prevPos
				dir = prevDir
				break
			end if
		else if gridAt(pos) == "#" then
			// hit wall
			pos = prevPos
			dir = prevDir
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
