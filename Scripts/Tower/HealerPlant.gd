extends SupportTower

@export var Attack_effect: CPUParticles2D

func _on_attack_timer_timeout() -> void:
	if not towers.is_empty():
		for i in towers.size():
			var target = towers[i]
			await get_tree().create_timer(5).timeout
			if target != null:
				target.Heal(randi_range(10, 20), self)
		Attack_effect.emitting = true
