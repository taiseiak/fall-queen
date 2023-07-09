extends CanvasLayer


export var paused: bool = false setget set_paused

onready var music_toggle = $CenterContainer/MarginContainer/VBoxContainer/HBoxContainer/MusicCheck \
		as CheckButton
onready var music_scroll = $CenterContainer/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/MusicScroll
onready var sound_toggle = $CenterContainer/MarginContainer/VBoxContainer/HBoxContainer2/CheckButton\
		as CheckButton
onready var sound_scroll = $CenterContainer/MarginContainer/VBoxContainer/HBoxContainer2/CenterContainer/SoundScroll


func _ready():
	music_toggle.connect("toggled", self, "_on_music_toggle_toggled")
	sound_toggle.connect("toggled", self, "_on_sound_toggle_toggled")

	music_scroll.connect("value_changed", self, "_on_music_scroll_changed")
	sound_scroll.connect("value_changed", self, "_on_sound_scroll_changed")


func set_paused(new_value: bool):
	paused = new_value
	if paused:
		$CenterContainer/MarginContainer/VBoxContainer/PauseGameButton.text = "Unpause"
	else:
		$CenterContainer/MarginContainer/VBoxContainer/PauseGameButton.text = "Pause"


func _on_music_toggle_toggled(button_pressed):
	AudioPlayer.play_music = button_pressed


func _on_sound_toggle_toggled(button_pressed):
	AudioPlayer.play_sounds = button_pressed


func _on_music_scroll_changed(value):
	AudioPlayer.music_sound_level = value


func _on_sound_scroll_changed(value):
	AudioPlayer.sound_sound_level = value
