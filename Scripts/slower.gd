extends Tower
@export var Attack_effect: CPUParticles2D

func _on_attack_timer_timeout() -> void:
	if not enemies.is_empty():
		$Shoot.pitch_scale = randf_range(0.9, 1.2)
		$Shoot.play()
		Attack_effect.emitting = true
		for i in enemies.size():
			var target = enemies[i]
			target.SlowDebuff()
