extends "res://stages/loadout/RelichuntPopup.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _ready():
	var nodeContainer = HBoxContainer.new()
	
	var nodeText = Label.new()
	nodeText.text = "Diamond tiles per layer"
	var nodeEdit = OptionButton.new()
	nodeEdit.align = Button.ALIGN_CENTER
	nodeContainer.add_child(nodeText)
	nodeContainer.add_child(nodeEdit)
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5/ModifiersBox/MarginContainer/Box.add_child(nodeContainer)
	Style.init(self)

func init():
	.init()
	var container = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5/ModifiersBox/MarginContainer/Box.get_child(3)
	var optionButton = container.get_child(1)
	optionButton.clear()
	optionButton.add_item("Default (" + str(CONSTARRC.DEFAULT_DIAMONDS_PER_LAYER) + ")")
	for i in range(1,11):
		optionButton.add_item(str(i))

func onClose():
	.onClose()
	var container = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5/ModifiersBox/MarginContainer/Box.get_child(3)
	var optionButton = container.get_child(1)
	
	var diamonds = CONSTARRC.DEFAULT_DIAMONDS_PER_LAYER
	if optionButton.get_selected_id() > 0:
		diamonds = int(optionButton.get_item_text(optionButton.get_selected_id()))
	GameWorld.diamondTilesPerLayer = diamonds
	print("Diamonds to add : " + str(diamonds))
