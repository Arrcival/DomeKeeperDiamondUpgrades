extends "res://content/gadgets/mineraltree/FruitGrowth.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func setType(type:String):
	match type:
		CONST.IRON:
			frame = -1 + int(name.substr(name.find("_") + 1))
			$Sprite2D.texture = preload("res://content/drop/iron/iron_smol.png")
			cyclesToGrow = 1
		CONST.WATER:
			frame = 2 + int(name.substr(name.find("_") + 1))
			$Sprite2D.texture = preload("res://content/drop/water/water_smol.png")
			cyclesToGrow = 2
		CONST.SAND:
			frame = 5 + int(name.substr(name.find("_") + 1))
			$Sprite2D.texture = preload("res://content/drop/sand/sand_smol.png")
			cyclesToGrow = 3
		CONSTARRC.DIAMOND:
			frame = 5 + int(name.substr(name.find("_") + 1))
			$Sprite2D.texture = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/diamond_small.png")
			cyclesToGrow = 3
	$Sprite2D.position = dropPositions[frame]
	if wasAutoDropped:
		cyclesToGrow -= 1
		wasAutoDropped = false
	remainingCycles = cyclesToGrow
	self.type = type
	visible = remainingCycles <= 0 and type != ""
	
	
