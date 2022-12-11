import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

resultA = []
resultB = []
for line in lines
	m = line.match("{p1},{p2}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if

//	span1 = Span.make(m.p1)
//	span2 = Span.make(m.p2)
	
	valueA = null
	
	valueB = null
	
	print m + ": " + valueA + ", " + valueB
	resultA.push valueA
	resultB.push valueB
end while

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean