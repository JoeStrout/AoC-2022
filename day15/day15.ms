import "aoc"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

if fname == "example.txt" then yOfInterest = 10 else yOfInterest = 2000000

// Loop over sensors (one per line), and build spans representing
// the coverage on the row of interest.
spans = []
for line in lines
	m = line.match("Sensor at x={sx}, y={sy}: closest beacon is at x={bx}, y={by}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.applyToValues @val
	m.stuffInto @locals
	distToSensor = abs(bx-sx) + abs(by-sy)
	ydiff = abs(sy - yOfInterest)
	if ydiff > distToSensor then continue
	radiusAtY = distToSensor - ydiff
	span = Span.make(sx - radiusAtY, sx + radiusAtY)
	
	found = false
	for i in spans.indexes
		if spans[i].overlaps(span) then
			spans[i] = spans[i].union(span)
			found = true
			break
		end if
	end for
	if not found then spans.push span
end for

// Further combine any spans that can be combined.
while spans.len > 1
	didAny = false
	for i in range(spans.len-1, 1)
		for j in range(i-1)
			if spans[j].overlaps(spans[i]) then
				spans[j] = spans[j].union(spans[i])
				spans.remove i
				didAny = true
				break
			end if
		end for
		if didAny then break
	end for
	if not didAny then break
end while

// Find the total area covered by the remaining span(s).
resultA = []
for s in spans
	resultA.push s.endVal - s.startVal
end for

print "final answer (part A): " + resultA.sum
