extends Node

@export var sub_menu : PackedScene
@export var world_create : PackedScene
@export var tutorial : PackedScene
@export var sub_options : PackedScene
@export var credits : PackedScene

func _ready() -> void:
	%AnimationPlayer.play("intro")

func _connect_menu_buttons():
	for btn in get_tree().get_nodes_in_group("menu_buttons"):
		if btn is Button:
			if not btn.pressed.is_connected(_on_button_pressed):
				btn.pressed.connect(_on_button_pressed.bind(btn.name))

func _on_button_pressed(action: String) -> void:
	SoundManager.play_2d("click")
	
	match action:
		"back":
			WindowManager.close_last_window()
			WindowManager.open_window(sub_menu)
			SoundManager.play_random_music()
			await get_tree().process_frame
			_connect_menu_buttons()
		
		"worlds":
			WindowManager.close_last_window()
			WindowManager.open_window(world_create)
			await get_tree().process_frame
			_connect_menu_buttons()
			
		"tutorial":
			WindowManager.close_last_window()
			WindowManager.open_window(tutorial)
			await get_tree().process_frame
			_connect_menu_buttons()
		
		"sub_options":
			WindowManager.close_last_window()
			WindowManager.open_window(sub_options)
			
			await get_tree().process_frame
			_connect_menu_buttons()
		
		"credits":
			WindowManager.close_last_window()
			WindowManager.open_window(credits)
			
			await get_tree().process_frame
			_connect_menu_buttons()
		
		_:
			print("button not found")

func _intro_finished(anim_name: StringName) -> void:
	%intro.queue_free()
	WindowManager.open_window(sub_menu)
	_connect_menu_buttons()
	await get_tree().create_timer(1.5).timeout
	SoundManager.play_random_music()
