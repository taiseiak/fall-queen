extends CanvasLayer


func _ready():
	$AButton.connect("pressed", self, "_on_a_button_pressed")
	$DButton.connect("pressed", self, "_on_d_button_pressed")


func _on_a_button_pressed():
	print("a")


func _on_d_button_pressed():
	print("d")
