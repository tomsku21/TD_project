extends Node

@export var spawn_timer: Timer

@export var path: Path2D

@export var enemys: Dictionary = {
	0: preload("res://Scenes/Enemies/enemy.tscn"),
	1: preload("res://Scenes/Enemies/enemy2.tscn")
}
var enemies: Array = []

var enemy_count: int
func _ready() -> void:
	spawn_timer.start()

func _process(_delta: float) -> void:
	for enemy in enemies:
		if enemy.progress_ratio >= 0.99:
			enemies.erase(enemy)
			enemy.queue_free()
			enemy_count -= 1

func _on_timer_timeout() -> void:
	if enemy_count < 300:
		var rand = randi_range(0,1)
		var new_enemy = enemys[rand].instantiate()
		path.add_child(new_enemy)
		enemies.append(new_enemy)
		enemy_count += 1
