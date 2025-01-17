extends "res://content/weapons/sword/Sword.gd"


func onRetractCompleted():
	retracting = false
	var relExtension = maxExtension / Data.of("sword.stabRange")
	var relStabbing = 1.0 - remainingPierceDamage / Data.of("sword.stabDamage") * Data.of("sword.dpsmod")
	cooldown = Data.of("sword.stabCooldown")
	cooldown = 0.5 * cooldown + max(relExtension, relStabbing) * 0.5 * cooldown
	maxCooldown = cooldown
	$BladeTrail.clear_points()
	bladeExtension = 0.0
	$Blade.position = bladeBasePos
	$Blade.rotation = 0.0
	$RetractedSound.play()
	$Base/BaseEffect.frame = 0
	$Base/BaseEffect.play("retracted")
	InputSystem.shake(60, 0.25)
	if arrowUnlocked:
		hideArrow()
	
	if active and Data.of("sword.aimLine"):
		AimLine.visible = true
	else:
		AimLine.visible = false
	 
	if not active:
		$SparksSound.stop()
		move *= 0


func extend():
	super.extend()
	remainingPierceDamage = Data.of("sword.stabDamage") * Data.of("sword.dpsmod")

func shootJavelin():
	javelinShot = true
	var javeling = preload("res://content/weapons/sword/JavelinBlade.tscn").instantiate()
	javeling.remainingPierceDamage = Data.of("sword.stabDamage") * Data.of("sword.dpsmod")
	javeling.position = $Blade.global_position
	javeling.rotation = $Blade.global_rotation
	javeling.add_child($Blade/ArrowLeft.duplicate())
	javeling.add_child($Blade/ArrowRight.duplicate())
	var sprite = $Blade/Sprite2D.duplicate()
	sprite.play("charged" + bladeSuffix)
	javeling.add_child(sprite)
	javeling.add_child($Blade/MoveParticles.duplicate())
	javeling.setCollisionShapes(BladeCollisionShape, $Blade/HitArea/ArrowHead)
	Level.viewports.addElement(javeling)
	InputSystem.shake(60, 0.25)
	$JavelinFireSound.play()
	$Blade/Sprite2D.play("init"+bladeSuffix)
	cooldown = 0.1
	javelinCharge = 0.0
	$Base/BaseEffect.frame = 0
	$Base/BaseEffect.play("retracted")
	updateFilling()
	$RechargeSound.stop()
	extendRotation = 0
	
	var bombState = Data.of("sword.stabexplosive") - 1
	if bombState >= 0:
		var bombsprite = $Blade/Bombtip.duplicate()
		bombsprite.frame = bombState
		bombsprite.visible = true
		bombsprite.position.y = fillingY - 8
		javeling.addBomb(bombsprite)
