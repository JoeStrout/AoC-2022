import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

//f = file.open("input.txt")
f = file.open("example.txt")

resultA = []
resultB = []
while not f.atEnd
	line = f.readLine
	if line == null then break // end of file

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
f.close

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean