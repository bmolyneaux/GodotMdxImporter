extends Reference

const MdxUtils = preload("./MdxUtils.gd")

const War3AlphaTrack = preload("../types/War3AlphaTrack.gd")
const War3ColorTrack = preload("../types/War3ColorTrack.gd")
const War3GeosetAnimation = preload("../types/War3GeosetAnimation.gd")


static func parse_alpha_track(file: File) -> War3AlphaTrack:
	var track = War3AlphaTrack.new()
	var tracks_count = file.get_32()
	track.interpolation_type = file.get_32()
	
	# TODO: Check against -1
	var global_sequence_id = file.get_32()

	for i in range(tracks_count):
		var time = file.get_32()
		
		track.times.append(time)
		track.values.append(file.get_float())
		
		var INTERPOLATION_TYPE_LINEAR = 1
		if track.interpolation_type > INTERPOLATION_TYPE_LINEAR:
			track.in_tangents = file.get_float()
			track.out_tangents = file.get_float()

	return track


static func parse_color_track(file: File) -> War3ColorTrack:
	var track = War3ColorTrack.new()
	var tracks_count = file.get_32()
	track.interpolation_type = file.get_32()
	
	# TODO: Check against -1
	var global_sequence_id = file.get_32()

	for i in range(tracks_count):
		var time = file.get_32()
		
		track.times.append(time)
		track.values.append(MdxUtils.get_color(file))
		
		var INTERPOLATION_TYPE_LINEAR = 1
		if track.interpolation_type > INTERPOLATION_TYPE_LINEAR:
			track.in_tangents = MdxUtils.get_color(file)
			track.out_tangents = MdxUtils.get_color(file)

	return track


func parse_animation(file):
	var animation = War3GeosetAnimation.new()
	
	var size = file.get_32()
	
	var final_position = file.get_position() + size - 4
	animation.alpha = file.get_float()
	animation.flags = file.get_32()
	animation.color = Color(file.get_float(), file.get_float(), file.get_float())
	
	animation.geoset_id = file.get_32()
	if animation.geoset_id == 0xFFFFFFFF:
		animation.geoset_id = null
	
	while file.get_position() < final_position:
		var chunk_id = MdxUtils.get_chunk_id(file)

		assert(chunk_id in ["KGAO", "KGAC"])

		if chunk_id == "KGAC":
			animation.color_track =  parse_color_track(file)
		elif chunk_id == "KGAO":
			animation.alpha_track = parse_alpha_track(file)
		
			
	return animation


func parse(file: File, chunk_size: int, version: int):
	var animations = []
	
	var final_position = file.get_position() + chunk_size
	while file.get_position() < final_position:
		animations.append(parse_animation(file))
	
	return animations
