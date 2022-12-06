import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

f = file.open("input.txt")
//f = file.open("example.txt")

stacks = []
result = []

// Load initial stack configuration
while not f.atEnd
	line = f.readLine	
	if line[:3] == " 1 " then break  // got to numbers
	if not stacks then
		stacks = []
		for i in range(1, ceil(line.len/4))
			stacks.push []
		end for
	end if
	for i in stacks.indexes
		item = line[i*4+1]
		if item == " " then continue
		stacks[i].insert 0, item
	end for
end while

// apply all the specified moves
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
	for i in range(1, qty)
		item = stacks[src-1].pop
		stacks[dst-1].push item
	end for
end while
f.close

// find result (top item of each stack)
for i in stacks.indexes
	if stacks[i] then
		result.push stacks[i][-1]
	else
		result.push " "
	end if
end for

print "final : " + result.join("")
