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
	// m = line.match("{s1}-{e1},{s2}-{e2}")
	// if not m then continue
	// m.applyToValues @val
	// m.stuffInto locals
	m = line.match("{p1},{p2}")
	if not m then continue
	span1 = Span.make(m.p1)
	span2 = Span.make(m.p2)
	
	contained = span1.contains(span2) or span2.contains(span1)
	overlap = span1.overlaps(span2)
	
	print span1.str + ", " + span2.str + ": " + contained + ", " + overlap
	totalA = totalA + contained
	totalB = totalB + overlap
end while
f.close

print "total (part A): " + totalA
print "total (part B): " + totalB
