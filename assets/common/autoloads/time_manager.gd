extends WorldEnvironment

@export var day_length: float = 125.0
@export var time_gradient: Gradient

var sky_material: Material

func _ready() -> void:
	if not environment or not environment.sky:
		push_error("WorldEnvironment: Sky")
		set_process(false)
		return
		
	sky_material = environment.sky.sky_material
	if not sky_material:
		push_error("Sky: SkyMaterial!")
		set_process(false)
		return

	if not time_gradient:
		_create_default_gradient()

func _process(delta: float) -> void:
	if not ("time" in GlobalValues):
		push_error("GlobalValues: time!")
		set_process(false)
		return

	var time_step: float = (24.0 / day_length) * delta
	GlobalValues.time = fmod(GlobalValues.time + time_step, 24.0)
	
	var gradient_position: float = GlobalValues.time / 24.0
	var current_sky_color: Color = time_gradient.sample(gradient_position)
	
	if "sky_top_color" in sky_material:
		sky_material.set("sky_top_color", current_sky_color)
	if "sky_horizon_color" in sky_material:
		sky_material.set("sky_horizon_color", current_sky_color)

func _create_default_gradient() -> void:
	time_gradient = Gradient.new()
	time_gradient.clear_points()
	time_gradient.add_point(0.0, Color("0a0a14"))
	time_gradient.add_point(0.25, Color("f64343"))
	time_gradient.add_point(0.5, Color("7eccfa"))
	time_gradient.add_point(0.75, Color("f64343"))
	time_gradient.add_point(1.0, Color("0a0a14"))
