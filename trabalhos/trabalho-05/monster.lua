local exports = {}

exports.newMonster = function (prGridX,prGridY,prActX,prActY,prSpeed,prLastMovementTime,prMovementTime,prIsDead)
    local monster = {} 
	local bombs = {}
    monster.grid_x = prGridX
	monster.grid_y = prGridY
	monster.act_x = prActX
	monster.act_y = prActY
	monster.speed = prSpeed
	monster.lastMovementTime = prLastMovementTime
	monster.movementTime = prMovementTime
	monster.isDead = prIsDead
	monster.bomb = bombs

    return monster
end

return exports
