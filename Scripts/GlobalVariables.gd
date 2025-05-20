extends Node

var game_state: bool = false
var started: bool = false
var game_over: bool = false
var enemies: Array[PathFollow2D]
#var enemy_count: int:
	#set(value):
		#if value >= 0:
			#enemy_count = value
		#else:
			#enemy_count = 0
var turrets: Array = []
var player_hp: float = 1000.0
var MAX_HP: float = 1000.0
var cost: int = 0
var current_round: int = 0
var best_round: int
var max_rounds: int = 15
var selected_turret
var is_mouse_in_Area2D = false
var show_circles = false
var in_mainMenu: bool = true
var normal_cursor = load("res://Assets/cursor/normal.png")
var clicked_cursor = load("res://Assets/cursor/clicked.png")
var fullscreen: bool = false
func _ready() -> void:
	load_game()
	if GlobalVariables.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			Input.set_custom_mouse_cursor(clicked_cursor)
		else:
			Input.set_custom_mouse_cursor(normal_cursor)

func reset():
	save_game()
	enemies.clear()
	game_state = true
	player_hp = MAX_HP
	game_over = false
	cost = 0
	current_round = 0

func save_game(path: String = "user://save.json"):
	var round
	if current_round > best_round:
		round = current_round
	else:
		round = best_round
	var save_data = {
		"round": round,
		"fullscreen": fullscreen
	}
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		print("Saving to file: ", file.get_path())
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
	else:
		print("Failed to open file for writing")

func load_game(path: String = "user://save.json"):
	if not FileAccess.file_exists(path):
		print("Save file not found:", path)
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(json_text)
		if typeof(data) == TYPE_DICTIONARY:
			if data.has("round"):
				var round_data = data["round"]
				best_round = round_data
			if data.has("fullscreen"):
				var screen_data = data["fullscreen"]
				fullscreen = screen_data
