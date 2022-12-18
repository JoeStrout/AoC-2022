if 1 then fname = "input.txt" else fname = "example.txt"
gas = file.readLines(fname)[0]
nextGasNum = 0

column = [[]] * 7	// contents of each column of the pit
colHeight = 0		// height (always equal to column[n].len)

// Rock class: represents a Tetris-like block dropped in
Rock = {}
Rock.pattern = []
Rock.make = function(pattern)
	noob = new Rock
	noob.pattern = pattern
	noob.width = pattern[0].len
	noob.height = pattern.len
	return noob
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
	// first, grow all columns as needed
	newHeight = y + self.height
	if colHeight < newHeight then
		for col in column.indexes
			column[col] = column[col] + ["."] * (newHeight-colHeight)
		end for
		globals.colHeight = newHeight
	end if
	// then stuff the rock into the columns
	for row in self.pattern.indexes
		p = self.pattern[self.height - 1 - row]
		for col in p.indexes
			if p[col] != "#" then continue
			column[x + col][y + row] = "#"
		end for
	end for
end function

rock0 = Rock.make(["####"])
rock1 = Rock.make([".#.", "###", ".#."])
rock2 = Rock.make(["..#", "..#", "###"])
rock3 = Rock.make(["#"]*4)
rock4 = Rock.make(["##", "##"])
rocks = [rock0, rock1, rock2, rock3, rock4]

add1Rock = function(rock)
	// left edge 2 units away from left wall
	x = 2
	// bottom edge 3 units above highest rock (or floor)
	y = colHeight + 3
	
	while true
		// apply gas
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
		
		// fall down
		if rock.hitsSomethingAt(x, y - 1) then
			// Settled!
			rock.settle x, y
			return
		end if
		y = y - 1
	end while
end function

nextRockNum = 0
for i in range(1,2022)
	add1Rock rocks[nextRockNum]
	nextRockNum = (nextRockNum + 1) % rocks.len
end for

print colHeight
