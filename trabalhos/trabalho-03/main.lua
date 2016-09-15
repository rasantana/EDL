function love.load()
	player = {
		grid_x = 64,
		grid_y = 64,
		act_x = 200,
		act_y = 200,
		speed = 10
	}
	bomb = {
		grid_x = 0,
		grid_y = 0,
		initTime = 0,
		timeExplosion = 3,
		distanceExplosion = 5,
		existBomb=false
	}
	monsters = {{grid_x = 288,grid_y = 192,act_x = 200,act_y = 200,speed = 10,lastMovementTime = 0,movementTime = 2,color= {0, 255, 255, 125},isDead=false},
				{grid_x = 384,grid_y = 384,act_x = 200,act_y = 200,speed = 10,lastMovementTime = 0,movementTime = 2,color= {0, 0, 255, 255},isDead=false}
	}
	--0: Blank space
	--1: Block
	--2: Stone
	map = {
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{ 1, 0, 0, 2, 2, 0, 2, 0, 0, 2, 2, 2, 0, 2, 1 },
		{ 1, 0, 1, 2, 1, 0, 1, 0, 1, 2, 1, 0, 1, 2, 1 },
		{ 1, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 },
		{ 1, 2, 2, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 0, 1, 0, 1, 2, 1, 2, 1, 0, 1, 2, 1 },
		{ 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 2, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 },
		{ 1, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1 },
		{ 1, 2, 1, 2, 1, 0, 1, 0, 1, 2, 1, 0, 1, 2, 1 },
		{ 1, 0, 0, 2, 2, 2, 0, 0, 2, 0, 0, 0, 0, 0, 1 },
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	}
	mapColor = {255, 255, 255}
	playerColor= {100, 125, 125}
	sideSquare=32
	gameOver=false
	explosionColor={255,0,0}
	teste =0
end
 
function love.update(dt)
	player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)
	player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
	local i=1
	for i=1, #monsters do 
		monsters[i].act_y = monsters[i].act_y - ((monsters[i].act_y - monsters[i].grid_y) * monsters[i].speed * dt)
		monsters[i].act_x = monsters[i].act_x - ((monsters[i].act_x - monsters[i].grid_x) * monsters[i].speed * dt)
	end	
	movementMonsters(monsters[1])
	collisionOfPlayerWithMonster()
end
 
function love.draw()
	if(gameOver==false) then
		createMap()
		setPlayer()
		setMonsters()
		setExplosion()
		explosion()
		
		printInformations()
		printMap()
	else
		love.graphics.print('Fim de jogo', love.graphics.getWidth()/2 - 40, love.graphics.getHeight()/2 - 5)
	end
end

function setPlayer()
	love.graphics.setColor(playerColor)
	love.graphics.rectangle("fill", player.act_x, player.act_y, sideSquare, sideSquare)
end

function setMonsters()
	local i=1
	for i=1, #monsters do 
		if(monsters[i].isDead==false) then
			love.graphics.setColor(monsters[i].color)
			love.graphics.rectangle("fill", monsters[i].act_x, monsters[i].act_y, sideSquare, sideSquare)			
		end
	end
end

function setExplosion()
	if(bomb.existBomb==true) then
		love.graphics.setColor(explosionColor)
		love.graphics.rectangle("fill", bomb.grid_x,bomb.grid_y,sideSquare, sideSquare)
	end
end

function printInformations()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(teste,530,60)
	love.graphics.print("player.grid_x: " .. player.grid_x,530,80)
	love.graphics.print("player.grid_y: " .. player.grid_y,530,100)	
	love.graphics.print("bomb.grid_x: " .. bomb.grid_x,530,120)
	love.graphics.print("bomb.grid_y: " .. bomb.grid_y,530,140)	
	love.graphics.print("monster[1].grid_x: " .. monsters[1].grid_x,530,160)
	love.graphics.print("monster[1].grid_y: " .. monsters[1].grid_y,530,180)	
	love.graphics.print("monster[2].grid_x: " .. monsters[2].grid_x,530,200)
	love.graphics.print("monster[2].grid_y: " .. monsters[2].grid_y,530,220)
end

function createMap()
	love.graphics.setColor(mapColor)
	for y=1, #map do
		for x=1, #map[y] do
			if map[y][x] == 1 then
				love.graphics.rectangle("fill", x * sideSquare,y * sideSquare, sideSquare, sideSquare)
			end
			if map[y][x] == 2 then
				love.graphics.rectangle("line", x * sideSquare, y * sideSquare, sideSquare, sideSquare)
			end
		end
	end
end

function printMap()
	local y,x
	for y=1, #map do
		for x=1, #map[y] do
			if x==1 then
				love.graphics.print("{ " .. map[y][x] .. ", ",520+(x*15),240+(y*10))	
			elseif x==#map[y] then
				love.graphics.print(", " .. map[y][x] .. "}",520+(x*15),240+(y*10))	
			else 
				love.graphics.print(", " .. map[y][x] .. " ",520+(x*15),240+(y*10))	
			end
		end
	end
end 

