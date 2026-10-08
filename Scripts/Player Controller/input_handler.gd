extends Node

@export_group("Camera")
@export_range(0.0, 1.0) var sensitivity: float
@export var camera_direction: Vector2
@export var scroll_up: bool
@export var scroll_down: bool

@export_group("Movement")
@export var space: bool
@export var input_direction: Vector2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_released("right_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("scroll_up"):
		scroll_up = true
	if event.is_action_released("scroll_up"):
		scroll_up = false
	if event.is_action_pressed("scroll_down"):
		scroll_down = true
	if event.is_action_released("scroll_down"):
		scroll_down = false
	if event.is_action_pressed("space"):
		space = true
	if event.is_action_released("space"):
		space = false

func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_direction = event.relative * sensitivity
	
	input_direction = Input.get_vector("a", "d", "w", "s")
