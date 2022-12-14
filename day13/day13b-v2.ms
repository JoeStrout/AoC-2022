import "stringUtil"
import "aoc"
import "json"

if 1 then fname = "input.txt" else fname = "example.txt"
f = file.open(fname)

// return >0 if lhs and rhs are in the right order;
// <0 if in the wrong order;
// 0 if unknown
compare = function(lhs, rhs)
	if lhs isa number and rhs isa number then
		return rhs - lhs
	end if
	if lhs isa number then lhs = [lhs]
	if rhs isa number then rhs = [rhs]
	i = 0
	while true
		if i >= lhs.len then
			if i >= rhs.len then return 0
			return 1
		end if
		if i >= rhs.len then return -1
		result = compare(lhs[i], rhs[i])
		if result != 0 then return result
		i = i + 1
	end while
end function

packets = []
packets.push [[2]]
packets.push [[6]]

index = 1
while not f.atEnd
	p1 = f.readLine
	if p1 == null then break
	p1 = json.parse(p1)
	p2 = json.parse(f.readLine)
	f.readLine  // skip
	
	packets.push p1
	packets.push p2
end while
f.close

print "Sorting"
packets.sortWithFunction @compare
packets.reverse		// (because I got the sign wrong in my compare function)

idx1 = packets.indexOf( [[2]] ) + 1
idx2 = packets.indexOf( [[6]] ) + 1
print "divider packets at " + idx1 + " and " + idx2 + ", so: " + (idx1*idx2)
