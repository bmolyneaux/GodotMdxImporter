extends Reference

var interpolation_type := 0
var global_sequence_id
var times  # PoolIntArray
var values  # PoolVector3Array
var in_tangents  # PoolVector3Array
var out_tangents  # PoolVector3Array


func _init() -> void:
	times = []
	values = []
	in_tangents = PoolVector3Array()
	out_tangents = PoolVector3Array()
