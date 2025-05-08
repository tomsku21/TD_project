extends Node

@onready var spawn_timer: Timer = $SpawnTimer

@onready var path: Path2D = $"../TileMap/Road/Path2D"

@export var enemys: Dictionary = {
	0: preload("res://Scenes/Enemies/enemy.tscn"),
	1: preload("res://Scenes/Enemies/enemy2.tscn")
}

@export var rounds := []

var time: float

func _ready() -> void:
	GlobalVariables.cost += 100
	spawn_timer.start()

func _physics_process(delta: float) -> void:
	if GlobalVariables.spawned_enemies >= rounds[GlobalVariables.current_round]:
		spawn_timer.stop()
		if GlobalVariables.enemy_count == 0:
			GlobalVariables.spawned_enemies = 0
			if GlobalVariables.current_round < GlobalVariables.max_rounds:
				GlobalVariables.cost += 3
				GlobalVariables.current_round += 1
			spawn_timer.start()

func _on_timer_timeout() -> void:
	var new_enemy = enemys[GlobalVariables.current_round].instantiate()
	path.add_child(new_enemy)
	#new_enemy.get_child(0).speed = randi_range(50, 60)
	#new_enemy.get_child(0).sdamage = randi_range(5, 10)
	
	GlobalVariables.enemy_count += 1
	GlobalVariables.spawned_enemies += 1
