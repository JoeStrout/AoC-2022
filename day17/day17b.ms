if 1 then fname = "input.txt" else fname = "example.txt"
gas = file.readLines(fname)[0]
nextGasNum = 0

column = [[]] * 7	// contents of each column of the pit
colHeight = 0		// total height (no longer equal to column[n].len)
colScroll = 0		// additional rows we've scrolled away

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
			if column[x + col][y - colScroll + row] == "#" then return true
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
		if column[0].len > 200 then
			globals.colScroll = colScroll + 100
			for col in column.indexes
				column[col] = column[col][100:]
			end for
		end if
	end if
	for row in self.pattern.indexes
		p = self.pattern[self.height - 1 - row]
		for col in p.indexes
			if p[col] != "#" then continue
			column[x + col][y - colScroll + row] = "#"
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

memo = {}		// key: state key; value: [i, colHeight]

t0 = time
nextRockNum = 0
i = 0
while i < 1E12
	if colHeight > 32 and memo != null then
		keyParts = [nextRockNum, nextGasNum]
		for col in column.indexes
			keyParts.push column[col][-32:]
		end for
		key = keyParts.join("")
		if memo.hasIndex(key) then
			print "HEY!!! Found a cycle at i=" + i + " (colHeight=" + colHeight + ")"
			print memo[key]
			// Now we have a cycle, we can fast-forward to near a trillion.
			lastI = memo[key][0]
			lastHeight = memo[key][1]
			cycleHeight = colHeight - lastHeight			
			cycleIters = i - lastI
			extraCycles = floor((1E12 - i) / cycleIters)
			colScroll = colScroll + extraCycles * cycleHeight
			colHeight = colHeight + extraCycles * cycleHeight
			i = i + extraCycles * cycleIters
			print "Fast-forwarded to i=" + i + ", colHeight=" + colHeight
			memo = null
		else
		memo[key] = [i, colHeight]
		end if
	end if
	add1Rock rocks[nextRockNum]
	nextRockNum = (nextRockNum + 1) % rocks.len
	i = i + 1
end while
t1 = time

print colHeight
print "Time: " + (t1 - t0)

// 13.7 years for a simple iteration

// on real data:
// 2022 blocks	-> 3173 high
// 10000 blocks -> 15729 high
// 13345 blocks -> 20976 high
// 50455 blocks -> 79263 high

