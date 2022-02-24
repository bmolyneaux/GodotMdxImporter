extends "res://scripts/types/War3Node.gd"

var type = "bone"
var geoset_id = null

func is_billboard() -> bool:
	return flags & 0x8 != 0
