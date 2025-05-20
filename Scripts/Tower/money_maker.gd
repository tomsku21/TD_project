extends SupportTower

@export var Attack_effect: CPUParticles2D
var round_running: bool = false

func _enter_tree():
	SignalBus.NextRound.connect(_round_end)
	SignalBus.RoundStart.connect(_round_start)

func _on_attack_timer_timeout() -> void:
	if round_running:
		Attack_effect.emitting = true
		GlobalVariables.cost += stats["Income"]
		stats["Money Made"] += stats["Income"]

func _round_end():
	round_running = false

func _round_start():
	round_running = true
