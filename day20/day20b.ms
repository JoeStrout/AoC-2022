import "mapUtil"
import "listUtil"
import "aoc"

partTwo = false
if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

lines.apply @val
msg = lines
if partTwo then msg.multiplyBy 811589153

list.moveFromTo = function(idxA, idxB)
	value = self[idxA]
	self.remove idxA
	if idxB > idxA then self.insert idxB-1, value else self.insert idxB, value
end function

indexes = range(0, msg.len-1)

for iteration in range(1, 1 + 9 * partTwo)
	print "Iteration " +  iteration + "..."
	for idx in range(0, msg.len-1)
		oldIdx = indexes.indexOf(idx)
		value = msg[oldIdx]
		if value == 0 then continue
		steps = value % (msg.len - 1)
		idx = (oldIdx + steps + (steps>0)) % msg.len
		if idx < 0 then idx = idx + msg.len
		msg.moveFromTo oldIdx, (idx % msg.len)
		indexes.moveFromTo oldIdx, (idx % msg.len)
	end for
end for

result = []
zeroIdx = msg.indexOf(0)
result.push msg[(zeroIdx + 1000) % msg.len]
result.push msg[(zeroIdx + 2000) % msg.len]
result.push msg[(zeroIdx + 3000) % msg.len]

print "key numbers: " + result
print "final answer: " + result.sum
