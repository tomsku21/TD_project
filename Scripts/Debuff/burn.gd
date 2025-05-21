extends Node
class_name Burn
@export var main_script: CharacterBody2D

@export_category("Values")
@export var times: int
@export var burn_timeout: float
## Procent Values go like damge - 20%
@export_range(10.0,100.0,10.0, "suffix:%") var max_damage_minus_procent
## Procent Values go like damge - 10%
@export_range(10.0,100.0,10.0, "suffix:%") var min_damage_minus_procent



func FireDebuff(damage: int, attackerPlant: Node2D):
	if main_script:
		var max_damage = ((100 - max_damage_minus_procent) * 0.1) * 0.1
		var min_damage = ((100 - min_damage_minus_procent) * 0.1) * 0.1
		if main_script.taking_damage == false:
			main_script.taking_damage = true
			main_script.burning = true
			for i in range(times):
				if is_instance_valid(attackerPlant):
					if main_script is Enemy:
						if main_script.grabbed:
							return
					main_script.take_damage(damage * randf_range(max_damage, min_damage), attackerPlant)
					await get_tree().create_timer(burn_timeout).timeout
			main_script.taking_damage = false
			main_script.burning = false
	else:
		push_warning("Something is missing!")
