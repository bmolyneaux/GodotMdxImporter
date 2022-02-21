extends Reference

const MdxUtils = preload("../mdx/MdxUtils.gd")


func parse(file: File, chunk_size: int):
	var pivot_points = []
	
	assert(chunk_size % 12 == 0)
	
	for i in chunk_size / 12:
		pivot_points.append(MdxUtils.get_bone_transform(file))
		
	return pivot_points
