extends "res://stages/level/LevelStage.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func startUpgradesInput(keeper:Keeper):
	var i = preload("res://stages/level/UpgradesInputProcessor.gd").new()
	i.stopNamed = "UpgradesInputProcessor,BattleInputProcessor"
	var techTree = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/techtree/TechTreePopup.tscn").instance()
	find_node("TechtreeContainer").add_child(techTree)
	i.popup = techTree
	i.connect("buyUpgrade", techTree, "buyUpgrade")
	i.integrate(self)

func landDome():
	.landDome()
	if ModLoaderMod.is_mod_loaded(CONSTARRC.PHOSPHO_MOD_ID) and ModLoaderMod.get_mod_data(CONSTARRC.PHOSPHO_MOD_ID).is_active:
		var domeId = GameWorld.loadoutStageConfig.domeId
		if domeId == "domeobel1sk":
			var dome = Level.dome
			var shredder = Level.dome.get_node("Shredder")
			shredder.set_script(load("res://content/dome/shredder/Shredder.gd"))
			print("Shredder found and overloaded!")
