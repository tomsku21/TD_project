extends Node
class_name HealthComponent
var sprite
@export var character : Node2D
@export var MAX_HEALTH :int = 1000
@export var health: int
@export var shader_material: ShaderMaterial

var healthbar : ProgressBar


func _ready():
	health = MAX_HEALTH
	healthbar = %HealthBar
	healthbar.visible = false
	healthbar.max_value = MAX_HEALTH
	healthbar.value = health
	
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
	healthbar = %HealthBar
	health -= damage
	healthbar.visible = true
	healthbar.value = health
	shader_handler()
	if health <= 0:
		health = 0
		healthbar.value = health
		character.destroy()


func shader_handler():
	var material = sprite.material as ShaderMaterial
	var health_ratio = clamp(float(health) / MAX_HEALTH, 0.0, 1.0)
	material.set_shader_parameter("red_tint_amount", 1.0 - health_ratio)
	for i in 3:
		material.set_shader_parameter("flash_amount", 1.0)
		await get_tree().create_timer(0.01).timeout
		material.set_shader_parameter("flash_amount", 0.0)
		await get_tree().create_timer(0.01).timeout
