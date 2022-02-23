extends Reference

const War3Model = preload("../types/War3Model.gd")
const War3Node = preload("../types/War3Node.gd")


# TODO: Assumes ordering in MDX is BONE LITE HELP ATCH etc. If these are in a different order, the skinning will be wrong.
# The logic between these types of nodes should be deduplicated.


func build_skeleton(model: War3Model) -> Skeleton:
	var skeleton = Skeleton.new()
	skeleton.name = "Skeleton"
	
	var unparented_bones = []
	
	for bone_index in len(model.bones):
		var node = model.bones[bone_index].node as War3Node
		
		skeleton.add_bone(node.name)
		skeleton.set_bone_name(bone_index, node.name)
		
		if node.parent:
			unparented_bones.append(bone_index)
		else:
			skeleton.set_bone_rest(bone_index, model.pivot_points[bone_index])
	
	var unparented_helpers = []
	
	for helper_index in len(model.helpers):
		var node = model.helpers[helper_index].node as War3Node
		
		var bone_index = skeleton.get_bone_count()
		skeleton.add_bone(node.name)
		skeleton.set_bone_name(bone_index, node.name)
		
		if node.parent:
			unparented_helpers.append(helper_index)
		else:
			skeleton.set_bone_rest(bone_index, model.pivot_points[bone_index])
			
	while len(unparented_bones) > 0 or len(unparented_helpers) > 0:
		for i in len(unparented_bones):
			var bone_index = unparented_bones[i]
			var node = model.bones[bone_index].node as War3Node
			
			if not node.parent in unparented_bones:
				skeleton.set_bone_parent(bone_index, node.parent)
				var parent_bone = skeleton.get_bone_parent(bone_index)
				var inverse_parent_global = skeleton.get_bone_global_pose(parent_bone).affine_inverse()
				var global_pose = model.pivot_points[bone_index]
				
				var local_pose = global_pose * inverse_parent_global
				skeleton.set_bone_rest(bone_index, local_pose)

				unparented_bones.remove(i)
				break

		for i in len(unparented_helpers):
			var helper_index = unparented_helpers[i]
			var node = model.helpers[helper_index].node as War3Node
			
			var bone_index = helper_index + len(model.bones)
			
			if not node.parent in unparented_helpers:
				skeleton.set_bone_parent(bone_index, node.parent)
				var parent_bone = skeleton.get_bone_parent(bone_index)
				var inverse_parent_global = skeleton.get_bone_global_pose(parent_bone).affine_inverse()
				var global_pose = model.pivot_points[bone_index]
				
				var local_pose = global_pose * inverse_parent_global
				skeleton.set_bone_rest(bone_index, local_pose)

				unparented_helpers.remove(i)
				break
		
	return skeleton
