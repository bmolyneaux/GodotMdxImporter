extends Reference

const War3Model = preload("../types/War3Model.gd")
const War3Sequence = preload("../types/War3Sequence.gd")
const War3GeosetAnimation = preload("../types/War3GeosetAnimation.gd")


func build(model: War3Model, skeleton: Skeleton) -> AnimationPlayer:
	var animation_player = AnimationPlayer.new()
	animation_player.name = "AnimationPlayer"
	
	for sequence in model.sequences:
		sequence = sequence as War3Sequence
		var animation = Animation.new()
		
		for bone_index in skeleton.get_bone_count():
			var times = {}
			var translations = {}
			var rotations = {}
			var scales = {}
			
			var node = model.nodes[bone_index]

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
				animation.track_set_path(track, "Skeleton:" + skeleton.get_bone_name(bone_index))
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
					
					animation.loop = sequence.flags & 0x1 == 0
					
		for geoset_animation in model.geoset_animations:
			geoset_animation = geoset_animation as War3GeosetAnimation
			var alpha_track = geoset_animation.alpha_track
			var mesh = skeleton.get_child(geoset_animation.geoset_id)
			var track = animation.add_track(Animation.TYPE_VALUE)
			animation.track_set_path(track, "Skeleton/" + mesh.name + ":visible")
			for i in len(alpha_track.times):
				var time = alpha_track.times[i]
				var value = true if alpha_track.values[i] == 1 else false
				if sequence.interval_start <= time and time <= sequence.interval_end:
					var seconds = (time - sequence.interval_start) / 24.0 / 41.666666666
					animation.track_insert_key(track, seconds, value)
			
		
		animation_player.add_animation(sequence.name, animation)
		
	return animation_player
