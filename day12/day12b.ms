import "listUtil"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.remove -1

H = lines.len
W = lines[0].len

resultB = []
startPositions = []

for y in lines.indexes
	line = lines[y]
	for x in range(0,W-1)
		if line[x] == "S" or line[x] == "a" then startPositions.push [x,y]
		if line[x] == "E" then endPos = [x,y]
	end for
	lines[y] = line.replace("E", "z").replace("S", "a")
end for
pprint lines
print "Start: " + startPos
print "End: " + endPos


height = function(pos)
	return lines[pos[1]][pos[0]].code - 97
end function
walkableNeighbors = function(pos)
	h = height(pos)
	result = []
	if pos[0] > 0 and height([pos[0]-1, pos[1]]) <= h+1 then result.push [pos[0]-1, pos[1]]
	if pos[1] > 0 and height([pos[0], pos[1]-1]) <= h+1 then result.push [pos[0], pos[1]-1]
	if pos[0] < W-1 and height([pos[0]+1, pos[1]]) <= h+1 then result.push [pos[0]+1, pos[1]]
	if pos[1] < H-1 and height([pos[0], pos[1]+1]) <= h+1 then result.push [pos[0], pos[1]+1]
	return result
end function

findPath = function(startPos, endPos)
	// A* + Heuristics pathfinding implementation
	if startPos isa map then startPos = [startPos.col,startPos.row]
	if endPos isa map then endPos = [endPos.col,endPos.row]
	if startPos == endPos then return [endPos]
	
	// True distance function for diagnonals
	heuristic = function(endPos, nextPos)
	    a = endPos[0] - nextPos[0]
		b = endPos[1] - nextPos[1]
		return sqrt(a^2 + b^2)
	end function

	check = []
	check.push [startPos,0]
	globals.camefrom = {}
	camefrom[startPos] = null
	cellCosts = {}
	cellCosts[startPos] = 0
	while check
		current = check.pull[0]
		if current == endPos then
			break
		end if
		
		for nextCellPos in walkableNeighbors(current)
			cost = cellCosts[current] + heuristic(nextCellPos, current)
			if not cellCosts.hasIndex(nextCellPos) or cost < cellCosts[nextCellPos] then
				cellCosts[nextCellPos] = cost
				i = 0
				while i < check.len
					if check[i][1] > cost then break
					i = i + 1
				end while
				check.insert i, [nextCellPos, cost]
				camefrom[nextCellPos] = current
			end if
		end for
	end while
	
	current = endPos
	result = []
	if camefrom.hasIndex(current) then
		while current != startPos
			result.push current
			current = camefrom[current]
		end while
		if result then result.reverse
	end if
	return result
end function

for startPos in startPositions
	path = findPath(startPos, endPos)
	print "path len from " + startPos + ": " + path.len
	if path.len > 0 then resultB.push path.len
end for

print "Min: " + resultB.min
