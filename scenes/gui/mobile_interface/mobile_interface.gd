extends CanvasLayer

func _ready() -> void:
	if OS.get_name() in ["Windows", "Linux"]:
		queue_free()
		return
