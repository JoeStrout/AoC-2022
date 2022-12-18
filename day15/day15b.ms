import "stringUtil"
import "listUtil"
import "aoc"

resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

if fname == "example.txt" then maxY = 20 else maxY = 4000000

compareSpans = function(a,b)
	if a.startVal == b.startVal then
		return a.endVal - b.endVal
	else
		return a.startVal - b.startVal
	end if
end function

observations = []
for line in lines
	m = line.match("Sensor at x={sx}, y={sy}: closest beacon is at x={bx}, y={by}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.applyToValues @val
	observations.push m
end for

for yOfInterest in range(0,maxY)
	if yOfInterest % 1000 == 0 then print yOfInterest + "..."
	spans = []
	for m in observations
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
	
	if spans.len > 1 then spans.sortWithFunction @compareSpans
	spanStrs = []
	for s in spans
		spanStrs.push s.str
	end for
	if spans[0].startVal > 0 then
		print "y:" + yOfInterest + "  spans: " + spanStrs.join("; ")
		exit
	end if
	if spans.len == 1 then
		if spans[0].endVal < maxY then
			print "y:" + yOfInterest + "  spans: " + spanStrs.join("; ")
			exit
		end if
	else
		x = spans[0].endVal
		for i in range(1, spans.len-1)
			if spans[i].startVal > x+1 then
				print "y:" + yOfInterest + "  spans: " + spanStrs.join("; ")
				exit
			end if
			x = spans[i].endVal
		end for
	end if
end for
