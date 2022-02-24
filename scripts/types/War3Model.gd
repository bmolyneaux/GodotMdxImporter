extends Resource

export(String) var Version
export(Resource) var Info  # War3Info
export(Array) var textures  # Array[War3Texture]
export(Array) var materials  # Array[War3Material]
export(Array) var geosets  # Array[War3Geoset]
export(Array) var pivot_points  # Array[Transform]
export(Array) var sequences  # Array[War3Sequence]
export(Array) var geoset_animations  # Array[War3GeosetAnimation]
export(Array) var nodes  # Array[War3Node]


func _init() -> void:
	nodes = []
