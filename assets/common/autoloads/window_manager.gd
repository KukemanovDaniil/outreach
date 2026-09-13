extends CanvasLayer

@export var inventory_scene: PackedScene
var window_stack: Array = []

func _ready():
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS

func open_window(scene: PackedScene):
	if not scene: return
	
	if not window_stack.is_empty():
		return 

	var win = scene.instantiate()
	add_child(win)
	window_stack.append(win)
	
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_last_window():
	if window_stack.size() > 0:
		var win = window_stack.pop_back()
		if is_instance_valid(win):
			win.queue_free()
	
	if window_stack.is_empty():
		get_tree().paused = false
		if get_tree().current_scene.name != "menu":
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_all_windows():
	for win in window_stack:
		if is_instance_valid(win):
			win.queue_free()
	window_stack.clear()
	get_tree().paused = false
