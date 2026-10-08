class_name PlayerState
extends State

const IDLE = "Idle"
const WALKING = "Walking"
const JUMP = "Jump"
const FALLING = "Falling"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "no plaaaayer in scene noooooooooooooooooob")
