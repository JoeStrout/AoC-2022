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
	
	overlap = bFrom <= aTo and bTo >= aFrom
	
	print aFrom + "-" + aTo + " vs " + bFrom + "-" + bTo + ": " + overlap
	total = total + overlap
end while

print "total: " + total