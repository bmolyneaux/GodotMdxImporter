extends Reference


static func get_chunk_id(file: File) -> String:
	return file.get_buffer(4).get_string_from_utf8()


static func get_vector3(file: File) -> Vector3:
	var x = file.get_float()
	var y = file.get_float()
	var z = file.get_float()
	return Vector3(x, z, -y)


static func get_rotation(file: File) -> Quat:
	var x = file.get_float()
	var y = file.get_float()
	var z = file.get_float()
	var w = file.get_float()
	return Quat(x, z, -y, w)


static func get_bone_transform(file: File) -> Transform:
	var x = file.get_float()
	var y = file.get_float()
	var z = file.get_float()
	return Transform(
		Vector3(1, 0, 0),
		Vector3(0, 1, 0),
		Vector3(0, 0, 1),
		Vector3(x, z, -y)
		)


static func get_color(file: File) -> Color:
	var r = file.get_float()
	var g = file.get_float()
	var b = file.get_float()
	return Color(r, g, b)
