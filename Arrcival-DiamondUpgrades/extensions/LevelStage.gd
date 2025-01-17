extends "res://stages/level/LevelStage.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func startUpgradesInput(keeper:Keeper):
	var i = preload("res://stages/level/UpgradesInputProcessor.gd").new()
	i.deviceId = Keepers.getDeviceId(keeper.playerId)
	inputDeviceLimit = i.deviceId
	var techTreePopup = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/techtree/D_TechTreePopup.tscn").instantiate()
	techTreePopup.addPrefixMapping(keeper.techId, keeper.playerId)
	find_child("TechtreeContainer").add_child(techTreePopup)
	i.popup = techTreePopup
	i.connect("buyUpgrade", Callable(techTreePopup, "buyUpgrade"))
	i.connect("onStop", Callable(self, "set").bind("inputDeviceLimit", -1))
	i.integrate(self)
