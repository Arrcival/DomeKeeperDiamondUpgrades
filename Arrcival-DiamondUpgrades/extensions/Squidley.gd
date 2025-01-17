extends "res://content/gadgets/droneyard/Squidley.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func setCarriedResource(res:String):
	if res == CONSTARRC.DIAMOND:
		$CarriedResource.texture = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/diamond_small.png")
		$Sprite2D.play("idle")
		$PickupSound.play()
	super.setCarriedResource(res)

# Same thing than TransportDrone hook
func _process(delta):
	if GameWorld.paused:
		return
	
	if cooldown > 0.0:
		cooldown -= delta
		return
	
	match int(state):
		State.WAIT:
			# wait until Drone Hub assigns a drop
			$MoveAmb.stop()
			$Sprite2D.play("idle")
			$Sprite2D.speed_scale = speedMod
		State.PICKUP:
			if not TransportDrone.canTransport(targettedDrop):
				targettedDrop = null
				state = State.WAIT
				return
			
			if not $MoveAmb.playing:
				
				$MoveAmb.play()
			
			if followPath(delta):
				$Sprite2D.play("idle")
				var move:Vector2 = targettedDrop.global_position - $PickupSpot.global_position
				if move.length() >= 2 * GameWorld.TILE_SIZE or not is_instance_valid(targettedDrop):
					targettedDrop = null
					state = State.WAIT
					return
					
				#drop was deleted, potentially because it was picked up by another node
				if not targettedDrop.get_parent():
					targettedDrop = null
					state = State.WAIT
					return
					
				if move.length() < 1.0:
					if targettedDrop.type == "pack": 
						for drop in targettedDrop.get_children():
							if "@Sprite2D" in drop.name:
								var dropContent = []
								dropContent.append(drop.get_meta("dropType"))
								dropContent.append(drop.position.x)
								dropContent.append(drop.position.y)
								packedDropContent.append(dropContent)
						targettedDrop.get_parent().remove_child(targettedDrop)
					else:
						targettedDrop.remove()
					var dropTarget
					if targettedDrop.type == CONSTARRC.DIAMOND:
						dropTarget = Level.dome.find_child("Shredder")
					else:
						dropTarget = Level.dome.getDropTarget(targettedDrop.type)
					targetSpot = dropTarget.dropTarget()
					setCarriedResource(targettedDrop.type)
					state = State.WAIT_FOR_PATH_HOME
					emit_signal("request_path_home")
					$Sprite2D.speed_scale = speedMod
					
					var wakeup_call := preload("res://content/map/tile/RigidBodyWakeupCall.tscn").instantiate()
					wakeup_call.position = position
					get_parent().add_child(wakeup_call)
				else:
					move(move.normalized(), baseSpeed * 0.5 * speedMod, delta)
		State.RETRIEVE:
			if not $MoveAmb.playing:
				$MoveAmb.play()
			
			if followPath(delta):
				$Sprite2D.play("idle")
				var d = targetSpot - global_position
				if d.length() < 1.0:
					if carriedResource == CONST.PACK:
						for drop in packedDropContent:
							Data.changeByInt("inventory."+drop[0], 1)
						packedDropContent.clear()
						for child in $CarriedResource.get_children(): 
							child.queue_free()
					else:
						Data.changeByInt("inventory."+carriedResource, 1)
					setCarriedResource("")
					state = State.WAIT
					deliveredResources += 1
					baseSpeed = min(45 + deliveredResources * 2, 240)
					$Sprite2D.speed_scale = speedMod
				else:
					move(d.normalized(), baseSpeed * speedMod, delta)
		State.WAIT_FOR_PATH_HOME:
			# drone hub should assign new path back home
			$Sprite2D.play("idle")
			$Sprite2D.speed_scale = speedMod
			emit_signal("request_path_home")
			cooldown = 0.5
			$MoveAmb.stop()
