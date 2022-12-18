import "aoc"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

cubes = {}

for line in lines
	m = line.match("{x},{y},{z}")
	m.applyToValues @val
	cubes[line] = m
end for

outside = list.init3d(21, 21, 21, false)
toDo = [ [0,0,0] ]
while toDo
	item = toDo.pop
	k = item.join(",")
	if cubes.hasIndex(k) then continue
	if item[0] < 0 or item[0] > 20 then continue
	if item[1] < 0 or item[1] > 20 then continue
	if item[2] < 0 or item[2] > 20 then continue
	
	if outside[item[0]][item[1]][item[2]] then continue
	
	outside[item[0]][item[1]][item[2]] = true
	toDo.push [item[0]+1, item[1], item[2]]
	toDo.push [item[0]-1, item[1], item[2]]
	toDo.push [item[0], item[1]+1, item[2]]
	toDo.push [item[0], item[1]-1, item[2]]
	toDo.push [item[0], item[1], item[2]+1]
	toDo.push [item[0], item[1], item[2]-1]
end while

isOutside = function(cube, dx, dy, dz)
	x = cube.x + dx
	y = cube.y + dy
	z = cube.z + dz
	if x < 0 or x > 20 or y < 0 or y > 20 or z < 0 or z > 20 then return true
	return outside[cube.x+dx][cube.y+dy][cube.z+dz]
end function

count = 0
for cube in cubes.values
	count = count + isOutside(cube, -1, 0, 0)
	count = count + isOutside(cube, 1, 0, 0)
	count = count + isOutside(cube, 0, -1, 0)
	count = count + isOutside(cube, 0, 1, 0)
	count = count + isOutside(cube, 0, 0, -1)
	count = count + isOutside(cube, 0, 0, 1)
end for
print "Faces: " + count

