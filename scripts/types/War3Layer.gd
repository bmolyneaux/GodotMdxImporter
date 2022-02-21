extends Resource

enum BlendMode {
	None = 0,
	Transparent = 1,
	Blend = 2,
	Add = 3,
	AddAlpha = 4,
	Modulate = 5,
	Modulate2x = 6
}

enum ShadingFlags {
	Unshaded = 0x1,
	EnvironmentMap = 0x2,
	WrapWidth = 0x4,
	WrapHeight = 0x8,
	TwoSided = 0x10,
	Unfogged = 0x20,
	NoDepthTest = 0x40,
	NoDepthSet = 0x80,
	NoFallback = 0x100,
}

export(int) var filter_mode
export(int) var shading_flags
export(int) var texture_id
export(int) var texture_animation_id
export(int) var coord_id
export(float) var alpha
export(float) var emissive_gain
export(Color) var fresnel_color
export(float) var fresnel_opacity
export(float) var fresnel_team_color
export(Array) var material_alpha
export(Array) var fresnel_alpha
export(Array) var emissions
export(Array) var flipbook_texture_id
