import "tc"

if 1 then fname = "input.txt" else fname = "example2.txt"

f = file.open(fname)

rope = []
for i in range(9)
	rope.push [0,0]
end for

follow = function(head, tail)
	dx = head[0] - tail[0]
	dy = head[1] - tail[1]
	if abs(dx) <= 1 and abs(dy) <= 1 then return
	if dx == 0 then
		tail[1] = tail[1] + sign(dy)
	else if dy == 0 then
		tail[0] = tail[0] + sign(dx)
	else
		tail[0] = tail[0] + sign(dx)
		tail[1] = tail[1] + sign(dy)
	end if
end function

clear
scale = 8			// drawing scale
cx = 500; cy=480	// center of drawing

draw = function
	// draw the tail set
	for point in tailSet.indexes
		gfx.setPixel cx+point[0]*scale, cy+point[1]*scale,
		  color.gray
	end for
	// draw the rope
	for i in range(rope.len-2)
		a = rope[i]; b = rope[i+1]
		gfx.line cx+a[0]*scale, cy+a[1]*scale, 
		 cx+b[0]*scale, cy+b[1]*scale,
		 rgb(255-i*25, 200, 5+i*25), scale/2
	end for
	// draw the head
	a = rope[0]
	w = floor(scale*0.25)
	gfx.fillEllipse cx+a[0]*scale-w, cy+a[1]*scale-w, w*2, w*2
	flc		// (flip and clear, from the tc module)
	//wait 0.1
end function

tailSet = {}

while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	dir = line[0]
	dx = 0
	dy = 0
	if dir == "R" then dx = 1
	if dir == "L" then dx = -1
	if dir == "U" then dy = 1
	if dir == "D" then dy = -1
	for i in range(1, val(line[2:]))
		rope[0][0] = rope[0][0] + dx
		rope[0][1] = rope[0][1] + dy
		for j in range(1, 9)
			follow rope[j-1], rope[j]
		end for
		//print "head: " + rope[0] + "  tail: " + rope[-1]
		tailSet.push rope[-1][:]
		draw
	end for
end while

print tailSet.len
