
fname = "input.txt"

grid = file.readLines(fname)
if not grid[-1] then grid.remove -1
width = grid[0].len
height = grid.len
print "width: " + width + ", height: " + height

isVisInDir = function(x,y, dx,dy)
	h = grid[y][x]
	while true
		x = x + dx
		y = y + dy
		if x < 0 or x >= width or y < 0 or y >= height then
			return true
		end if
		if grid[y][x] >= h then return false
	end while
end function

isVisible = function(x,y)
	return isVisInDir(x,y, -1,0) or
		isVisInDir(x,y, 1,0) or
		isVisInDir(x,y, 0,-1) or
		isVisInDir(x,y, 0,1)
end function

count = 0
for x in range(0, width-1)
	for y in range(0, height-1)
		if isVisible(x,y) then count = count + 1
	end for
end for
print "final answer (part A): " + count

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

bestScore = 0
for x in range(0, width-1)
	print "x=" + x + "..."
	for y in range(0, height-1)
		score = scenicScore(x,y)
		if score > bestScore then bestScore = score
	end for
end for

print "final answer (part B): " + bestScore
