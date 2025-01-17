extends "res://tool/PaletteMaker/PaletteMaker.gd"

func updateDome(index := -1):
	if dome:
		dome.free()
		Data.apply("shield.stage", 0)
		dome = null
	
	if index == -1:
		if find_child("DomesList").get_selected_items().size() == 0:
			return
		else:
			index = find_child("DomesList").get_selected_items()[0]
	
	var domeName = find_child("DomesList").get_item_text(index)
	var scene = load("res://content/dome/"+domeName+"/"+domeName.capitalize().replace(" ", "")+".tscn")
	if not scene:
		return
	dome = scene.instantiate()
	dome.set_script(load("res://mods-unpacked/Arrcival-DiamondUpgrades/content/dome/Dome.gd"))
	dome.position = $DomePosition.position
	Level.dome = dome
	add_child(dome)
	dome.init()
	GameWorld.addUpgrade(dome.primaryWeapon)
	dome.addWeapon()
	var weapon = dome.find_child("WeaponContainer").get_children().front()
	if weapon:
		weapon.start()
	dome.find_child("CracksOverlay").visible = false
	Style.init(dome)
	unlockGadgets()
	Data.apply("dome.health", Data.of("dome.maxhealth"))
	
	Audio.set_bus_volume(Audio.BUS_MASTER, -60)
	_on_CellarOnButton_pressed()
