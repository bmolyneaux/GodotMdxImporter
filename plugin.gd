tool
extends EditorPlugin


var import_plugin


func _enter_tree():
	import_plugin = preload("import_plugin.gd").new()
	add_import_plugin(import_plugin)
	add_custom_type("UnitModel", "Spatial", preload("./scripts/UnitModel.gd"), preload("./war3_icon.png"))


func _exit_tree():
	remove_import_plugin(import_plugin)
	import_plugin = null
	remove_custom_type("War3Model")
