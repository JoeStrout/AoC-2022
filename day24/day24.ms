import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "search"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

mapW = lines[0].len-2
mapH = lines.len-2
print mapW + "x" + mapH

// State: [x,y,minute]

// blizzardMap: represents which blizzards are at each spot
// with a sum of 1, 2, 4, 8 for >, v, <, and ^ respectively.
// Indexed as [y][x], INTERIOR only.
newBlizMap = function
	return list.init2d(mapH, mapW, 0)
end function

_blizMapForMinute = {}

// load the initial blizzard map from the data
m = newBlizMap
for y in range(0, mapH-1)
	for x in range(0, mapW-1)
		c = lines[y+1][x+1]
		if c == "." then continue
		if c == ">" then m[y][x] = 1
		if c == "v" then m[y][x] = 2
		if c == "<" then m[y][x] = 4
		if c == "^" then m[y][x] = 8
	end for
end for
_blizMapForMinute[0] = m

blizMapForMinute = function(minute)
	if _blizMapForMinute.hasIndex(minute) then return _blizMapForMinute[minute]
	m = newBlizMap
	p = blizMapForMinute(minute - 1)
	for y in range(0, mapH-1)
		for x in range(0, mapW-1)
			sum = 0
			if bitAnd(p[y][(x+mapW-1)%mapW], 1) then sum = sum + 1
			if bitAnd(p[(y+mapH-1)%mapH][x], 2) then sum = sum + 2
			if bitAnd(p[y][(x+1)%mapW], 4) then sum = sum + 4
			if bitAnd(p[(y+1)%mapH][x], 8) then sum = sum + 8
			m[y][x] = sum
		end for
	end for	
	_blizMapForMinute[minute] = m
	return m
end function

pathFinder = new search.Search
pathFinder.heuristic = @search.heuristic2DDistance
pathFinder.neighbors = function(state)
	result = {}
	x = state[0]; y = state[1]
	nextMinute = state[-1] + 1
	// wait (if clear of blizzard)
	m = blizMapForMinute(nextMinute)
	if y < 0 or y >= mapH or not m[y][x] then result.push [x, y, nextMinute]
	// move in each direction, but only if clear of blizzards
	if y < mapH-1 and not m[y+1][x] then result.push [x, y+1, nextMinute]
	if y > 0 and not m[y-1][x] then result.push [x, y-1, nextMinute]
	if y < 0 or y >= mapH then return result
	if x > 0 and not m[y][x-1] then result.push [x-1, y, nextMinute]
	if x < mapW-1 and not m[y][x+1] then result.push [x+1, y, nextMinute]
	return result
end function

// go to goal
goal = [mapW-1, mapH-1]
path = pathFinder.findPath([0, -1, 0], goal)
minutes = path[-1][-1] + 1
print "From start to goal: " + minutes

// go back to start
goal = [0, 0]
path = pathFinder.findPath([mapW-1, mapH, minutes], goal)
minutes = path[-1][-1] + 1
print "Back to start: " + minutes

// and back to goal
goal = [mapW-1, mapH-1]
path = pathFinder.findPath([0, -1, minutes], goal)
minutes = path[-1][-1] + 1
print "Back to goal again: " + minutes
