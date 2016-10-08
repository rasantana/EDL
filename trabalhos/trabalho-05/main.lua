#TODO: verificar o uso do prKickBombFlag
Player = require('player')
Bomb = require('bomb')
Monster = require('monster')
function love.load()
	player = Player.newPlayer(64, 64, 200, 200, 10, "/Imagens/player1_moveDown.PNG" )
	player.bomb=Bomb.newBomb(0,0,200,200,10,0,3,5,false,0,false,1,false,0.3,0,0.5,"-","/Imagens/bomb1.PNG")

	--monsters = {{grid_x = 288,grid_y = 192,act_x = 200,act_y = 200,speed = 10,lastMovementTime = 0,movementTime = 2,color= {0, 255, 255, 125},isDead=false},
	---			{grid_x = 384,grid_y = 384,act_x = 200,act_y = 200,speed = 10,lastMovementTime = 0,movementTime = 2,color= {0, 0, 255, 255},isDead=false}
	--}
	monsters = { }
	monsters[1] = Monster.newMonster(288,192,200,200,10,0,2,false)
	monsters[2] = Monster.newMonster(384,384,200,200,10,0,2,false)
	colorMonsters={0, 255, 255, 125}
	--0: Blank space
	--1: Block
	--2: Stone
	--3: bomb
	--4:´player
	--5: monster
	map = {
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{ 1, 0, 0, 2, 2, 0, 2, 0, 0, 2, 2, 2, 0, 2, 1 },
		{ 1, 0, 1, 2, 1, 0, 1, 0, 1, 2, 1, 0, 1, 2, 1 },
		{ 1, 0, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 0, 1 },
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
	sideSquare=32
	map[player.grid_y/sideSquare][player.grid_x/sideSquare]=4
	-- Nome: variável "sideSquare"
	-- Propriedade: endereço
	-- Binding time: compilação
	-- Explicação: dado que sideSquare é uma variável global, seu endereço já é determinado em tempo de compilação    
	gameOver=false
	-- Nome: variável "gameOver"
	-- Propriedade: endereço
	-- Binding time: compilação
	-- Explicação: dado que gameOver é uma variável global, seu endereço já é determinado em tempo de compilação    
	teste =0
	kickBombs=true
end
 
function love.update(dt)
	player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)
	player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
	
	player.bomb.act_y = player.bomb.act_y - ((player.bomb.act_y - player.bomb.grid_y) * player.bomb.speed * dt)
	player.bomb.act_x = player.bomb.act_x - ((player.bomb.act_x - player.bomb.grid_x) * player.bomb.speed * dt)
	if(player.bomb.kickBombDirection~="-")then
		kickBomb()
	end
	local i=1
	-- Nome: Palavra reservada "local"
	-- Propriedade: Restrição de escopo
	-- Binding time: desenho
	-- Explicação: A palavra 'local' é utilizada para restringir o escopo de variaveis
	for i=1, #monsters do 
		monsters[i].act_y = monsters[i].act_y - ((monsters[i].act_y - monsters[i].grid_y) * monsters[i].speed * dt)
		monsters[i].act_x = monsters[i].act_x - ((monsters[i].act_x - monsters[i].grid_x) * monsters[i].speed * dt)
	end	
	movementMonsters(monsters[1])
end
 
function love.draw()
	if(gameOver==false) then
		createMap()
		setPlayer()
		setMonsters()
		setBomb()
		explosion()
		
		printInformations()
		printMap()
	else
		love.graphics.print('Fim de jogo', love.graphics.getWidth()/2 - 40, love.graphics.getHeight()/2 - 5)
	end
end

