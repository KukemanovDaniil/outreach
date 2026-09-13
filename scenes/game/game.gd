extends Node3D

const random_ticks = preload("res://assets/common/voxel_terrain/random_ticks/random_ticks.gd")

func _ready() -> void:
	WindowManager.close_all_windows()
	SoundManager.play_random_music()
	
	Debug.create()
	
	var ticks_node = random_ticks.new()
	ticks_node.name = "random_ticks"
	add_child(ticks_node)
