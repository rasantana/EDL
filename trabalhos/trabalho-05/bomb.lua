local exports = {}

exports.newBomb = function (prGridX,prGridY,prActX,prActY,prSpeed,prInitTime,prTimeExplosion
						   ,prDistanceExplosion,prExistBomb,prLastIconTime,prIconChange
						   ,prIconNumber,prIconRevert,prIconFlag,prLastKickBombTime
						   ,prKickBombFlag,prKickBombDirection,prImg)
    local bomb = {}    
	bomb.grid_x = prGridX
	bomb.grid_y = prGridY
	bomb.act_x = prActX
	bomb.act_y = prActY
	bomb.speed = prSpeed
	bomb.initTime = prInitTime
	bomb.timeExplosion = prTimeExplosion
	bomb.distanceExplosion = prDistanceExplosion
	bomb.existBomb=prExistBomb
	bomb.lastIconTime = prLastIconTime
	bomb.iconChange =prIconChange
	bomb.iconNumber=prIconNumber
	bomb.iconRevert=prIconRevert
	bomb.iconFlag=prIconFlag
	bomb.lastKickBombTime=prLastKickBombTime
	bomb.kickBombFlag=prKickBombFlag
	bomb.kickBombDirection=prKickBombDirection
	bomb.img = love.graphics.newImage(prImg)

    return bomb
end

return exports