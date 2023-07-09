extends Button


func _ready():
	connect("pressed", self, "_on_pressed")


func _on_pressed():
	AudioPlayer.play_button_sound()
	UiEventBus.emit_signal("quit_game")
