extends Reference

const MdxUtils = preload("../mdx/MdxUtils.gd")

const War3Sequence = preload("../types/War3Sequence.gd")


func parse_sequence(file: File) -> War3Sequence:
	var sequence = War3Sequence.new()
	sequence.name = file.get_buffer(80).get_string_from_utf8()
	
	sequence.interval_start = file.get_32()
	sequence.interval_end = file.get_32()
	
	sequence.movement_speed = file.get_float()
	
	sequence.flags = file.get_32()
	
	sequence.rarity = file.get_float()
	var sync_point = file.get_32()
	var bounds_radius = file.get_float()
	var minimum_extent = MdxUtils.get_vector3(file)
	var maximum_extent = MdxUtils.get_vector3(file)
	
	return sequence


func parse(file: File, chunk_size: int) -> Array:
	var sequences = []
	
	assert(chunk_size % 132 == 0)
	
	var sequences_count = chunk_size / 132
	
	for i in sequences_count:
		sequences.append(parse_sequence(file))
	
	return sequences
