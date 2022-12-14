import "json"

if 1 then fname = "input.txt" else fname = "example.txt"

f = file.open(fname)
resultA = []

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
		if i >= lhs.len then return i < rhs.len
		if i >= rhs.len then return -1
		result = compare(lhs[i], rhs[i])
		if result != 0 then return result
		i = i + 1
	end while
end function

index = 1
while not f.atEnd
	p1 = f.readLine
	if p1 == null then break
	p1 = json.parse(p1)
	p2 = json.parse(f.readLine)
	f.readLine  // skip
	
	print "Compare: " + p1
	print "     to: " + p2
	result = compare(p1, p2)
	if result > 0 then resultA.push index
	
	index = index + 1
end while
f.close

print "final answer (part A): " + resultA.sum
