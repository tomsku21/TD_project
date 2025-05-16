extends SupportTower

@export var Attack_effect: CPUParticles2D
@export var heal_range: Heal_Range_Component

func _on_attack_timer_timeout() -> void:
	print("trying to heal")
	if not heal_range.towers.is_empty():
		print("there is a healable tower to pump")
		for i in heal_range.towers.size():
			print("going through towers")
			var target = heal_range.towers[i]
			if target != null:
				print("pushing out the wave")
				target.Heal(stats["Healing"], self)
		Attack_effect.emitting = true
