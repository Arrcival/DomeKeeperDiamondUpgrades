extends "res://content/gadgets/transportdrone/TransportDrone.gd"


const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func setCarriedResource(res:String):
	.setCarriedResource(res)
	if res == CONSTARRC.DIAMOND:
		$CarriedResource.texture = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/diamond_small.png")
		$Sprite.play("idle")
		$PickupSound.play()
