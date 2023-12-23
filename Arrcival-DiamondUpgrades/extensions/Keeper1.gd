extends "res://content/keeper/keeper1/Keeper1.gd"

func drill_check()->void :
	DrillHitTestRay.rotation = moveDirectionInput.angle()

	DrillHitTestRay.force_raycast_update()
	var tile = DrillHitTestRay.get_collider()
	if not (tile and tile.has_meta("destructable") and tile.get_meta("destructable")):
		return 
	var dir = global_position - tile.global_position
	var totalDrillDamage = Data.of("keeper1.drillStrength") * Data.of("keeper1.drillMod")
	tile.hit(dir, totalDrillDamage)
	emit_signal("mined", 0.1)

	if Options.shakeDrill:
		InputSystem.getCamera().shake(20, 0.2, 8)
	
	var knockback = Data.of("keeper1.acceleration") * Data.of("keeper1.tileKnockback")
	hitCooldown = Data.of("keeper1.tileHitCooldown")
	moveSlowdown = 0.25 + currentSpeed() * 0.01
	spriteLockDuration = hitCooldown
	var drillbuff = 1.0 - float(Data.of("keeper.drillBuff"))
	if drillbuff < 1.0:
		hitCooldown = max(hitCooldown * drillbuff, 0.017)
		knockback *= drillbuff
		spriteLockDuration *= drillbuff
	if abs(dir.x) > abs(dir.y):
		move.x = sign(dir.x) * knockback
		move.y *= 0.1
	else :
		move.y = sign(dir.y) * knockback
		move.x *= 0.1
	
	$TileHitSounds.hit(tile, drillbuff < 1.0, true)

	DrillSprite.show()
	DrillSprite.frame = 0
	DrillSprite.play("drill" + animationSuffix)
	DrillSprite.rotation = DrillHitTestRay.rotation + PI

	var anim_name = ""
	if abs(move.x) > abs(move.y):
		anim_name = "drill_right" if move.x < 0 else "drill_left"
	else :
		anim_name = "down" if move.y < 0 else "up"

	$Sprite.play(anim_name + animationSuffix)
	
	var hits_needed_to_destroy:float = float(tile.max_health) / float(totalDrillDamage)
	emit_sparks(DrillHitTestRay.get_collision_point(), tile, hits_needed_to_destroy)
	emit_signal("tileHit")

func currentSpeed()->float:
	var s = Data.of("keeper1.maxSpeed") * Data.of("keeper1.speedMod") + Data.of("keeper.additionalmaxspeed")
	s += Data.of("keeper.speedBuff")
	var yMove = move.normalized().y
	if yMove < 0:
		s += Data.of("keeper.additionalupwardsspeed") * abs(yMove)
	var limit = Data.ofOr("keeper.speedlimit", - 1)
	if limit >= 0.0 and limit < s:
		s = limit
	return s
