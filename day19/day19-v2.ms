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
	if timeLeft < 1 then return [0, []]
	
//	print "Time " + timeLeft + ": " + [ore, clay, obs, oreBots, clayBots, obsBots, geoBots].join(",")
	// collect resources
//	ore = ore + oreBots
//	clay = clay + clayBots
//	obs = obs + obsBots
//	geo = geoBots
	baseScore = geoBots
	
	if ore < 4 then
		foo = bestScore(plan, oreBots + ore, clayBots + clay, obsBots + obs,
				oreBots, clayBots, obsBots, geoBots, timeLeft - 1)
		score = foo[0]
		path = [k] + foo[1]
	else
		score = 0
		path = [k]
	end if
		
	// consider building each type of bot
	if ore >= plan.geoOreCost and obs > plan.geoObsCost then
//		print k + " builds a geoBot"
		foo = bestScore(plan, oreBots + ore - plan.geoOreCost,
			clayBots + clay, obsBots + obs - plan.geoObsCost,
			oreBots, clayBots, obsBots, geoBots + 1, timeLeft - 1)
		if baseScore + foo[0] > score then
			score = baseScore + foo[0]
			path = [k] + foo[1]
		end if
	else if ore >= plan.obsOreCost and clay > plan.obsClayCost then
//		print k + " builds a obsBot"
		foo = bestScore(plan, oreBots + ore - plan.obsOreCost,
			clayBots + clay - plan.obsClayCost, obsBots + obs,
			oreBots, clayBots, obsBots + 1, geoBots, timeLeft - 1)
		if baseScore + foo[0] > score then
			score = baseScore + foo[0]
			path = [k] + foo[1]
		end if
	else if ore >= plan.clayCost then
//		print k + " builds a clayBot"
		foo = bestScore(plan, oreBots + ore - plan.clayCost, 
			clayBots + clay, obsBots + obs,
			oreBots, clayBots + 1, obsBots, geoBots, timeLeft - 1)
		if baseScore + foo[0] > score then
			score = baseScore + foo[0]
			path = [k] + foo[1]
		end if
	else if ore >= plan.oreCost then
//		print k + " builds a oreBot"
		foo = bestScore(plan, oreBots + ore - plan.oreCost,
			clayBots + clay, obsBots + obs,
			oreBots + 1, clayBots, obsBots, geoBots, timeLeft - 1)
		if baseScore + foo[0] > score then
			score = baseScore + foo[0]
			path = [k] + foo[1]
		end if
	end if
	memo[k] = [score, path]
	if memo.len % 5000 == 0 then print memo.len + ": " + k + " -> " + memo[k]
	return [score, path]
end function

for plan in plans
	score = bestScore(plan, 0, 0, 0, 1, 0, 0, 0, 24)
	print "Plan " + plan.num + " score: " + score[0]
	pprint score[1]
	exit
end for

print "final answer (part A): " + resultA.sum
print "final answer (part B): " + resultB.sum
// Also available: list.min, list.max, list.mean