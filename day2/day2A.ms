// https://adventofcode.com/2022/day/2
score = {}
score.AX = 3 + 1; score.AY = 6 + 2; score.AZ = 0 + 3
score.BX = 0 + 1; score.BY = 3 + 2; score.BZ = 6 + 3
score.CX = 6 + 1; score.CY = 0 + 2; score.CZ = 3 + 3

f = file.open("day2-input.txt")
total = 0
while true
	line = f.readLine
	if line == null then break // end of file
	points = score[line.replace(" ", "")]
	total = total + points
	print line + ": " + points + ", total=" + total
end while

