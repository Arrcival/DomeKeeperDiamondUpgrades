extends "res://content/map/Map.gd"

const TILE_SCENE_EDITED = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/map/tile/Tile.tscn")
const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func init(fromDeserialize: = false):
	.init(fromDeserialize)
	tilesByType = {CONST.WATER:[], CONST.SAND:[], CONST.IRON:[], CONSTARRC.DIAMOND:[]}
	TYPE_MAP.merge({CONSTARRC.TILE_DIAMOND:CONSTARRC.DIAMOND})


func revealTile(coord:Vector2):
	var typeId:int = tileData.get_resource(coord.x, coord.y)
	if typeId == Data.TILE_EMPTY:
		return 
	
	if tiles.has(coord):
		return 
	
	if typeId == Data.TILE_CAVE:
		onTileRemoved(coord)
	else :
		var tile = TILE_SCENE_EDITED.instance()
		var biomeId:int = tileData.get_biome(coord.x, coord.y)
		tile.layer = biomeId
		tile.biome = biomes[tile.layer]
		tile.position = coord * GameWorld.TILE_SIZE
		tile.coord = coord
		if coord.y == - 1 and coord.x != 0:
			tile.visible = false
		tile.hardness = tileData.get_hardness(coord.x, coord.y)
		
		tile.type = TYPE_MAP.get(typeId, "dirt")
		match tile.type:
			CONST.IRON:
				tile.richness = 2
				revealTileVisual(coord)
			CONST.SAND:
				tile.richness = 2.0
				revealTileVisual(coord)
			CONST.WATER:
				tile.richness = 2.5
				revealTileVisual(coord)
			CONSTARRC.DIAMOND:
				tile.richness = 2
				revealTileVisual(coord)
		tiles[coord] = tile
		
		if tilesByType.has(tile.type):
			tilesByType[tile.type].append(tile)
		tile.connect("destroyed", self, "destroyTile", [tile])
		
		if futureRoots.has(coord):
			futureRoots.erase(coord)
			tile.root()
		
		tiles_node.add_child(tile)

	
	visibleTileCoords[coord] = null
	
	var invalids: = []
	if tileRevealedListeners.has(coord):
		for listener in tileRevealedListeners[coord]:
			if is_instance_valid(listener):
				listener.tileRevealed(coord)
			else :
				invalids.append(listener)
		for invalid in invalids:
			tileRevealedListeners.erase(invalid)


func destroyTile(tile):
	var sound
	match tile.type:
		CONST.BORDER:
			return 
		CONST.IRON:
			sound = $TileDestroyedIron.duplicate(DUPLICATE_USE_INSTANCING)
		CONST.WATER:
			sound = $TileDestroyedWater.duplicate(DUPLICATE_USE_INSTANCING)
		CONST.SAND:
			sound = $TileDestroyedSand.duplicate(DUPLICATE_USE_INSTANCING)
		CONST.GADGET:
			sound = $TileDestroyedChamber.duplicate(DUPLICATE_USE_INSTANCING)
		CONST.RELIC:
			sound = $TileDestroyedChamber.duplicate(DUPLICATE_USE_INSTANCING)
		CONSTARRC.DIAMOND:
			sound = $TileDestroyedSand.duplicate(DUPLICATE_USE_INSTANCING)
		_:
			sound = $TileDestroyed.duplicate(DUPLICATE_USE_INSTANCING)
	sound.setSimulatedPosition(tile.global_position)
	add_child(sound)
	sound.play()
	
	dig(tile.coord)
	
	if tile.type == CONST.IRON:
		currentIronCountByLayer[tile.layer] = currentIronCountByLayer[tile.layer] - 1
	
	if tile.type == CONST.IRON or tile.type == CONST.SAND or tile.type == CONST.WATER or tile.type == CONSTARRC.DIAMOND:
		var goalRichness = tile.richness * Data.ofOr("resourcemodifiers.richness." + tile.type, 1.0)
		var drops = floor(goalRichness - 1 + (randi() % 3))
		if tile.type == CONST.IRON:
			if isFirstDrop:
				
				isFirstDrop = false
				drops = 2
		var newDelta = dropDeltas.get(tile.type, 0) + drops - goalRichness
		if newDelta >= 3:
			drops -= 1
			newDelta -= 1
		elif newDelta <= - 3:
			drops += 1
			newDelta += 1
		dropDeltas[tile.type] = newDelta
		
		if tile.type == CONST.SAND and drops < 3 and Level.loadout.modeId == CONST.MODE_RELICHUNT and Level.loadout.difficulty <= 0:
			
			var sandWithFloating = Data.of("inventory.sand") + Data.of("inventory.floatingsand")
			if Data.of("dome.health") < 350 - 60 * sandWithFloating:
				drops += 1
		if drops < 3 and Level.difficulty() * 0.1 < - randf():
			drops += 1
		
		if tile.type == CONSTARRC.DIAMOND:
			var diamondCap = CONSTARRC.MAXIMUM_DIAMONDS - CONSTARRC.MINIMUM_DIAMONDS + 1 # 1-3 gives 3
			var randNum = randi() % diamondCap # picks between 0 1 2 for 3
			drops = randNum + 1 # adds one to 0 1 2
		
		for _i in range(0, drops):
			var drop = Data.DROP_SCENES.get(tile.type).instance()
			drop.position = tile.global_position + 0.6 * Vector2(GameWorld.HALF_TILE_SIZE - randf() * GameWorld.TILE_SIZE, GameWorld.HALF_TILE_SIZE - randf() * GameWorld.TILE_SIZE)
			drop.apply_central_impulse(Vector2(0, 40).rotated(randf() * TAU))
			call_deferred("addDrop", drop)
			GameWorld.incrementRunStat("resources_mined")
	
	tiles.erase(tile.coord)
	for t in tilesByType.values():
		t.erase(tile)
	tilesByType.get(tile.type, {}).erase(tile)
	tile.queue_free()
	
	onTileRemoved(tile.coord)
