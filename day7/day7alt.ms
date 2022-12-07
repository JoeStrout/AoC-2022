f = file.open("input.txt")
//f = file.open("example.txt")

Node = {}
Node.name = ""
Node.size = 0

DirNode = new Node
DirNode.children = null // map from name to Node
DirNode.addChild = function(node)
	self.children[node.name] = node
	node.parent = self
end function
DirNode.size = function
	sum = 0
	for c in self.children.values
		sum = sum + c.size
	end for
	return sum
end function

root = new DirNode
root.name = ""
root.children = {}

curDir = root
allDirs = []

while not f.atEnd
	line = f.readLine
	if line == null then break // end of file
	print line
	m = line.match("$ cd {subdir}")
	if m then
		if m.subdir == "/" then
			curDir = root
		else if m.subdir == ".." then
			curDir = curDir.parent
		else
			curDir = curDir.children[m.subdir]
		end if
	else if line == "$ ls" then
		continue
	else
		// file line
		sizeOrDir = line.split(" ")[0]
		name = line.split(" ")[1]
		if sizeOrDir == "dir" then
			noob = new DirNode
			noob.children = {}
			allDirs.push noob
		else
			noob = new Node
			noob.size = sizeOrDir.val
		end if
		noob.name = name
		curDir.addChild noob
	end if
end while
f.close

// find sum of small dirs
resultA = []
for e in allDirs
	sz = e.size
	if sz <= 100000 then
		print "Small dir: " + e.name + " of size: " + sz
		resultA.push sz
	end if
end for
print "final answer (part A): " + resultA.sum

diskSize = 70000000
spaceUsed = root.size
curFree = diskSize - spaceUsed
spaceRequired = 30000000
needed = spaceRequired - curFree
print "Need to find " + needed + " bytes"

// Now find smallest dir that's at least needed bytes
best = null
for d in allDirs
	sz = d.size
	if sz < needed then continue
	if best == null or sz < best then best = sz
end for
print "final answer (part B): " + best

