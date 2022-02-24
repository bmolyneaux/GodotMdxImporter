extends Reference

const War3Model = preload("../types/War3Model.gd")
const War3Bone = preload("../types/War3Bone.gd")


func build(model: War3Model) -> Array:
	var skins = []
	
	for mesh_index in len(model.geosets):
		var skin = Skin.new()
		for node in model.nodes:
			if node is War3Bone:
				var bone = node as War3Bone
				var pivot_point = model.pivot_points[bone.id]
				skin.add_bind(bone.id, pivot_point)
				skin.set_bind_name(bone.id, bone.name)
				skin.set_bind_pose(bone.id, pivot_point.affine_inverse())
		skins.append(skin)
	
	return skins
