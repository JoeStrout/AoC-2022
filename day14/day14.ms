if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

clear
bgColor = "#000000FF"; sandColor = "#CC9900FF"
gfx.clear bgColor
gfx.scale = 3; gfx.scrollX = 1024; gfx.scrollY = 1200

// draw obstacles
for line in lines
	parts = split(line, " -> ")
	prevx = null; prevy = null
	for part in parts
		x = part.split(",")[0].val
		y = 600 - part.split(",")[1].val
		if prevx != null then
			gfx.line prevx, prevy, x, y
		end if
		prevx = x
		prevy = y
	end for
end for

// return true if landed, false if fell into abyss
dropOneGrain = function
	x = 500; y = 600 - 0
	// fall until we can't fall any more, or go off the bottom
	while true
		if y <= 0 then return false  // fell into abyss
		if gfx.pixel(x, y-1) == bgColor then
			y = y - 1
			continue
		else if gfx.pixel(x-1, y-1) == bgColor then
			x = x - 1
			y = y - 1
			continue
		else if gfx.pixel(x+1, y-1) == bgColor then
			x = x + 1
			y = y - 1
			continue
		end if
		gfx.setPixel x, y, sandColor
		return true
	end while
end function

count = 0
while dropOneGrain
	count = count + 1
	if gfx.pixel(500, 600) != bgColor then break
end while

print "Count: " + count