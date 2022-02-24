extends Reference

const MdxNodeParser = preload("./MdxNodeParser.gd")

const War3Helper = preload("../types/War3Helper.gd")


func parse(file: File, chunk_size: int, version: int) -> Array:
	var helpers = []
	
	var final_position = file.get_position() + chunk_size
	while file.get_position() < final_position:
		var helper = War3Helper.new()
		MdxNodeParser.parse_node(file, helper)
		helpers.append(helper)
	
	return helpers
