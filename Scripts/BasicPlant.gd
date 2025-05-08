extends Tower

func _on_attack_timer_timeout() -> void:
	if not enemies.is_empty():
		$Shoot.pitch_scale = randf_range(0.9, 1.2)
		$Shoot.play()
		var target = enemies[0]
		var new_bullet = bullet.instantiate()
		add_child(new_bullet)
		new_bullet.gun = marker_2d
		new_bullet.target = target
		new_bullet.damage = sdamage
