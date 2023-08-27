extends "res://game/GameWorld.gd"

var diamondTilesPerLayer = 2

func prepareCleanData():
	.prepareCleanData()
	Data.apply("inventory.diamond", 0)
	Data.apply("inventory.floatingDiamond", 0)
	Data.apply("inventory.totalDiamond", 0)
