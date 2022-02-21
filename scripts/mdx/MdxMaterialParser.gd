extends Reference

const MdxLayerParser = preload("../mdx/MdxLayerParser.gd")
const War3Material = preload("../types/War3Material.gd")


func parse(file: File, chunk_size: int, version: int) -> Array:
	var materials = []
	
	var final_position = file.get_position() + chunk_size
	while file.get_position() < final_position:
		var material = War3Material.new()
		
		var inclusive_size = file.get_32()
		var priority_plane = file.get_32()
		var flags = file.get_32()
		
		var shader = file.get_buffer(80).get_string_from_utf8()
		assert(shader == "")
		var layer_chunk_data_size = inclusive_size - 92
		
		if layer_chunk_data_size > 0:
			material.layers = MdxLayerParser.new().parse(file, version)
			
		materials.append(material)
	
	return materials
