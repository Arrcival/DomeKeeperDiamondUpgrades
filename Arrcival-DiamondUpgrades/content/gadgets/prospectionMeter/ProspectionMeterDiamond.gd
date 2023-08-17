extends HudElement

var unlockedMeters: = []
var tilesToScan: = {}
var cooldown: = 0.0

var meterSpots: = [3, 10, 17, 24]

func init():
	visible = false
	$Diamond.visible = false
	Data.listen(self, "prospectionmeter.diamond", true)

func propertyChanged(property:String, oldValue, newValue):
	match property:
		"prospectionmeter.diamond":
			if newValue == 1:
				visible = true
				unlockedMeters.append(CONSTARRC.DIAMOND)
				$Diamond.visible = true
				tilesToScan[CONSTARRC.TILE_DIAMOND] = []
	updateSize()

func updateSize():
	var i: = 0
	for m in get_children():
		if m is Control and m.visible:
			m.rect_position.y = meterSpots[i]
			i += 1
			
	size.y = 1 + i
	emit_signal("request_rebuild")

func _process(delta:float)->void :
	if cooldown > 0.0:
		cooldown -= delta
		return 
	
	if visible:
		cooldown = Data.of("prospectionMeter.scandelay")
		for r in tilesToScan:
			tilesToScan[r].clear()
		var radius:int = Data.of("prospectionMeter.range")
		var keeperCoord = Level.map.getTileCoord(Level.keeper.global_position)
		for x in range( - radius, radius + 1):
			for y in range( - radius, radius + 1):
				if abs(x) + abs(y) > radius:
					continue
				var res = Level.map.tileData().get_resource(keeperCoord.x + x, keeperCoord.y + y)
				if tilesToScan.has(res):
					var tileOffset = Vector2(x, y)
					tilesToScan[res].append(tileOffset)
		
		for res in tilesToScan:
			var best = null
			var dist = 9999999
			for tileOffset in tilesToScan[res]:
				var d = tileOffset.length()
				if d < dist:
					dist = d
					best = tileOffset
			
			var type = Map.TYPE_MAP.get(res)
			var meter = find_node(type.capitalize() + "Meter")
			if best:
				if meter.goalFilling == 0.0:
					$DetectSound.play()
				var floatDist = Level.map.getTilePos(keeperCoord + best) - Level.keeper.global_position
				meter.goalFilling = 1.0 - clamp((floatDist.length() - GameWorld.TILE_SIZE) / float(radius * GameWorld.TILE_SIZE), 0.0, 1.0)
			else :
				meter.goalFilling = 0.0
