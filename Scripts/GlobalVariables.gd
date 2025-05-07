extends Node

var enemy_count: int
var spawned_enemies: int
var turrets: Array = []
var player_hp: float = 1000.0
var MAX_HP: float = 1000.0
var cost: int = 0
var current_round: int = 0
var max_rounds: int = 1
var selected_turret
var is_mouse_in_Area2D = false

var normal_cursor = load("res://Assets/cursor/normal.png")
var clicked_cursor = load("res://Assets/cursor/clicked.png")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			Input.set_custom_mouse_cursor(clicked_cursor)
		else:
			Input.set_custom_mouse_cursor(normal_cursor)
	
