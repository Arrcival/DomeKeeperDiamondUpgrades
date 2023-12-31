extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func generate():
	.generate()
	
	if finishedSuccessful == false:
		return
		
	finishedSuccessful = false
	var tdResources = $TileData / Resources
	var tdBiomes = $TileData / Biomes
	
	var rand: = RandomNumberGenerator.new()
	rand.seed = gen_seed
	
	var diamondPerLayers = GameWorld.diamondTilesPerLayer
	
	for i in range(10, 20):
		var cells = tdBiomes.get_used_cells_by_id(i)
		if cells.size() == 0:
			break

		var biomeCells = Data.seedShuffle(cells, gen_seed)
		
		var diamondsGenerated = 0
		for cell in biomeCells:
			var ressourceCell = tdResources.get_cell(cell.x, cell.y)
			if ressourceCell >= Data.TILE_DIRT_START && ressourceCell <= Data.TILE_DIRT_END:
				tdResources.set_cell(cell.x, cell.y, CONSTARRC.TILE_DIAMOND)
				printGeneratedDiamond(cell)
				diamondsGenerated += 1
			if diamondsGenerated >= diamondPerLayers:
				break

		# debugging purposes
		# tdResources.set_cell(0, 1, CONSTARRC.TILE_DIAMOND)
				
	finishedSuccessful = true

func printGeneratedDiamond(cell):
	if GameWorld.devMode:
		print("Generated diamond at " + str(cell))
