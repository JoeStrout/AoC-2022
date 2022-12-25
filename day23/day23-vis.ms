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
elves = {}			// set of elves, each an [x,y] pair
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
			if elves.hasIndex([x+i, y+j]) then return true
		end for
	end for
end function

propose = function(dirs)
	globals.nextPos = {}
	globals.propCount = {}
	for elf in elves.indexes
		if not hasAnyNeighbor(elf) then continue
		for dir in dirs
			// check to see if there is any elf in that direction or diagonal to it
			anyElf = false
			for d in dposWithDiagonals[dir]
				pos = elf.plus(d)
				if elves.hasIndex(pos) then
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
	for elf in elves.indexes
		p = nextPos.get(elf, null)
		if p == null then continue
		if propCount[p] > 1 then continue
		elves.remove elf
		elves.push p
		count = count + 1
	end for
	return count
end function

clear
gfx.scale = 4
drawAndSave = function(roundNum)
	gfx.fillRect 0, 0, gfx.width, gfx.height, color.white
	for elf in elves.indexes
		gfx.setPixel elf[0]+20, elf[1]+20, "#008800"
	end for
	img = gfx.getImage(0, 0, 168,168)
	file.saveImage "vis/round-" + ("0000" + roundNum)[-4:] + ".png", img
end function
	

dirs = [N,S,W,E]
round = 1
while true
	print "Round " + round + " (dirs " + dirs + ")"
	propose dirs
	count = move
	print count + " elves moved"
	if count == 0 then break
	dirs.push dirs.pull
	drawAndSave round
//	showElves; // key.get
	round = round + 1
end while
