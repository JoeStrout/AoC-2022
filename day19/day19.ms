import "stringUtil"
import "mapUtil"
import "listUtil"
import "mathUtil"
import "aoc"

resultA = []
resultB = []

if 0 then fname = "input.txt" else fname = "example.txt"
lines = file.readLines(fname)
if lines == null then
	print "Unable to read: " + fname
	exit
end if
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
bestScore = function(plan, ore, clay, obs, oreBots, clayBots, obsBots, geoBots, timeLeft)
	k = [ore, clay, obs, oreBots, clayBots, obsBots, geoBots, timeLeft].join(",")
	if memo.hasIndex(k) then return memo[k]
	if timeLeft < 1 then return 0
	
	//print "Time " + timeLeft + ": " + [ore, clay, obs, oreBots, clayBots, obsBots, geoBots].join(",")
	// collect resources
	ore = ore + oreBots
	clay = clay + clayBots
	obs = obs + obsBots
	geo = geoBots
	baseScore = geo
	
	// consider doing nothing
	score = baseScore + bestScore(plan, ore, clay, obs,
			oreBots, clayBots, obsBots, geoBots, timeLeft - 1)
	
	// consider building each type of bot
	if ore >= plan.oreCost then
		score = max(score, baseScore + bestScore(plan, ore - plan.oreCost, clay, obs,
			oreBots + 1, clayBots, obsBots, geoBots, timeLeft - 1))
	end if
	if ore >= plan.clayCost then
		score = max(score, baseScore + bestScore(plan, ore - plan.clayCost, clay, obs,
			oreBots, clayBots + 1, obsBots, geoBots, timeLeft - 1))
	end if
	if ore >= plan.obsOreCost and clay > plan.obsClayCost then
		score = max(score, baseScore + bestScore(plan, ore - plan.obsOreCost,
			clay - plan.obsClayCost, obs,
			oreBots, clayBots, obsBots + 1, geoBots, timeLeft - 1))
	end if
	if ore >= plan.geoOreCost and obs > plan.geoObsCost then
		score = max(score, baseScore + bestScore(plan, ore - plan.geoOreCost,
			clay, obs - plan.geoObsCost,
			oreBots, clayBots, obsBots, geoBots + 1, timeLeft - 1))
	end if
	memo[k] = score
	if memo.len % 5000 == 0 then print memo.len + ": " + k + " -> " + score
	return score
end function

for plan in plans
	score = bestScore(plan, 0, 0, 0, 1, 0, 0, 0, 24)
	print "Plan " + plan.num + " score: " + score
end for

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean