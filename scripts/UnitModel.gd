tool
extends Spatial

export(Array) var billboard_bones


func get_animation_player() -> AnimationPlayer:
	return $AnimationPlayer as AnimationPlayer


func get_skeleton() -> Skeleton:
	return $Skeleton as Skeleton


func _process(delta: float) -> void:
	var camera = get_viewport().get_camera()
	if not camera:
		return
	
	for bone in billboard_bones:
		var skeleton = get_skeleton()
		var parent_bone = skeleton.get_bone_parent(bone)
		var inverse_parent_global
		if parent_bone == -1:
			inverse_parent_global = Transform.IDENTITY
		else:
			inverse_parent_global = skeleton.get_bone_global_pose(parent_bone).affine_inverse()
		
		var global_pose = skeleton.global_transform * skeleton.get_bone_global_pose(bone)
		var inverse_rest = skeleton.get_bone_rest(bone).affine_inverse()
		
		var scaley = global_pose.basis.get_scale()
		var global_look_at = global_pose.looking_at(camera.global_transform.origin, Vector3(0, 1, 0))
		global_look_at.basis = global_look_at.basis.rotated(Vector3(0, 1, 0), PI / 2)
		global_look_at.basis = global_look_at.basis.scaled(scaley)
		
		var cool = skeleton.global_transform.affine_inverse()
		
		var local_pose = inverse_rest * inverse_parent_global * cool * global_look_at
		
		skeleton.set_bone_pose(bone, local_pose)
