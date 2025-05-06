extends Node

@onready var spawn_timer: Timer = $SpawnTimer

@onready var path: Path2D = $"../TileMap/Road/Path2D"

@export var enemys: Dictionary = {
	0: preload("res://Scenes/enemy.tscn")
}
var time: float

func _ready() -> void:
	spawn_timer.start()

func _on_timer_timeout() -> void:
	#time = randf_range(5.0, 20.0)
	#spawn_timer.wait_time = time
	
	var new_enemy = enemys[0].instantiate()
	path.add_child(new_enemy)
	new_enemy.get_child(0).speed = randi_range(70, 100)
	new_enemy.get_child(0).sdamage = randi_range(5, 10)
	
	GlobalVariables.enemy_count += 1
