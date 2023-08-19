extends "res://content/gadgets/converter/ConverterPopup.gd"

func _ready():
	
	var container = find_node("ConversionsContainer")
	var containerChilds = container.get_child_count()
	for i in range(containerChilds):
		container.remove_child(container.get_child(0))
		
	var spdModifier = Data.of("converter.speedMod")
	var ratio = Data.of("converter.watertoiron")
	if ratio > 0:
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("water", "iron", ratio, Data.of("converter.ironwatertime") * spdModifier)
		container.add_child(con)
	ratio = Data.of("converter.irontowater")
	if ratio > 0:
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("iron", "water", ratio, Data.of("converter.ironwatertime") * spdModifier)
		container.add_child(con)
	ratio = Data.of("converter.irontocobalt")
	if ratio > 0:
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("iron", "sand", ratio, Data.of("converter.ironcobalttime") * spdModifier)
		container.add_child(con)
	ratio = Data.of("converter.cobalttoiron")
	if ratio > 0:
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("sand", "iron", ratio, Data.of("converter.ironcobalttime") * spdModifier)
		container.add_child(con)
	ratio = Data.of("converter.irontoiron")
	if ratio > 0:
		var con = preload("res://content/gadgets/converter/Conversion.tscn").instance()
		con.setConversion("iron", "iron", ratio, Data.of("converter.ironirontime") * spdModifier)
		container.add_child(con)

	Style.init(self)
