extends "res://content/techtree/Tech2.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func build(id:String, tier := -1):
	if !(id.begins_with("diamond") or id.begins_with("player1.diamond")):
		return super.build(id, tier)

	self.techId = id
	var data = GameWorld.upgrades.get(id)
	visualTechId = data.get("shadowing", techId)
	if tier == 1:
		state = State.INITIAL
		$Icon.custom_minimum_size = Vector2.ONE * 144
		texture = preload("res://content/techtree/panels/big.png")
		$SelectedPanel.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		$SelectedPanel.texture = preload("res://content/techtree/panels/big_focus.png")
	$SelectedPanel.visible = false
	if data.has("cost"):
		var cost = data.get("cost")
		var costsBox = find_child("Costs")
		for costType in cost:
			var label = Label.new()
			label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
			label.size_flags_horizontal = label.SIZE_EXPAND_FILL 
			label.text = str(cost[costType])
			label.label_settings = preload("res://gui/fontsettings/NumbersFontSettings.tres")
			costsBox.add_child(label)
			costLabels[costType] = label
			
			var rect = TextureRect.new()
			rect.stretch_mode = TextureRect.STRETCH_KEEP
			var tex:Texture2D
			match costType:
				CONST.WATER:
					tex = preload("res://content/icons/icon_water.png")
				CONST.IRON:
					tex = preload("res://content/icons/icon_iron.png")
				CONST.SAND:
					tex = preload("res://content/icons/icon_sand.png")
				CONSTARRC.DIAMOND:
					tex = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/diamond_icon.png")
			rect.texture = tex
			costsBox.add_child(rect)
	
	propertyChanges = data.get("propertychanges", [])
	if data.has("overwriteTitleKey"):
		title = tr(data.get("overwriteTitleKey"))
	else:
		title = tr("upgrades." + visualTechId + ".title")
	if data.has("overwriteDescKey"):
		explanationBb = tr(data.get("overwriteDescKey"))
	else:
		explanationBb = GameWorld.iconify(tr("upgrades." + visualTechId + ".desc"))
	
	updateState()
	
	icon = load("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/upgrades/" + visualTechId + ".png")
	find_child("Icon").texture = icon
	
	_on_Tech_focus_exited()
	

