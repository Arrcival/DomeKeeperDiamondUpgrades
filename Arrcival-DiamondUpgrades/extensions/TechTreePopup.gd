extends "res://content/techtree/TechTreePopup.gd"

func _ready():
	var gridContainer: GridContainer = find_child("GridContainer")
	var textureRect = TextureRect.new()
	#textureRect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	textureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	textureRect.size_flags_horizontal = Control.SIZE_EXPAND
	textureRect.size_flags_vertical = Control.SIZE_EXPAND
	textureRect.texture = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/drop/diamond/diamond_small.png")
	textureRect.custom_minimum_size = Vector2i(24, 34)
	var labelDiamond = Label.new()
	labelDiamond.text = "0"
	labelDiamond.name = "LabelDiamond"
	labelDiamond.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	var labelDiamondCost = Label.new()
	labelDiamondCost.text = "0"
	labelDiamondCost.name = "LabelDiamondCost"
	labelDiamondCost.label_settings = find_child("LabelIronCost")
	labelDiamondCost.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	gridContainer.add_child(textureRect)
	gridContainer.add_child(labelDiamond)
	gridContainer.add_child(labelDiamondCost)
	
	textureRect.owner = gridContainer
	labelDiamond.owner = gridContainer
	labelDiamondCost.owner = gridContainer
	
	labelDiamondCost.label_settings = find_child("LabelIronCost").label_settings.duplicate()
	
	defaultFontColor = %LabelIronCost.label_settings.font_color
	find_child("LabelDiamond", true, false).text = str(Data.getInventory("diamond"))
	Data.listen(self, "inventory.diamond")
	super._ready()

func propertyChanged(property:String, oldValue, newValue):
	match property:
		"inventory.diamond":
			find_child("LabelDiamond").text = str(clamp(newValue, 0, 999))
			return
	super.propertyChanged(property, oldValue, newValue)

func moveOut():
	if not isIn:
		return 
	Data.unlisten(self, "inventory.diamond")
	super.moveOut()

func updateCostLabels():
	find_child("LabelDiamondCost", true, false).text = ""
	super.updateCostLabels()
