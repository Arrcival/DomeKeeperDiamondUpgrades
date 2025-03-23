extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _ready(chain: ModLoaderHookChain):
	chain.execute_next()

	var main_node : Node = chain.reference_object
	
	if main_node.res_sprite and main_node.type == CONSTARRC.DIAMOND:
		main_node.res_sprite.texture = load("res://mods-unpacked/Arrcival-DiamondUpgrades/content/map/border/diamond_resources_sheet.png")
		Style.init(main_node.res_sprite)

func setType(chain: ModLoaderHookChain, type:String):
	var main_node : Node = chain.reference_object
	main_node.type = type
	if type == CONSTARRC.DIAMOND:
		var baseHealth:float = Data.of("map.tileBaseHealth")
		
		main_node.set_meta("destructable", true)
		main_node.initResourceSprite(Vector2(4, 4))
		baseHealth += Data.of("map.sandAdditionalHealth")
		
		var healthMultiplier:float = 1.0
		match int(main_node.hardness):
			0:
				main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier0")
			1:
				main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier1")
			2:
				main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier2")
			3:
				main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier3")
			4:
				main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier4")
			5:
				main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier5")
			_:
				main_node.hardnessMultiplier = 1
		
		healthMultiplier *= main_node.hardnessMultiplier
		healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), main_node.layer))
		
		var max_health = max(1, round(healthMultiplier * baseHealth))
		main_node.max_health = max_health
		main_node.health = max_health
		return
	chain.execute_next([type])

