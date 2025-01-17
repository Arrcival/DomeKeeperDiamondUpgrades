extends "res://content/dome/Dome.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func getDropTarget(dropType: String):
	if dropType == CONSTARRC.DIAMOND:
		return $Shredder
	return super.getDropTarget(dropType)
