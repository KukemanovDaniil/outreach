extends CharacterBody3D

@export var jump_force: float = 5.0
@export var move_speed: float = 3.0
@export var gravity: float = 9.8

enum State { IDLE, WANDER }
var current_state: State = State.IDLE
var wander_direction: Vector3 = Vector3.ZERO

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	_start_idle()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta)

	move_and_slide()

func _start_idle() -> void:
	current_state = State.IDLE
	timer.start(randf_range(1.0, 2.0)) # Ждем 1-3 секунды

func _start_wander() -> void:
	current_state = State.WANDER
	
	var angle := randf_range(0, TAU)
	wander_direction = Vector3(cos(angle), 0, sin(angle)).normalized()
	
	look_at(global_position + wander_direction, Vector3.UP)
	
	velocity.y = jump_force
	velocity.x = wander_direction.x * move_speed
	velocity.z = wander_direction.z * move_speed
	
	timer.start(randf_range(1.5, 2.5)) 

func _on_timer_timeout() -> void:
	if current_state == State.IDLE:
		_start_wander()
	else:
		_start_idle()
