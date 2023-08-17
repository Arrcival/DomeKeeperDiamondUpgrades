extends Node

const MYMODNAME_MOD_DIR = "Arrcival-DiamondUpgrades/"
const MYMODNAME_LOG = "Arrcival-DiamondUpgrades"

const EXTENSIONS_DIR = "extensions/"

func _init(modLoader = ModLoader):
	ModLoaderLog.info("init starting", MYMODNAME_LOG)
	var dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	var ext_dir = dir + EXTENSIONS_DIR
	
	ModLoaderMod.register_global_classes_from_array([{ "base": "Reference", "class": "CONSTARRC", "language": "GDScript", "path": dir + "ConstArrc.gd" }])
	
	# Add extensions
	ModLoaderMod.install_script_extension(ext_dir + "content/map/tile/DirtParticle.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/map/Map.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/map/generation/TileDataGenerator.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/map/tile/NewTile.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "content/dome/shredder/Shredder.gd")
	
	
	ModLoaderMod.install_script_extension(ext_dir + "content/techtree/TechTreePopup.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/techtree/Tech2.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "content/hud/inventory/Inventory.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "content/weapons/sword/Sword.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "content/keeper/keeper1/Keeper1.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/keeper/keeper2/Keeper2.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/keeper/keeper2/Pinball.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "content/gadgets/converter/ConverterPopup.gd")
	ModLoaderMod.install_script_extension(ext_dir + "content/gadgets/probe/ProbeImpulse.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "game/GameWorld.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "stages/level/LevelStage.gd")
	
	ModLoaderMod.install_script_extension(ext_dir + "Data.gd")
	
	ModLoaderMod.add_translation(dir + "localization/diamond.en.translation")
	
	ModLoaderLog.info("init done", MYMODNAME_LOG)

func _ready():
	ModLoaderLog.info("_ready starting", MYMODNAME_LOG)
	add_to_group("mod_init")
	StageManager.connect("level_ready", self, "addDiamondInventoryHud")
	StageManager.connect("level_ready", self, "addProspectionMeterDiamondHud")
	diamondInit()
	ModLoaderLog.info("_ready done", MYMODNAME_LOG)
	for k in Data.DROP_ICONS.keys():
		ModLoaderLog.info("icons : " + k, MYMODNAME_LOG)
	for k in Data.DROP_SCENES.keys():
		ModLoaderLog.info("scenes : " + k, MYMODNAME_LOG)

func diamondInit():
	# Magic strings cause magic godot
	Data.DROP_ICONS["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/diamond_icon.png")
	Data.DROP_SCENES["diamond"] = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/DiamondDrop.tscn")

func addDiamondInventoryHud(): # Breaks mod impacting the inventory HUD : to do, make an inventory element for diamonds (must be displayed with inventory)
	Level.hud.removeHudElement({"hud": "content/hud/inventory/Inventory.tscn"})
	var hud = Level.hud.addHudElement({"hud": "mods-unpacked/Arrcival-DiamondUpgrades/content/hud/inventory/Inventory.tscn"})
	
func addProspectionMeterDiamondHud(): 
	var hud = Level.hud.addHudElement({"hud": "mods-unpacked/Arrcival-DiamondUpgrades/content/gadgets/prospectionMeter/ProspectionMeterDiamond.tscn"})
	pass
	
func modInit():
	pass
