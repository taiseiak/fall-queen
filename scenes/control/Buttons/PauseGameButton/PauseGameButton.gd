extends Button


func _ready():
	connect("pressed", self, "_on_pressed")


func _on_pressed():
	UiEventBus.emit_signal("toggle_pause")
