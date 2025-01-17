extends "res://content/gadgets/mineraltree/MineralTree.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func updateFruitType():
	var rootedResources := {CONST.IRON: 1}
	for rootCoord in rootCoords:
		var res = Level.map.getTileData().get_resourcev(rootCoord)
		match int(res):
			0: rootedResources[CONST.IRON] = 1 + rootedResources.get(CONST.IRON, 0)
			1: rootedResources[CONST.WATER] = 1 + rootedResources.get(CONST.WATER, 0)
			2: rootedResources[CONST.SAND] = min(1, 1 + rootedResources.get(CONST.SAND, 0))
			42:rootedResources[CONSTARRC.DIAMOND] = 1 + rootedResources.get(CONSTARRC.DIAMOND, 0)
	
	for f in fruits[fruitStage]:
		match f.type:
			CONST.IRON: rootedResources[CONST.IRON] = rootedResources.get(CONST.IRON, 0) - 1
			CONST.WATER: rootedResources[CONST.WATER] = rootedResources.get(CONST.WATER, 0) - 1
			CONST.SAND: rootedResources[CONST.SAND] = rootedResources.get(CONST.SAND, 0) - 1
			CONSTARRC.DIAMOND:rootedResources[CONSTARRC.DIAMOND] = rootedResources.get(CONSTARRC.DIAMOND, 0) - 1
	
	for fs in fruits[fruitStage]:
		if not fs.type or fs.type == "":
			# decide on a new fruit
			var type:String
			if rootedResources.get(CONST.SAND, 0) > 0:
				type = CONST.SAND
				rootedResources[CONST.SAND] = rootedResources.get(CONST.SAND, 0) - 1
			elif rootedResources.get(CONSTARRC.DIAMOND, 0) > 0:
				type = CONSTARRC.DIAMOND
				rootedResources[CONSTARRC.DIAMOND] = rootedResources.get(CONSTARRC.DIAMOND, 0) - 1
			elif rootedResources.get(CONST.WATER, 0) > 0:
				type = CONST.WATER
				rootedResources[CONST.WATER] = rootedResources.get(CONST.WATER, 0) - 1
			elif rootedResources.get(CONST.IRON, 0) > 0:
				type = CONST.IRON
				rootedResources[CONST.IRON] = rootedResources.get(CONST.IRON, 0) - 1
		
			if type:
				fs.setType(type)
			else:
				for t in [CONST.SAND, CONSTARRC.DIAMOND, CONST.WATER, CONST.IRON]:
					for fs2 in fruits[fruitStage] and fs.totalCycles >= 5:
						if fs2 == t:
							fs.setType(t)
