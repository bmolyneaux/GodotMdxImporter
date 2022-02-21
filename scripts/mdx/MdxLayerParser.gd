extends Reference

const MdxUtils = preload("../mdx/MdxUtils.gd")
const War3Layer = preload("../types/War3Layer.gd")

const CHUNK_LAYER = 'LAYS'

const CHUNK_MATERIAL_TEXTURE_ID = 'KMTF'
const CHUNK_MATERIAL_ALPHA = 'KMTA'
const CHUNK_MATERIAL_EMISSIONS = 'KMTE'
const CHUNK_MATERIAL_FRESNEL_COLOR = 'KFC3'
const CHUNK_MATERIAL_FRESNEL_ALPHA = 'KFCA'
const CHUNK_MATERIAL_FRESNEL_TEAMCOLOR = 'KFTC'

const SUB_CHUNKS_LAYER = [
	CHUNK_MATERIAL_TEXTURE_ID,
	CHUNK_MATERIAL_ALPHA,
	CHUNK_MATERIAL_EMISSIONS,
	CHUNK_MATERIAL_FRESNEL_COLOR,
	CHUNK_MATERIAL_FRESNEL_ALPHA,
	CHUNK_MATERIAL_FRESNEL_TEAMCOLOR
]

const INTERPOLATION_TYPE_LINEAR = 1


static func parse_fresnel_color(file: File):
	var tracks_count = file.get_32()
	var interpolation_type = file.get_32()
	var global_sequence_id = file.get_32()

	var times = []
	var values = []

	for i in range(tracks_count):
		var time = file.get_32()
		var value = [file.get_float(), file.get_float(), file.get_float()]
		times.append(time)
		values.append(value)

		if interpolation_type > INTERPOLATION_TYPE_LINEAR:
			var in_tan = [file.get_float(), file.get_float(), file.get_float()]
			var out_tan = [file.get_float(), file.get_float(), file.get_float()]
	
	return null


static func parse_material_alpha(file: File):
	var tracks_count = file.get_32()
	var interpolation_type = file.get_32()
	var global_sequence_id = file.get_32()

	var times = []
	var values = []

	for i in range(tracks_count):
		var time = file.get_32()
		var value = file.get_32()
		times.append(time)
		values.append(value)

		if interpolation_type > INTERPOLATION_TYPE_LINEAR:
			var in_tan = file.get_float()
			var out_tan = file.get_float()
	
	# TODO: Actually return something
	return null


static func parse_material_texture_id(file: File):
	var tracks_count = file.get_32()
	var interpolation_type = file.get_32()
	var global_sequence_id = file.get_32()

	var times = []
	var values = []

	for i in range(tracks_count):
		var time = file.get_32()
		var value = file.get_32()    # texture id value
		times.append(time)
		values.append(value)

		if interpolation_type > INTERPOLATION_TYPE_LINEAR:
			var in_tan = file.get_float()
			var out_tan = file.get_float()
	
	# TODO: Actually return something
	return null


func parse(file: File, version: int) -> Array:
	var chunk_id = MdxUtils.get_chunk_id(file)
	assert(chunk_id == CHUNK_LAYER)
	var layers_count = file.get_32()
	var layers = []

	for i in range(layers_count):
		var layer = War3Layer.new()
		
		var final_position = file.get_position() + file.get_32()
		layer.filter_mode = file.get_32()
		layer.shading_flags = file.get_32()
		layer.texture_id = file.get_32()
		layer.texture_animation_id = file.get_32()
		layer.coord_id = file.get_32()
		layer.alpha = file.get_float()
		
		if version > 800:
			layer.emissive_gain = file.get_32()
		if version > 900:
			layer.fresnel_color = [file.get_float(), file.get_float(), file.get_float()]
			layer.fresnel_opacity = file.get_float()
			layer.fresnel_team_color = file.get_float()
			while file.get_position() < final_position:
				chunk_id = MdxUtils.get_chunk_id(file)
				assert(chunk_id in SUB_CHUNKS_LAYER)
				if chunk_id == CHUNK_MATERIAL_TEXTURE_ID:
					layer.flipbook_texture_id = parse_material_texture_id(file)
				elif chunk_id == CHUNK_MATERIAL_ALPHA:
					layer.material_alpha = parse_material_alpha(file)
				elif chunk_id == CHUNK_MATERIAL_FRESNEL_COLOR:
					layer.fresnel_color = parse_fresnel_color(file)
				elif chunk_id == CHUNK_MATERIAL_EMISSIONS:
					layer.emissions = parse_material_alpha(file)
				elif chunk_id == CHUNK_MATERIAL_FRESNEL_ALPHA:
					layer.fresnel_alpha = parse_material_alpha(file)
				elif chunk_id == CHUNK_MATERIAL_FRESNEL_TEAMCOLOR:
					assert(false) # Probably the wrong thing
					layer.fresnel_team_color = parse_material_alpha(file)
		layers.append(layer)

	return layers
