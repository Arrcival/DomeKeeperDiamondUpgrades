extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func generate_resources(rand):
	super.generate_resources(rand)

	var diamondPerLayers = GameWorld.diamondTilesPerLayer
	
	for i in range(0, 10):
		var cells = $MapData.get_biome_cells_by_index(i)
		if cells.size() == 0:
			break

		var biomeCells = Data.seedShuffle(cells, gen_seed)
		
		var diamondsGenerated = 0
		for cell in biomeCells:
			var ressourceCell = $MapData.get_resourcev(cell)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:
				$MapData.set_resourcev(cell, CONSTARRC.TILE_DIAMOND)
				printGeneratedDiamond(cell)
				diamondsGenerated += 1
			if diamondsGenerated >= diamondPerLayers:
				break

	# debugging purposes
	if GameWorld.devMode or OS.is_debug_build():
		$MapData.set_resourcev(Vector2(0, 2) , CONSTARRC.TILE_DIAMOND)


func printGeneratedDiamond(cell):
	if GameWorld.devMode or OS.is_debug_build():
		print("--------- Generated diamond at " + str(cell))
