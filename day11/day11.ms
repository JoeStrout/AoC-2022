if 1 then fname = "input.txt" else fname = "example.txt"

Monkey = {}
Monkey.items = null
Monkey.op = null
Monkey.divBy = 1
Monkey.ifTrue = -1
Monkey.ifFalse = -1
Monkey.init = function(items)
	self.items = items
end function
Monkey.inspectCount = 0

Monkey.doOneItem = function
	if not self.items then return false
	item = self.items.pull
	self.inspectCount = self.inspectCount + 1
	print "monkey " + monkeys.indexOf(self) + " inspects item " + item
	item = self.op(item)
	print "worry level becomes " + item
	item = floor(item/3)
	
	print "monkey gets bored, worry level drops to " + item
	if item % self.divBy == 0 then
		print "monkey passes to " + self.ifTrue
		monkeys[self.ifTrue].items.push item
	else
		print "monkey passes to " + self.ifFalse
		monkeys[self.ifFalse].items.push item
	end if
	return self.items.len > 0
end function

doOneRound = function
	for idx in monkeys.indexes
		m = monkeys[idx]
		while m.doOneItem; end while
	end for
end function

monkeys = []
if fname == "example.txt" then
	m = new Monkey
	m.init [79,98]
	m.op = function(old); return old*19; end function
	m.divBy = 23
	m.ifTrue = 2
	m.ifFalse = 3
	monkeys.push m
	
	m = new Monkey
	m.init [54, 65, 75, 74]
	m.op = function(old); return old + 6; end function
	m.divBy = 19
	m.ifTrue = 2
	m.ifFalse = 0
	monkeys.push m
	
	m = new Monkey
	m.init [79, 60, 97]
	m.op = function(old); return old * old; end function
	m.divBy = 13
	m.ifTrue = 1
	m.ifFalse = 3
	monkeys.push m
	
	m = new Monkey
	m.init [74]
	m.op = function(old); return old + 3; end function
	m.divBy = 17
    m.ifTrue = 0
    m.ifFalse = 1
	monkeys.push m
else
	m = new Monkey
	m.init [83, 97, 95, 67]
	m.op = function(old); return old * 19; end function
	m.divBy = 17
	m.ifTrue = 2
	m.ifFalse = 7
	monkeys.push m

	m = new Monkey
	m.init [71, 70, 79, 88, 56, 70]
	m.op = function(old); return old + 2; end function
	m.divBy = 19
	m.ifTrue = 7
	m.ifFalse = 0
	monkeys.push m

	m = new Monkey
	m.init [98, 51, 51, 63, 80, 85, 84, 95]
	m.op = function(old); return old + 7; end function
	m.divBy = 7
	m.ifTrue = 4
	m.ifFalse = 3
	monkeys.push m

	m = new Monkey
	m.init [77, 90, 82, 80, 79]
	m.op = function(old); return old + 1; end function
	m.divBy = 11
	m.ifTrue = 6
	m.ifFalse = 4
	monkeys.push m

	m = new Monkey
	m.init [68]
	m.op = function(old); return old * 5; end function
	m.divBy = 13
	m.ifTrue = 6
	m.ifFalse = 5
	monkeys.push m

	m = new Monkey
	m.init [60, 94]
	m.op = function(old); return old + 5; end function
	m.divBy = 3
	m.ifTrue = 1
	m.ifFalse = 0
	monkeys.push m

	m = new Monkey
	m.init [81, 51, 85]
	m.op = function(old); return old * old; end function
	m.divBy = 5
	m.ifTrue = 5
	m.ifFalse = 1
	monkeys.push m

	m = new Monkey
	m.init [98, 81, 63, 65, 84, 71, 84]
	m.op = function(old); return old + 3; end function
	m.divBy = 2
	m.ifTrue = 2
	m.ifFalse = 3
	monkeys.push m
end if


for round in range(1,20)
	doOneRound
end for

// sort by inspection count
monkeys.sort "inspectCount"
print "Most activity:" + monkeys[-1].inspectCount + ", " + monkeys[-2].inspectCount
print "Monkey business: " + monkeys[-1].inspectCount * monkeys[-2].inspectCount
