extends Reference

const TeamColorTexture = preload("../sentinels/TeamColorTexture.gd")
const TeamGlowTexture = preload("../sentinels/TeamGlowTexture.gd")

const War3Model = preload("../types/War3Model.gd")
const War3Texture = preload("../types/War3Texture.gd")

const war3_directory = "res://war3/"


func build_textures(model: War3Model) -> Array:
	var textures = []
	
	for texture in model.textures:
		texture = texture as War3Texture
		if texture.replaceable_id == 1:
			textures.append(TeamColorTexture.new())
		elif texture.replaceable_id == 2:
			textures.append(TeamGlowTexture.new())
		elif texture.image_file_name:
			var t = load("res://war3/" + texture.image_file_name.replace(".blp", ".dds").to_lower())
			textures.append(t)
		else:
			print("scary texture")
			textures.append(TeamColorTexture.new())
	
	return textures
