extends "res://content/map/tile/DirtParticle.gd"

var tex_diamond = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/content/map/tile/diamond_tile-break-dirt-particle.png")
const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

func _ready():
	._ready()
	if type != "default" and randf() > 0.7 && type == CONSTARRC.DIAMOND:
		var sprite = $Sprite
		sprite.scale = Vector2.ONE * 0.7
		sprite.texture = tex_diamond
		Style.init(sprite)
		sprite.frame = randi() % (sprite.hframes * sprite.vframes)
		sprite.modulate = Color.white * rand_range(0.7, 1.5)
		sprite.modulate.a = 1.0
		sprite.scale = Vector2.ONE * (ease(randf() * 0.7, 1.5) + 0.7)
		
		$AnimationPlayer.playback_speed = rand_range(0.8, 1.2)
		$AnimationPlayer.play("start")
