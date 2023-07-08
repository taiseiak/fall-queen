extends Node2D
class_name Spring


signal collided
signal extended

## Node to move with the end position of the spring
export(NodePath) var move_node_path

onready var body = $SpringBodySprite as Sprite
onready var base = $SpringBaseSprite as Sprite
onready var end_position = $EndPosition as Position2D
onready var move_node = get_node(move_node_path) as Node2D
onready var collision_area = $SpringBaseSprite/Area2D as Area2D

var tween: SceneTreeTween
var monitoring: bool = true setget _set_monitoring


func _ready():
	collision_area.connect("body_exited", self, "_on_collision_area_body_exited")
	collision_area.connect("body_entered", self, "_on_collision_area_body_entered")


func push(level: float):
	var move_node_original_y_position
	if move_node != null:
		move_node_original_y_position = move_node.position.y
	level = clamp(level, 0.1, 1.0)
	var squish_tween_time = level / 2.0
	tween = create_tween()

	# squish
	tween.set_parallel(true)
	tween.tween_callback($SpringBaseSprite/Area2D, "set", ["monitoring", false])
	tween.tween_property(body, "scale:y", level, squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	# level 0.5 should put the base at 0
	tween.tween_property(end_position, "position:y", 16 * level, squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if move_node != null:
		tween.tween_property(
				move_node,
				"position:y",
				move_node_original_y_position + 16 * level,
				squish_tween_time)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	# extend
	tween.chain().tween_property(body, "scale:y", 1.0, squish_tween_time)\
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

	# reset
	tween.tween_callback(self, "emit_signal", ["extended"])


func _on_collision_area_body_entered(body):
	if tween == null or not tween.is_running():
		emit_signal("collided")
		push(0.5)


func _set_monitoring(value):
	monitoring = value
	$SpringBaseSprite/Area2D.set_deferred("monitoring", true)


func _on_collision_area_body_exited(body: Node):
	set_deferred("monitoring", true)
