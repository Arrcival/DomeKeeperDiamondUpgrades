extends "res://content/gadgets/teleporter/Teleporter.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func canTeleportDrop(body):
	return body.type == CONST.IRON \
	or body.type == CONST.WATER \
	or body.type == CONST.SAND \
	or body.type == CONSTARRC.DIAMOND \
	or body.type == "pack"
