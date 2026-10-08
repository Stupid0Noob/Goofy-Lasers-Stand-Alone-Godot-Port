extends Node

@onready var pivot: Node3D = %Pivot
@onready var camera: Camera3D = %Camera
@onready var crane: SpringArm3D = %Crane

@export_group("Camera")
@export_range(0.0, 1.0) var sensitivity := 0.0

var camera_direction = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_released("right_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("scroll_up") and crane.spring_length > 0:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(crane, "spring_length", clamp(crane.spring_length - 15, 0, 100), 0.25)
	if event.is_action_pressed("scroll_down"):
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(crane, "spring_length", clamp(crane.spring_length + 15, 0, 100), 0.25)

func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_direction = event.relative * sensitivity

func _physics_process(delta: float) -> void:
	pivot.rotation.x -= camera_direction.y * delta
	pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	pivot.rotation.y -= camera_direction.x * delta
	
	camera_direction = Vector2.ZERO
