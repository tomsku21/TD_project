extends Node
class_name HealthComponent
@export var sprite: AnimatedSprite2D
@export var character : Node2D
@export var MAX_HEALTH :float
@export var health: float
@export var shader_material: ShaderMaterial


func _ready():
	MAX_HEALTH = character.max_health
	health = MAX_HEALTH
	if sprite:
		sprite.material = shader_material.duplicate()
		var material = sprite.material as ShaderMaterial
		material.set_shader_parameter("red_tint_amount", 0.0)

func damage(damage):
	health -= damage
	#print("damage taken: ", damage)
	shader_handler(true)
	if health <= 0:
		health = 0
		character.destroy()


func shader_handler(flash: bool = true):
	var material = sprite.material as ShaderMaterial
	var health_ratio = clamp(float(health) / MAX_HEALTH, 0.0, 0.5)
	material.set_shader_parameter("red_tint_amount", 0.5 - health_ratio)
	if flash:
		for i in 3:
			material.set_shader_parameter("flash_amount", 0.3)
			if character is Enemy:
				if character.grabbed:
					return
			await get_tree().create_timer(0.05).timeout
			material.set_shader_parameter("flash_amount", 0.0)
			if character is Enemy:
				if character.grabbed:
					return
			await get_tree().create_timer(0.05).timeout
