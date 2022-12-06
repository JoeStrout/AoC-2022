
// = file.open("input.txt")
line = file.readLines("example.txt")[0]

for i in range(4, line.len)
	s = line[i-4:i]
	d = {}
	for c in s; d.push c; end for
	if d.len == 4 then
		print s + " after " + i
		exit
	end if
end for
