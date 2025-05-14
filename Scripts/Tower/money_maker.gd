extends SupportTower

@export var Attack_effect: CPUParticles2D
@export_category("Plant texture for dropshadow")
@export var plantimg: Texture

func _ready():
	print("money before assigning it: ", stats["Money Made"])

func _on_attack_timer_timeout() -> void:
	Attack_effect.emitting = true
	GlobalVariables.cost += stats["Income"]
	stats["Money Made"] += stats["Income"]
