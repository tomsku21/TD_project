extends Tower

@export_category("Plant texture for dropshadow")
@export var plantimg: Texture

func _on_attack_timer_timeout() -> void:
	print("damage dealt: ", stats["Damage Dealt"])
	if not enemies.is_empty():
		$Shoot.pitch_scale = randf_range(0.9, 1.2)
		$Shoot.play()
		var target = enemies[0]
		var new_bullet = bullet.instantiate()
		add_child(new_bullet)
		new_bullet.gun = marker_2d
		new_bullet.target = target
		new_bullet.damage = stats["Damage"]
