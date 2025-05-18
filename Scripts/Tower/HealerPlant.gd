extends SupportTower

@export var Attack_effect: CPUParticles2D
@export var heal_range: Heal_Range_Component
var healing: bool = false #I don't like creating this

func _on_attack_timer_timeout() -> void:
	if not heal_range.towers.is_empty():
		#first check if any tower in range is hurt
		healing = false
		for i in heal_range.towers.size():
			var target = heal_range.towers[i]
			if target != null and target.healthcomponent.health < target.healthcomponent.MAX_HEALTH:
				if target.Heal(stats["Healing"], self):
					healing = true
					print("healing")
		if healing:
			Attack_effect.emitting = true
