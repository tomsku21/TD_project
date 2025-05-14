extends Tower
@export var grabbed: Array = []
var path
func _enter_tree() -> void:
	path = get_tree().get_first_node_in_group("Path")

func _on_attack_timer_timeout() -> void:
	if not enemies.is_empty() and grabbed.is_empty() and enemies[0].grabbed == false:
		var target = enemies[0].get_parent()
		path.remove_child(target)
		grabbed.append(target)
		target.get_child(0).grabbed = true
		target.get_child(0).currently_grabbed = true
		await get_tree().create_timer(10).timeout
		var restored_enemy = grabbed.pop_front()
		path.add_child(restored_enemy)
		target.get_child(0).take_damage(stats["Damage"], self)
		target.get_child(0).currently_grabbed = false
