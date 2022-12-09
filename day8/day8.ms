import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

fname = "input.txt"
//fname = "example.txt"

resultA = []
resultB = []

grid = file.readLines(fname)
if not grid[-1] then grid.remove -1
width = grid[0].len
height = grid.len
print "width: " + width + ", height: " + height

isVisLeft = function(x,y)
	if x == 0 then return true
	row = grid[y]
	for i in range(0, x-1)
		if row[i] >= row[x] then return false
	end for
	return true
end function
isVisRight = function(x,y)
	if x == width-1 then return true
	row = grid[y]
	for i in range(x+1, width-1)
		if row[i] >= row[x] then return false
	end for
	return true
end function
isVisUp = function(x,y)
	if y == 0 then return true
	for i in range(0, y-1)
		if grid[i][x] >= grid[y][x] then return false
	end for
	return true
end function
isVisDown = function(x,y)
	if y == height-1 then return true
	for i in range(y+1, height-1)
		if grid[i][x] >= grid[y][x] then return false
	end for
	return true
end function
isVisible = function(x,y)
	return isVisLeft(x,y) or isVisRight(x,y) or
	 isVisUp(x,y) or isVisDown(x,y)
end function

safeRange = function(a,b)
	if a > b then return []
	return range(a,b)
end function

viewDist = function(x, y, dx, dy)
	h = grid[y][x]
	d = 0
	while true
		x = x + dx
		y = y + dy
		if x < 0 or x >= width or y < 0 or y >= height then break
		t = grid[y][x]
		d = d + 1
		if t >= h then break
	end while
	return d
end function

scenicScore = function(x,y)
	return viewDist(x,y, -1,0) *
		viewDist(x,y, 1,0) *
		viewDist(x,y, 0,-1) *
		viewDist(x,y, 0,1)
end function

count = 0
for x in range(0, width-1)
	for y in range(0, height-1)
		if isVisible(x,y) then count = count + 1
	end for
end for

bestScore = 0
for x in range(0, width-1)
	print "x=" + x + "..."
	for y in range(0, height-1)
		score = scenicScore(x,y)
		if score > bestScore then bestScore = score
	end for
end for



print "final answer (part A): " + count
print "final answer (part B): " + bestScore
// Also available: list.min, list.max, list.mean