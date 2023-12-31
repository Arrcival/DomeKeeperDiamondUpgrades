extends Node

const MYMODNAME_MOD_DIR = "Arrcival-DiamondUpgrades/"
const MYMODNAME_LOG = "Arrcival-DiamondUpgrades"

const EXTENSIONS_DIR = "extensions/"

const PHOSPHO_MOD_ID = "Snek-Obel1sk"

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR
	
	# Add extensions
	loadExtension(ext_dir, "Achievements.gd")
	loadExtension(ext_dir, "ConverterPopup.gd")
	loadExtension(ext_dir, "DirtParticle.gd")
	loadExtension(ext_dir, "Dome.gd")
	loadExtension(ext_dir, "FruitGrowth.gd")
	loadExtension(ext_dir, "GameWorld.gd")
	loadExtension(ext_dir, "Inventory.gd")
	loadExtension(ext_dir, "Keeper1.gd")
	loadExtension(ext_dir, "Keeper2.gd")
	loadExtension(ext_dir, "LevelStage.gd")
	loadExtension(ext_dir, "Map.gd")
	loadExtension(ext_dir, "MineralTree.gd")
	loadExtension(ext_dir, "Pinball.gd")
	loadExtension(ext_dir, "ProbeImpulse.gd")
	loadExtension(ext_dir, "RelichuntPopup.gd")
	loadExtension(ext_dir, "Shredder.gd")
	loadExtension(ext_dir, "Sword.gd")
	loadExtension(ext_dir, "Tech2.gd")
	loadExtension(ext_dir, "TechTreePopup.gd")
	loadExtension(ext_dir, "Teleporter.gd")
	loadExtension(ext_dir, "Tile.gd")
	loadExtension(ext_dir, "TileDataGenerator.gd")
	loadExtension(ext_dir, "TransportDrone.gd")
	
	ModLoaderMod.add_translation(dir + "localization/diamond.en.translation")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	StageManager.connect("level_ready", self, "addProspectionMeterDiamondHud")
	diamondInit()
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)

func loadExtension(ext_dir, fileName):
	ModLoaderMod.install_script_extension(ext_dir + fileName)

func diamondInit():
	# Magic strings cause magic godot
	Data.DROP_ICONS["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/diamond_icon.png")
	Data.DROP_SCENES["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/DiamondDrop.tscn")

func addProspectionMeterDiamondHud(): 
	var hud = Level.hud.addHudElement({"hud": "mods-unpacked/Arrcival-DiamondUpgrades/content/gadgets/prospectionMeter/ProspectionMeterDiamond.tscn"})
	
func modInit():
	var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR + "yaml/"
	Data.parseUpgradesYaml(pathToModYaml + "upgrades2.yaml")
	phosphoMod()

func phosphoMod():
	if ModLoaderMod.is_mod_loaded(PHOSPHO_MOD_ID) and ModLoaderMod.get_mod_data(PHOSPHO_MOD_ID).is_active:
		var pathToModYaml : String = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR + "yaml/"
		Data.parseUpgradesYaml(pathToModYaml + "upgrades_phospho.yaml")
		print("Added phospho upgrades")
