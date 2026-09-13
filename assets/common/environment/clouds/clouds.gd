extends Node3D

func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		var target_pos = camera.global_position
		target_pos.y = 0.0
		global_position = target_pos
