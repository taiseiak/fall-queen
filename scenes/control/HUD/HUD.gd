extends CanvasLayer


func _ready():
	$MarginContainer/PauseButton.connect("pressed", self, "_on_pause_button_pressed")


func _on_pause_button_pressed():
	UiEventBus.emit_signal("toggle_pause")
	$MarginContainer/PauseButton.pressed = false
