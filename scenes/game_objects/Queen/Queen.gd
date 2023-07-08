extends RigidBody2D


onready var spring: Spring = $Spring


func _process(delta):
	if self is RigidBody2D:
		# print("linear_velocity ", linear_velocity)
		pass

func _ready():
	spring.connect("collided", self, "_on_spring_collided")
	spring.connect("extended", self, "_on_spring_extended")


func _on_spring_collided():
	# MODE_KINEMATIC = 3
	sleeping = true
	set_deferred("mode", 3)
	pass

func _on_spring_extended():
	# MODE_RIGID = 0
	call_deferred("_set_to_rigid_and_apply_force", 200)

func _set_to_rigid_and_apply_force(force: float):
	mode = MODE_RIGID
	var direction_from_spring = (global_position - spring.global_position).normalized()
	apply_central_impulse(direction_from_spring * 200)
	print("applied inpulse")
