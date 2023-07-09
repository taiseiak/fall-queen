extends Node


var paused: bool = false setget set_paused


func _ready():
	GameBodyEventBus.connect("queen_died", $LevelManager, "load_level",
			["res://scenes/levels/Level.tscn"])
	GameBodyEventBus.connect("level_won", self, "_on_level_won")
	UiEventBus.connect("toggle_pause", self, "_on_toggle_pause")
	UiEventBus.connect("quit_game", self, "_on_quit_game")
	UiEventBus.connect("start_game", self, "_on_start_game")
	$UI/LevelWonUI.visible = false
	$UI/GameMenu.visible = false
	$World.pause_mode = Node.PAUSE_MODE_STOP
	$UI/GameMenu.pause_mode = Node.PAUSE_MODE_PROCESS
	if OS.get_name() == "HTML5":
		if JavaScript.eval("matchMedia('(hover: none)').matches"):
			$TouchScreenButtons.visible = true


func _input(event):
	if event.is_action_pressed("esc"):
		self.paused = not paused


func set_paused(new_value):
	var game_start_ui = get_node_or_null("UI/GameStartUI")
	if game_start_ui != null:
		game_start_ui.visible = paused
	paused = new_value
	$UI/GameMenu.visible = paused
	$UI/GameMenu.paused = paused
	$UI/HUD.visible = not paused
	get_tree().paused = paused


func _on_level_won(win_position):
	$UI/LevelWonUI.visible = true


func _on_toggle_pause():
	self.paused = not paused


func _on_quit_game():
	get_tree().quit()


func _on_start_game():
	var game_start_ui = get_node_or_null("UI/GameStartUI")
	if game_start_ui != null:
		game_start_ui.visible = false
	$LevelManager.load_level("res://scenes/levels/Level.tscn")
	$UI/GameStartUI.queue_free()
