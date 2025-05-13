extends SupportTower

@export var money: int
@export var Attack_effect: CPUParticles2D
@export_category("Plant texture for dropshadow")
@export var plantimg: Texture

func _on_attack_timer_timeout() -> void:
	Attack_effect.emitting = true
	GlobalVariables.cost += money
