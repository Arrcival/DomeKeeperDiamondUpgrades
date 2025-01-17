extends "res://content/gadgets/converter/ConverterPopup.gd"

func _ready():
	
	$Container.position.y += get_viewport_rect().size.y
	$ColorRect.color = Style.OVERLAY_COLOR_OUT
	$ColorRect.visible = false
	%AutoQueueCheckBox.visible = Data.of("converter.queue")
	%AutoQueueCheckBox.set_pressed_no_signal(Data.of("converter.queueselected"))
	var container = find_child("ConversionsContainer")
	
	var spdModifier = Data.of("converter.speedMod")
	var ratio = Data.of("converter.watertoiron")
	if ratio > 0 and (currentConversionId == "" or currentConversionId == "watertoiron"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instantiate()
		con.setConversion("watertoiron", "water", "iron", 1, ratio, Data.of("converter.ironwatertime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))

	ratio = Data.of("converter.ironperwater")
	if ratio > 0 and (currentConversionId == "" or currentConversionId == "ironperwater"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instantiate()
		con.setConversion("ironperwater", "iron", "water", ratio, 1, Data.of("converter.ironwatertime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))
	
	ratio = Data.of("converter.ironpercobalt")
	if ratio > 0 and (currentConversionId == "" or currentConversionId == "ironpercobalt"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instantiate()
		con.setConversion("ironpercobalt", "iron", "sand", ratio, 1, Data.of("converter.ironcobalttime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))
	
	ratio = Data.of("converter.cobalttoiron")
	if ratio > 0 and (currentConversionId == "" or currentConversionId == "cobalttoiron"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instantiate()
		con.setConversion("cobalttoiron", "sand", "iron", 1, ratio, Data.of("converter.ironcobalttime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))
	ratio = Data.of("converter.irontoiron")
	if ratio > 0 and (currentConversionId == "" or currentConversionId == "irontoiron"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instantiate()
		con.setConversion("irontoiron", "iron", "iron", 1, ratio, Data.of("converter.ironirontime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))
	
	ratio = Data.of("converter.waterdiamond")
	if ratio > 0  and (currentConversionId == "" or currentConversionId == "waterdiamond"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("water", "diamond", ratio, Data.of("converter.waterdiamondtime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))
	ratio = Data.of("converter.diamonddiamond")
	if ratio > 0  and (currentConversionId == "" or currentConversionId == "diamonddiamond"):
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("diamond", "diamond", ratio, Data.of("converter.diamonddiamondtime") * spdModifier)
		container.add_child(con)
		con.connect("mouse_selected", Callable(self, "emit_signal").bind("conversion_selected", con))

	if currentConversionId == "":
		%LabelPick.visible = true
		%LabelInProgress.visible = false
	else:
		%LabelPick.visible = false
		%LabelInProgress.visible = true
		for c in get_tree().get_nodes_in_group("conversion_choices"):
			c.disable()
	
	Style.init(self)
	
	Data.listen(self, "inventory.iron")
	Data.listen(self, "inventory.water")
	Data.listen(self, "inventory.sand")
