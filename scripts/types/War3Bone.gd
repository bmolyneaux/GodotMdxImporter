extends "./War3Node.gd"

var geoset_id = null

func is_billboard() -> bool:
	return flags & 0x8 != 0
