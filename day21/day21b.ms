import "stringUtil"
import "eval"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

Monkey = {}
Monkey.value = null
Monkey.op = ""
Monkey.dependsOn = null  // list of 2 monkeys, or null

Monkey.make = function(line)
	m = line.match("{name}: {name1} {op} {name2}")
	if m == null then
		m = line.match("{name}: {value}")
		if m.value == "0" or val(m.value) then
			noob = new Monkey
			noob.name = m.name
			noob.value = val(m.value)
			return noob
		end if
		print "Error: " + line
		exit
	end if
	noob = new Monkey
	noob.name = m.name
	noob.dependsOn = [m.name1, m.name2]
	noob.op = m.op
	return noob
end function
Monkey.dependsOnHumn = function
	if self.dependsOn == null then return false
	if self.dependsOn.contains("humn") then return true
	return monkeys[self.dependsOn[0]].dependsOnHumn or
	  monkeys[self.dependsOn[1]].dependsOnHumn
end function
Monkey.evaluate = function
	if self.value != null then return self.value
	arg0 = monkeys[self.dependsOn[0]].evaluate
	arg1 = monkeys[self.dependsOn[1]].evaluate
	self.value = eval.eval(arg0 + self.op + arg1)
	return self.value
end function
Monkey.solve = function(forValue)
	print "Solving " + self.name + " = " + forValue
	m0 = monkeys[self.dependsOn[0]]; m1 = monkeys[self.dependsOn[1]]
	if m0.dependsOnHumn or m0.name == "humn" then
		arg1 = m1.evaluate
		if self.op == "+" then
			newVal = forValue - arg1
		else if self.op == "-" then
			newVal = forValue + arg1
		else if self.op == "*" then
			newVal = forValue / arg1
		else if self.op == "/" then
			newVal = forValue * arg1
		else
			print "unknown op " + self.op
			exit
		end if
		if m0.name == "humn" then solvedAs newVal
		m0.solve newVal
	else if m1.dependsOnHumn or m1.name == "humn" then
		arg0 = m0.evaluate
		if self.op == "+" then
			newVal = forValue - arg0
		else if self.op == "-" then
			newVal = arg0 - forValue
		else if self.op == "*" then
			newVal = forValue / arg0
		else if self.op == "/" then
			newVal = arg0 / forValue
		else
			print "unknown op " + self.op
			exit
		end if
		if m1.name == "humn" then solvedAs newVal
		m1.solve newVal	
	end if
end function
			
solvedAs = function(solution)
	print "humn must be: " + solution
	exit
end function

monkeys = {}	// key: name; value: monkey

for line in lines
	m = Monkey.make(line)
	monkeys[m.name] = m
end for

pprint monkeys.root
m0 = monkeys[monkeys.root.dependsOn[0]]
m1 = monkeys[monkeys.root.dependsOn[1]]
m0.solve m1.evaluate

