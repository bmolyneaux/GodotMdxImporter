extends Reference

const MdxUtils = preload("../mdx/MdxUtils.gd")
const War3Geoset = preload("../types/War3Geoset.gd")


const CHUNK_TANGENTS = 'TANG'
const CHUNK_SKIN = 'SKIN'
const CHUNK_TEXTURE_VERTEX_GROUP = 'UVAS'
const CHUNK_VERTEX_TEXTURE_POSITION = 'UVBS'


func get_vertex_groups(
		matrix_groups: Array, # Array[uint8]
		matrix_groups_sizes: Array, # Array[int]
		matrix_indices: Array # Array[int]
		):
	var i = 0
	var matrix = []

	# TODO: Merge i and j variables
	for matrix_group_size in matrix_groups_sizes:
		var m = []
		for j in range(matrix_group_size):
			m.append(matrix_indices[i + j])
		matrix.append(m)
		i += matrix_group_size

	var vertex_groups = []
	var vertex_groups_ids = {}

	for matrix_group in matrix_groups:
		if matrix_group < len(matrix):
			var vertex_group = matrix[matrix_group]
			vertex_groups.append(vertex_group)

			for vertex_group_id in vertex_group:
				vertex_groups_ids[vertex_group_id] = true

	if len(vertex_groups) == 0:
		for m_i in matrix_indices:
			vertex_groups.append([])
			vertex_groups_ids[m_i] = true

	vertex_groups_ids = vertex_groups_ids.keys()
	vertex_groups_ids.sort()

	return [vertex_groups, vertex_groups_ids]


func _parse_geoset(file: File, chunk_size: int, version: int) -> War3Geoset:
	var geoset = War3Geoset.new()
	
	var final_position = file.get_position() + chunk_size
	
	assert(MdxUtils.get_chunk_id(file) == 'VRTX')
	var vertex_count = file.get_32()
	for i in range(vertex_count):
		geoset.vertices.append(MdxUtils.get_vector3(file))
	
	assert(MdxUtils.get_chunk_id(file) == 'NRMS')
	var normals_count = file.get_32()
	for i in range(normals_count):
		geoset.normals.append(MdxUtils.get_vector3(file))
	
	assert(MdxUtils.get_chunk_id(file) == 'PTYP')
	var primitive_count = file.get_32()
	for i in range(primitive_count):
		# TODO: Do I need this data?
		assert(file.get_32() == 4)
	
	assert(MdxUtils.get_chunk_id(file) == 'PCNT')
	var face_group_count = file.get_32()
	for i in range(face_group_count):
		# TODO: Do I need this data?
		file.get_32()
	
	assert(MdxUtils.get_chunk_id(file) == 'PVTX')
	var indices_count = file.get_32()
	for i in range(indices_count):
		var index = file.get_16()
		assert(index >= 0)
		geoset.faces.append(index)
	
	assert(MdxUtils.get_chunk_id(file) == 'GNDX')
	var matrix_groups_count = file.get_32()
	var matrix_groups = []
	for i in range(matrix_groups_count):
		var group = file.get_8()
		assert(group >= 0)
		matrix_groups.append(group)
	
	assert(MdxUtils.get_chunk_id(file) == 'MTGC')
	var matrix_groups_sizes_count = file.get_32()
	var matrix_groups_sizes = []
	for i in range(matrix_groups_sizes_count):
		var size = file.get_32()
		matrix_groups_sizes.append(size)
	
	assert(MdxUtils.get_chunk_id(file) == 'MATS')
	var matrix_indices_count = file.get_32()
	var matrix_indices = []
	for i in range(matrix_indices_count):
		matrix_indices.append(file.get_32())
	
	var results = get_vertex_groups(matrix_groups, matrix_groups_sizes, matrix_indices)
	geoset.vertex_groups = results[0]
	geoset.vertex_groups_ids = results[1]
	
	geoset.material_id = file.get_32()
	var selection_group = file.get_32()
	var selection_flags = file.get_32()

	if version > 800:
		var lod = file.get_32()
		var lod_name = file.get_buffer(80).get_string_from_utf8()

	var bounds_radius = file.get_float()
	var minimum_extent = MdxUtils.get_vector3(file)
	var maximum_extent = MdxUtils.get_vector3(file)
	var extents_count = file.get_32()

	for i in range(extents_count):
		bounds_radius = file.get_float()
		minimum_extent = MdxUtils.get_vector3(file)
		maximum_extent = MdxUtils.get_vector3(file)

	if version > 800:
		var chunk_id = MdxUtils.get_chunk_id(file)
		assert(chunk_id in [CHUNK_TANGENTS, CHUNK_SKIN, CHUNK_TEXTURE_VERTEX_GROUP])
		if chunk_id == CHUNK_TANGENTS:
			var tangent_size = file.get_32()
			file.seek(file.get_position() + 16 * tangent_size)
			chunk_id = MdxUtils.get_chunk_id(file)
			assert(chunk_id in [CHUNK_TANGENTS, CHUNK_SKIN, CHUNK_TEXTURE_VERTEX_GROUP])
		assert(chunk_id != CHUNK_SKIN)
#		if chunk_id == CHUNK_SKIN:
#			var skin_size = file.get_32()
#			var skin_weights = []
#			for i in range(skin_size):
#				var weight = file.get_8()
#				assert(weight >= 0)
#				skin_weights.append(weight)
#			for i in range(skin_size / 8):
#				for j in range(i * 8, i * 8 + 8):
#					geoset.skin_weights.append(skin_weights[j])
#			chunk_id = MdxUtils.get_chunk_id(file)
		assert(chunk_id == CHUNK_TEXTURE_VERTEX_GROUP)
	else:
		var chunk_id = MdxUtils.get_chunk_id(file)
		assert(chunk_id == CHUNK_TEXTURE_VERTEX_GROUP)
	var texture_vertex_group_count = file.get_32()

	# parse uv-coordinates
	var chunk_id = MdxUtils.get_chunk_id(file)
	assert(chunk_id == CHUNK_VERTEX_TEXTURE_POSITION)
	var vertex_texture_position_count = file.get_32()

	for i in range(vertex_texture_position_count):
		var u = file.get_float()
		var v = file.get_float()
		geoset.uvs.append(Vector2(u, v))
	
	assert(file.get_position() == final_position)
	return geoset


func parse(file: File, chunk_size: int, version: int) -> Array:
	var geosets = []
	var final_position = file.get_position() + chunk_size
	while file.get_position() < final_position:
		var inclusive_size = file.get_32()
		var geoset_chunk_size = inclusive_size - 4
		geosets.append(_parse_geoset(file, geoset_chunk_size, version))
	return geosets
