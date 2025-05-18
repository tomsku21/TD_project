extends Node
@export var spawn_timer: Timer
@export var paths: Array[Path2D] = []
@export var enemys: Dictionary = {
	0: preload("res://Scenes/Enemies/Boss.tscn"),
	1: preload("res://Scenes/Enemies/enemy.tscn"),
	2: preload("res://Scenes/Enemies/enemy2.tscn"),
	3: preload("res://Scenes/Enemies/enemy3.tscn"),
	4: preload("res://Scenes/Enemies/enemy4.tscn"),
}

@export var rounds := []

var spawned_per_type: Array = []
var current_type_index: int = 0

func _ready() -> void:
	GlobalVariables.cost += 100
	if rounds.size() > 0:
		spawned_per_type.resize(rounds[0].size())
		spawned_per_type.fill(0)

func _physics_process(_delta: float) -> void:
	if GlobalVariables.game_state:
		if GlobalVariables.started == false:
			spawn_timer.start()
			GlobalVariables.started = true
		else:
			var all_spawned = true
			for type_index in rounds[GlobalVariables.current_round].size():
				if spawned_per_type[type_index] < rounds[GlobalVariables.current_round][type_index]:
					all_spawned = false
					break
			if all_spawned:
				spawn_timer.stop()
				if GlobalVariables.enemy_count == 0:
					current_type_index = 0
					spawned_per_type.fill(0)
					if GlobalVariables.current_round <= GlobalVariables.max_rounds:
						GlobalVariables.cost += 3
						if GlobalVariables.current_round != GlobalVariables.max_rounds:
							GlobalVariables.current_round += 1
							GlobalVariables.save_game()
						if GlobalVariables.current_round < rounds.size():
							spawned_per_type.resize(rounds[GlobalVariables.current_round].size())
							spawned_per_type.fill(0)
							GlobalVariables.game_state = false
							GlobalVariables.started = false
							SignalBus.NextRound.emit()
	else:
		spawn_timer.stop()
		GlobalVariables.started = false

func _on_timer_timeout() -> void:
	var round_data = rounds[GlobalVariables.current_round]
	while current_type_index < round_data.size():
		if spawned_per_type[current_type_index] < round_data[current_type_index]:
			if current_type_index in enemys:
				var new_enemy = enemys[current_type_index].instantiate()
				var path = paths.pick_random()
				new_enemy.get_child(0).path = path
				path.add_child(new_enemy)
				GlobalVariables.enemy_count += 1
				spawned_per_type[current_type_index] += 1
			break
		else:
			current_type_index += 1
