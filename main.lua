require "genome"
require "unit"

function love.load(args)
	love.window.setMode(800, 600)
	
	math.randomseed(os.time())
	
	fontBig = love.graphics.newFont(25)
	fontLittle = love.graphics.newFont(15)
	love.graphics.setFont(fontLittle)
	
	-- phase = "newGame"--"assignments"--
	
	phaseTransition("newGame")
end

function love.draw()
	_G[phase.."Draw"]()
end

function love.update(dt)
	_G[phase.."Update"](dt)
	-- print(glow) 
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end

	_G[phase.."Keypressed"](key)
end

function love.mousepressed(x, y, button)
	_G[phase.."Mousepressed"](x, y, button)
end

function love.mousereleased(x, y, button)
	_G[phase.."Mousereleased"](x, y, button)
end

function phaseTransition(p)
	phase = p
	
	_G[phase.."Init"]()
end

-------------------------------------------------------------------------------------------------------------------------------

function newGameInit()
	mountainName = "Kailash "..math.random()
end

function newGameUpdate(dt)
	--cursor blink
end

function newGameDraw()
	love.graphics.print("Name your mountain: "..mountainName, 100, 100)
end

--argh, why are you bothering!?
-- function love.textinput(t)
-- 	mountainName = mountainName .. t
-- end
--
function newGameKeypressed(key)
	if key == "return" then
		phaseTransition("progenitors")
	end
-- 	-- copied from https://love2d.org/wiki/love.textinput
--   if key == "backspace" then
--       -- get the byte offset to the last UTF-8 character in the string.
--       local byteoffset = utf8.offset(text, -1)
--
--       if byteoffset then
--           -- remove the last UTF-8 character.
--           -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
--           text = string.sub(text, 1, byteoffset - 1)
--       end
--   end
end

function newGameMousepressed(x, y, button)
end

function newGameMousereleased(x, y, button)
	phaseTransition("progenitors")
end

-------------------------------------------------------------------------------------------------------------------------------

function progenitorsInit()
	races = {"RABBIT", "ELEPHANT", "DEER", "SQUIRREL", "GRASSHOPPER", "BEAVER"}
	candidates = {}
	
	for i = 1, 6 do
		candidates[i] = generateProgenitor(races[i])
		-- print(races[i])
	end
	-- helpText = ""
end

function progenitorsUpdate(dt)
end

function progenitorsDraw()
	-- love.graphics.print("PROGENITORS", 100, 100)
	
	for i = 1, 6 do
		drawUnitSmall(candidates[i], 40, i * 125 - 100)
	end
	
	--accept button
	love.graphics.setColor(.8,.8,.8)
	love.graphics.rectangle("fill", 350, 500, 100, 50)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Pick 3", 355, 505)
end

function progenitorsKeypressed(key)
end

function progenitorsMousepressed(x, y, button)
	--implement draggin ;) TODO even though it doesn't matter here
	if x >= 350 and x <= 450 and y >= 500 and y <= 550 then
		if numSelected == 3 then
			phaseTransition("roster")
		end
	end
	
	if y > 40 and y < 240 then
		if x > 25 and x < 775 then
			local n = math.floor((x - 25) / 125) + 1
			print(n)
			
			if candidates[n] then
				candidates[n].outlined = not candidates[n].outlined
			end
		end
	end
end

function progenitorsMousereleased(x, y, button)
	-- phaseTransition("roster")
end


-------------------------------------------------------------------------------------------------------------------------------

function rosterInit()
end

function rosterUpdate(dt)
end

function rosterDraw()
	love.graphics.print("ROSTER", 100, 100)
end

function rosterKeypressed(key)
end

function rosterMousepressed(x, y, button)
end

function rosterMousereleased(x, y, button)
	phaseTransition("invest")
end

-------------------------------------------------------------------------------------------------------------------------------

function investInit()
end

function investUpdate(dt)

end

function investDraw()
	love.graphics.print("INVEST", 100, 100)
end

function investKeypressed(key)
end

function investMousepressed(x, y, button)
end

function investMousereleased(x, y, button)
	phaseTransition("battle")
end

-------------------------------------------------------------------------------------------------------------------------------

function battleInit()
end

function battleUpdate(dt)

end

function battleDraw()
	love.graphics.print("battle", 100, 100)
end

function battleKeypressed(key)
end

function battleMousepressed(x, y, button)
end

function battleMousereleased(x, y, button)
	phaseTransition("aftermath")
end

-------------------------------------------------------------------------------------------------------------------------------

function aftermathInit()
end

function aftermathUpdate(dt)

end

function aftermathDraw()
	love.graphics.print("aftermath", 100, 100)
end

function aftermathKeypressed(key)
end

function aftermathMousepressed(x, y, button)
end

function aftermathMousereleased(x, y, button)
	phaseTransition("assignments")
end


-------------------------------------------------------------------------------------------------------------------------------

function assignmentsInit()
	wIncrementor = 0
	oscillator = 0
	glow = 1
	
	generateBlocks()
	
	--DEBUG
	if args and args[1] and args[2] then
		parent1 = generateParent(args[1])
		parent2 = generateParent(args[2])
	else
		parent1 = generateParent()
		parent2 = generateParent()
	end
	
	compatibility = findCompatibility(parent1, parent2)
	
	child = generateChild(parent1, parent2)
end

function assignmentsUpdate(dt)
	if moving then
		if counter > 0 then
			counter = counter - dt * 100
			-- print(counter)
		else
			--counter over! swap stuff
			counter = 0
			moving = false
			
			parent1 = child
			parent2 = newParent
			
			compatibility = findCompatibility(parent1, parent2)
			
			child = generateChild(parent1, parent2)
		end
	end
	
	oscillator = oscillator + dt * 5
	glow = math.cos(oscillator) / 2 + 0.5
end

function assignmentsDraw()
	if moving then 
		drawUnit(child, 10 + counter, 10 + counter)
		drawUnit(newParent, 10 - counter, 410 - counter)
	else
		drawUnit(parent1, 10, 10)
		drawUnit(parent2, 10, 410)
		drawUnit(child, 210, 210)
		love.graphics.print("(compatibility = "..compatibility..")", 235, 100)
	end
end

function assignmentsKeypressed(key)
	if not moving then
		if key == "c" then child = generateChild(parent1, parent2) end
		
		if key == "q" then
			generateBlocks()
		end
	
		if key == "p" or key == "r" or key == "g" or key == "b" or key == "a" or key == "x" or key == "q" or key == "t" or key == "w" then
			moving = true
			counter = 200
			
			newParent = generateParent(key)
		end
	end
end

function assignmentsMousepressed(x, y, button)
end

function assignmentsMousereleased(x, y, button)
	phaseTransition("roster")
end


-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------

function white()
	love.graphics.setColor(1,1,1)
end