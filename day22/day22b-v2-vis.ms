import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "qa"

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

connectMap = {}	// key: [x,y,dir] triplet; value: new [x,y,dir] triplet

connect = function(fromX0, fromY0, fromX1, fromY1, fromDir, toX0, toY0, toX1, toY1, toDir)
	steps = abs(fromX1-fromX0) + abs(fromY1-fromY0)
	qa.assert abs(toX1-toX0) + abs(toY1-toY0) == steps
	dFrom = [sign(fromX1-fromX0), sign(fromY1-fromY0)]
	dTo = [sign(toX1-toX0), sign(toY1-toY0)]
	fromPos = [fromX0, fromY0]
	toPos = [toX0, toY0]
	for step in range(0, steps)
		connectMap[fromPos + [fromDir]] = toPos + [toDir]
		print (fromPos + [fromDir]) + " --> " + (toPos + [toDir])
		connectMap[toPos + [(toDir+2)%4]] = fromPos + [(fromDir+2)%4]
		fromPos.add dFrom
		toPos.add dTo
	end for
end function

// connect the edges of the cube
if fname == "example.txt" then
	connect 11,4, 11,7, RIGHT,		15,8, 12,8,  DOWN		// 4-6
	connect 11,3, 11,0, RIGHT,		15,8, 15,11, LEFT		// 1-6
	connect 8,8,  8,11, LEFT,		7,7,  4,7,   UP			// 3-5
	connect 7,4,  4,4,  UP,			8,3,  8,0,   RIGHT		// 1-3
	connect 3,4,  0,4,  UP,			8,0,  11,0,  DOWN		// 1-2
	connect 3,7,  0,7,  DOWN,		8,11, 11,11, UP			// 2-5
	connect 12,15, 15,15, DOWN,		0,7,  0,4,   RIGHT		// 2-6
else
	connect 149,49, 149,0, RIGHT,	99,100, 99,149, LEFT	// F-C
	connect 99,50, 99,99, RIGHT,	100,49, 149,49, UP		// D-F
	connect 49,150, 49,199, RIGHT,	50,149, 99,149, UP		// A-C
	connect 0,199, 49,199, DOWN,	100,0, 149,0, DOWN		// A-F
	connect 50,0, 50,49, LEFT,		0,149, 0,100, RIGHT		// E-B
	connect 50,50, 50,99, LEFT,		0,100, 49,100, DOWN		// D-B
	connect 0,150, 0,199, LEFT,		50,0, 99,0, DOWN		// A-E
end if

// TEST HACKS:
//pos = [37,110]
//for i in grid.indexes
//	grid[i] = grid[i].replace("#", ".")
//end for
//dir = RIGHT
//instruction = "200"

clear; gfx.clear color.white
gfx.scale = 3
for x in range(0,149)
	for y in range(0,199)
		c = gridAt([x,y])
		if c == "." then
			gfx.setPixel 100+x, 210-y, "#CCCCCC"
		else if c == "#" then
			gfx.setPixel 100+x, 210-y, "#AA6600"
		end if
	end for
end for

stepCount = 0

prevPos = pos[:]

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
//	print "Move " + d + " at " + pos

	// move forward
	for j in range(1, d)
		gfx.setPixel 100 + prevPos[0], 210 - prevPos[1], color.blue
		gfx.setPixel 100 + pos[0], 210 - pos[1], color.yellow
		prevPos = pos[:]
		prevDir = dir
		pos.add dpos[dir]
//		print " ...move from " + prevPos + " to " + pos
		if gridAt(pos) == " " then
			// wrap around!
			//print "Wraping around from " + (prevPos + [dir])
			newPos = connectMap[prevPos + [dir]]
			if gridAt(newPos) == "#" then
				// hit wall
				pos = prevPos
				dir = prevDir
				break
			end if
			pos = newPos[:2]
			dir = newPos[2]
		else if gridAt(pos) == "#" then
			// hit wall
			pos = prevPos
			dir = prevDir
			break
		end if
		stepCount = stepCount + 1
		if stepCount % 20 == 0 then yield
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
	
key.get
print "Final position: " + pos + " with dir " + dir
pwd = 1000 * (pos[1]+1) + 4 * (pos[0]+1) + dir
print "Password: " + pwd
