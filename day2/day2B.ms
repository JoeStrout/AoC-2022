// https://adventofcode.com/2022/day/2
score = {}
score.AX = 0 + 3; score.AY = 3 + 1; score.AZ = 6 + 2
score.BX = 0 + 1; score.BY = 3 + 2; score.BZ = 6 + 3
score.CX = 0 + 2; score.CY = 3 + 3; score.CZ = 6 + 1

f = file.open("day2-input.txt")
total = 0
while true
	line = f.readLine
	if line == null then break // end of file
	points = score[line.replace(" ", "")]
	total = total + points
	print line + ": " + points + ", total=" + total
end while

