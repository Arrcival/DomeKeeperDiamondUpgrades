extends "res://content/techtree/TechTreePopup.gd"

func _ready():	
	find_node("LabelDiamond").text = str(Data.getInventory(CONSTARRC.DIAMOND))
	Data.listen(self, "inventory.diamond")

func propertyChanged(property:String, oldValue, newValue):
	match property:
		"inventory.diamond":
			find_node("LabelDiamond").text = str(clamp(newValue, 0, 999))
	.propertyChanged(property, oldValue, newValue)

func moveOut():
	if not isIn:
		return 
	Data.unlisten(self, "inventory.diamond")
	.moveOut()

func updateCostLabels():
	find_node("LabelDiamondCost").text = ""
	.updateCostLabels()
