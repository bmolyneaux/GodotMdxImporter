extends Resource

export(Array) var vertices  # Array[Vector3]
export(Array) var normals  # Array[Vector3]
export(Array) var uvs  # Array[Vector2]
export(Array) var vertex_groups  # Array[int]
export(Array) var vertex_groups_ids  # Array[int]
export(Array) var faces  # Array[int]
export(Array) var groups  # Array[Array[int]]
export(int) var material_id
export(int) var selection_group
export(bool) var unselectable
# etc


func _init() -> void:
	vertices = []
	normals = []
	uvs = []
	faces = []
	vertex_groups = []
	vertex_groups_ids = []
	groups = []
