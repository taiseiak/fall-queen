extends Area2D


var queen_died = false

func _ready():
	queen_died = false
	connect("body_entered", self, "_on_body_entered")
	GameBodyEventBus.connect("queen_died", self, "_on_queen_died")


func _on_body_entered(body: Node2D):
	if not queen_died:
		GameBodyEventBus.emit_signal("level_won",
				Vector2(body.global_position.x, global_position.y))
		AudioPlayer.play_level_win_sound()


func _on_queen_died():
	queen_died = true
