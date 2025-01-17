extends "res://content/keeper/keeper2/Keeper2.gd"

func currentSpeed() -> float:
	var s = Data.of(playerId + ".keeper2.maxSpeed") * Data.of(playerId + ".keeper2.speedMod")
	s += Data.ofOr(playerId + ".keeper.speedBuff", 0)
	var yMove = move.normalized().y
	s += Data.ofOr(playerId + ".keeper.additionalupwardsspeed", 0) * abs(yMove)
	return s

