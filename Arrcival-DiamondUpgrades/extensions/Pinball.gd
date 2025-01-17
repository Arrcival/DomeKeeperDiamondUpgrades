extends "res://content/keeper/keeper2/Pinball.gd" 

func _ready():
	super._ready()
	baseDamage = baseDamage * Data.of(playerId + ".keeper2.sphereDamageMod")
