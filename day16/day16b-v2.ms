import "aoc"
import "search"

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

valves = {}
goodValves = []

for line in lines
print line
	m = line.match("Valve {name} has flow rate={rate}; tunnels lead to valves {exits}")
	if m == null then
		m = line.match("Valve {name} has flow rate={rate}; tunnel leads to valve {exits}")
	end if
	m.rate = val(m.rate)
	m.exits = m.exits.split(", ")
	print m
	valves[m.name] = m
	if m.name == "AA" or m.rate > 0 then goodValves.push m.name
end for

// Find the travel time from every good (rate > 0, plus "AA")
// to every other open valve.
travelTime = {}
pather = new search.Search
pather.neighbors = function(state)
	result = {}
	for e in valves[state].exits
		result.push e
	end for
	return result
end function
for a in goodValves
	timesFromA = {}
	travelTime[a] = timesFromA
	for b in goodValves
		if b == a then continue	// don't go to self
		if b == "AA" and valves.AA==0 then continue	// (don't bother going back to A)
		timesFromA[b] = pather.findPath(a, b).len - 1
	end for
end for
// ...and then remove AA, if it has no flow
if valves.AA == 0 then goodValves.removeVal "AA"


State = {}
State.current = "AA" // current location
State.closed = null // list of valves still to open
State.timeLeft = 30
State.make = function(location, closed, timeLeft)
	noob = new State
	noob.current = location
	noob.closed = closed
	noob.timeLeft = timeLeft
	return noob
end function
State.key = function
	return self.current + self.closed.join("") + self.timeLeft
end function

// memo key: a State.key; value: best score (released pressure) from
// just the open valves in that time
memo = {}	

// Get the best score possible for the given state
bestScore = function(state)
	key = state.key
	if memo.hasIndex(key) then return memo[key]
	if state.timeLeft < 1 then return 0	// no time to do anything
	
	timeLeft = state.timeLeft
	
	// consider opening this valve
	rate = valves[state.current].rate
	if rate > 0 then
		baseScore = rate * (state.timeLeft - 1)
		timeLeft = timeLeft - 1
	else
		baseScore = 0
	end if
	whatsLeft = state.closed[:]
	whatsLeft.removeVal state.current
	// consider doing that, and then going to each of the other closed valves
	score = baseScore
	for dest in whatsLeft
		travel = travelTime[state.current][dest]
		if travel >= state.timeLeft then continue
		dscore = baseScore + bestScore(State.make(dest, whatsLeft, 
		  timeLeft - travel))
		if dscore > score then score = dscore
	end for
	
	// and now we have our best score!  remember it, and return it.
	memo[key] = score

	if memo.len % 1000 == 0 then
		print "Check " + memo.len + ": " + key + " has score " + score
	end if
	
	return score
end function

// Find all ways to divide up the valves among me and the elephant.
// (Note that it doesn't matter who does which, so we only need to
// go up to half the number of good valves.)
totalBest = 0
for n in range(1, goodValves.len/2)
	combos = goodValves.combinations(n)
	for i in combos.indexes
		setA = combos[i]
		setB = goodValves[:]
		for v in setA; setB.removeVal v; end for
		print setA + " and " + setB + " (" + i + "/" + combos.len + "...)"
		score = bestScore(State.make("AA", setA, 26)) +
		  bestScore(State.make("AA", setB, 26))
		print "Score: " + score + " NEW BEST!" * (score > totalBest)
		totalBest = max(totalBest, score)
	end for
end for
print "Total best: " + totalBest