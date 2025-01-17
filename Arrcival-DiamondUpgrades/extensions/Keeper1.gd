extends "res://content/keeper/keeper1/Keeper1.gd"

func drill_check()->void:
	DrillHitTestRay.rotation = moveDirectionInput.angle()
#	force raycast update, as otherwise we might get a drill collision while already moving in an other direction
	DrillHitTestRay.force_raycast_update()
	var tile = DrillHitTestRay.get_collider()
	
	if not tile or not tile.has_meta("destructable"):
		return
	if not tile.get_meta("destructable"):
		if Data.of(playerId + ".keeper1.destroyindestructibletiles"):
			if not Level.map.isWithinBounds(tile.coord):
				return 
		else:
			return
	
	var dir = global_position - tile.global_position
	var drillStrength = Data.of(playerId + ".keeper1.drillStrength")
	if tile.hardness >= 3:
		var tilehardnessmodifier = Data.ofOr(playerId + ".keeper1.hardtilesmodifier", 1.0)
		drillStrength *= tilehardnessmodifier
	
	# Diamond upgrades modification
	var totalStrength = drillStrength * Data.of(playerId + ".keeper1.drillMod")
	tile.hit(dir, totalStrength)
	emit_signal("mined", 0.1)
	
	if Options.shakeDrill:
		InputSystem.shakeTarget(self, 20, 0.2, 8)

	var knockback = Data.of("keeper1.acceleration") * Data.of("keeper1.tileKnockback")
	hitCooldown = Data.of("keeper1.tileHitCooldown")
	moveSlowdown = 0.25 + currentSpeed() * 0.01
	spriteLockDuration = hitCooldown
	var drillbuff = 1.0 - float(Data.of(playerId+".keeper.drillBuff"))
	if drillbuff < 1.0:
		hitCooldown = max(hitCooldown * drillbuff, 0.017)
		knockback *= drillbuff
		spriteLockDuration *= drillbuff
	if abs(dir.x) > abs(dir.y):
		move.x = sign(dir.x) * knockback
		move.y *=  0.1
	else:
		move.y = sign(dir.y) * knockback
		move.x *=  0.1

	$TileHitSounds.hit(tile, drillbuff < 1.0, true)

	DrillSprite.show()
	DrillSprite.frame = 0
	var infix  = "_big" if Data.of("keeper1.destroyindestructibletiles") else ""
	DrillSprite.play("drill" + infix + animationSuffix)
	DrillSprite.rotation = DrillHitTestRay.rotation + PI

	var anim_name = ""
	if abs(move.x) > abs(move.y):
		anim_name = "drill_right" if move.x < 0 else "drill_left"
	else:
		anim_name = "down" if move.y < 0 else "up"

	$Sprite2D.play(anim_name + animationSuffix)
	
	var hits_needed_to_destroy:float = float(tile.max_health) / float(Data.of(playerId + ".keeper1.drillStrength"))
	emit_sparks(DrillHitTestRay.get_collision_point(), tile, hits_needed_to_destroy)
	emit_signal("tileHit")

func currentSpeed() -> float:
	var s = Data.of(playerId + ".keeper1.maxSpeed") * Data.of(playerId + ".keeper1.speedMod")
	s += Data.ofOr(playerId + ".keeper.speedBuff", 0)
	var yMove = move.normalized().y
	s += Data.ofOr(playerId + ".keeper.additionalupwardsspeed", 0) * abs(yMove)
	return s

