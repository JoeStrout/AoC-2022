import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"
import "search"

resultA = []
resultB = []

if 1 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
if not lines[-1] then lines.pop

Valve = {}

valves = {} // name : Valve
goodValves = []

for line in lines
	line = line.replace("valves", "valve")
	m = line.match("Valve {name} has flow rate={rate}; {} to valve {exits}")
	m.rate = val(m.rate)
	m.exits = m.exits.split(", ")
	m.__isa = Valve
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
State.isElephant = false
State.timeLeft = 30
State.make = function(location, closed, timeLeft, isElephant)
	noob = new State
	noob.current = location
	noob.closed = closed
	noob.timeLeft = timeLeft
	noob.isElephant = isElephant
	return noob
end function
State.key = function
	return self.current + self.closed.join("") + self.timeLeft + "E"*self.isElephant
end function

// memo key: a State.key; value: best score (released pressure) from
// just the open valves in that time
memo = {}	

// Get the best score possible for a given state
bestScore = function(state)
	key = state.key
	if memo.hasIndex(key) then return memo[key]
	if state.timeLeft < 1 then
		// We're out of time... but if we're not the elephant, then
		// now give the elephant a chance to plan his own moves,
		// working on whatever valves we couldn't get to.
		if state.isElephant then return 0	// no time to do anything
//		print "Starting elephant with " + state.closed
		return bestScore(State.make("AA", state.closed, 26, true))
	end if
	
	timeLeft = state.timeLeft
	score = 0
	
	// consider stopping here (before we even open our valve)
	// and letting the elephant do the rest
	if not state.isElephant then
		escore = bestScore(State.make("AA", state.closed, 26, true))
		score = escore
	end if
	
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
	score = max(score, baseScore)
	
	// consider stopping now, and letting the elephant do the rest
	if not state.isElephant then
		escore = bestScore(State.make("AA", whatsLeft, 26, true))
		score = max(score, escore)
	end if

	// or consider opening our valve, and then going to each of the other closed valves
	for dest in whatsLeft
		travel = travelTime[state.current][dest]
		if travel >= state.timeLeft and state.isElephant then continue
		dscore = baseScore + bestScore(State.make(dest, whatsLeft, 
		  timeLeft - travel, state.isElephant))
		score = max(score, dscore)
	end for

	// and now we have our best score!  remember it, and return it.
	memo[key] = score

	if memo.len % 100 == 0 then
		print "Check " + memo.len + ": " + key + " has score " + score
	end if
	
	return score
end function

startState = State.make("AA", goodValves, 26, false)
print bestScore(startState)

// expanded 3015179 states
