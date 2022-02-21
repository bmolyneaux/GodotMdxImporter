extends Reference

const War3Node = preload("../types/War3Node.gd")

var type = "bone"
var node: War3Node
var geoset_id = null

func is_billboard() -> bool:
	return node.flags & 0x8 != 0
