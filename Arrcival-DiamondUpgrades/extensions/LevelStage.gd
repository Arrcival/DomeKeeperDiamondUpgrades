extends "res://stages/level/LevelStage.gd"

func startUpgradesInput(keeper:Keeper):
	var i = preload("res://stages/level/UpgradesInputProcessor.gd").new()
	i.stopNamed = "UpgradesInputProcessor,BattleInputProcessor"
	var techTree = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/techtree/TechTreePopup.tscn").instance()
	find_node("TechtreeContainer").add_child(techTree)
	i.popup = techTree
	i.connect("buyUpgrade", techTree, "buyUpgrade")
	i.integrate(self)
