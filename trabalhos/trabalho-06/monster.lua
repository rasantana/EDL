local exports = {}

exports.newMonster = function (prGridX,prGridY)
    local monster = {} 
	local bombs = {}
    monster.grid_x = prGridX
	monster.grid_y = prGridY
	
	monster.act_x = prGridX
	monster.act_y = prGridY
	monster.speed = 10
	monster.lastMovementTime = 0
	monster.movementTime = 2
	monster.bomb = bombs

    return monster
end

return exports
