extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("walking")

func physics_update(delta: float) -> void:
	var input_direction := Input.get_vector("a", "d", "w", "s") 
	var move_direction := player.pivot.global_basis.z * input_direction.y + player.camera.global_basis.x * input_direction.x

	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	player.velocity.y = 0.0
	player.velocity = player.velocity.move_toward(move_direction * player.speed, player.acceleration * delta)
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_pressed("space"):
		finished.emit(JUMP)
	elif player.velocity.length() < 1:
		finished.emit(IDLE)
