extends Node
class_name Poison

@export var main_script: CharacterBody2D

@export_category("Values")
@export var times: int
@export var poison_timeout: float
@export_range(0.0,50.0,1.0, "int") var max_damage
@export_range(0.0,50.0,1.0, "int") var min_damage

func PoisonDebuff(attackerPlant: Area2D):
	if main_script != null:
		if main_script.taking_damage == false:
			main_script.taking_damage = true
			main_script.poisoned = true
			for i in times:
				main_script.take_damage(randi_range(max_damage,min_damage), attackerPlant)
				await get_tree().create_timer(poison_timeout).timeout
			main_script.taking_damage = false
			main_script.poisoned = false
	else:
		push_warning("Something is missing!")
