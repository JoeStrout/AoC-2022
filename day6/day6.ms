import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

f = file.open("input.txt")
//f = file.open("example.txt")

resultA = []
resultB = []
while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	f.close
	for i in range(14, line.len)
		s = line[i-14:i]
		d = {}
		for c in s; d.push c; end for
		if d.len == 14 then
			print s + " after " + i
			exit
		end if
	end for
end while
f.close
