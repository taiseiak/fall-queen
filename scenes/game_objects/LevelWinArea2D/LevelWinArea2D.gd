extends Area2D


var queen_died = false

func _ready():
	queen_died = false
	connect("body_entered", self, "_on_body_entered")
	GameBodyEventBus.connect("queen_died", self, "_on_queen_died")


func _on_body_entered(body: Node):
	if not queen_died:
		GameBodyEventBus.emit_signal("level_won")


func _on_queen_died():
	queen_died = true
