// https://adventofcode.com/2022/day/1
f = file.open("input.txt")

top3 = [0,0,0]
curTotal = 0
while true
	line = f.readLine
	print line
	if not line then
		// done with elf
		top3.push curTotal
		top3.sort
		top3.pull
		print "Total: " + curTotal + "  Top 3: " + top3
		curTotal = 0
	else
		curTotal = curTotal + val(line)
	end if
	if line == null then break // end of file
end while

print "Sum of top 3: " + top3.sum
