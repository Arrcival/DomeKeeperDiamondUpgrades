extends "res://game/GameWorld.gd"

var diamondTilesPerLayer = 3

func prepareCleanData():
	super.prepareCleanData()
	Data.apply("inventory.diamond", 0)
	Data.apply("inventory.floatingDiamond", 0)
	Data.apply("inventory.totalDiamond", 0)

