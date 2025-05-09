extends Node
class_name HealthComponent
var sprite
@export var character : Node2D
@export var MAX_HEALTH :float
@export var health: float
@export var shader_material: ShaderMaterial


func _ready():
	MAX_HEALTH = character.max_health
	health = MAX_HEALTH
	if get_parent().has_node("AnimatedSprite2D"):
		sprite = get_parent().get_node("AnimatedSprite2D")
	elif get_parent().has_node("Sprite2D"):
		sprite = get_parent().get_node("Sprite2D")
	else:
		push_warning("HealthComponent: Sprite node not found!")

	if sprite:
		sprite.material = shader_material.duplicate()
		var material = sprite.material as ShaderMaterial
		material.set_shader_parameter("red_tint_amount", 0.0)

func damage(damage):
	health -= damage
	print("damage taken: ", damage)
	shader_handler()
	if health <= 0:
		health = 0
		character.destroy()


func shader_handler():
	var material = sprite.material as ShaderMaterial
	var health_ratio = clamp(float(health) / MAX_HEALTH, 0.0, 0.7)
	material.set_shader_parameter("red_tint_amount", 0.7 - health_ratio)
	for i in 3:
		material.set_shader_parameter("flash_amount", 0.6)
		await get_tree().create_timer(0.05).timeout
		material.set_shader_parameter("flash_amount", 0.0)
		await get_tree().create_timer(0.05).timeout
