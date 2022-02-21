tool
extends EditorImportPlugin


func get_importer_name():
	return "war3_importer"


func get_visible_name():
	return "Warcraft 3 Mesh Importer"


func get_recognized_extensions():
	return ["mdx"]


func get_save_extension():
	return "scn"


func get_resource_type():
	return "PackedScene"


func get_option_visibility(option, options):
	return true


func get_preset_count():
	return 0


func get_import_options(preset):
	return []


func import(source_file: String, save_path: String, import_options: Dictionary, r_platform_variants: Array, r_gen_files: Array):
	var MdxImporter = preload("./scripts/MdxImporter.gd").new()
	var mdx = MdxImporter.import(source_file)
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(mdx)
	
	var filename = save_path + "." + get_save_extension()
	var error = ResourceSaver.save(filename, packed_scene)
	return error
