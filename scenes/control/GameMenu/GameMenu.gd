extends CanvasLayer


export var paused: bool = false setget set_paused


func set_paused(new_value: bool):
	paused = new_value
	if paused:
		$CenterContainer/MarginContainer/VBoxContainer/PauseGameButton.text = "Unpause"
	else:
		$CenterContainer/MarginContainer/VBoxContainer/PauseGameButton.text = "Pause"
