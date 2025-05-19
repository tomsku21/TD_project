extends Enemy

func _physics_process(delta: float) -> void:
	if end == false:
		pathfollow.progress += current_speed * delta
	if pathfollow.progress_ratio >= 0.99:
		if attack_timer.is_stopped():
			attack_timer.start()
			end = true
	else:
		check_turret()
	if grabbed == true and currently_grabbed == false:
		await get_tree().create_timer(10).timeout
		grabbed = false
	if life_tree == null:
		life_tree = get_tree().get_first_node_in_group("LifeTree")
