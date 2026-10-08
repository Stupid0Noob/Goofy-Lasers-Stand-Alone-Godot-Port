extends PlayerState

func activate(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("idle")

func physics_update(_delta: float) -> void:
	var input_direction = Input.get_vector("a", "d", "w", "s") 

	player.velocity.y += player.gravity * _delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("space"):
		finished.emit(JUMPING)
	elif input_direction:
		finished.emit(RUNNING)
