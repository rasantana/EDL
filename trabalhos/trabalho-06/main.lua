Player = require('player')
Bomb = require('bomb')
Monster = require('monster')
function love.load()
	itens = {kick_bomb=1, rollerblades=2,fire_bomb_1=3,fire_bomb_2=4, ghost=5, superbomb=6,qtdBomb=7}
	-- trabalho-06
	-- table 'itens' esta sendo usada como registro
	player = Player.newPlayer(64, 64,"/Imagens/player1_moveDown.PNG")
	--trabalho5
	--monsters: colecao de monstros 
	--Escopo: Variável global.
	--Tempo de vida: Cada monstro, que representa uma posição na coleção monsters, tem seu tempo de vida definido
	--a partir do momento em que o jogo é carregado(pelo metodo load) até o momento em que em que encostam em uma 
	--explosão provocada por uma bomba, vale frisar que não há adição de monstros dinamicamente.
	--Alocação: a alocação na memoria da variavel monsters ocorre no metodo load, seus objetos são instanciados e
	--alocados a cada chamada de newMonster
	--Desalocação: ao encostar em uma explosão provocada por uma bomba, o monstro é desalocado (linha 471)
	monsters = { }
	informations = {}
	-- trabalho-06
	-- table 'informations' esta sendo usada como dicionario
	monsters[1] = Monster.newMonster(288,192)
	monsters[2] = Monster.newMonster(384,384)
	monsters[3] = Monster.newMonster(64,384)
	-- trabalho-06
	-- table 'monsters' esta sendo usada como array
	colorMonsters={0, 255, 255, 125}
	teste = #(player.bomb)
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
	
	mapItem = {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
		}	
	--createMapItem()
		
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

	createItens()
end
 
