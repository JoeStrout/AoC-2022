import "mapUtil"
import "aoc"

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if not lines[-1] then lines.pop

plans = []

for line in lines
	m = line.match("Blueprint {num}: Each ore robot costs {oreCost} ore. Each clay robot costs {clayCost} ore. Each obsidian robot costs {obsOreCost} ore and {obsClayCost} clay. Each geode robot costs {geoOreCost} ore and {geoObsCost} obsidian.")
	if not m then
		print "Pattern did not match on line: " + line
		continue
	end if
	m.applyToValues @val
	print m
	plans.push m
end for

memo = {}
bestScore = function(plan, ore, clay, obs, geo, oreBots, clayBots, obsBots, geoBots, timeLeft)
	//print [ore, clay, obs, geo, oreBots, clayBots, obsBots, geoBots, timeLeft].join(",")
	nextGeo = geo + geoBots
	if timeLeft == 1 then return nextGeo
	nextOre = ore + oreBots
	nextClay = clay + clayBots
	nextObs = obs + obsBots
	if ore >= plan.geoOreCost and obs >= plan.geoObsCost then
		return bestScore(plan, nextOre - plan.geoOreCost, nextClay, 
			nextObs - plan.geoObsCost,
			nextGeo, oreBots, clayBots, obsBots, geoBots + 1, timeLeft - 1)
	end if
	if ore >= plan.obsOreCost and clay >= plan.obsClayCost then
		return bestScore(plan, nextOre - plan.obsOreCost, nextClay - plan.obsClayCost,
			nextObs, nextGeo, oreBots, clayBots, obsBots + 1, geoBots, timeLeft - 1)
	end if
	options = []
	if ore < 6 then
		options.push bestScore(plan, nextOre, nextClay, nextObs,
			nextGeo, oreBots, clayBots, obsBots, geoBots, timeLeft - 1)
	end if
	if ore >= plan.oreCost then
		options.push bestScore(plan, nextOre - plan.oreCost, nextClay, nextObs,
			nextGeo, oreBots + 1, clayBots, obsBots, geoBots, timeLeft - 1)
	end if
	if ore >= plan.clayCost then
		options.push bestScore(plan, nextOre - plan.clayCost, nextClay, nextObs,
			nextGeo, oreBots, clayBots + 1, obsBots, geoBots, timeLeft - 1)
	end if
	return options.max	
end function

if true then
	// Part One:
	quality = 0
	for plan in plans
		score = bestScore(plan, 0, 0, 0, 0, 1, 0, 0, 0, 24)
		print "Plan " + plan.num + " score: " + score
		quality = quality + plan.num * score
	end for
	print "Total quality: " + quality
else
	// Part Two:
	product = 1
	for plan in plans[:3]
		score = bestScore(plan, 0, 0, 0, 0, 1, 0, 0, 0, 32)
		print "Plan " + plan.num + " score: " + score
		product = product * score
	end for
end if