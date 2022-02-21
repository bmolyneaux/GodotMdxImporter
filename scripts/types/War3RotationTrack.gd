extends Reference

var interpolation_type := 1
var times = []  # Array[int]
var values = []  # Array[Quat]
var in_tangents = []  # Array[Quat]
var out_tangents = []  # Array[Quat]


func _init() -> void:
	times = []
	values = []
	in_tangents = []
	out_tangents = []
