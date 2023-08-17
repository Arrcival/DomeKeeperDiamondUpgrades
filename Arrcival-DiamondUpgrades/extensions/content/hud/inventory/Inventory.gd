extends "res://content/hud/inventory/Inventory.gd"

func init():
	.init()
	Data.listen(self, "inventory.diamond", true)

func propertyChanged(property:String, oldValue, newValue):
	.propertyChanged(property, oldValue, newValue)
	match property:
		"inventory.diamond":
			find_node("LabelDiamond").text = str(clamp(newValue, 0, 99))
