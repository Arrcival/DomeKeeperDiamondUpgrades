extends "res://content/map/generation/TileDataGenerator.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func generate():
	.generate()
	
	finishedSuccessful = false
	var tdResources = $TileData / Resources
	var tdBiomes = $TileData / Biomes
	
	var rand: = RandomNumberGenerator.new()
	rand.seed = gen_seed
	
	for i in range(10, 20):
		var cells = tdBiomes.get_used_cells_by_id(i)
		if cells.size() == 0:
			break
			
		# TODO : make it prettier
		var diamondGenerated = false
		var biomeCells = Data.seedShuffle(cells, gen_seed)
		var j = 0
		while not diamondGenerated:
			var biomeCell = biomeCells[j]
			var ressourceCell = tdResources.get_cell(biomeCell.x, biomeCell.y)
			if ressourceCell < Data.TILE_DIRT_START || ressourceCell > Data.TILE_DIRT_END:
				print("Not on dirt : not generated")
				j = j + 1
				continue
			
			tdResources.set_cell(biomeCell.x, biomeCell.y, CONSTARRC.TILE_DIAMOND)
			diamondGenerated = true
			print("Generated diamond at " + str(biomeCell))
		
		# debugging purposes
		# tdResources.set_cell(0, 1, CONSTARRC.TILE_DIAMOND)
		
		
	finishedSuccessful = true
