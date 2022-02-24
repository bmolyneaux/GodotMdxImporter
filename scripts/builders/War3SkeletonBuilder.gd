extends Reference

const War3Model = preload("../types/War3Model.gd")
const War3Node = preload("../types/War3Node.gd")


func build_skeleton(model: War3Model) -> Skeleton:
	var skeleton = Skeleton.new()
	skeleton.name = "Skeleton"
	
	var unparented_bones = []
	
	for node_index in len(model.nodes):
		var node = model.nodes[node_index] as War3Node
		
		skeleton.add_bone(node.name)
		skeleton.set_bone_name(node_index, node.name)
		
		if node.parent:
			unparented_bones.append(node_index)
		else:
			skeleton.set_bone_rest(node_index, model.pivot_points[node.id])
			
	while len(unparented_bones) > 0:
		for i in len(unparented_bones):
			var bone_index = unparented_bones[i]
			var node = model.nodes[bone_index] as War3Node
			
			if not node.parent in unparented_bones:
				skeleton.set_bone_parent(bone_index, node.parent)
				var inverse_parent_global = skeleton.get_bone_global_pose(node.parent).affine_inverse()
				var global_pose = model.pivot_points[node.id]
				
				var local_pose = global_pose * inverse_parent_global
				skeleton.set_bone_rest(bone_index, local_pose)
				
				unparented_bones.remove(i)
				break
		
	return skeleton
