extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")
enum State {WAIT, PICKUP, WAIT_FOR_PATH_HOME, RETRIEVE}

func setCarriedResource(chain: ModLoaderHookChain, res: String):
	if res == CONSTARRC.DIAMOND:
		var main_node : Node = chain.reference_object
		main_node.carriedResource = res
		main_node.get_node("CarriedResource").texture = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/diamond_small.png")
		main_node.get_node("Sprite").play("idle")
		main_node.get_node("SpriteOverlay").visible = true
		main_node.get_node("SpriteOverlay").play("carry_idle")
		main_node.get_node("PickupSound").play()
		return
	chain.execute_next([res])


# dirty until Dome.gd is vanilla fixed just for Level.dome.getDropTarget hooks
func _process(chain: ModLoaderHookChain, delta):
	if GameWorld.paused:
		return
	
	var main_node : Node = chain.reference_object
	if main_node.cooldown > 0.0:
		main_node.cooldown -= delta
		return
	
	match int(main_node.state):
		State.WAIT:
			# wait until Drone Hub assigns a drop
			main_node.find_child("MoveAmb").stop()
			main_node.find_child("Sprite").play("idle")
			main_node.find_child("Sprite").speed_scale = main_node.speedMod
		State.PICKUP:
			if not TransportDrone.canTransport(main_node.targettedDrop):
				main_node.targettedDrop = null
				main_node.state = State.WAIT
				return
			
			if not main_node.find_child("MoveAmb").playing:
				main_node.find_child("MoveAmb").play()
			
			if main_node.followPath(delta):
				var move:Vector2 = main_node.targettedDrop.global_position - main_node.find_child("PickupSpot").global_position
				if move.length() >= 2 * GameWorld.TILE_SIZE or not is_instance_valid(main_node.targettedDrop):
					main_node.targettedDrop = null
					main_node.state = State.WAIT
					return
				
				#drop was deleted, potentially because it was picked up by another node
				if not main_node.targettedDrop.get_parent():
					main_node.targettedDrop = null
					main_node.state = State.WAIT
					return
					
				if move.length() < 1.0:
					if main_node.targettedDrop.type == "pack": 
						for drop in main_node.targettedDrop.get_children():
							if "@Sprite2D" in drop.name:
								var dropContent = []
								dropContent.append(drop.get_meta("dropType"))
								dropContent.append(drop.position.x)
								dropContent.append(drop.position.y)
								main_node.packedDropContent.append(dropContent)
						main_node.targettedDrop.get_parent().remove_child(main_node.targettedDrop)
					else:
						main_node.targettedDrop.remove()
					
					var dropTarget
					if main_node.targettedDrop.type == CONSTARRC.DIAMOND:
						dropTarget = Level.dome.find_child("Shredder")
					else:
						dropTarget = Level.dome.getDropTarget(main_node.targettedDrop.type)
					main_node.targetSpot = dropTarget.dropTarget()
					main_node.setCarriedResource(main_node.targettedDrop.type)
					main_node.state = State.WAIT_FOR_PATH_HOME
					
					var wakeup_call := preload("res://content/map/tile/RigidBodyWakeupCall.tscn").instantiate()
					wakeup_call.position = main_node.position
					main_node.get_parent().add_child(wakeup_call)
				else:
					main_node.move(move.normalized(), main_node.baseSpeed * 0.5 * main_node.speedMod, delta)
		State.RETRIEVE:
			if not main_node.find_child("MoveAmb").playing:
				main_node.find_child("MoveAmb").play()
			
			if main_node.followPath(delta):
				main_node.find_child("Sprite").play("idle")
				var d = main_node.targetSpot - main_node.global_position
				if d.length() < 1.0:
					if main_node.carriedResource == CONST.PACK:
						for drop in main_node.packedDropContent:
							Data.changeByInt("inventory."+drop[0], 1)
						main_node.packedDropContent.clear()
						for child in main_node.find_child("CarriedResource").get_children(): 
							child.queue_free()
					else:
						Data.changeByInt("inventory."+main_node.carriedResource, 1)
					main_node.setCarriedResource("")
					main_node.state = State.WAIT
					main_node.find_child("Sprite").speed_scale = main_node.speedMod
				else:
					main_node.move(d.normalized(), main_node.baseSpeed * main_node.speedMod, delta)
		State.WAIT_FOR_PATH_HOME:
			# drone hub should assign new path back home
			main_node.find_child("Sprite").play("idle")
			main_node.find_child("Sprite").speed_scale = main_node.speedMod
			main_node.emit_signal("request_path_home")
			main_node.cooldown = 0.5
			main_node.find_child("MoveAmb").stop()
