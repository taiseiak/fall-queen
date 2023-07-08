extends RigidBody2D


export var spring_power: float = 400
export var push_damp_factor: float = 250

onready var spring: Spring = $Spring

var previous_velocity: float
var stop_velocity = false


func _ready():
	$GameOverArea.connect("body_entered", self, "_on_game_over_area_body_entered")
	spring.connect("collided", self, "_on_spring_collided")
	spring.connect("extended", self, "_on_spring_extended")


func _physics_process(delta):
	var horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
	add_torque(80 * horizontal)
	set_angular_velocity(min(PI/8, angular_velocity))


func _on_spring_collided():
	previous_velocity = linear_velocity.length()
	spring.push(previous_velocity / push_damp_factor)
	set_angular_velocity(0.0)


func _on_spring_extended():
	var direction_from_spring = ($CollisionShape2D.global_position - spring.global_position).normalized()
	apply_central_impulse(direction_from_spring * max(50, spring_power * previous_velocity / push_damp_factor))


func _set_to_rigid_and_apply_force(force: float):
	pass


func _on_game_over_area_body_entered(body):
	GameBodyEventBus.emit_signal("queen_died")