function love.keypressed(key)
	if key == "up" then
		if noCollision(0, -1) then
			player.grid_y = player.grid_y - sideSquare
		end
	elseif key == "down" then
		if noCollision(0, 1) then
			player.grid_y = player.grid_y + sideSquare
		end
	elseif key == "left" then
		if noCollision(-1, 0) then
			player.grid_x = player.grid_x - sideSquare
		end
	elseif key == "right" then
		if noCollision(1, 0) then
			player.grid_x = player.grid_x + sideSquare
		end
	elseif key == "space" then
		if(bomb.existBomb==false) then
			bomb.grid_x=player.grid_x 
			bomb.grid_y=player.grid_y
			map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=3
			bomb.initTime = love.timer.getTime()
			bomb.existBomb=true
		end
	end
end

function movementMonsters()
	for i=1, #monsters do 
		local currentTime = love.timer.getTime()
		local timeResult = math.floor(currentTime - monsters[i].lastMovementTime)
		
		key = love.math.random(1, 4)
		if key == 1 then
			if noCollisionForMonsters(0, -1, monsters[i]) then
				if(timeResult > monsters[i].movementTime) then
					monsters[i].grid_y = monsters[i].grid_y - sideSquare
					monsters[i].lastMovementTime=love.timer.getTime()
				end
			end
		elseif key == 2 then
			if noCollisionForMonsters(0, 1, monsters[i]) then
				if(timeResult > monsters[i].movementTime) then
					monsters[i].grid_y = monsters[i].grid_y + sideSquare
					monsters[i].lastMovementTime=love.timer.getTime()
				end
			end
		elseif key == 3 then
			if noCollisionForMonsters(-1, 0, monsters[i]) then
				if(timeResult > monsters[i].movementTime) then
					monsters[i].grid_x = monsters[i].grid_x - sideSquare
					monsters[i].lastMovementTime=love.timer.getTime()
				end
			end
		elseif key == 4 then
			if noCollisionForMonsters(1, 0, monsters[i]) then
				if(timeResult > monsters[i].movementTime) then
					monsters[i].grid_x = monsters[i].grid_x + sideSquare
					monsters[i].lastMovementTime=love.timer.getTime()
				end
			end
		end
	end
end

function collisionOfPlayerWithMonster()
	local i
	for i=1, #monsters do 
		if(monsters[i].isDead==false) then
			if(player.grid_x==monsters[i].grid_x and 
			player.grid_y==monsters[i].grid_y) then
				gameOver=true
			end
		end
	end
end
 
function noCollision(x, y)
	if map[(player.grid_y / sideSquare) + y][(player.grid_x / sideSquare) + x] == 1 or
	   map[(player.grid_y / sideSquare) + y][(player.grid_x / sideSquare) + x] == 2 
	then
		return false
	end
	if(bomb.existBomb==true) then
		if map[(player.grid_y / sideSquare) + y][(player.grid_x / sideSquare) + x] == 3 then
			return false
		end
	end
	return true
end

function noCollisionForMonsters(x, y, monster)
	if map[(monster.grid_y / sideSquare) + y][(monster.grid_x / sideSquare) + x] == 1 or
	   map[(monster.grid_y / sideSquare) + y][(monster.grid_x / sideSquare) + x] == 2 
	then
		return false
	end
	if(bomb.existBomb==true) then
		if map[(monster.grid_y / sideSquare) + y][(monster.grid_x / sideSquare) + x] == 3 then
			return false
		end
	end
	return true
end

function explosion()
	if(bomb.existBomb==true) then
		local currentTime = love.timer.getTime()
		local timeResult = math.floor(currentTime - bomb.initTime)
		if(timeResult > bomb.timeExplosion) then
			explosionCollision(0, 1)
			explosionCollision(0, -1)
			explosionCollision(1, 0)
			explosionCollision(-1, 0)
			--When the player is on the bomb
			if(bomb.grid_y==player.grid_y and bomb.grid_x==player.grid_x)then
				gameOver=true
			end
			bomb.existBomb=false
			map[(bomb.grid_y / sideSquare)][(bomb.grid_x / sideSquare)] = 0
		end
	end
end

function explosionCollision(x, y)
	local i=1
	for i=1, bomb.distanceExplosion do	
		love.graphics.rectangle("fill", bomb.grid_x  + (x*i*sideSquare),bomb.grid_y + (y*i*sideSquare), sideSquare, sideSquare)
		
		--explosion colision with stones
		if map[(bomb.grid_y / sideSquare) + (y*i)][(bomb.grid_x / sideSquare) + (x*i)] == 2 
		then	
			map[(bomb.grid_y / sideSquare) + (y*i)][(bomb.grid_x / sideSquare) + (x*i)] = 0
			--No caso de uma melhoria no qual se pega um objeto na tela onde a bomba ultrapassa blocos, esse break deve estar dentro de um if do tipo
			--if(nao pegou o item)
			break
		end			
		--explosion colision with blocks
		if map[(bomb.grid_y / sideSquare) + (y*i)][(bomb.grid_x / sideSquare) + (x*i)] == 1 
		then	
			break
		end	
		--explosion colision with player
		if(bomb.grid_x +(sideSquare*i*x)==player.grid_x and bomb.grid_y +(sideSquare*i*y)==player.grid_y)
		then	
			gameOver=true
		end		
		--explosion colision with monsters
		local j
		for j=1, #monsters do 
			if(bomb.grid_x +(sideSquare*i*x)==monsters[j].grid_x and bomb.grid_y +(sideSquare*i*y)==monsters[j].grid_y)
			then	
				monsters[j].isDead=true
			end		
		end
	end
end
