extends Reference

const War3Model = preload("../types/War3Model.gd")
const War3Sequence = preload("../types/War3Sequence.gd")


func build(model: War3Model, skeleton: Skeleton) -> AnimationPlayer:
	var animation_player = AnimationPlayer.new()
	
	for sequence in model.sequences:
		sequence = sequence as War3Sequence
		var animation = Animation.new()
		
		for bone in skeleton.get_bone_count():
			var times = {}
			var translations = {}
			var rotations = {}
			var scales = {}
			
			var node = model.bones[bone].node
			if node.translations:
				for i in len(node.translations.times):
					var time = node.translations.times[i]
					var translation = node.translations.values[i]
					if sequence.interval_start <= time and time <= sequence.interval_end:
						times[time] = true
						translations[time] = translation
			if node.rotations:
				for i in len(node.rotations.times):
					var time = node.rotations.times[i]
					var rotation = node.rotations.values[i]
					if sequence.interval_start <= time and time <= sequence.interval_end:
						times[time] = true
						rotations[time] = rotation
			if node.scalings:
				for i in len(node.scalings.times):
					var time = node.scalings.times[i]
					var scale = node.scalings.values[i]
					if sequence.interval_start <= time and time <= sequence.interval_end:
						times[time] = true
						scales[time] = scale
			
			if times:
				var track = animation.add_track(Animation.TYPE_TRANSFORM)
				animation.track_set_path(track, "Skeleton:" + skeleton.get_bone_name(bone))
				animation.length = (sequence.interval_end - sequence.interval_start) / 24.0 / 41.666666666
				
				for time in times:
					var transform = Transform.IDENTITY
					if time in translations:
						transform = Transform(Basis.IDENTITY, translations[time])
					if time in rotations:
						transform.basis = Basis(rotations[time])
					if time in scales:
						transform.basis = transform.basis.scaled(scales[time])
					var seconds = (time - sequence.interval_start) / 24.0 / 41.666666666
					var key = animation.transform_track_insert_key(track, seconds, transform.origin, transform.basis.get_rotation_quat(), transform.basis.get_scale())
					animation.loop = true
		
		animation_player.add_animation(sequence.name, animation)
		
	return animation_player
