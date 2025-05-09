extends Node
class_name Slow
@export var main_script: CharacterBody2D
@export var timer: Timer
@export_category("Values")
@export_range(10.0,100.0,10.0, "%") var slow_debuff

func SlowDebuff():
	if main_script and timer:
		var result = ((100 - slow_debuff) * 0.1) * 0.1
		var material = main_script.sprite.material as ShaderMaterial
		material.set_shader_parameter("ice_tint_amount", 0.6)
		main_script.current_speed = main_script.speed * result
		timer.start()
	else:
		push_warning("Something is missing!")

func _on_slow_debuff_timeout() -> void:
	var material = main_script.sprite.material as ShaderMaterial
	material.set_shader_parameter("ice_tint_amount", 0.0)
	main_script.current_speed = main_script.speed
	timer.stop()
