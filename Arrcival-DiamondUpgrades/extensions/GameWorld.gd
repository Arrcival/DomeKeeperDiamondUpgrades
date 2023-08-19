extends "res://game/GameWorld.gd"

func prepareCleanData():
	.prepareCleanData()
	Data.apply("inventory.diamond", 0)
	Data.apply("inventory.floatingDiamond", 0)
	Data.apply("inventory.totalDiamond", 0)
