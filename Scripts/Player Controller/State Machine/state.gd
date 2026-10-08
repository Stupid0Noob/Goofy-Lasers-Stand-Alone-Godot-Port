class_name State
extends Node

signal finished(next_state_path: String, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func activate(previous_state_path: String, data := {}) -> void:
	pass

func deactivate() -> void:
	pass
