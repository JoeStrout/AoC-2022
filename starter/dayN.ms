import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

//f = file.open("input.txt")
f = file.open("example.txt")

totalA = 0
totalB = 0
while not f.atEnd
	line = f.readLine
	if line == null then break // end of file

	m = line.match("{p1},{p2}")
	if not m then continue

//	span1 = Span.make(m.p1)
//	span2 = Span.make(m.p2)
	
	valueA = null
	
	valueB = null
	
	print m + ": " + valueA + ", " + valueB
	totalA = totalA + valueA
	totalB = totalB + valueB
end while
f.close

print "total (part A): " + totalA
print "total (part B): " + totalB
