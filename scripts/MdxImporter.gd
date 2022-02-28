extends Reference

const MdxParser = preload("./mdx/MdxParser.gd")

const War3AnimationBuilder = preload("./builders/War3AnimationBuilder.gd")
const War3MaterialBuilder = preload("./builders/War3MaterialBuilder.gd")
const War3MeshBuilder = preload("./builders/War3MeshBuilder.gd")
const War3MeshInstanceBuilder = preload("./builders/War3MeshInstanceBuilder.gd")
const War3SkeletonBuilder = preload("./builders/War3SkeletonBuilder.gd")
const War3SkinBuilder = preload("./builders/War3SkinBuilder.gd")
const War3TextureBuilder = preload("./builders/War3TextureBuilder.gd")

const War3Bone = preload("./types/War3Bone.gd")
const UnitModel = preload("./UnitModel.gd")


func import(mdx_path: String) -> Spatial:
	var root = Spatial.new()
	
	var mdx_parser = MdxParser.new(mdx_path)
	var model = mdx_parser.parse()
	
	root.name = model.name
	
	var textures = War3TextureBuilder.new().build_textures(model)
	
	var materials = War3MaterialBuilder.new().build_materials(model, textures)
	
	var meshes = War3MeshBuilder.new().build_meshes(model)
	
	var skins = War3SkinBuilder.new().build(model)
	
	var mesh_instances = War3MeshInstanceBuilder.new().build(model, meshes, materials, skins)
	
	var skeleton = War3SkeletonBuilder.new().build_skeleton(model)
	root.add_child(skeleton)
	skeleton.set_owner(root)
	
	for mesh_instance in mesh_instances:
		skeleton.add_child(mesh_instance)
		mesh_instance.set_owner(root)
		
	var animation_player = War3AnimationBuilder.new().build(model, skeleton)
	root.add_child(animation_player)
	animation_player.set_owner(root)
	
	root.set_script(UnitModel)
	root.billboard_bones = []
	for i in len(model.nodes):
		var node = model.nodes[i]
		if node is War3Bone and node.is_billboard():
			root.billboard_bones.append(i)
	
	root.scale = Vector3(0.01, 0.01, 0.01)
	return root
