extends Reference

const War3Model = preload("../types/War3Model.gd")


func build(model: War3Model) -> Array:
	var skins = []
	
	for mesh_index in len(model.geosets):
		var skin = Skin.new()
		for bone in model.bones:
			var node = bone.node
			var pivot_point = model.pivot_points[node.id]
			skin.add_bind(node.id, pivot_point)
			skin.set_bind_name(node.id, node.name)
			skin.set_bind_pose(node.id, pivot_point.affine_inverse())
		skins.append(skin)
	
	return skins
