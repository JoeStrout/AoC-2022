import "stringUtil"
import "listUtil"

if 1 then fname = "input.txt" else fname = "example.txt"
f = file.open(fname)

x = 1
cycle = 1

clear
text.delimiter = ""
checkCycle = function
	if (cycle-1) % 40 == 0 then print char(13)
	col = text.column
	if abs(x-col) <= 1 then
		text.color = color.orange
		print "#"
	else
		text.color = color.gray
		print "."
	end if
end function	

while not f.atEnd
	line = f.readLine
	if line == null then break // end of file

	checkCycle
	if line.startsWith("noop") then
		cycle = cycle + 1
	else if line.startsWith("addx") then
		cycle = cycle + 1
		checkCycle
		cycle = cycle + 1
		x = x + val(line.split(" ")[1])
	end if
end while
f.close
text.delimiter = char(13)
