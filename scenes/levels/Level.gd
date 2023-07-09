extends Node2D


var victory_queen_path = "res://scenes/game_objects/VictoryQueen/VictoryQueen.tscn"


func _ready():
	GameBodyEventBus.connect("level_won", self, "_on_level_won")


func _on_level_won(win_position: Vector2):
	var victory_queen_node: Node = null
	if ResourceLoader.exists(victory_queen_path):
		victory_queen_node = ResourceLoader.load(victory_queen_path).instance()
	if victory_queen_node == null:
		return

	victory_queen_node.global_position = win_position
	add_child(victory_queen_node)
	$Queen.queue_free()
