extends Reference

const War3Model = preload("../types/War3Model.gd")


func build(model: War3Model, meshes: Array, materials: Array, skins: Array) -> Array:
	var mesh_instances = []
	
	for mesh_index in len(meshes):
		var material_id = model.geosets[mesh_index].material_id
		var mesh = meshes[mesh_index]
		var mesh_instance = MeshInstance.new()
		mesh_instance.mesh = mesh
		mesh_instance.name = str(mesh_index)
		mesh_instance.set_surface_material(0, materials[material_id])
		
		mesh_instance.skin = skins[mesh_index]
		
		mesh_instances.append(mesh_instance)
	
	return mesh_instances
