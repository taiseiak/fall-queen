extends RigidBody2D


onready var spring: Spring = $Spring

var previous_velocity: float
var stop_velocity = false


func _ready():
	$GameOverArea.connect("body_entered", self, "_on_game_over_area_body_entered")
	spring.connect("collided", self, "_on_spring_collided")
	spring.connect("extended", self, "_on_spring_extended")


func _physics_process(delta):
	var horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
	add_torque(90 * horizontal)
	set_angular_velocity(min(PI, angular_velocity))


func _on_spring_collided():
	previous_velocity = linear_velocity.length()
	print(previous_velocity)
	spring.push(previous_velocity / 200)


func _on_spring_extended():
	var direction_from_spring = ($CollisionShape2D.global_position - spring.global_position).normalized()
	apply_central_impulse(direction_from_spring * 100)


func _set_to_rigid_and_apply_force(force: float):
	pass


func _on_game_over_area_body_entered(body):
	GameBodyEventBus.emit_signal("queen_died")

