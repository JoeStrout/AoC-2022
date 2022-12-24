import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop
lines.apply @val

msg = lines[:]

list.moveFromTo = function(idxA, idxB)
	value = self[idxA]
	self.remove idxA
	if idxB > idxA then self.insert idxB-1, value else self.insert idxB, value
end function

indexes = range(0, msg.len-1)

for idx in indexes[:]
	oldIdx = indexes.indexOf(idx)
	value = msg[oldIdx]
	if value == 0 then continue
	steps = value % (msg.len - 1)
	idx = (oldIdx + steps + (steps>0)) % msg.len
	if idx < 0 then idx = idx + msg.len
	msg.moveFromTo oldIdx, (idx % msg.len)
	indexes.moveFromTo oldIdx, (idx % msg.len)
	if 0 then
		print "Moved " + value + " from " + oldIdx + " to " + idx
		print msg
	end if
end for

zeroIdx = msg.indexOf(0)
resultA.push msg[(zeroIdx + 1000) % msg.len]
resultA.push msg[(zeroIdx + 2000) % msg.len]
resultA.push msg[(zeroIdx + 3000) % msg.len]

print "key numbers: " + resultA
print "final answer (part A): " + resultA.sum
//print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean