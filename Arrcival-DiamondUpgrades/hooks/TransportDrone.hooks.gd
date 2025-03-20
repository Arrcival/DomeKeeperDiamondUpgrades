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
