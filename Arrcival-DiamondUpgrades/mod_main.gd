extends Node

const MYMODNAME_MOD_DIR = "Arrcival-DiamondUpgrades/"
const MYMODNAME_LOG = "Arrcival-DiamondUpgrades"

const EXTENSIONS_DIR = "extensions/"

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR
	
	# Add extensions
	loadExtension(ext_dir, "ConverterPopup.gd")
	loadExtension(ext_dir, "Data.gd")
	loadExtension(ext_dir, "DirtParticle.gd")
	loadExtension(ext_dir, "GameWorld.gd")
	loadExtension(ext_dir, "Inventory.gd")
	loadExtension(ext_dir, "Keeper1.gd")
	loadExtension(ext_dir, "Keeper2.gd")
	loadExtension(ext_dir, "LevelStage.gd")
	loadExtension(ext_dir, "Map.gd")
	loadExtension(ext_dir, "Pinball.gd")
	loadExtension(ext_dir, "ProbeImpulse.gd")
	loadExtension(ext_dir, "Shredder.gd")
	loadExtension(ext_dir, "Sword.gd")
	loadExtension(ext_dir, "Tech2.gd")
	loadExtension(ext_dir, "TechTreePopup.gd")
	loadExtension(ext_dir, "Tile.gd")
	loadExtension(ext_dir, "TileDataGenerator.gd")
	
	ModLoaderMod.add_translation(dir + "localization/diamond.en.translation")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	StageManager.connect("level_ready", self, "addProspectionMeterDiamondHud")
	diamondInit()
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)
	for k in Data.DROP_ICONS.keys():
		ModLoaderLog.info("icons : " + k, MYMODNAME_LOG)
	for k in Data.DROP_SCENES.keys():
		ModLoaderLog.info("scenes : " + k, MYMODNAME_LOG)

func loadExtension(ext_dir, fileName):
	ModLoaderMod.install_script_extension(ext_dir + fileName)

func diamondInit():
	# Magic strings cause magic godot
	Data.DROP_ICONS["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/diamond_icon.png")
	Data.DROP_SCENES["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/DiamondDrop.tscn")

func addProspectionMeterDiamondHud(): 
	var hud = Level.hud.addHudElement({"hud": "mods-unpacked/Arrcival-DiamondUpgrades/content/gadgets/prospectionMeter/ProspectionMeterDiamond.tscn"})
	pass
	
func modInit():
	pass
