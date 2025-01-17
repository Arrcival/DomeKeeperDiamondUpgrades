extends "res://content/gamemode/summary/MiningSummary.gd"

const CONSTARRC = preload("res://mods-unpacked/Arrcival-DiamondUpgrades/Consts.gd")

enum ColorIdxDiamond 
{
	Background,
	Mined,
	Stone,
	Border,
	Relic,
	Gadget,
	Iron,
	Kobalt,
	Water,
	Hole,
	Transparent
}

func create_initial_buffer() -> PackedByteArray:
	var usedRect = Recorder.initialMapData.get_used_rect()
	var arr = PackedByteArray()
	
	for y in range(usedRect.position.y, usedRect.end.y):
		for x in range(usedRect.position.x, usedRect.end.x ):
			var res = Recorder.initialMapData.get_resource(x, y)
			match res:
				Data.TILE_EMPTY: arr.append(ColorIdx.Background)
				Data.TILE_IRON: arr.append(ColorIdx.Iron)
				Data.TILE_WATER: arr.append(ColorIdx.Water)
				Data.TILE_SAND: arr.append(ColorIdx.Kobalt)
				Data.TILE_GADGET: arr.append(ColorIdx.Gadget)
				Data.TILE_RELIC: arr.append(ColorIdx.Relic)
				Data.TILE_NEST: arr.append(ColorIdx.Hole)
				Data.TILE_RELIC_SWITCH: arr.append(ColorIdx.Relic)
				Data.TILE_SUPPLEMENT: arr.append(ColorIdx.Gadget)
				Data.TILE_CAVE: arr.append(ColorIdx.Hole)
				Data.TILE_BORDER: arr.append(ColorIdx.Border)
				CONSTARRC.TILE_DIAMOND: arr.append(CONSTARRC.TILE_DIAMOND)
				_: arr.append(ColorIdx.Stone)
	
	return arr

func create_color_table() -> Array:
	var table: Array[Color] = super.create_color_table()
	table.append(Color.from_string("#F0F0F0", Color.BLACK))
	return table
