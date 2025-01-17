extends "res://content/hud/inventory/Inventory.gd"

var labelDiamond: Label

var diamondAmount = 0

func init():
	super.init()
	Data.listen(self, "inventory.diamond", true)
	

func _ready():
	super._ready()
	element_size.y += 2
	
	var gridContainer = find_child("GridContainer")
	
	var textureRect = TextureRect.new()
	textureRect.texture = load("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/diamond_icon.png")
	Style.init(textureRect)
	# add texture and size
	labelDiamond = Label.new()
	labelDiamond.name = "LabelDiamond"
	labelDiamond.text = "0"
	labelDiamond.label_settings = load("res://gui/fontsettings/HudPixelartMonospacedFontSettings.tres")
	
	gridContainer.add_child(textureRect)
	gridContainer.add_child(labelDiamond)
	

func propertyChanged(property:String, oldValue, newValue):
	super.propertyChanged(property, oldValue, newValue)
	match property:
		"inventory.diamond":
			diamondAmount = newValue
			updateSize()
			labelDiamond.text = str(newValue)
			
func updateSize():
	super.updateSize()
	var limit := 0
	for v in cache:
		limit = max(v, limit)
	limit = max(limit, diamondAmount)
	if limit >= 100 and element_size.x != 5:
		element_size.x = 5
		%LabelIron.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		%LabelWater.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		%LabelSand.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		labelDiamond.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		request_rebuild.emit()
	elif limit < 100 and element_size.x != 4:
		element_size.x = 4
		%LabelIron.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		%LabelWater.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		%LabelSand.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		labelDiamond.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		request_rebuild.emit()
