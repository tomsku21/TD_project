extends SupportTower

@export var Attack_effect: CPUParticles2D
@export var heal_range: Heal_Range_Component

func _on_attack_timer_timeout() -> void:
	if not heal_range.towers.is_empty():
		for i in heal_range.towers.size():
			var target = heal_range.towers[i]
			if target != null:
				target.Heal(stats["Healing"], self)
		Attack_effect.emitting = true
