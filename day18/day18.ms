import "aoc"

resultA = []
resultB = []

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

cubes = {}

for line in lines
	m = line.match("{x},{y},{z}")
	m.applyToValues @val
	cubes[line] = m
end for

hasNeighbor = function(cube, dx, dy, dz)
	k = (cube.x+dx) + "," + (cube.y+dy) + "," + (cube.z+dz)
	return cubes.hasIndex(k)
end function

count = 0
for cube in cubes.values
	print "checking " + cube
	count = count + (not hasNeighbor(cube, -1, 0, 0))
	count = count + (not hasNeighbor(cube, 1, 0, 0))
	count = count + (not hasNeighbor(cube, 0, -1, 0))
	count = count + (not hasNeighbor(cube, 0, 1, 0))
	count = count + (not hasNeighbor(cube, 0, 0, -1))
	count = count + (not hasNeighbor(cube, 0, 0, 1))
end for
print "Faces: " + count

