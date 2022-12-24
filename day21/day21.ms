import "stringUtil"
import "eval"

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

Monkey = {}
Monkey.value = null		// numeric value, if known; else null
Monkey.op = ""			// operator (+, -, *, or -)
Monkey.dependsOn = null	// list of 2 monkey names, or null

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
Monkey.evaluate = function
	if self.value != null then return self.value
	arg0 = monkeys[self.dependsOn[0]].evaluate
	arg1 = monkeys[self.dependsOn[1]].evaluate
	self.value = eval.eval(arg0 + self.op + arg1)
	return self.value
end function

monkeys = {}	// key: name; value: monkey

for line in lines
	m = Monkey.make(line)
	monkeys[m.name] = m
end for

print monkeys.root.evaluate