function kickBomb()
	local currentTime = love.timer.getTime()
	local timeResult = currentTime - player.bomb.lastKickBombTime
	if (timeResult > player.bomb.kickBombFlag)then
		if(player.bomb.kickBombDirection=="UP")then
			if noCollision(0, -1, player.bomb) then
				if existCollision(0, -1, player.bomb,5) then
					player.bomb.kickBombDirection="-"
				else
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=0
					player.bomb.grid_y = player.bomb.grid_y - sideSquare	
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=3
				end
			end	
		elseif(player.bomb.kickBombDirection=="DOWN")then
			if noCollision(0, 1, player.bomb) then
				if existCollision(0, 1, player.bomb,5) then
					player.bomb.kickBombDirection="-"
				else
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=0
					player.bomb.grid_y = player.bomb.grid_y + sideSquare
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=3
				end
			end
		elseif(player.bomb.kickBombDirection=="LEFT")then
			if noCollision(-1, 0, player.bomb) then
				if existCollision(-1, 0, player.bomb,5) then
					player.bomb.kickBombDirection="-"
				else
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=0
					player.bomb.grid_x = player.bomb.grid_x - sideSquare
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=3
				end
			end
		elseif(player.bomb.kickBombDirection=="RIGHT")then
			if noCollision(1, 0, player.bomb) then
				if existCollision(1, 0, player.bomb,5) then
					player.bomb.kickBombDirection="-"
				else
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=0
					player.bomb.grid_x = player.bomb.grid_x + sideSquare	
					map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=3
				end
			end
		end
	end
end

function setPlayer()
	love.graphics.draw(player.img, player.act_x, player.act_y)
end

function setMonsters()
	local i=1
	for i=1, #monsters do 
		if(monsters[i].isDead==false) then
			love.graphics.setColor(colorMonsters)
			love.graphics.rectangle("fill", monsters[i].act_x, monsters[i].act_y, sideSquare, sideSquare)			
		end
	end
end

function setBomb()
	if(player.bomb.existBomb==true) then
		local currentTime = love.timer.getTime()
		if(player.bomb.iconChange==false) then
			player.bomb.lastIconTime = love.timer.getTime()
			player.bomb.iconChange=true
		end
		local timeResult = currentTime - player.bomb.lastIconTime
		if (timeResult > player.bomb.iconFlag)then
			player.bomb.img = love.graphics.newImage("/Imagens/bomb"..player.bomb.iconNumber..".PNG")
			player.bomb.iconChange=false	
			--control for animate of bomb
			if(player.bomb.iconRevert==false)then
				if(player.bomb.iconNumber<=3) then
					if(player.bomb.iconNumber==3)then
						player.bomb.iconRevert=true
					else
						player.bomb.iconNumber=player.bomb.iconNumber+1
					end
				end
			else
				if(player.bomb.iconNumber>=1) then
					if(player.bomb.iconNumber==1)then
						player.bomb.iconRevert=false
					else
						player.bomb.iconNumber=player.bomb.iconNumber-1
					end
				end
			end
		end
		if(timeResult>player.bomb.timeExplosion) then
			player.bomb.iconRevert=false
			player.bomb.iconChange=false
			player.bomb.iconNumber=1
		end
		love.graphics.draw(player.bomb.img, player.bomb.act_x, player.bomb.act_y)
		
		teste = timeResult
	end
end

