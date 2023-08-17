extends "res://content/gadgets/probe/ProbeImpulse.gd"

func _ready():
	$Particles2D.process_material = $Particles2D.process_material.duplicate()
	
	$ProbeSound.play()
	
	$Particles2D.emitting = true
	$Particles2D.amount = Data.of("probe.range") * log(Data.of("probe.range")) * 10
	var pm = $Particles2D.process_material as ParticlesMaterial
	var start = 5
	var end = (Data.of("probe.range") + 1) * GameWorld.TILE_SIZE
	var probe_time = end / float(Data.of("probe.impulseSpeed"))
	
	var fade_start = Color(1, 1, 1, 1)
	var fade_end = Color(1, 1, 1, 0)
	
	$Tween.interpolate_property(pm, "emission_ring_radius", start, end, probe_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(pm, "emission_ring_inner_radius", start * 0.5, end * 0.9, probe_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Particles2D, "modulate", fade_start, fade_end, probe_time, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.start()
	
	
	var center = Level.map.getTileCoord(position)
	var radius = Data.of("probe.range")
	var detectCaves = Data.of("probe.detectcaves")
	var detectDiamond = Data.of("probe.detectdiamonds")
	var detectChambers = Data.of("probe.detectchambers")
	for x in range( - radius, radius + 1):
		for y in range( - radius, radius + 1):
			var coord = center + Vector2(x, y)
			var marker_position = Level.map.getTilePos(coord) + Level.map.borderSpriteOffset
			if position.distance_to(marker_position) > (radius + 0.6) * GameWorld.TILE_SIZE:
				continue
			
			var t = Level.map.tileData().get_resource(coord.x, coord.y)
			if (Level.map.isResourceTile(t) or (detectDiamond and t == CONSTARRC.TILE_DIAMOND) or  (detectCaves and t == Data.TILE_CAVE) or (detectChambers and t == Data.TILE_GADGET)) and not Level.map.isRevealed(coord):
				var alreadyMarked: = false
				for m in get_tree().get_nodes_in_group("probe_markers"):
					if m.tileCoord == coord:
						alreadyMarked = true
						m.refresh()
						break
				if not alreadyMarked:
					var marker = ProbeMarker.instance()
					marker.tileCoord = coord
					marker.sound = $EchoSound.duplicate()
					match t:
						Data.TILE_IRON:marker.sound.pitch_scale = 1.69
						Data.TILE_SAND:marker.sound.pitch_scale = 2.52
						Data.TILE_WATER:marker.sound.pitch_scale = 1.98
						Data.TILE_CAVE:
							marker.sound.pitch_scale = 1.1
							marker.sound.volume_db -= 4.0
						Data.TILE_GADGET:
							marker.sound.pitch_scale = 1.1
							marker.sound.volume_db -= 4.0
					marker.add_child(marker.sound)
					marker.center = position
					marker.position = marker_position
					Level.map.addTileOverlay(marker)
	
	Style.init(self)
