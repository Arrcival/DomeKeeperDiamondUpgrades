extends Object

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func get_mineable_tile_coords(chain: ModLoaderHookChain) -> Array:
	var coords = chain.execute_next()
	var main_node : Node = chain.reference_object
	coords.append_array(main_node.get_resource_cells_by_id(CONSTARRC.TILE_DIAMOND))
	return coords
