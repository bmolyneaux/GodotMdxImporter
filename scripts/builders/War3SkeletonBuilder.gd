extends Reference

const War3Model = preload("../types/War3Model.gd")
const War3Node = preload("../types/War3Node.gd")


func build_skeleton(model: War3Model) -> Skeleton:
	var skeleton = Skeleton.new()
	
	var bone_index = 0
	for bone in model.bones:
		var node = bone.node as War3Node
		
		skeleton.add_bone(node.name)
		skeleton.set_bone_name(bone_index, node.name)
		if node.parent:
			skeleton.set_bone_parent(bone_index, node.parent)
			
			var parent_bone = skeleton.get_bone_parent(bone_index)
			var inverse_parent_global = skeleton.get_bone_global_pose(parent_bone).affine_inverse()
			var global_pose = model.pivot_points[bone_index]
			
			var local_pose = global_pose * inverse_parent_global
			skeleton.set_bone_rest(bone_index, local_pose)
		else:
			skeleton.set_bone_rest(bone_index, model.pivot_points[bone_index])
		
		bone_index += 1
		
	return skeleton
