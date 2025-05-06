extends Node
class_name HealthComponent

@export var character : Node2D
@export var MAX_HEALTH :int = 1000
@export var health: int
var healthbar : ProgressBar


func _ready():
	health = MAX_HEALTH
	healthbar = %HealthBar
	healthbar.visible = false
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health

func damage(damage):
	healthbar = %HealthBar
	health -= damage
	healthbar.visible = true
	healthbar.value = health
	if health <= 0:
		health = 0
		healthbar.value = health
		character.destroy()
