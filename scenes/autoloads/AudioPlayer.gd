extends Node


export(float, -80, -20) var music_sound_level: float = -20 setget set_music_sound_level
export(float, -80, -10) var sound_sound_level: float = -20 setget set_sound_sound_level

var play_music: bool = true setget set_play_music
var play_sounds: bool = true


func play_button_sound():
	if play_sounds:
		$Button.play()


func play_bounce_sound():
	if play_sounds:
		$Bounce.play()


func play_level_win_sound():
	if play_sounds:
		$LevelWin.play()


func set_play_music(new_value: bool):
	play_music = new_value
	$Music.playing = new_value


func set_music_sound_level(new_value: float):
	music_sound_level = new_value
	$Music.volume_db = new_value


func set_sound_sound_level(new_value: float):
	sound_sound_level = new_value
	$Button.volume_db = new_value
	$Bounce.volume_db = new_value
	$LevelWin.volume_db = new_value
