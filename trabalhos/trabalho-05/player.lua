local exports = {}

exports.newPlayer = function (prGridX,prGridY,prActX,prActY,prSpeed,prImg)
    local player = {}    
	local bombs = {}
    player.grid_x = prGridX
	player.grid_y = prGridY
	player.act_x = prActX
	player.act_y = prActY
	player.speed = prSpeed
	player.img = love.graphics.newImage(prImg)
	player.bomb = bombs

    return player
end

return exports