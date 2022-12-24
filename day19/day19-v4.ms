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

simulate = function(plan, maxOreBots, maxClayBots, maxObsBots)
	oreBots = 1; clayBots = 0; obsBots = 0; geoBots = 0
	ore = 0; clay = 0; obs = 0; geo = 0;
	for minute in range(1,24)
		action = "wait"
		if oreBots < maxOreBots and ore >= plan.oreCost then
			action = "Build Orebot"
			ore = ore - plan.oreCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			oreBots = oreBots + 1
		else if clayBots < maxClayBots and ore >= plan.clayCost then
			action = "Build ClayBot"
			ore = ore - plan.clayCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			clayBots = clayBots + 1
		else if obsBots < maxObsBots and ore >= plan.obsOreCost and clay >= plan.obsClayCost then
			action = "Build ObsBot"
			ore = ore - plan.obsOreCost
			clay = clay - plan.obsClayCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			obsBots = obsBots + 1
		else if ore >= plan.geoOreCost and obs > plan.geoObsCost then
			action = "Build GeoBot"
			ore = ore - plan.obsOreCost
			obs = obs - plan.geoObsCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			geoBots = geoBots + 1
		else
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
		end if
		
		
		print minute + ": " + action + " --> Resources: " + [ore,clay,obs,geo].join(",") +
			" Bots: " + [oreBots, clayBots, obsBots, geoBots].join(",")
	end for
	return geo
end function

simulate2 = function(plan, maxOreBots, maxClayBots, maxObsBots)
	oreBots = 1; clayBots = 0; obsBots = 0; geoBots = 0
	ore = 0; clay = 0; obs = 0; geo = 0;
	for minute in range(1,24)
		action = "wait"
		if ore >= plan.geoOreCost and obs >= plan.geoObsCost then
			action = "Build GeoBot"
			ore = ore - plan.obsOreCost
			obs = obs - plan.geoObsCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			geoBots = geoBots + 1
		else if obsBots < maxObsBots and ore >= plan.obsOreCost and clay >= plan.obsClayCost then
			action = "Build ObsBot"
			ore = ore - plan.obsOreCost
			clay = clay - plan.obsClayCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			obsBots = obsBots + 1
		else if clayBots < maxClayBots and ore >= plan.clayCost then
			action = "Build ClayBot"
			ore = ore - plan.clayCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			clayBots = clayBots + 1
		else if oreBots < maxOreBots and ore >= plan.oreCost then
			action = "Build Orebot"
			ore = ore - plan.oreCost
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
			oreBots = oreBots + 1
		else
			ore = ore + oreBots; clay = clay + clayBots; obs = obs + obsBots; geo = geo + geoBots
		end if
		
		
		print minute + ": " + action + " --> Resources: " + [ore,clay,obs,geo].join(",") +
			" Bots: " + [oreBots, clayBots, obsBots, geoBots].join(",")
	end for
	return geo
end function


//for plan in plans
//	score = bestScore(plan, 0, 0, 0, 0, 1, 0, 0, 0, 24)
//	print "Plan " + plan.num + " score: " + score
//	exit
//end for
//
