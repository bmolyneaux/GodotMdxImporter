extends Reference

const MdxUtils = preload("../mdx/MdxUtils.gd")

const War3Node = preload("../types/War3Node.gd")
const War3RotationTrack = preload("../types/War3RotationTrack.gd")
const War3VectorTrack = preload("../types/War3VectorTrack.gd")


static func parse_vector_track(file: File) -> War3VectorTrack:
	var track = War3VectorTrack.new()
	var tracks_count = file.get_32()
	track.interpolation_type = file.get_32()
	var global_sequence_id = file.get_32()

	for i in range(tracks_count):
		var time = file.get_32()
		
		track.times.append(time)
		track.values.append(MdxUtils.get_vector3(file))
		
		var INTERPOLATION_TYPE_LINEAR = 1
		if track.interpolation_type > INTERPOLATION_TYPE_LINEAR:
			track.in_tangents = MdxUtils.get_vector3(file)
			track.out_tangents = MdxUtils.get_vector3(file)

	return track


static func parse_rotation_track(file: File) -> War3RotationTrack:
	var track = War3RotationTrack.new()
	var tracks_count = file.get_32()
	track.interpolation_type = file.get_32()
	var global_sequence_id = file.get_32()

	for i in range(tracks_count):
		var time = file.get_32()
		track.values.append(MdxUtils.get_rotation(file))

		track.times.append(time)
		
		var INTERPOLATION_TYPE_LINEAR = 1
		if track.interpolation_type > INTERPOLATION_TYPE_LINEAR:
			track.in_tangents = MdxUtils.get_rotation(file)
			track.out_tangents = MdxUtils.get_rotation(file)

	return track


static func parse_node(file: File, node: War3Node):
	var current_position = file.get_position()
	var chunk_size = file.get_32()
	var final_position = current_position + chunk_size
	node.name = file.get_buffer(80).get_string_from_utf8()
	node.id = file.get_32()
	node.parent = file.get_32()
	#print(node.name, " ", node.parent, " ", node.id)

	if node.parent == 0xffffffff:
		node.parent = null

	node.flags = file.get_32()
	
	var CHUNK_GEOSET_TRANSLATION = 'KGTR'
	var CHUNK_GEOSET_ROTATION = 'KGRT'
	var CHUNK_GEOSET_SCALING = 'KGSC'

	while file.get_position() < final_position:
		var chunk_id = MdxUtils.get_chunk_id(file)
		assert(chunk_id in [CHUNK_GEOSET_TRANSLATION, CHUNK_GEOSET_ROTATION, CHUNK_GEOSET_SCALING])

		if chunk_id == CHUNK_GEOSET_TRANSLATION:
			node.translations = parse_vector_track(file)
		elif chunk_id == CHUNK_GEOSET_ROTATION:
			node.rotations = parse_rotation_track(file)
		elif chunk_id == CHUNK_GEOSET_SCALING:
			node.scalings = parse_vector_track(file)

	return node
