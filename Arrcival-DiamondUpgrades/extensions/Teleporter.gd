extends "res://content/gadgets/teleporter/Teleporter.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func canTeleportDrop(body) -> bool:
	if body.type == CONSTARRC.DIAMOND:
		return true
	return super.canTeleportDrop(body)
