extends Reference

const MdxModelParser = preload("../mdx/MdxModelParser.gd")

const War3Model = preload("../types/War3Model.gd")

var _file_name: String


func _init(file_name: String) -> void:
	_file_name = file_name


func parse() -> War3Model:
	var file = File.new()
	file.open(_file_name, File.READ)
	
	return MdxModelParser.new().parse(file)
