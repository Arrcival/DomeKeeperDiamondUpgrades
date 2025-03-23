extends "res://stages/manager/StageManager.gd"
 
var buttons: Array = []

func _startNewStage():
	super._startNewStage()
	
	var loadoutStage = get_node("CurrentStage/MultiplayerLoadoutStage")
	
	if not loadoutStage:
		return

	var ui_node: Node = loadoutStage.find_child("GameModeMarginContainer").find_child("VBoxContainer")
	
	var diamondVBox = VBoxContainer.new()
	var labelTitle = Label.new()
	labelTitle.label_settings = load("res://gui/fontsettings/LargeFontSettings.tres")
	labelTitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	labelTitle.text = "Diamond tiles per layer"
	diamondVBox.add_child(labelTitle)
	
	var buttonsContainer = HBoxContainer.new()
	
	buttons.clear()
	for i in range(1, 6):
		var e = preload("res://stages/loadout/LoadoutChoice.tscn").instantiate()
		e.setChoice(str(i), "diamond_amount_" + str(i), null)
		if i == GameWorld.diamondTilesPerLayer:
			e.selected = true
		e.select.connect(set_diamonds_amount.bind(i))
		buttonsContainer.add_child(e)
		Style.init(e)
		buttons.append(e)
	diamondVBox.add_child(buttonsContainer)
	buttonsContainer = HBoxContainer.new()
	for i in range(6, 11):
		var e = preload("res://stages/loadout/LoadoutChoice.tscn").instantiate()
		e.setChoice(str(i), "diamond_amount_" + str(i), null)
		if i == GameWorld.diamondTilesPerLayer:
			e.selected = true
		e.select.connect(set_diamonds_amount.bind(i))
		buttonsContainer.add_child(e)
		Style.init(e)
		buttons.append(e)
	diamondVBox.add_child(buttonsContainer)
	diamondVBox.name = "DiamondSettings"
	ui_node.add_child(diamondVBox)
	Style.init(diamondVBox)


func set_diamonds_amount(amount: int) -> void:
	GameWorld.diamondTilesPerLayer = amount
	for i in range(len(buttons)):
		buttons[i].selected = (i == amount - 1)
