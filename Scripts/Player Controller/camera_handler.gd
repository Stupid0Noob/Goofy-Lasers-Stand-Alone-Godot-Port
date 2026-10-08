extends Node

@onready var input_handler: Node = %InputHandler
var camera_direction = input_handler.camera_direction

@export var pivot: Node3D
@export var camera: Camera3D
@export var crane: SpringArm3D

func _physics_process(delta: float) -> void:
	pivot.rotation.x -= camera_direction.y * delta
	pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	pivot.rotation.y -= camera_direction.x * delta
	
	camera_direction = Vector2.ZERO
