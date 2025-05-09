extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var shader_material: ShaderMaterial
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var attack_timer: Timer = $AttackTimer

@export var sdamage: int
@export var attackTime: float
var enemies: Array = []
func _ready() -> void:
	attack_timer.wait_time = attackTime
	if sprite_2d:
		sprite_2d.material = shader_material.duplicate()
		var material = sprite_2d.material as ShaderMaterial
		material.set_shader_parameter("red_tint_amount", 0.0)

func _physics_process(delta: float) -> void:
	pass

func take_damage(damage: int):
	GlobalVariables.player_hp -= damage
	shader_handler()
	progress_bar.value = GlobalVariables.player_hp / 10
	if GlobalVariables.player_hp <= 0:
		queue_free()

func shader_handler():
	var material = sprite_2d.material as ShaderMaterial
	var health_ratio = clamp(float(GlobalVariables.player_hp) / GlobalVariables.MAX_HP, 0.0, 0.7)
	material.set_shader_parameter("red_tint_amount", 0.7 - health_ratio)
	for i in 3:
		material.set_shader_parameter("flash_amount", 0.6)
		await get_tree().create_timer(0.01).timeout
		material.set_shader_parameter("flash_amount", 0.0)
		await get_tree().create_timer(0.01).timeout


func _on_mouse_entered() -> void:
	progress_bar.visible = true


func _on_mouse_exited() -> void:
	progress_bar.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not body in enemies:
		enemies.append(body)
		if attack_timer.is_stopped():
			attack_timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body in enemies:
		enemies.erase(body)
		if enemies.is_empty():
			attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	if not enemies.is_empty():
		var target = enemies[0]
		target.take_damage(sdamage)
