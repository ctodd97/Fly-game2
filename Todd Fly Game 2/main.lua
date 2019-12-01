-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- 320x480 


local touch = 0
local score = 0

-- array of burritos
local burritos = {}

-- array of tacos
local tacos = {}

-- array of churros
local churros = {}

--gravity and bounce constants
local gravity = 0.25
local bounce = 0.7

function initGame()
	display.setStatusBar ( display.HiddenStatusBar )

	local background = display.newImageRect( "sky.jpg", display.contentWidth, display.contentHeight + 200 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- setting up width and height of the screen
	width = display.contentWidth
	height = display.contentHeight

	-- creating the bird
	bird = display.newImageRect( "bird.png", 96, 52 )
	bird.x = 70

	-- Variable for velocity of the bird falling
	bird.dy = 0

	-- lives left for bird
	bird.lives = 3

	-- score counter
	scoreTxt = display.newText( "Score: " .. score, width/2, 20, native.systemFont, 25)
	scoreTxt:setFillColor( 1, 0, 0 )

	-- reset button position
	local reset = display.newImageRect( "reset.png", 60, 30 )
	reset.x = 280
	reset.y = 450
	
	-- setting up the burritos
	for i = 1, 3 do
		burritos[i] = display.newImageRect( "burrito.png", 30, 20 )
		b = burritos[i]
		b.x = 270 + ( i * 150 )
		b.y = math.random( 70, 395 )
	end

	-- setting up the tacos
	for i = 1, 3 do
		tacos[i] = display.newImageRect( "taco.png", 35, 25 )
		t = tacos[i]
		t.x = width + ( i * 150 )
		t.y = math.random( 70, 395 )
	end

	-- setting up the churros
	for i = 1, 3 do
		churros[i] = display.newImageRect( "churro.png", 30, 20 )
		c = churros[i]
		c.x = width + ( i * 150 )
		c.y = math.random( 70, 395 )
	end

	Runtime:addEventListener( "enterFrame", moveLeft )
	Runtime:addEventListener( "enterFrame", moveDown )
	Runtime:addEventListener( "touch", moveUp )
	reset:addEventListener( "touch", resetTouched )
	Runtime:addEventListener( "enterFrame", checkHit )




end

-- function activates on every frame to check if the bird eats it
function checkHit()
	for i = 1, 3 do
		if  (burritos[i].x <= 130 and burritos[i].x >= 30)  --checks if burrito is on the bird
		 and math.abs(bird.y - burritos[i].y) <= 52 then
			addHit(3)    --adds 3 points because the burrito comes by less often
			recycleTargetB(i)
		end
	end
	for i = 1, 3 do
		if  (tacos[i].x <= 130 and tacos[i].x >= 30)
		 and math.abs(bird.y - tacos[i].y) <= 52 then
			addHit(2)
			recycleTargetT(i)
		end
	end
	for i = 1, 3 do
		if  (churros[i].x <= 130 and churros[i].x >= 30)
		 and math.abs(bird.y - churros[i].y) <= 52 then
			addHit(1)  --only adding one point because of how often churros pass by
			recycleTargetC(i)
		end
	end
end

-- functions used to reset the specific targets
function recycleTargetB(i)
	burritos[i].y = 900  -- targets go down to 900 pixels on the screen when they are eaten
end

function recycleTargetT(i)
	tacos[i].y = 900
end

function recycleTargetC(i)
	churros[i].y = 900
end

-- function for adding a hit
function addHit(i)
	score = score + i
	scoreTxt.text = "Score: " .. score
end

-- function for adding to the misses
function addMiss(i)
	score = score - i  -- lose amount of points that the target is worth
	scoreTxt.text = "Score: " .. score
	if score <= -5 then
		loseGame()
	end
end

-- function used to move the bird down
function moveDown()
	if touch ~= 0 then
		bird.y = bird.y + bird.dy
	else
		touch = 1
	end
	if bird.y > height - bird.height / 2 then    -- when the bird hits the ground
		bird.y = bird.y - bird.dy
		bird.dy = -bird.dy * bounce
	end
	bird.dy = bird.dy + gravity
end

--function called when the user taps the screen
function moveUp(event)
	if event.phase == "began" then
		touch = 1
		bird.dy = -7
		touch = 0
	end
	return true
end

-- function to move the objects left
function moveLeft()
	for i = 1, 3 do
		b = burritos[i]
		b.x = b.x - 1
		if b.x < -b.width then
			b.x = 270 + 150
			if b.y < 800 then
				addMiss(3)
			end
			b.y = math.random( 70, 430 )
		end
	end
	for i = 1, 3 do
		t = tacos[i]
		t.x = t.x - 2
		if t.x < -t.width then
			t.x = 270 + 150
			if t.y < 800 then
				addMiss(2)
			end
			t.y = math.random( 70, 430 )
		end
	end
	for i = 1, 3 do
		c = churros[i]
		c.x = c.x - 3
		if c.x < -c.width then 
			c.x = 270 + 150
			if c.y < 800 then
				addMiss(1)
			end
			c.y = math.random( 70, 430 )
		end
	end
end

function resetTouched( event )
	if event.phase == "began" then
		score = 0
		scoreTxt.text = "Score: " .. score
		Runtime:removeEventListener( "enterFrame", moveLeft )
		Runtime:removeEventListener( "enterFrame", moveDown )
		Runtime:removeEventListener( "enterFrame", checkHit )
		initGame()
	end
	return true
end

function loseGame()
	bird.lives = bird.lives - 1
	Runtime:removeEventListener( "enterFrame", moveLeft )
	Runtime:removeEventListener( "enterFrame", moveDown )
	Runtime:removeEventListener( "enterFrame", checkHit )
	loseGameTxt = display.newText( "You lose, press reset", width/2, height/2, native.systemFont, 25 )
	loseGameTxt:setFillColor( 1, 0, 0 )
end



initGame()