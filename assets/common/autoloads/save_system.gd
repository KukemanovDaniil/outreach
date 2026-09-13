extends Node

const PATH = "user://settings.cfg"
var config = ConfigFile.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_val(section: String, key: String, value):
	config.load(PATH)
	config.set_value(section, key, value)
	config.save(PATH)

func get_val(section: String, key: String, default):
	config.load(PATH)
	return config.get_value(section, key, default)
