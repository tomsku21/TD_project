extends SupportTower

@export var Attack_effect: CPUParticles2D

func _on_attack_timer_timeout() -> void:
	Attack_effect.emitting = true
	GlobalVariables.cost += stats["Income"]
	stats["Money Made"] += stats["Income"]
