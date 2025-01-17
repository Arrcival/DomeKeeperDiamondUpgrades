extends "res://stages/loadout/AssignmentChoice.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	var title: Label = find_child("LabelTitle")
	title.add_theme_color_override("font_color", "#839cd0")
	super._ready()
