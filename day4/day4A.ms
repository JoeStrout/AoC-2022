f = file.open("day4-input.txt")
total = 0
while true
	line = f.readLine
	if line == null then break // end of file
	
	parts = line.split(",")
	aFrom = parts[0].split("-")[0].val
	aTo = parts[0].split("-")[1].val
	bFrom = parts[1].split("-")[0].val
	bTo = parts[1].split("-")[1].val
	
	contained = (bFrom >= aFrom and bTo <= aTo) or
	   (aFrom >= bFrom and aTo <= bTo)
	
	print aFrom + "-" + aTo + " vs " + bFrom + "-" + bTo + ": " + contained
	total = total + contained
end while

print "total: " + total