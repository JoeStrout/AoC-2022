import "stringUtil"
import "listUtil"

if 1 then fname = "input.txt" else fname = "example.txt"
f = file.open(fname)

x = 1
cycle = 1
resultA = []

checkCycle = function
	if [20,60,100,140,180,220].contains(cycle) then
		print "Cycle " + cycle + ", x: " + x + " --> " + cycle*x
		resultA.push x * cycle
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

print "final answer (part A): " + resultA.sum