function printInformations()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(teste,530,60)
	love.graphics.print("player.grid_x: " .. player.grid_x,530,80)
	love.graphics.print("player.grid_y: " .. player.grid_y,530,100)	
	love.graphics.print("bomb.grid_x: " .. player.bomb.grid_x,530,120)
	love.graphics.print("bomb.grid_y: " .. player.bomb.grid_y,530,140)	
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
	-- Nome: variável "x"
	-- Propriedade: endereço
	-- Binding time: execução
	-- Explicação: dado que x é uma variável local de uma função, seu endereço só pode ser determinado em tempo de execução    
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
		if(existCollision(0, -1, player,3)) then
			player.bomb.kickBombDirection="UP"
		elseif(existCollision(0,-1,player,5))then
			gameOver=true
		elseif noCollision(0, -1, player) then
			player.img = love.graphics.newImage("/Imagens/player1_moveUp.PNG")
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=0
			player.grid_y = player.grid_y - sideSquare		
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=4
		end
	elseif key == "down" then
		if(existCollision(0, 1, player,3)) then
			player.bomb.kickBombDirection="DOWN"
		elseif(existCollision(0,1,player,5))then
			gameOver=true
		elseif noCollision(0, 1, player) then
			player.img = love.graphics.newImage("/Imagens/player1_moveDown.PNG")
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=0
			player.grid_y = player.grid_y + sideSquare		
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=4
		end
	elseif key == "left" then
		if(existCollision(-1, 0, player,3)) then
			player.bomb.kickBombDirection="LEFT"
		elseif(existCollision(-1,0,player,5))then
			gameOver=true
		elseif noCollision(-1, 0, player) then
			player.img = love.graphics.newImage("/Imagens/player1_moveLeft.PNG")
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=0
			player.grid_x = player.grid_x - sideSquare	
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=4
		end
	elseif key == "right" then
		if(existCollision(1, 0, player,3)) then
			player.bomb.kickBombDirection="RIGHT"
		elseif(existCollision(1, 0, player, 5))then
			gameOver=true
		elseif noCollision(1, 0, player) then
			player.img = love.graphics.newImage("/Imagens/player1_moveRight.PNG")	
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=0
			player.grid_x = player.grid_x + sideSquare		
			map[player.grid_y/sideSquare][player.grid_x/sideSquare]=4
		end
	elseif key == "space" then
		if(player.bomb.existBomb==false) then
			player.bomb.grid_x=player.grid_x 
			player.bomb.grid_y=player.grid_y
			player.bomb.act_x=player.bomb.grid_x
			player.bomb.act_y=player.bomb.grid_y
			map[player.bomb.grid_y/sideSquare][player.bomb.grid_x/sideSquare]=3
			player.bomb.initTime = love.timer.getTime()
			player.bomb.existBomb=true
		end
	end
end

function movementMonsters()
	for i=1, #monsters do 
		if(monsters[i].isDead==false)then
			local currentTime = love.timer.getTime()
			local timeResult = math.floor(currentTime - monsters[i].lastMovementTime)
			
			key = love.math.random(1, 4)
			if key == 1 then
				if noCollision(0, -1, monsters[i]) then
					if(timeResult > monsters[i].movementTime) then
						if(existCollision(0,-1,monsters[i],4))then
							gameOver=true
						end
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=0
						monsters[i].grid_y = monsters[i].grid_y - sideSquare
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=5
						monsters[i].lastMovementTime=love.timer.getTime()
					end
				end
			elseif key == 2 then
				if noCollision(0, 1, monsters[i]) then
					if(timeResult > monsters[i].movementTime) then
						if(existCollision(0,1,monsters[i],4))then
							gameOver=true
						end
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=0
						monsters[i].grid_y = monsters[i].grid_y + sideSquare
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=5
						monsters[i].lastMovementTime=love.timer.getTime()
					end
				end
			elseif key == 3 then
				if noCollision(-1, 0, monsters[i]) then
					if(timeResult > monsters[i].movementTime) then
						if(existCollision(-1,0,monsters[i],4))then
							gameOver=true
						end
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=0
						monsters[i].grid_x = monsters[i].grid_x - sideSquare
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=5
						monsters[i].lastMovementTime=love.timer.getTime()
					end
				end
			elseif key == 4 then
				if noCollision(1, 0, monsters[i]) then
					if(timeResult > monsters[i].movementTime) then
						if(existCollision(1,0,monsters[i],4))then
							gameOver=true
						end
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=0
						monsters[i].grid_x = monsters[i].grid_x + sideSquare
						map[monsters[i].grid_y/sideSquare][monsters[i].grid_x/sideSquare]=5
						monsters[i].lastMovementTime=love.timer.getTime()
					end
				end
			end
		end
	end
end

