import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 0 then fname = "input.txt" else fname = "example.txt"
gas = file.readLines(fname)[0]
nextGasNum = 0

column = [[]] * 7
colHeight = 0

Rock = {}
Rock.pattern = []
Rock.make = function(pattern, imgColor)
	noob = new Rock
	noob.pattern = pattern
	noob.width = pattern[0].len
	noob.height = pattern.len
	gfx.clear color.clear
	display(6).mode = displayMode.pixel
	for row in noob.pattern.indexes
		p = noob.pattern[noob.height - 1 - row]
		for col in p.indexes
			if p[col] != "#" then continue
			gfx.fillRect col*10, row*10, 10, 12, color.black
			gfx.print "#", col*10, row*10, imgColor, "small"
		end for
	end for
	noob.image = gfx.getImage(0, 0, noob.width*10, noob.height*10+2)
	//view noob.image
	return noob
end function

Rock.drawAt = function(x,y)
	gfx.drawImage self.image, 600 + x*10, 10 + y*10
end function
Rock.eraseAt = function(x,y)
	for row in self.pattern.indexes
		p = self.pattern[self.height - 1 - row]
		for col in p.indexes
			if p[col] != "#" then continue
			gfx.fillRect 600 + (x+col)*10, 10 + (y+row)*10, 10, 12, color.clear
		end for
	end for
end function

Rock.hitsSomethingAt = function(x,y)
	if x + self.width > 7 then return true
	if x < 0 then return true
	if y < 0 then return true
	for row in self.pattern.indexes
		if y + row >= colHeight then return false
		p = self.pattern[self.height - 1 - row]
		for col in p.indexes
			if p[col] != "#" then continue
			if column[x + col][y + row] == "#" then return true
		end for
	end for
	return false
end function

Rock.settle = function(x, y)
	//print "rock settles at " + x + ", " + y
	// first, grow all columns as needed
	oldColHeight = colHeight
	newHeight = y + self.height
	if colHeight < newHeight then
		for col in column.indexes
			column[col] = column[col] + ["."] * (newHeight-colHeight)			
		end for
		globals.colHeight = newHeight
	end if
	for row in self.pattern.indexes
		p = self.pattern[self.height - 1 - row]
		for col in p.indexes
			if p[col] != "#" then continue
			column[x + col][y + row] = "#"
		end for
	end for
	if colHeight > oldColHeight then
		for y in range(oldColHeight, colHeight-1)
			for x in range(0,6)
				if column[x][y] != "#" then
					bkgnd.print ".", 600 + x*10, 10 +y*10, "#444444", "small"
				end if
			end for
		end for
	end if
end function

rock0 = Rock.make(["####"], color.yellow)
rock1 = Rock.make([".#.", "###", ".#."], color.aqua)
rock2 = Rock.make(["..#", "..#", "###"], color.fuchsia)
rock3 = Rock.make(["#"]*4, color.lime)
rock4 = Rock.make(["##", "##"], color.silver)
rocks = [rock0, rock1, rock2, rock3, rock4]

clear
gfx.clear color.clear
display(6).mode = displayMode.pixel
bkgnd = display(6)
bkgnd.clear

bkgnd.line 600 - 3, 10 - 3, 670 + 1, 10 - 3, color.gray
bkgnd.line 600 - 3, 10 - 3, 600 - 3, 640, color.gray
bkgnd.line 670 + 1, 640, 670 + 1, 10 - 3, color.gray


add1Rock = function(rock)
	// left edge 2 units away from left wall
	x = 2
	// bottom edge 3 units above highest rock (or floor)
	y = colHeight + 3
	//print "Rock starts dropping at " + x + ", " + y
	rock.drawAt x, y
	
	while true
		// apply gas
		wait 0.05
		rock.eraseAt x, y
		dir = gas[nextGasNum]
		globals.nextGasNum = (nextGasNum + 1) % gas.len
		if dir == ">" then
			if not rock.hitsSomethingAt(x + 1, y) then
				x = x + 1
			end if
		else
			if not rock.hitsSomethingAt(x - 1, y) then
				x = x - 1
			end if
		end if
		rock.drawAt x,y
		
		// fall down
		wait 0.05
		if rock.hitsSomethingAt(x, y - 1) then
			// Settled!
			rock.settle x, y
			return
		end if
		rock.eraseAt x, y
		y = y - 1
		rock.drawAt x, y
		
	end while
end function

nextRockNum = 0
for i in range(1,2022)
	add1Rock rocks[nextRockNum]
	nextRockNum = (nextRockNum + 1) % rocks.len
end for

print colHeight


