extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("idle")

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	var input_direction := Input.get_vector("a", "d", "w", "s") 

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_pressed("space"):
		finished.emit(JUMP)
	elif input_direction:
		finished.emit(WALKING)
