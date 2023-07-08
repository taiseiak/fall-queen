extends RigidBody2D


onready var spring: Spring = $Spring

var previous_velocity: float


func _ready():
	self.connect("body_entered", self, "_on_self_body_entered")
	spring.connect("collided", self, "_on_spring_collided")
	spring.connect("extended", self, "_on_spring_extended")


func _physics_process(delta):
	if sleeping == false:
		var horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
		add_torque(15 * horizontal)


func _on_spring_collided():
	previous_velocity = linear_velocity.length()
	sleeping = true
	# MODE_KINEMATIC = 3
	#set_deferred("mode", 3)
	spring.push(previous_velocity / 150)


func _on_spring_extended():
	call_deferred("_set_to_rigid_and_apply_force", 200)


func _set_to_rigid_and_apply_force(force: float):
	mode = MODE_RIGID
	var direction_from_spring = (global_position - spring.global_position).normalized()
	apply_central_impulse(direction_from_spring * max(50, previous_velocity))


func _on_self_body_entered(body):
	print("collided")

