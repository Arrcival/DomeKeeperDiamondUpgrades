extends "res://content/dome/shredder/Shredder.gd"


func _on_Shredder_area_entered(area):
	._on_Shredder_area_entered(area)
	var drop = area.getDeliverableDrop(CONSTARRC.DIAMOND)
	if drop:
		drop.floatToDropTarget(self)
		return
