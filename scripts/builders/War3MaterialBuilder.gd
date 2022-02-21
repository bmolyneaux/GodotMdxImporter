extends Reference

const TeamColorTexture = preload("../sentinels/TeamColorTexture.gd")
const TeamGlowTexture = preload("../sentinels/TeamGlowTexture.gd")

const War3Material = preload("../types/War3Material.gd")
const War3Model = preload("../types/War3Model.gd")


func build(material: War3Material, textures: Array) -> Material:
	var result = null
	
	for layer in material.layers:
		var unshaded = layer.shading_flags & 0x1 != 0
		var two_sided = layer.shading_flags & 0x10 != 0
		var transparent = layer.filter_mode == 1
		var blend = layer.filter_mode == 2
		var add = layer.filter_mode == 3
		var team_color = textures[layer.texture_id] is TeamColorTexture
		var team_glow = textures[layer.texture_id] is TeamGlowTexture
		
		assert(not (team_color and blend))
		assert(not (team_glow and blend))
		
		assert(layer.filter_mode <= 3)
		
		if team_color:
			# TODO: Doesn't handle case where material is just a big team color situation
			pass
		elif team_glow:
			# TODO: Support team colors for glow
			var team_glow_material = preload("../../materials/team_glow_material.tres") as SpatialMaterial
			team_glow_material.params_cull_mode = SpatialMaterial.CULL_FRONT
			return team_glow_material
		elif blend:
			var team_color_material = preload("../../materials/team_color_material.tres") as ShaderMaterial
			var new_material = team_color_material.duplicate()
			new_material.set_shader_param("Albedo", textures[layer.texture_id])
			return new_material
			# TODO: Set cull mode based on two_sided for team_color_material
		else:
			var new_material = SpatialMaterial.new()
			new_material.params_cull_mode = SpatialMaterial.CULL_FRONT
			new_material.albedo_texture = textures[layer.texture_id]
			new_material.params_use_alpha_scissor = transparent
			if two_sided:
				new_material.params_cull_mode = SpatialMaterial.CULL_DISABLED
			if add:
				new_material.params_blend_mode = SpatialMaterial.BLEND_MODE_ADD
				new_material.flags_unshaded = true
				new_material.flags_transparent = true
			return new_material
	
	#for layer in material.layers:
	#	print("blendMode: ", layer.filterMode, "   shadingFlags: ", layer.shadingFlags, "   texture: ", model.textures[layer.texture_id].image_file_name)
	
	assert(result)
	return result


func build_materials(model: War3Model, textures: Array) -> Array:
	var materials = []
	
	for material in model.materials:
		materials.append(build(material, textures))
	
	return materials
