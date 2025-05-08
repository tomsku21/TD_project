extends SupportTower

@export var Attack_effect: CPUParticles2D

func _on_attack_timer_timeout() -> void:
	if not towers.is_empty():
		Attack_effect.emitting = true
		for i in towers.size():
			var target = towers[i]
			await get_tree().create_timer(5).timeout
			target.Heal()
