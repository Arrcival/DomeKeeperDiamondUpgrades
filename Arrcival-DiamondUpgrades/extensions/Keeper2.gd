extends "res://content/keeper/keeper2/Keeper2.gd"

func currentSpeed()->float:
	var s = Data.of("keeper2.maxSpeed") * Data.of("keeper2.speedMod") + Data.of("keeper.additionalmaxspeed")
	s += Data.of("keeper.speedBuff")
	var yMove = move.normalized().y
	if yMove < 0:
		s += Data.of("keeper.additionalupwardsspeed") * abs(yMove)
	return s
