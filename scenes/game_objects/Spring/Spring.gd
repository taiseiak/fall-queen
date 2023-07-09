extends Area2D
class_name Spring


signal collided
signal extended

## Node to move with the end position of the spring
export(NodePath) var move_node_path
export var enabled: bool = true

onready var spring_body = $SpringBodySprite as Sprite
onready var end_position = $EndPosition as Position2D
onready var move_node = get_node(move_node_path) as Node2D

var tween: SceneTreeTween
var ready: bool = true


func _ready():
	connect("body_exited", self, "_on_collision_area_body_exited")
	connect("body_entered", self, "_on_collision_area_body_entered")
	$SpringTimer.connect("timeout", self, "_on_spring_timer_timeout")


func push(level: float):
	if not ready or not enabled:
		return
	var move_node_original_y_position
	if move_node != null:
		move_node_original_y_position = move_node.position.y
	level = clamp(level, 0.1, 1.0)
	var squish_tween_time = level / 2.0
	tween = create_tween()

	# squish
	tween.set_parallel(true)
	tween.tween_callback(self, "set", ["ready", false])
	tween.tween_property(spring_body, "scale:y", 1 - level, squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	# level 0.5 should put the base at 0
	tween.tween_property(end_position, "position:y", 16 * level, squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback($CPUParticles2D, "set", ["emitting", true])
	if move_node != null:
		tween.tween_property(
				move_node,
				"position:y",
				move_node_original_y_position + min(16 * level + 4, 16),
				squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	# extend
	tween.chain().tween_property(spring_body, "scale:y", 1.0, squish_tween_time)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(end_position, "position:y", 0.0, squish_tween_time)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	if move_node != null:
		tween.tween_property(
				move_node,
				"position:y",
				move_node_original_y_position,
				squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(self, "emit_signal", ["extended"])
	tween.tween_callback($CPUParticles2D, "set", ["emitting", false])


func _on_collision_area_body_entered(body: Node):
	if tween == null or not tween.is_running():
		emit_signal("collided")
		$SpringTimer.start()


func _on_collision_area_body_exited(body: Node):
	ready = true
	$SpringTimer.stop()


func _on_spring_timer_timeout():
	if self.get_overlapping_bodies().size() > 0:
		ready = true
		push(0.5)
