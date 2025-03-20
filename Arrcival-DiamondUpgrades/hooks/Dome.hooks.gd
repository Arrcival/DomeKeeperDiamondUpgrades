extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func getDropTarget(chain: ModLoaderHookChain, dropType:String):
	var main_node : Node = chain.reference_object

	if dropType == CONSTARRC.DIAMOND:
		return main_node.find_child("Shredder")
	
	return chain.execute_next([dropType])

