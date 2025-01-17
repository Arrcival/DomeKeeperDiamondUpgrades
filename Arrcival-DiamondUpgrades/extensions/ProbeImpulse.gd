extends "res://content/gadgets/probe/ProbeImpulse.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _ready():
	$GPUParticles2D.process_material = $GPUParticles2D.process_material.duplicate()
	# Ping
	$ProbeSound.play()
	
	$GPUParticles2D.emitting = true
	$GPUParticles2D.amount = Data.of("probe.range") * log(Data.of("probe.range")) * 10
	var pm = $GPUParticles2D.process_material as ParticleProcessMaterial
	var start = 5 # px
	var end = (Data.of("probe.range")+1) * GameWorld.TILE_SIZE # px
	var probe_time = end / float(Data.of("probe.impulseSpeed"))
	
	var fade_start = Color(1,1,1,1)
	var fade_end = Color(1,1,1,0)
	
	$Tween.interpolate_property(pm, "emission_ring_radius", start, end, probe_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(pm, "emission_ring_inner_radius", start*0.5, end*0.9, probe_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($GPUParticles2D, "modulate", fade_start, fade_end, probe_time, Tween.TRANS_QUART, Tween.EASE_IN)
	
	# Find all on screen resources and mark them
	var center = Level.map.getTileCoord(position)
	var radius = Data.of("probe.range")
	var detectChambers = Data.of("probe.detectchambers")
	var detectDiamond = Data.of("probe.detectdiamonds")
	var impulseSpeed = Data.of("probe.impulseSpeed")
	var permanentrevealresources = Data.of("probe.permanentrevealresources")
	var permanentrevealrock = Data.of("probe.permanentrevealrock")
	for x in range(-radius, radius+1):
		for y in range(-radius, radius+1):
			var coord = Vector2(center) + Vector2(x, y)
			var marker_position = Level.map.getTilePos(coord) 
			if position.distance_to(marker_position) > (radius+0.6) * GameWorld.TILE_SIZE:
				continue
			
			var t = Level.map.getTileData().get_resource(coord.x, coord.y)
			var isResourceTile = Level.map.isResourceTile(t)
			if Level.map.isCaveTile(coord):
				continue
				
			if permanentrevealrock or (permanentrevealresources and isResourceTile):
				var distance = position.distance_to(marker_position)
				if distance > 0.0:
					# this is the case when it's not a savegame being loaded
					var delay = distance / impulseSpeed
					# revealTileVisual for rocks, but without it we just get pings on resources, so we also call revealTile on top of it for everything that isn't a barren rock
					$Tween.interpolate_callback(Level.map, delay, "revealTile", coord)
					$Tween.interpolate_callback(Level.map, delay, "revealTileVisually", coord)
			
			var chamberDetected = detectChambers and \
			(t == Data.TILE_GADGET or t == Data.TILE_SUPPLEMENT or t == Data.TILE_RELIC or t == Data.TILE_RELIC_SWITCH)
			if (isResourceTile or chamberDetected) and not Level.map.isRevealed(coord):
				var alreadyMarked := false
				for m in get_tree().get_nodes_in_group("probe_markers"):
					if m.tileCoord == coord:
						alreadyMarked = true
						m.refresh()
						break
				if not alreadyMarked:
					var marker = ProbeMarker.instantiate()
					marker.tileCoord = coord
					marker.sound = $EchoSound.duplicate()
					match t:
						Data.TILE_IRON: marker.sound.pitch_scale = 1.69
						Data.TILE_SAND: marker.sound.pitch_scale = 2.52
						Data.TILE_WATER: marker.sound.pitch_scale = 1.98
						CONSTARRC.TILE_DIAMOND: marker.sound.pitch_scale = 2.7
						Data.TILE_CAVE: 
							marker.sound.pitch_scale = 1.1
							marker.sound.volume_db -= 4.0
						Data.TILE_GADGET: 
							marker.sound.pitch_scale = 1.1
							marker.sound.volume_db -= 4.0
					marker.add_child(marker.sound)
					marker.center = position
					marker.position = marker_position
					Level.map.addTileOverlayEffect(marker)
	$Tween.start()
	
	Style.init(self)
	
