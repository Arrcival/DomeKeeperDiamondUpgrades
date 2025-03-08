extends "res://content/gadgets/teleporter/Teleporter.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func canTeleportDrop(body):
	if body.type == CONSTARRC.DIAMOND:
		return true
	super.canTeleportDrop(body)
