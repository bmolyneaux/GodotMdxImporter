extends Reference

const War3Attachment = preload("../types/War3Attachment.gd")
const War3VisibilityTrack = preload("../types/War3VisibilityTrack.gd")

const MdxNodeParser = preload("./MdxNodeParser.gd")
const MdxUtils = preload("./MdxUtils.gd")


func parse_attachment_visibility(file: File):
	var chunk_id = MdxUtils.get_chunk_id(file)
	print("parse_attachment_visibility")
	assert(chunk_id == "KATV")
	var visibility = War3VisibilityTrack.new()
	var tracks_count = file.get_32()
	visibility.interpolation_type = file.get_32()
	visibility.global_sequence_id = file.get_32()

	for i in tracks_count:
		var time = file.get_32()
		var value = file.get_float()    # visibility value
		visibility.times.append(time)
		visibility.values.append(value)

		var INTERPOLATION_TYPE_LINEAR = 1
		if visibility.interpolation_type > INTERPOLATION_TYPE_LINEAR:
			var in_tan = file.get_float()
			var out_tan = file.get_float()


func parse_attachment(file: File, data_size: int) -> War3Attachment:
	var attachment = War3Attachment.new()
	
	var final_position = file.get_position() + data_size
	
	attachment.node = MdxNodeParser.new().parse_node(file)
	var path = file.get_buffer(260)
	var attachment_id = file.get_32()
	
	if file.get_position() < final_position:
		parse_attachment_visibility(file)
	
	return attachment


func parse(file: File, chunk_size: int) -> Array:
	var attachments = []
	
	var final_position = file.get_position() + chunk_size
	while file.get_position() < final_position:
		var size = file.get_32()
		attachments.append(parse_attachment(file, size - 4))
	
	return attachments
