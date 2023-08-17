extends "res://systems/data/Data.gd"

func _ready():
	
	gameProperties = {}
	parsePropertiesYaml("res://properties.yaml")
	
	
	upgrades = {}
	gadgets = {}
	
	# TODO : find a less hacky way to do this as it currently override the whole yaml upgrades
	parseUpgradesYaml("res://mods-unpacked/Arrcival-DiamondUpgrades/yaml/upgrades.yaml")
