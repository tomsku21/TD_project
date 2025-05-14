extends SupportTower

@export var Attack_effect: CPUParticles2D


func _on_attack_timer_timeout() -> void:
	if not towers.is_empty():
		for i in towers.size():
			var target = towers[i]
			if target != null:
				target.Heal(stats["Healing"], self)
		Attack_effect.emitting = true
