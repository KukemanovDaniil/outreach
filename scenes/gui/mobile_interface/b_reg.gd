extends Button

@export var passby: bool = false

func _ready() -> void:
	ButtonManager.register_button(self)
	
