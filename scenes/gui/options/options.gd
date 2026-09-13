extends PanelContainer

@onready var buttons = {
	"clouds": %clouds_button,
	"v_sync": %v_sync_button
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	sync_ui_with_values()

func sync_ui_with_values():
	for key in buttons:
		if key in GlobalValues:
			buttons[key].button_pressed = GlobalValues.get(key)
	
	if "render_distance" in GlobalValues:
		%render_distance.value = GlobalValues.render_distance
	if "update_distance" in GlobalValues:
		%update_distance.value = GlobalValues.update_distance
	if "fov" in GlobalValues:
		%fov.value = GlobalValues.fov
	if "music_volume" in GlobalValues:
		%music_volume.value = GlobalValues.music_volume * 100.0
	if "sfx_volume" in GlobalValues:
		%sfx_volume.value = GlobalValues.sfx_volume * 100.0

func _on_button_pressed(action: String) -> void:
	match action:
		"clouds":
			GlobalValues.clouds = !GlobalValues.clouds
			Debug._setup_clouds()
		"v_sync":
			GlobalValues.v_sync = !GlobalValues.v_sync
			var mode = DisplayServer.VSYNC_ENABLED if GlobalValues.v_sync else DisplayServer.VSYNC_DISABLED
			DisplayServer.window_set_vsync_mode(mode)
	
	if action in GlobalValues:
		SaveSystem.set_val("options", action, GlobalValues.get(action))

func _on_render_distance_value_changed(value: float) -> void:
	GlobalValues.render_distance = int(value)
	Debug._setup_environment() 
	Debug._setup_render_distance()
	SaveSystem.set_val("options", "render_distance", GlobalValues.render_distance)


func _on_fov_value_changed(value: float) -> void:
	GlobalValues.fov = int(value)
	SaveSystem.set_val("options", "fov", GlobalValues.fov)


func _on_music_value_changed(value: float) -> void:
	GlobalValues.music_volume = value / 100.0
	
	SoundManager.sync_music_volume()
	
	SaveSystem.set_val("audio", "music_volume", GlobalValues.music_volume)

func _on_sfx_value_changed(value: float) -> void:
	GlobalValues.sfx_volume = value / 100.0
	
	SaveSystem.set_val("audio", "sfx_volume", GlobalValues.sfx_volume)


func _on_update_distance_value_changed(value: float) -> void:
	GlobalValues.update_distance = int(value)
	SaveSystem.set_val("options", "update_distance", GlobalValues.update_distance)
