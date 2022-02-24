extends Reference

const War3Bone = preload("../types/War3Bone.gd")

const MdxNodeParser = preload("./MdxNodeParser.gd")


func parse(file: File, chunk_size: int, version: int) -> Array:
	var bones = []
	
	var final_position = file.get_position() + chunk_size
	while file.get_position() < final_position:
		var bone = War3Bone.new()
		MdxNodeParser.new().parse_node(file, bone)

		bone.geoset_id = file.get_32()
		var geoset_animation_id = file.get_32()
		bones.append(bone)
	
	return bones
