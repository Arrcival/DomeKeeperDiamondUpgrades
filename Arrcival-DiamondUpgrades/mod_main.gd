extends Node

const MYMODNAME_MOD_DIR = "Arrcival-DiamondUpgrades/"
const MYMODNAME_LOG = "Arrcival-DiamondUpgrades"

const EXTENSIONS_DIR = "extensions/"
const HOOKS_DIR = "hooks/"

const PHOSPHO_MOD_ID = "Snek-Obel1sk"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR
	var hooks_dir = dir + HOOKS_DIR
	
	# Add extensions
	loadExtension(ext_dir, "AssignmentChoice.gd")
	loadExtension(ext_dir, "ConverterPopup.gd")
	loadExtension(ext_dir, "DirtParticle.gd")
	loadExtension(ext_dir, "FruitGrowth.gd")
	loadExtension(ext_dir, "GameWorld.gd")
	loadExtension(ext_dir, "Inventory.gd")
	loadExtension(ext_dir, "Keeper1.gd")
	loadExtension(ext_dir, "Keeper2.gd")
	loadExtension(ext_dir, "MineralTree.gd")
	loadExtension(ext_dir, "MiningSummary.gd")
	loadExtension(ext_dir, "Pinball.gd")
	loadExtension(ext_dir, "ProbeImpulse.gd")
	loadExtension(ext_dir, "ResourcePackerEffect.gd")
	loadExtension(ext_dir, "SaveGame.gd")
	loadExtension(ext_dir, "Shredder.gd")
	loadExtension(ext_dir, "Squidley.gd")
	loadExtension(ext_dir, "StageManager.gd")
	loadExtension(ext_dir, "Sword.gd")
	loadExtension(ext_dir, "Tech2.gd")
	loadExtension(ext_dir, "TechTreePopup.gd")
	loadExtension(ext_dir, "Teleporter.gd")
	loadExtension(ext_dir, "TileDataGenerator.gd")
	
	ModLoaderMod.add_translation(dir + "localization/diamond.en.translation")
	
	#loadHook("res://systems/achievements/Achievements.gd", hooks_dir, "Achievements.hooks.gd")
	#loadHook("res://content/dome/Dome.gd", hooks_dir, "Dome.hooks.gd") # Dome.gd can't be hooked -> bug vanilla
	loadHook("res://content/map/Map.gd", hooks_dir, "Map.hooks.gd")
	loadHook("res://content/map/MapData.gd", hooks_dir, "MapData.hooks.gd")
	#loadHook("res://stages/loadout/MultiplayerloadoutStage.gd", hooks_dir, "MultiplayerloadoutStage.hooks.gd")
	loadHook("res://content/map/tile/Tile.gd", hooks_dir, "Tile.hooks.gd")
	loadHook("res://content/gadgets/droneyard/TransportDrone.gd", hooks_dir, "TransportDrone.hooks.gd")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	diamondInit()
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)

func loadExtension(ext_dir, fileName):
	ModLoaderMod.install_script_extension(ext_dir + fileName)

func loadHook(vanilla_class, hooks_dir, fileName):
	ModLoaderMod.install_script_hooks(vanilla_class, hooks_dir + fileName)

func diamondInit():
	# Magic strings cause magic godot
	Data.DROP_ICONS["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/diamond_icon.png")
	Data.DROP_SCENES["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/DiamondDrop.tscn")

func modInit():
	var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR + "yaml/"
	Data.parseUpgradesYaml(pathToModYaml + "diamond_upgrades.yaml")
