extends "res://content/gadgets/teleporter/Teleporter.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _on_ResourceSucker_body_entered(body):
	._on_ResourceSucker_body_entered(body)
	if body.type == CONSTARRC.DIAMOND:
		resourcesInSucker.append(body)

func _on_ResourceSucker_body_exited(body):
	._on_ResourceSucker_body_exited(body)
	if body.type == CONSTARRC.DIAMOND:
		resourcesInSucker.erase(body)
