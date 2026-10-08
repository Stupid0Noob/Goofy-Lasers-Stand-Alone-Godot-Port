class_name Player
extends CharacterBody3D

@export_group("Player Character")
@export var speed := 0.0
@export var acceleration := 0.0
@export var rotate_speed := 0.0
@export var jump_power := 0.0
@export var decrease_acceleration := 0.0

@onready var pivot: Node3D = %Pivot
@onready var camera: Camera3D = %Camera
@onready var player: Node3D = $Model
@onready var crane: SpringArm3D = %Crane
@onready var _acceleration := acceleration
@onready var forward := player.global_basis.z
@onready var animation_player: AnimationTree = %AnimationTree

var last_move_direction := forward

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("a", "d", "w", "s")
	var move_direction := pivot.global_basis.z * input.y + camera.global_basis.x * input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	if move_direction.length() > 0.2:
		last_move_direction = move_direction
	
	var target := forward.signed_angle_to(last_move_direction, Vector3.UP)
	player.rotation.y = lerp_angle(player.rotation.y, target, rotate_speed * delta)
