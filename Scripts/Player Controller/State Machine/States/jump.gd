extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("jump")

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	var input_direction := Input.get_vector("a", "d", "w", "s") 
	var move_direction := player.pivot.global_basis.z * input_direction.y + player.camera.global_basis.x * input_direction.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	var velocity_y := player.velocity.y
	player.velocity.y = 0.0

	player.acceleration = player._acceleration - player.decrease_acceleration
	player.velocity = player.velocity.move_toward(move_direction * player.speed, player.acceleration * delta)
	player.velocity.y += player.jump_power

	if not player.is_on_floor():
		player.velocity.y = velocity_y - 98 * delta

	player.move_and_slide()

	if player.velocity.y < -10.0:
		finished.emit(FALLING)
