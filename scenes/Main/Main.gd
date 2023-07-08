extends Node


func _ready():
	GameBodyEventBus.connect("queen_died", $LevelManager, "restart_level",
			["res://scenes/levels/Level.tscn"])
