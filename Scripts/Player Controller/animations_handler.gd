extends AnimationTree

@onready var Animator: AnimationTree = $"."

#--THIS IS DISGUTING I CAN'T EVEN SPELL RIGHT
func play(name: String):
	if name == "idle":
		Animator["parameters/walking/blend_amount"] = 0.0
		Animator["parameters/jump/blend_amount"] = 0.0
		Animator["parameters/falling/blend_amount"] = 0.0
	elif name == "walking":
		Animator["parameters/walking/blend_amount"] = 1.0
		Animator["parameters/jump/blend_amount"] = 0.0
		Animator["parameters/falling/blend_amount"] = 0.0
	elif name == "jump":
		Animator["parameters/walking/blend_amount"] = 0.0
		Animator["parameters/jump/blend_amount"] = 1.0
		Animator["parameters/falling/blend_amount"] = 0.0
	elif name == "falling":
		Animator["parameters/walking/blend_amount"] = 0.0
		Animator["parameters/jump/blend_amount"] = 0.0
		Animator["parameters/falling/blend_amount"] = 1.0
