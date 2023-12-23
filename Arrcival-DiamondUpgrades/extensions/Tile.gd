extends "res://content/map/tile/Tile.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _ready():
	var baseHealth:float = Data.of("map.tileBaseHealth")
	
	var forceMultiplier: = 0.0
	if type != "special":
		match type:
			"border":
				res_sprite.queue_free()
			"dirt":
				res_sprite.hide()
				set_meta("destructable", true)
				initResourceSprite(Vector2(5, 0))
			CONST.IRON:
				set_meta("destructable", true)
				res_sprite.flip_h = randf() > 0.5
				initResourceSprite(Vector2(2, 11))
				baseHealth += Data.of("map.ironAdditionalHealth")
			CONST.SAND:
				set_meta("destructable", true)
				res_sprite.flip_h = randf() > 0.5
				initResourceSprite(Vector2(2, 3))
				baseHealth += Data.of("map.sandAdditionalHealth")
			CONST.WATER:
				set_meta("destructable", true)
				res_sprite.flip_h = randf() > 0.5
				initResourceSprite(Vector2(2, 7))
				baseHealth += Data.of("map.waterAdditionalHealth")
			CONST.GADGET:
				set_meta("destructable", true)
				initResourceSprite(Vector2(4, 1))
				baseHealth += Data.of("map.gadgetAdditionalHealth")
				forceMultiplier = 1.0
			CONST.POWERCORE:
				set_meta("destructable", true)
				initResourceSprite(Vector2(4, 1))
				baseHealth += Data.of("map.gadgetAdditionalHealth")
				forceMultiplier = 1.0
			CONST.RELIC:
				set_meta("destructable", true)
				initResourceSprite(Vector2(4, 2))
				baseHealth += Data.of("map.relicAdditionalHealth")
				forceMultiplier = 1.0
			CONST.RELICSWITCH:
				set_meta("destructable", true)
				initResourceSprite(Vector2(4, 2))
				baseHealth += Data.of("map.relicAdditionalHealth")
				forceMultiplier = 1.0
			CONST.NEST:
				set_meta("destructable", true)
				initResourceSprite(Vector2(5, 0))
				forceMultiplier = 1.0
			CONSTARRC.DIAMOND:
				set_meta("destructable", true)
				res_sprite.flip_h = randf() > 0.5
				initResourceSprite(Vector2(4, 4))
				baseHealth += Data.of("map.sandAdditionalHealth") # to edit later
	
	var healthMultiplier:float = Data.of("map.tileHealthBaseMultiplier")
	if forceMultiplier != 0.0:
		health *= forceMultiplier
	else :
		match int(hardness):
			0:
				healthMultiplier *= Data.of("map.hardnessMultiplier0")
			1:
				healthMultiplier *= Data.of("map.hardnessMultiplier1")
			2:
				healthMultiplier *= Data.of("map.hardnessMultiplier2")
			3:
				healthMultiplier *= Data.of("map.hardnessMultiplier3")
			4:
				healthMultiplier *= Data.of("map.hardnessMultiplier4")
	
	healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), layer))
	
	max_health = max(1, round(healthMultiplier * baseHealth))
	if hasRoots:
		max_health *= 5
	health = max_health
	
	Style.init(res_sprite)
