extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func init(chain: ModLoaderHookChain, fromDeserialize := false, generateChambers := true):
	chain.execute_next([fromDeserialize, generateChambers])
	var main_node : Node = chain.reference_object
	main_node.tilesByType[CONSTARRC.DIAMOND] = []
	Data.TILE_ID_TO_STRING_MAP[CONSTARRC.TILE_DIAMOND] = CONSTARRC.DIAMOND

func isResourceTile(chain: ModLoaderHookChain, typeId:int) -> bool:
	return chain.execute_next([typeId]) or typeId == CONSTARRC.TILE_DIAMOND

func revealTile(chain: ModLoaderHookChain, coord:Vector2):
	
	var main_node : Node = chain.reference_object
	var invalids := []
	if main_node.tileRevealedListeners.has(coord):
		for listener in main_node.tileRevealedListeners[coord]:
			if is_instance_valid(listener):
				listener.tileRevealed(coord)
			else:
				invalids.append(listener)
		for invalid in invalids:
			main_node.tileRevealedListeners.erase(invalid)
	
	var typeId:int = main_node.tileData.get_resource(coord.x, coord.y)
	if typeId == Data.TILE_EMPTY:
		return
	
	if main_node.tiles.has(coord):
		return
	
	var tile = main_node.tile_scene.instantiate()
	var biomeId:int = main_node.tileData.get_biome(coord.x, coord.y)
	tile.layer = biomeId
	tile.biome = main_node.biomes[tile.layer]
	tile.position = coord * GameWorld.TILE_SIZE
	tile.coord = coord
		
	tile.hardness = main_node.tileData.get_hardness(coord.x, coord.y)

	tile.type = Data.TILE_ID_TO_STRING_MAP.get(typeId, "dirt")
	match tile.type:
		CONST.IRON:
			tile.richness = Data.ofOr("map.ironrichness", 2)
			main_node.revealTileVisually(coord)
		CONST.SAND:
			tile.richness = Data.ofOr("map.cobaltrichness", 2)
			main_node.revealTileVisually(coord)
		CONST.WATER:
			tile.richness = Data.ofOr("map.waterrichness", 2.5)
			main_node.revealTileVisually(coord)
		CONSTARRC.DIAMOND:
			tile.richness = 2
			main_node.revealTileVisually(coord)
	main_node.tiles[coord] = tile 
	
	if main_node.tilesByType.has(tile.type):
		main_node.tilesByType[tile.type].append(tile)
	tile.destroyed.connect(main_node.destroyTile.bind(tile))
	
	main_node.tiles_node.add_child(tile)

	# Allow border tiles to fade correctly at edges of the map
	main_node.visibleTileCoords[coord] = typeId

func destroyTile(chain: ModLoaderHookChain, tile, withDropsAndSound := true):
	if tile.type != CONSTARRC.DIAMOND:
		return chain.execute_next([tile, withDropsAndSound])
	
	var main_node : Node = chain.reference_object
	Data.changeByInt("map.tilesDestroyed", 1)
	Recorder.recordTileDestroyed(tile.coord)
	if withDropsAndSound:
		var sound
		sound = main_node.find_child("TileDestroyedSand").duplicate(Node.DuplicateFlags.DUPLICATE_USE_INSTANTIATION)
		sound.setSimulatedPosition(tile.global_position)
		main_node.add_child(sound)
		sound.play()
	
		var goalRichness = tile.richness * Data.ofOr("resourcemodifiers.richness." + tile.type, 1.0)
		var drops 

		if tile.type == CONSTARRC.DIAMOND:
			var diamondCap = CONSTARRC.MAXIMUM_DIAMONDS - CONSTARRC.MINIMUM_DIAMONDS + 1 # 1-3 gives 3
			var randNum = randi() % diamondCap # picks between 0 1 2 for 3
			drops = randNum + 1 # adds one to 0 1 2
		
		for _i in range(0, drops):
			var drop = Data.DROP_SCENES.get(tile.type).instantiate()
			drop.position = tile.global_position + 0.6 * Vector2(GameWorld.HALF_TILE_SIZE - randf()*GameWorld.TILE_SIZE, GameWorld.HALF_TILE_SIZE - randf()*GameWorld.TILE_SIZE)
			drop.apply_central_impulse(Vector2(0, 40).rotated(randf() * TAU))
			main_node.call_deferred("addDrop", drop)
			GameWorld.incrementRunStat("resources_mined")

	if tile.hardness == 5:
		# border tile destroyed, make sure there are physical tiles around now
		main_node.buildBorderAroundTile(tile.coord, main_node.tileData.get_biomev(tile.coord))
	
	main_node.tiles.erase(tile.coord)
	for t in main_node.tilesByType.values():
		t.erase(tile)
	main_node.tilesByType.get(tile.type, {}).erase(tile)
	tile.queue_free()
	
	main_node.onTileRemoved(tile.coord)
#	for d in CONST.DIRECTIONS:
#		tileCoordsToReveal.append(tile.coord + d)
	main_node.tileCoordsToReveal.append(tile.coord)
	main_node.floodRevealTiles()

