extends "res://content/keeper/keeper2/Pinball.gd" 

func _ready():
	._ready()
	baseDamage = Data.of("keeper2.spherebasedamage") * Data.of("keeper2.sphereDamageMod")
