import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

f = file.open("input.txt")
//f = file.open("example.txt")

stacks = []

printStacks = function
	for i in stacks.indexes
		print stacks[i].join(" ")
	end for
end function

resultA = []
resultB = []
while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	
	if line[:3] == " 1 " then break  // got to numbers
	if not stacks then
		stacks = []
		for i in range(1, ceil(line.len/4))
			stacks.push []
		end for
		print "Initialized to " + stacks.len + " stacks"
	end if
	for i in stacks.indexes
		item = line[i*4+1]
		if item == " " then continue
		print "Found " + item + " in stack " + i
		stacks[i].insert 0, item
	end for
end while
printStacks

while not f.atEnd
	line = f.readLine.trim
	if not line then continue
	m = line.match("move {qty} from {src} to {dst}")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.applyToValues @val
	print m
	m.stuffInto locals
	print "Moving " + qty + " from " + src + " to " + dst
	items = stacks[src-1][-qty:]
	stacks[src-1] = stacks[src-1][:-qty]
	stacks[dst-1] = stacks[dst-1] + items
	printStacks
	//key.get
end while
f.close

for i in stacks.indexes
	print stacks[i].join(" ")
	if stacks[i] then
		resultA.push stacks[i][-1]
	else
		resultA.push " "
	end if
end for

print "final answer (part A): " + resultA.join("")
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean