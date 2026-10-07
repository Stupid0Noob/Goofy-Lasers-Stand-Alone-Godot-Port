extends CharacterBody3D

#Camera
@onready var pivot: Node3D = %Pivot
@onready var camera: Camera3D = %Camera
@onready var player: Node3D = $Model
@onready var crane: SpringArm3D = %Crane
@onready var animation_tree: AnimationTree = $AnimationTree

#Variables
@export_group("Camera")
@export_range(0.0, 1.0) var sensitivity := 0.0

@export_group("Player Character")
@export var speed := 0.0
@export var acceleration := 0.0
@export var rotate_speed := 0.0
@export var jump_power := 0.0

@onready var forward := player.global_basis.z
var last_move_direction := forward
var camera_direction := Vector2.ZERO
@onready var _acceleration := acceleration

#Functions
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_released("right_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("scroll_up") and crane.spring_length > 0:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(crane, "spring_length", clamp(crane.spring_length - 15, 0, 0), 0.25)
	if event.is_action_pressed("scroll_down"):
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(crane, "spring_length", crane.spring_length + 15, 0.25)

func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_direction = event.relative * sensitivity

#Functions
func _physics_process(delta: float) -> void:
	pivot.rotation.x -= camera_direction.y * delta
	pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	pivot.rotation.y -= camera_direction.x * delta
	
	camera_direction = Vector2.ZERO
	
	var input := Input.get_vector("a", "d", "w", "s")
	var move_direction := pivot.global_basis.z * input.y + camera.global_basis.x * input.x
	
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	var velocity_y := velocity.y
	velocity.y = 0.0

	velocity = velocity.move_toward(move_direction * speed, acceleration * delta)

	if not is_on_floor():
		velocity.y = velocity_y - 98 * delta
		acceleration = _acceleration - 800

		animation_tree["parameters/walking/blend_amount"] = lerp(animation_tree["parameters/walking/blend_amount"], 0.0, 10.0 * delta)
		animation_tree["parameters/jump/blend_amount"] = lerp(animation_tree["parameters/jump/blend_amount"], 1.0, 10.0 * delta)

		if velocity.y < 0.0:
			animation_tree["parameters/falling/blend_amount"] = lerp(animation_tree["parameters/falling/blend_amount"], 1.0, 10.0 * delta)
	elif Input.is_action_pressed("space") and is_on_floor():
		velocity.y += jump_power
		animation_tree["parameters/jump/blend_amount"] = lerp(animation_tree["parameters/jump/blend_amount"], 0.0, 50.0 * delta)
		animation_tree["parameters/falling/blend_amount"] = lerp(animation_tree["parameters/falling/blend_amount"], 0.0, 50.0 * delta)
	else:
		acceleration = _acceleration
		animation_tree["parameters/falling/blend_amount"] = lerp(animation_tree["parameters/falling/blend_amount"], 0.0, 20.0 * delta)
		animation_tree["parameters/jump/blend_amount"] = lerp(animation_tree["parameters/jump/blend_amount"], 0.0, 10.0 * delta)

	move_and_slide()

	if move_direction.length() > 0.2:
		last_move_direction = move_direction
	
	var target := forward.signed_angle_to(last_move_direction, Vector3.UP)
	player.rotation.y = lerp_angle(player.rotation.y, target, rotate_speed * delta)
	
	var move_speed := velocity.length()
	
	if move_speed > 0 and is_on_floor():
		animation_tree["parameters/walking/blend_amount"] = lerp(animation_tree["parameters/walking/blend_amount"], 1.0, 10.0 * delta)
	else:
		animation_tree["parameters/walking/blend_amount"] = lerp(animation_tree["parameters/walking/blend_amount"], 0.0, 10.0 * delta)
