@tool extends Button

var block_id: int = 0
var block_name: String = "none"

static var atlas_tex := preload("res://assets/textures/block_atlas.png")

func setup_slot(id: int, b_name: String, atlas_pos: Vector2i) -> void:
	block_id = id
	block_name = b_name
	
	var atlas_sub_tex = AtlasTexture.new()
	atlas_sub_tex.atlas = atlas_tex
	atlas_sub_tex.region = Rect2(atlas_pos.x * 16, atlas_pos.y * 16, 16, 16)

	%icon.texture = atlas_sub_tex
	self.expand_icon = true
	self.text = "" 

func _pressed() -> void:
	SoundManager.play_2d("click")
	
	TextAnim.call("spawn_floating_text", self, block_name)
	GlobalValues.current_block = block_id
