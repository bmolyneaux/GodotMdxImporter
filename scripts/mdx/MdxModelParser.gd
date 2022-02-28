extends Reference

const MdxBoneParser = preload("../mdx/MdxBoneParser.gd")
const MdxGeosetParser = preload("../mdx/MdxGeosetParser.gd")
const MdxHelperParser = preload("../mdx/MdxHelperParser.gd")
const MdxMaterialParser = preload("../mdx/MdxMaterialParser.gd")
const MdxPivotPointParser = preload("../mdx/MdxPivotPointParser.gd")
const MdxSequenceParser = preload("../mdx/MdxSequenceParser.gd")
const MdxTextureParser = preload("../mdx/MdxTextureParser.gd")
const MdxGeosetAnimationParser = preload("../mdx/MdxGeosetAnimationParser.gd")
const MdxAttachmentParser = preload("../mdx/MdxAttachmentParser.gd")


const MdxUtils = preload("../mdx/MdxUtils.gd")

const War3Model = preload("../types/War3Model.gd")

const CHUNK_MDX_MODEL = 'MDLX'

const CHUNK_VERSION = 'VERS'
const CHUNK_GEOSET = 'GEOS'
const CHUNK_TEXTURE = 'TEXS'
const CHUNK_MATERIAL = 'MTLS'
const CHUNK_MODEL = 'MODL'
const CHUNK_BONE = 'BONE'
const CHUNK_PIVOT_POINT = 'PIVT'
const CHUNK_HELPER = 'HELP'
const CHUNK_ATTACHMENT = 'ATCH'
const CHUNK_EVENT_OBJECT = 'EVTS'
const CHUNK_COLLISION_SHAPE = 'CLID'
const CHUNK_SEQUENCE = 'SEQS'
const CHUNK_GEOSET_ANIMATION = 'GEOA'

const CHUNKS = [
	CHUNK_VERSION,
	CHUNK_GEOSET,
	CHUNK_TEXTURE,
	CHUNK_MATERIAL,
	CHUNK_MODEL,
	CHUNK_BONE,
	CHUNK_PIVOT_POINT,
	CHUNK_HELPER,
	CHUNK_ATTACHMENT,
	CHUNK_EVENT_OBJECT,
	CHUNK_COLLISION_SHAPE,
	CHUNK_SEQUENCE,
	CHUNK_GEOSET_ANIMATION,
	"GLBS",
	"PRE2",
	"RIBB",
	"CAMS",
	"LITE",
]

func parse_chunk(file: File, model: War3Model, chunk_id: String, chunk_size: int) -> void:
	if chunk_id == CHUNK_VERSION:
		model.Version = file.get_32()
	elif chunk_id == CHUNK_TEXTURE:
		model.textures = MdxTextureParser.new().parse(file, chunk_size)
	elif chunk_id == CHUNK_MATERIAL:
		model.materials = MdxMaterialParser.new().parse(file, chunk_size, model.Version)
	elif chunk_id == CHUNK_GEOSET:
		model.geosets = MdxGeosetParser.new().parse(file, chunk_size, model.Version)
	elif chunk_id == CHUNK_BONE:
		model.nodes.append_array(MdxBoneParser.new().parse(file, chunk_size, model.Version))
	elif chunk_id == CHUNK_PIVOT_POINT:
		model.pivot_points = MdxPivotPointParser.new().parse(file, chunk_size)
	elif chunk_id == CHUNK_SEQUENCE:
		model.sequences = MdxSequenceParser.new().parse(file, chunk_size)
	elif chunk_id == CHUNK_HELPER:
		model.nodes.append_array(MdxHelperParser.new().parse(file, chunk_size, model.Version))
	elif chunk_id == CHUNK_GEOSET_ANIMATION:
		model.geoset_animations = MdxGeosetAnimationParser.new().parse(file, chunk_size, model.Version)
	elif chunk_id == CHUNK_ATTACHMENT:
		model.nodes.append_array(MdxAttachmentParser.new().parse(file, chunk_size))
	elif chunk_id == CHUNK_MODEL:
		model.name = file.get_buffer(0x50).get_string_from_utf8()
		var animation_file = file.get_buffer(0x104).get_string_from_utf8()
		var bounds_radius = file.get_float()
		var minimum_extent = MdxUtils.get_vector3(file)
		var maximum_extent = MdxUtils.get_vector3(file)
		var blend_time = file.get_32()


func parse(file: File) -> War3Model:
	var file_size = file.get_len()
	
	var model = War3Model.new()
	
	assert(MdxUtils.get_chunk_id(file) == CHUNK_MDX_MODEL)
	
	while not file.eof_reached() and file.get_position() < file_size:
		
		var chunk_id = MdxUtils.get_chunk_id(file)
		assert(chunk_id in CHUNKS, "Unexpected chunk %s" % chunk_id)
		
		var chunk_size = file.get_32()
		assert(chunk_size != 0)
		
		var next_position = file.get_position() + chunk_size
		parse_chunk(file, model, chunk_id, chunk_size)
		file.seek(next_position)
	
	return model
