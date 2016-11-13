local exports = {}

exports.newMonster = function (prGridX,prGridY,prMovementTime,prIsMovementRec)
    local monster = {} 
	local bombs = {}
    monster.grid_x = prGridX
	monster.grid_y = prGridY
	monster.movementTime = prMovementTime
	monster.isMovementRec = prIsMovementRec
	monster.act_x = prGridX
	monster.act_y = prGridY
	monster.speed = 10
	monster.lastMovementTime = 0
	monster.bomb = bombs

    return monster
end

return exports
