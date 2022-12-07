f = file.open("input.txt")
//f = file.open("example.txt")

contents = {} // key: path; value: list of [name, size]
curDir = "/"
curEntries = []
contents[curDir] = curEntries

while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	print line
	m = line.match("$ cd {subdir}")
	if m then
		if m.subdir == "/" then
			curDir = "/"
		else if m.subdir == ".." then
			curDir = file.parent(curDir)
		else
			newDir = file.child(curDir, m.subdir)
			curDir = newDir
		end if
		if contents.hasIndex(curDir) then
			curEntries = contents[curDir]
		else
			curEntries = []
			contents[curDir] = curEntries
		end if
	else if line == "$ ls" then
		continue
	else
		// file line
		sizeOrDir = line.split(" ")[0]
		name = line.split(" ")[1]
		if sizeOrDir == "dir" then
			curEntries.push [name, "dir"]
		else
			curEntries.push [name, sizeOrDir.val]
		end if
	end if
end while
f.close

dirSize = function(path)
	entries = contents[path]
	sum = 0
	for e in entries
		if e[1] == "dir" then
			sum = sum + dirSize(file.child(path, e[0]))
		else
			sum = sum + e[1]
		end if
	end for
	return sum
end function

resultA = []
findSmallDirs = function(path)
	for e in contents[path]
		if e[1] == "dir" then
			subpath = file.child(path, e[0])
			sz = dirSize(subpath)
			if sz <= 100000 then
				print "Small dir: " + subpath + " of size: " + sz
				resultA.push sz
			end if
			findSmallDirs subpath
		end if
	end for
end function

findSmallDirs "/"
print "final answer (part A): " + resultA.sum

diskSize = 70000000
spaceUsed = dirSize("/")
curFree = diskSize - spaceUsed
spaceRequired = 30000000
needed = spaceRequired - curFree
print "Need to find " + needed + " bytes"

// Now find smallest dir that's at least needed bytes
best = null
for d in contents.indexes
	sz = dirSize(d)
	if sz < needed then continue
	if best == null or sz < best then best = sz
end for
print "final answer (part B): " + best

