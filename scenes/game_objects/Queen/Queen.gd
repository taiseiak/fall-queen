extends RigidBody2D


export var spring_power: float = 400
export var push_damp_factor: float = 250
## Overrides the push power of the spring
export(float, 0.0, 1.0, 0.01) var push_power_override: float = 0

onready var spring: Spring = $Spring

var dumb_mode: bool = false setget set_dumb_mode
var previous_velocity: float
var stop_velocity = false


func _ready():
	GameBodyEventBus.connect("level_won", self, "_on_level_won")
	$GameOverArea.connect("body_entered", self, "_on_game_over_area_body_entered")
	spring.connect("collided", self, "_on_spring_collided")
	spring.connect("extended", self, "_on_spring_extended")


func _physics_process(delta):
	if not dumb_mode:
		var horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
		add_torque(80 * horizontal)
	angular_velocity = clamp(angular_velocity, -PI/4, PI/4)


func set_dumb_mode(new_value: bool):
	dumb_mode = new_value
	$GameOverArea.monitoring = not dumb_mode


func _on_spring_collided():
	previous_velocity = linear_velocity.length()
	if push_power_override > 0:
		spring.push(push_power_override)
	else:
		spring.push(previous_velocity / push_damp_factor)
	angular_velocity = 0.0
	$AnimationPlayer.play("compress")


func _on_spring_extended():
	var direction_from_spring = ($CollisionShape2D.global_position - spring.global_position).normalized()
	if push_power_override > 0:
		apply_central_impulse(direction_from_spring * max(50, spring_power))
	else:
		apply_central_impulse(direction_from_spring * max(50, spring_power * previous_velocity / push_damp_factor))
	$AnimationPlayer.play_backwards("compress")


func _on_level_won(win_position):
	self.dumb_mode = true
	spring.enabled = false


func _on_game_over_area_body_entered(body: Node):
	GameBodyEventBus.emit_signal("queen_died")
