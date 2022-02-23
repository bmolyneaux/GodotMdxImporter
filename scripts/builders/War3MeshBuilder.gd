extends Reference

const War3Geoset = preload("../types/War3Geoset.gd")
const War3Model = preload("../types/War3Model.gd")


func build_meshes(model: War3Model) -> Array:
	var meshes = []

	for geoset in model.geosets:
		geoset = geoset as War3Geoset
		var mesh = ArrayMesh.new()
		
		var arrays = []
		arrays.resize(Mesh.ARRAY_MAX)
		
		var bones_array = PoolIntArray()
		
		var weights_array = PoolRealArray()
		
		for vertex_group_ids in geoset.vertex_groups:
			bones_array.append_array([vertex_group_ids[0], 0, 0, 0])
			weights_array.append_array([1, 0, 0, 0])
			
			# Theoretically, this should be the code, but the results don't look right
#			var bones = []
#			var weights = []
#			for i in 4:
#				if i < len(vertex_group_ids):
#					bones.append(vertex_group_ids[i])
#					weights.append(1)
#				else:
#					bones.append(0)
#					weights.append(0)
#			assert(len(bones) == 4)
#			assert(len(weights) == 4)
#			bones_array.append_array(bones)
#			weights_array.append_array(weights)
		
		arrays[Mesh.ARRAY_VERTEX] = PoolVector3Array(geoset.vertices)
		arrays[Mesh.ARRAY_TEX_UV] = PoolVector2Array(geoset.uvs)
		arrays[Mesh.ARRAY_NORMAL] = PoolVector3Array(geoset.normals)
		arrays[Mesh.ARRAY_INDEX] = PoolIntArray(geoset.faces)
		arrays[Mesh.ARRAY_BONES] = bones_array
		arrays[Mesh.ARRAY_WEIGHTS] = weights_array
		
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		
		meshes.append(mesh)

	return meshes
