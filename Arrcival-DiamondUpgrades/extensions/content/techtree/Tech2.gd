extends "res://content/techtree/Tech2.gd"

func build(id:String, tier: = - 1):
	if !id.begins_with("diamond"):
		return .build(id, tier)
		
	self.techId = id
	var data = GameWorld.upgrades.get(id)
	visualTechId = data.get("shadowing", techId)
	if tier == 1:
		state = State.INITIAL
		$Icon.rect_min_size = Vector2.ONE * 144
		$Icon.rect_position = Vector2( - 4, - 4)
		texture = preload("res://content/techtree/panels/big.png")
		$SelectedPanel.texture = preload("res://content/techtree/panels/big_focus.png")
	$SelectedPanel.visible = false
	if data.has("cost"):
		var cost = data.get("cost")
		var costsBox = find_node("Costs")
		for costType in cost:
			var label = Label.new()
			label.align = Label.ALIGN_RIGHT
			label.size_flags_horizontal = label.SIZE_EXPAND_FILL
			label.text = str(cost[costType])
			label.add_font_override("font", preload("res://gui/fonts/FontNumbers.tres"))
			label.add_to_group("unstyled")
			costsBox.add_child(label)
			costLabels[costType] = label
			
			var rect = TextureRect.new()
			var tex:Texture
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
	
	title = tr("upgrades." + visualTechId + ".title")
	explanationBb = GameWorld.iconify(tr("upgrades." + visualTechId + ".desc"))
	
	updateState()
	
	icon = load("res://mods-unpacked/Arrcival-DiamondUpgrades/content/icons/upgrades/" + visualTechId + ".png")
	
	find_node("Icon").texture = icon
	
	_on_Tech_focus_exited()
