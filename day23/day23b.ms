import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

mapW = lines[0].len
mapH = lines[1].len
print "Map: " + mapW + " x " + mapH

// find the elves
elves = []			// each an [x,y] pair
for y in lines.indexes
	line = lines[y]
	for x in line.indexes
		if line[x] == "#" then elves.push [x,y]
	end for
end for
print elves.len + " elves"


N = 0; S = 1; W = 2; E = 3
dpos = [[0,-1], [0,1], [-1,0], [1,0]]

dposWithDiagonals = [
	[[0,-1],[-1,-1],[1,-1]],
	[[0,1], [-1,1], [1,1]],
	[[-1,0], [-1,-1], [-1,1]],
	[[1,0], [1,-1], [1,1]] ]

nextPos = {}		// key: [x,y] of an elf; value: new [x,y] to move to
propCount = {}		// key: [x,y]; value: count of elves proposing to move there

hasAnyNeighbor = function(elf)
	x = elf[0]; y = elf[1]
	for i in range(-1,1)
		for j in range(-1,1)
			if i == 0 and j == 0 then continue
			if elves.contains([x+i, y+j]) then return true
		end for
	end for
end function

propose = function(dirs)
	globals.nextPos = {}
	globals.propCount = {}
	for elf in elves
		if not hasAnyNeighbor(elf) then continue
		for dir in dirs
			// check to see if there is any elf in that direction or diagonal to it
			anyElf = false
			for d in dposWithDiagonals[dir]
				pos = elf.plus(d)
				if elves.contains(pos) then
					anyElf = true
					break
				end if
			end for
			if anyElf then continue
			// since not, propose to move in that direction
			newPos = elf.plus(dpos[dir])
			propCount[newPos] = propCount.get(newPos,0) + 1
			nextPos[elf] = newPos
			// ...and consider no other directions
			break
		end for  // next direction
	end for  // next elf
end function

move = function()
	count = 0
	for elfIdx in elves.indexes
		elf = elves[elfIdx]
		p = nextPos.get(elf, null)
		if p == null then continue
		if propCount[p] > 1 then continue
		elves[elfIdx] = p
		count = count + 1
	end for
	return count
end function

calcMinMax = function()
	elves = elves.indexes
	globals.minX = elves[0][0]; globals.maxX = minX
	globals.minY = elves[0][1]; globals.maxY = minY
	for elf in elves
		globals.minX = min(minX, elf[0])
		globals.maxX = max(maxX, elf[0])
		globals.minY = min(minY, elf[1])
		globals.maxY = max(maxY, elf[1])
	end for
end function

showElves = function()
	calcMinMax
	globals.emptyGround = 0
	for y in range(minY, maxY)
		s = []
		for x in range(minX, maxX)
			if elves.contains([x,y]) then
				s.push "#"
			else
				s.push "."
				globals.emptyGround = emptyGround + 1
			end if
		end for
		print s.join("")
	end for
end function

clear
showElves

dirs = [N,S,W,E]
round = 1
while true
	print "Round " + round + " (dirs " + dirs + ")"
	propose dirs
	count = move
	print count + " elves moved"
	if count == 0 then break
	dirs.push dirs.pull
//	showElves; // key.get
	round = round + 1
end while

