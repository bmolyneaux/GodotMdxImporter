extends Reference

const War3Texture = preload("../types/War3Texture.gd")


func parse(file: File, chunk_size: int) -> Array:
	var textures = []
	
	assert(chunk_size % 268 == 0)

	var textures_count = chunk_size / 268

	for i in range(textures_count):
		var texture = War3Texture.new()
		texture.replaceable_id = file.get_32()
		texture.image_file_name = file.get_buffer(260).get_string_from_utf8()
		var flags = file.get_32()
		textures.append(texture)
		
	return textures
