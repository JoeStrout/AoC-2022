import "vector3"

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

cubes = []
volume = list.init3d(21, 21, 21, 0)

for line in lines
	pos = line.split(",")
	pos.apply @val
	cubes.push pos
	volume.set pos, 1
end for

count = 0
for cube in cubes.values
	for n in vector3.neighbors6
		npos = cube.plus(n)
		if not volume.get(npos) then count = count + 1
	end for
end for
print "Faces: " + count