function love.update(dt)
	player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)
	player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
	
	if(#player.bomb>0)then
		for i=#player.bomb,1,-1 do 
			player.bomb[i].act_y = player.bomb[i].act_y - ((player.bomb[i].act_y - player.bomb[i].grid_y) * player.bomb[i].speed * dt)
			player.bomb[i].act_x = player.bomb[i].act_x - ((player.bomb[i].act_x - player.bomb[i].grid_x) * player.bomb[i].speed * dt)
		
			if(player.bomb[i].kickBombDirection~="-")then
				kickBomb(player.bomb[i])
			end		
		end
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
	movementMonsters()
	if(player.iconDirection~="-")then
		animationMovement(player)
	end
	cancelIconDirection(player)
	informations = {["player.grid_x:"]=player.grid_x, 
					["player.grid_y:"]=player.grid_y, 
					["player.qtdBombs:"]=player.qtdBombs, 
					["player.bombDistanceExplosion:"]=player.bombDistanceExplosion, 
					["player.speed:"]=player.speed, 
					["player.kick_bombs:"]=tostring(player.kick_bombs), 
					["player.isGhost:"]=tostring(player.isGhost), 
					["player.hasSuperBomb:"]=tostring(player.hasSuperBomb)
	}
	--teste = player.act_x.."----"..player.act_y
end
 
function love.draw()
	if(gameOver==false) then
		createMap()
		setPlayer()
		setMonsters()
		if(#player.bomb>0)then
			for i=1, #player.bomb do 
				setBomb(player.bomb[i])
			end
		end
		explosion()
		
		printInformations()
		printMap()
	else
		love.graphics.print('Fim de jogo', love.graphics.getWidth()/2 - 40, love.graphics.getHeight()/2 - 5)
	end
end

function printInformations()
	love.graphics.setColor(255, 255, 255)
	local x = 530
	local y = 60
	for key,value in pairs (informations) do 
		love.graphics.print(key.." "..value,x,y)
		y=y+20
	end
end

function cancelIconDirection(object)
	if(object.iconDirection=="Up")then
		if(object.act_y<=(object.grid_y+4))then
			object.img = love.graphics.newImage("/Imagens/player1_move"..object.iconDirection..".PNG")
			object.iconDirection="-"	
		end
	elseif(object.iconDirection=="Down")then
		if(object.act_y>=(object.grid_y-4))then
			object.img = love.graphics.newImage("/Imagens/player1_move"..object.iconDirection..".PNG")
			object.iconDirection="-"	
		end
	elseif(object.iconDirection=="Left")then
		if(object.act_x<=(object.grid_x+4))then
			object.img = love.graphics.newImage("/Imagens/player1_move"..object.iconDirection..".PNG")
			object.iconDirection="-"	
		end
	elseif(object.iconDirection=="Right")then
		if(object.act_x>=(object.grid_x-4))then
			object.img = love.graphics.newImage("/Imagens/player1_move"..object.iconDirection..".PNG")
			object.iconDirection="-"	
		end
	end
end

--ao utilizar esse metodo para monstros lembre-se de inserir os atributos utilizados aqui na "classe" monstro também 
function animationMovement(object)
	local currentTime = love.timer.getTime()
	local timeResult = currentTime - object.lastIconTime
	
	if(timeResult > object.iconFlag)then
		player.img = love.graphics.newImage("/Imagens/player1_move"..object.iconDirection..object.iconNumber..".PNG")
		if(object.iconNumber==1)then
			object.iconNumber=object.iconNumber+1
		else
			object.iconNumber=object.iconNumber-1
		end
		object.lastIconTime = love.timer.getTime()
	end
end

--1:kick bomb
--2:rollerblades
--3:fire bomb 1
--4:fire bomb 2
--5:ghost
--6:superbomb
function createItens()
	createItem(itens.kick_bomb)
	createItem(itens.kick_bomb)
	createItem(itens.rollerblades)
	createItem(itens.rollerblades)
	createItem(itens.rollerblades)
	createItem(itens.rollerblades)
	createItem(itens.fire_bomb_1)
	createItem(itens.fire_bomb_1)
	createItem(itens.fire_bomb_1)
	createItem(itens.fire_bomb_1)
	createItem(itens.fire_bomb_2)
	createItem(itens.fire_bomb_2)
	createItem(itens.ghost)
	createItem(itens.ghost)
	createItem(itens.superbomb)
	createItem(itens.superbomb)
	createItem(itens.qtdBomb)
	createItem(itens.qtdBomb)
	createItem(itens.qtdBomb)
	createItem(itens.qtdBomb)
end

function createItem(item)
	while(true) do
		local x = love.math.random(1, #map[1])
		local y = love.math.random(1, #map)
		if(map[y][x]==2)then
			mapItem[y][x]=item
			break
		end
	end
end

function kickBomb(bomb)
	local currentTime = love.timer.getTime()
	local timeResult = currentTime - bomb.lastKickBombTime
	if (timeResult > bomb.kickBombFlag)then
		if(bomb.kickBombDirection=="UP")then
			if noCollision(0, -1, bomb) then
				if existCollision(0, -1, bomb,5) then
					bomb.kickBombDirection="-"
				else
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=0
					bomb.grid_y = bomb.grid_y - sideSquare	
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=3
				end
			end	
		elseif(bomb.kickBombDirection=="DOWN")then
			if noCollision(0, 1, bomb) then
				if existCollision(0, 1, bomb,5) then
					bomb.kickBombDirection="-"
				else
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=0
					bomb.grid_y = bomb.grid_y + sideSquare
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=3
				end
			end
		elseif(bomb.kickBombDirection=="LEFT")then
			if noCollision(-1, 0, bomb) then
				if existCollision(-1, 0, bomb,5) then
					bomb.kickBombDirection="-"
				else
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=0
					bomb.grid_x = bomb.grid_x - sideSquare
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=3
				end
			end
		elseif(bomb.kickBombDirection=="RIGHT")then
			if noCollision(1, 0, bomb) then
				if existCollision(1, 0, bomb,5) then
					bomb.kickBombDirection="-"
				else
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=0
					bomb.grid_x = bomb.grid_x + sideSquare	
					map[bomb.grid_y/sideSquare][bomb.grid_x/sideSquare]=3
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
		love.graphics.setColor(colorMonsters)
		love.graphics.rectangle("fill", monsters[i].act_x, monsters[i].act_y, sideSquare, sideSquare)			
	end
end

function setBomb(bomb)
	local currentTime = love.timer.getTime()
	if(bomb.iconChange==false) then
		bomb.lastIconTime = love.timer.getTime()
		bomb.iconChange=true
	end
	local timeResult = currentTime - bomb.lastIconTime
	if (timeResult > bomb.iconFlag)then
		bomb.img = love.graphics.newImage("/Imagens/bomb"..bomb.iconNumber..".PNG")
		bomb.iconChange=false	
		--control for animate of bomb
		if(bomb.iconRevert==false)then
			if(bomb.iconNumber<=3) then
				if(bomb.iconNumber==3)then
					bomb.iconRevert=true
				else
					bomb.iconNumber=bomb.iconNumber+1
				end
			end
		else
			if(bomb.iconNumber>=1) then
				if(bomb.iconNumber==1)then
					bomb.iconRevert=false
				else
					bomb.iconNumber=bomb.iconNumber-1
				end
			end
		end
	end
	if(timeResult>bomb.timeExplosion) then
		bomb.iconRevert=false
		bomb.iconChange=false
		bomb.iconNumber=1
	end
	love.graphics.draw(bomb.img, bomb.act_x, bomb.act_y)
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
			if(map[y][x] == 0)then
				if (mapItem[y][x] == itens.kick_bomb) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_kick_bomb.PNG"), x * sideSquare, y * sideSquare)
				elseif (mapItem[y][x] == itens.rollerblades) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_rollerblades.PNG"), x * sideSquare, y * sideSquare)
				elseif (mapItem[y][x] == itens.fire_bomb_1) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_fire_bomb1.PNG"), x * sideSquare, y * sideSquare)
				elseif (mapItem[y][x] == itens.fire_bomb_2) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_fire_bomb2.PNG"), x * sideSquare, y * sideSquare)
				elseif (mapItem[y][x] == itens.ghost) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_ghost.PNG"), x * sideSquare, y * sideSquare)
				elseif (mapItem[y][x] == itens.superbomb) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_super_bomb.PNG"), x * sideSquare, y * sideSquare)
				elseif (mapItem[y][x] == itens.qtdBomb) then
					love.graphics.draw(love.graphics.newImage("/Imagens/item_bomb.PNG"), x * sideSquare, y * sideSquare)
				end
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
				love.graphics.print("{ " .. mapItem[y][x] .. ", ",520+(x*15),380+(y*10))	
			elseif x==#map[y] then
				love.graphics.print(", " .. map[y][x] .. "}",520+(x*15),240+(y*10))	
				love.graphics.print(", " .. mapItem[y][x] .. "}",520+(x*15),380+(y*10))	
			else 
				love.graphics.print(", " .. map[y][x] .. " ",520+(x*15),240+(y*10))	
				love.graphics.print(", " .. mapItem[y][x] .. " ",520+(x*15),380+(y*10))	
			end
		end
	end
end 

function love.keypressed(key)
	if key == "up" then
	-- trabalho-06
	-- variável 'key' esta sendo usada como enumeração
		movePlayer(0,-1,"UP","/Imagens/player1_moveUp.PNG")
	elseif key == "down" then
		movePlayer(0,1,"DOWN","/Imagens/player1_moveDown.PNG")
	elseif key == "left" then
		movePlayer(-1,0,"LEFT","/Imagens/player1_moveLeft.PNG")
	elseif key == "right" then
		movePlayer(1,0,"RIGHT","/Imagens/player1_moveRight.PNG")
	elseif key == "space" then
		if(#player.bomb < player.qtdBombs) then
			--if player isnt on the block
			if (not existCollision(0, 0, player, 2)) then
				local aux = #player.bomb+1
				player.bomb[aux]=Bomb.newBomb()		
				player.bomb[aux].grid_x=player.grid_x 
				player.bomb[aux].grid_y=player.grid_y
				player.bomb[aux].act_x=player.bomb[aux].grid_x
				player.bomb[aux].act_y=player.bomb[aux].grid_y
				map[player.bomb[aux].grid_y/sideSquare][player.bomb[aux].grid_x/sideSquare]=3	
				player.bomb[aux].initTime = love.timer.getTime()
				--player.qtdBombs=player.qtdBombs+1
				teste = #player.bomb
			end
		end
	end
end

function movePlayer(x,y,direction,imgDirection)
	if(existCollision(x, y, player,3)) then
		if(player.kick_bombs)then
			if(#player.bomb>0)then
				for i=#player.bomb,1,-1 do 
					player.bomb[i].kickBombDirection=direction
				end
			end
		end
	elseif(existCollision(x, y, player,5))then
		gameOver=true
	elseif (not existCollision(x, y, player, 1)) then 
		if (not existCollision(x, y, player, 3)) then
			if (not existCollision(x, y, player, 2) or player.isGhost) then
				player.img = love.graphics.newImage(imgDirection)
				if(not player.isGhost)then
					map[player.grid_y/sideSquare][player.grid_x/sideSquare]=0
				end
				if(direction == "UP")then
					player.grid_y = player.grid_y - sideSquare
					player.iconDirection = "Up"
				elseif(direction == "DOWN")then
					player.grid_y = player.grid_y + sideSquare
					player.iconDirection = "Down"
				elseif(direction == "LEFT")then
					player.grid_x = player.grid_x - sideSquare
					player.iconDirection = "Left"
				elseif(direction == "RIGHT")then
					player.grid_x = player.grid_x + sideSquare
					player.iconDirection = "Right"
				end
				if(not player.isGhost)then
					map[player.grid_y/sideSquare][player.grid_x/sideSquare]=4
				end
			end
		end
	end
	if(existCollision(0, 0, player,6)) then
		setItemForPlayer(player)
	end		
end

function setItemForPlayer(prPlayer)
	local posXPlayer = prPlayer.grid_x / sideSquare
	local posYPlayer = prPlayer.grid_y / sideSquare

	if(mapItem[posYPlayer][posXPlayer]==itens.kick_bomb)then
		prPlayer.kick_bombs=true
	elseif(mapItem[posYPlayer][posXPlayer]==itens.rollerblades)then
		prPlayer.speed = prPlayer.speed+2
	elseif(mapItem[posYPlayer][posXPlayer]==itens.fire_bomb_1)then
		prPlayer.bombDistanceExplosion = prPlayer.bombDistanceExplosion+1
	elseif(mapItem[posYPlayer][posXPlayer]==itens.fire_bomb_2)then
		prPlayer.bombDistanceExplosion = prPlayer.bombDistanceExplosion+2
	elseif(mapItem[posYPlayer][posXPlayer]==itens.ghost)then
		prPlayer.isGhost = true
	elseif(mapItem[posYPlayer][posXPlayer]==itens.superbomb)then
		prPlayer.hasSuperBomb = true
	elseif(mapItem[posYPlayer][posXPlayer]==itens.qtdBomb)then
		prPlayer.qtdBombs = prPlayer.qtdBombs + 1
	end
	mapItem[posYPlayer][posXPlayer]=0
end

function movementMonsters()
	for i=1, #monsters do 
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

--valueMap=1 --> collision of object with blocks
--valueMap=2 --> collision of object with stones
--valueMap=3 --> collision of object with bombs
--valueMap=4 --> collision of object with player
--valueMap=5 --> collision of object with monster
--valueMap=6 --> collision of object with itens
function existCollision(x, y, object, valueMap)
	if(valueMap==5)then
		local i
		for i=1, #monsters do 
			if map[(object.grid_y / sideSquare) + y][(object.grid_x / sideSquare) + x] == valueMap then
				return true
			end
		end
	elseif(valueMap==3)then
		if(#player.bomb>0)then
			if map[(object.grid_y / sideSquare) + y][(object.grid_x / sideSquare) + x] == valueMap then
				return true
			end
		end
	elseif(valueMap==6)then			
		if mapItem[(object.grid_y / sideSquare) + y][(object.grid_x / sideSquare) + x] ~=0 then
			return true
		end
	else
		if map[(object.grid_y / sideSquare) + y][(object.grid_x / sideSquare) + x] == valueMap then
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
	if(#player.bomb>0)then
		for i=1, #player.bomb do 
			if map[(item.grid_y / sideSquare) + y][(item.grid_x / sideSquare) + x] == 3 then
				return true
			end
		end
	end
	return false
end

function explosion()
	if(#player.bomb>0) then
		for i=#player.bomb, 1, -1 do	
			local currentTime = love.timer.getTime()
			local timeResult = math.floor(currentTime - player.bomb[i].initTime)
			map[(player.bomb[i].grid_y / sideSquare)][(player.bomb[i].grid_x / sideSquare)]=3
			if(timeResult > player.bomb[i].timeExplosion) then
				explosionCollision(0, 1, player.bomb[i])
				explosionCollision(0, -1, player.bomb[i])
				explosionCollision(1, 0, player.bomb[i])
				explosionCollision(-1, 0, player.bomb[i])
				--When the player is on the bomb
				if(isPlayerOnTheBomb())then
					gameOver=true
				end
				player.bomb[i].kickBombDirection="-"
				map[(player.bomb[i].grid_y / sideSquare)][(player.bomb[i].grid_x / sideSquare)] = 0
				table.remove(player.bomb, i)
			end
		end
	end
end

function isPlayerOnTheBomb()
	if(#player.bomb>0)then
		for i=1, #player.bomb do 
			if(player.bomb[i].grid_y==player.grid_y and player.bomb[i].grid_x==player.grid_x)then
				return true
			end
		end
	end
	return false
end

function explosionCollision(x, y, bomb)
	local i=1
	for i=1, player.bombDistanceExplosion do	
		love.graphics.rectangle("fill", bomb.grid_x  + (x*i*sideSquare),bomb.grid_y + (y*i*sideSquare), sideSquare, sideSquare)
		
		local yi=(bomb.grid_y / sideSquare) + (y*i)
		local xi=(bomb.grid_x / sideSquare) + (x*i)

		--explosion colision with stones
		if map[yi][xi] == 2 
		then	
			map[yi][xi] = 0
			if(not player.hasSuperBomb)then
				break
			end	
		--explosion colision with itens
		elseif mapItem[yi][xi] ~=0 
		then	
			mapItem[yi][xi] = 0
		end		
		--explosion colision with blocks
		if map[yi][xi] == 1 
		then	
			break
			-- Nome: Palavra reservada "break"
			-- Propriedade: Desvio de instruções
			-- Binding time: desenho
			-- Explicação: A palavra 'break' é utilizada para desviar as instruções para fora do laço a qual o break se encontra
		end	
		--explosion colision with player
		if(bomb.grid_x +(sideSquare*i*x)==player.grid_x and bomb.grid_y +(sideSquare*i*y)==player.grid_y)
		then	
			gameOver=true
		end		
		--explosion colision with monsters
		local j
		--local aux=false
		for j=#monsters,1,-1 do 
			if(bomb.grid_x +(sideSquare*i*x)==monsters[j].grid_x and bomb.grid_y +(sideSquare*i*y)==monsters[j].grid_y)
			then
				map[(monsters[j].grid_y / sideSquare)][(monsters[j].grid_x / sideSquare)] = 0
			    table.remove(monsters, j)
			--	aux=true
			end		
		end
		--if(aux)then
			--break
		--end
	end
end
