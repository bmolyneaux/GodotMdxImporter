extends Reference

const War3Model = preload("../types/War3Model.gd")


func build(model: War3Model) -> Array:
	var skins = []
	
	for mesh_index in len(model.geosets):
		var skin = Skin.new()
		for bone_index in len(model.bones):
			skin.add_bind(bone_index, model.pivot_points[bone_index])
			skin.set_bind_name(bone_index, model.bones[bone_index].node.name)
			skin.set_bind_pose(bone_index, model.pivot_points[bone_index].affine_inverse())
		skins.append(skin)
	
	return skins