--valueMap=1 --> collision of item with blocks
--valueMap=2 --> collision of item with stones
--valueMap=3 --> collision of item with bombs
--valueMap=4 --> collision of item with player
--valueMap=5 --> collision of item with monster
function existCollision(x, y, item, valueMap)
	if(valueMap==5)then
		local i
		for i=1, #monsters do 
			if(monsters[i].isDead==false) then
				if map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == valueMap then
					return true
				end
			end
		end
	elseif(valueMap==3)then
		if(player.bomb.existBomb==true) then
			if map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == valueMap then
				return true
			end
		end
	else
		if map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == valueMap then
			return true
		end
	end
	return false
end
 
function noCollision(x, y, item)
	-- Nome: variável "x"
	-- Propriedade: endereço
	-- Binding time: execução
	-- Explicação: dado que x é uma variável local de uma função, seu endereço só pode ser determinado em tempo de execução    
	if map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == 1 or
	   map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == 2 
	then
		return false
	end
	if(existCollisionWithBomb(x,y,item))then
		return false
	end
	return true
end

function existCollisionWithBomb(x, y, item)
	if(player.bomb.existBomb==true) then
		if map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == 3 then
			return true
		end
	end
	return false
end

function explosion()
	if(player.bomb.existBomb==true) then
		local currentTime = love.timer.getTime()
		local timeResult = math.floor(currentTime - player.bomb.initTime)
		map[(player.bomb.grid_y / sideSquare)][(player.bomb.grid_x / sideSquare)]=3
		if(timeResult > player.bomb.timeExplosion) then
			explosionCollision(0, 1)
			explosionCollision(0, -1)
			explosionCollision(1, 0)
			explosionCollision(-1, 0)
			--When the player is on the bomb
			if(isPlayerOnTheBomb())then
				gameOver=true
			end
			player.bomb.existBomb=false
			player.bomb.kickBombDirection="-"
			map[(player.bomb.grid_y / sideSquare)][(player.bomb.grid_x / sideSquare)] = 0
		end
	end
end

function isPlayerOnTheBomb()
	if(player.bomb.grid_y==player.grid_y and player.bomb.grid_x==player.grid_x)then
		return true
	end
	return false
end

function explosionCollision(x, y)
	local i=1
	for i=1, player.bomb.distanceExplosion do	
		love.graphics.rectangle("fill", player.bomb.grid_x  + (x*i*sideSquare),player.bomb.grid_y + (y*i*sideSquare), sideSquare, sideSquare)
		
		--explosion colision with stones
		if map[(player.bomb.grid_y / sideSquare) + (y*i)][(player.bomb.grid_x / sideSquare) + (x*i)] == 2 
		then	
			map[(player.bomb.grid_y / sideSquare) + (y*i)][(player.bomb.grid_x / sideSquare) + (x*i)] = 0
			--No caso de uma melhoria no qual se pega um objeto na tela onde a bomba ultrapassa blocos, esse break deve estar dentro de um if do tipo
			--if(nao pegou o item)
			break
		end			
		--explosion colision with blocks
		if map[(player.bomb.grid_y / sideSquare) + (y*i)][(player.bomb.grid_x / sideSquare) + (x*i)] == 1 
		then	
			break
			-- Nome: Palavra reservada "break"
			-- Propriedade: Desvio de instruções
			-- Binding time: desenho
			-- Explicação: A palavra 'break' é utilizada para desviar as instruções para fora do laço a qual o break se encontra
		end	
		--explosion colision with player
		if(player.bomb.grid_x +(sideSquare*i*x)==player.grid_x and player.bomb.grid_y +(sideSquare*i*y)==player.grid_y)
		then	
			gameOver=true
		end		
		--explosion colision with monsters
		local j
		for j=1, #monsters do 
			if(player.bomb.grid_x +(sideSquare*i*x)==monsters[j].grid_x and player.bomb.grid_y +(sideSquare*i*y)==monsters[j].grid_y)
			then
				map[(monsters[j].grid_y / sideSquare)][(monsters[j].grid_x / sideSquare)] = 0
				monsters[j].isDead=true
			end		
		end
	end
end
