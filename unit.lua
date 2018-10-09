function generateUnit(parents, race)
	if parents then 
		--generateChild() i guess, but that'd have to be rewritten
	else
		if race then
			--generate a progenitor!!
			return generateProgenitor(race)
		else
			print("that's not how you generate a unit. need parents or a race!")
		end
	end
end

--basically generate a child but without parents
function generateProgenitor(race)
	local u = {
		race = race,
		name = randomName(),
		outlined = false
	}

	--generate genome with either r, g, or b leaning
	local g = {}
	local r = {"r", "g", "b"}
	r = r[math.random(3)]
	for y = 1, 9 do
		g[y] = {}
		for x = 1, 6 do			
			g[y][x] = {generateGene(r), generateGene(r)}
		end
	end
	
	u.genome = g
	
	return u
end



function drawUnitSmall(u, yOffset, xOffset)
	for y = 1, 9 do
		for x = 1, 6 do
			local m = u.genome[y][x][1]
			local n = u.genome[y][x][2]
			
			setGeneColor(m)
			love.graphics.rectangle("fill", xOffset + x * 12 + 0, yOffset + y * 12 + 20, 4, 9)
			setGeneColor(n)
			love.graphics.rectangle("fill", xOffset + x * 12 + 5, yOffset + y * 12 + 20, 4, 9)
		end
	end
	
	white()
	love.graphics.print(u.name, xOffset + 5, yOffset + 5)
	
	love.graphics.print(u.race, xOffset + 5, yOffset + 150)
	
	--outline? this is a bad place for this but... hacking...
	if u.outlined then
		love.graphics.rectangle("line", xOffset, yOffset, 120, 200)
	end
end



--obviously this can be more efficient. TODO
function randomName()
	local names = {"Blasey", "Bertha", "Sormtnin", "Orange", "Tamara", "Axel", "Hee", "Kissy", "Justine"} --it really doesn't matter right now
	return names[math.random(#names)]
end