extends "res://content/weapons/sword/Sword.gd"

func onRetractCompleted():
	retracting = false
	var totalDamage = Data.of("sword.stabDamage") * Data.of("sword.dpsmod")
	var relExtension = maxExtension / Data.of("sword.stabRange")
	var relStabbing = 1.0 - remainingPierceDamage / totalDamage
	cooldown = Data.of("sword.stabCooldown")
	cooldown = 0.5 * cooldown + max(relExtension, relStabbing) * 0.5 * cooldown
	maxCooldown = cooldown
	$BladeTrail.clear_points()
	bladeExtension = 0.0
	$Blade.position = bladeBasePos
	$Blade.rotation = 0.0
	$RetractedSound.play()
	$Base / BaseEffect.frame = 0
	$Base / BaseEffect.play("retracted")
	InputSystem.getCamera().shake(60, 0.25)
	if arrowUnlocked:
		hideArrow()
	
	if active and Data.of("sword.aimLine"):
		AimLine.visible = true
	else :
		AimLine.visible = false
		
	if not active:
		$SparksSound.stop()

func extend():
	.extend()
	remainingPierceDamage = Data.of("sword.stabDamage") * Data.of("sword.dpsmod")

func shootJavelin():
	.shootJavelin()
	Level.stage.get_child("JavelinBlade").remainingPierceDamage = Data.of("sword.stabDamage") * Data.of("sword.dpsmod")
