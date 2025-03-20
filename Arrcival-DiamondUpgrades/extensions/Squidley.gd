extends "res://content/gadgets/droneyard/Squidley.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func setCarriedResource(res:String):
	if res == CONSTARRC.DIAMOND:
		$CarriedResource.texture = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/diamond_small.png")
		$Sprite2D.play("idle")
		$PickupSound.play()
	super.setCarriedResource(res)
