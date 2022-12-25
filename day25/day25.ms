if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

values = {"2":2, "1":1, "0":0, "-":-1, "=":-2}

snafuToDec = function(s)
	power = 1
	result = 0
	for i in range(s.len - 1)
		result = result + values[s[i]] * power
		power = power * 5
	end for
	return result
end function

decToSnafu = function(d)
	digits = []
	while d
		x = d % 5
		if x == 4 then
			digits.insert 0, "-"
			d = d + 1
		else if x == 3 then
			digits.insert 0, "="
			d = d + 2
		else
			digits.insert 0, str(x)
		end if
		d = floor(d / 5)
	end while
	return digits.join("")
end function

resultA = []

for line in lines
	dec = snafuToDec(line)
	print line + " → " + dec + " → " + decToSnafu(dec)
	
	resultA.push dec
end for

sum = resultA.sum
print "final answer (part A): " + sum + " → " + decToSnafu(sum)
