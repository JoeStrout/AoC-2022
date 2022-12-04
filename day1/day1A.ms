// https://adventofcode.com/2022/day/1
f = file.open("input.txt")

maxTotal = 0
curTotal = 0
while true
	line = f.readLine
	print line
	if not line then
		// done with elf
		if curTotal > maxTotal then maxTotal = curTotal
		print "Total: " + curTotal + "  Max: " + maxTotal
		curTotal = 0
	else
		curTotal = curTotal + val(line)
	end if
	if line == null then exit // end of file
end while
