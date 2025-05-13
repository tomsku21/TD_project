extends CharacterBody2D

# Onready
@onready var path: PathFollow2D = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthcomponent: HealthComponent = %HealthComponent
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var audio: Node = $Audio

# Export
@export var shader_material: ShaderMaterial
@export var speed: float = 2.0
@export var max_health: float = 15
@export var sdamage: float = 10
@export var attack_distance: float = 50.0
@export_category("Debuff")
@export var poison: Poison
@export var burn: Burn
@export var slow: Slow

@export_category("Timers")
@export var walk_timer: Timer
@export var attack_timer: Timer

# Variables
var sprite
var end: bool = false
var taking_damage: bool = false
var current_speed: float
var basic_speed: float
var current_turret = null
var attacktime: float
var life_tree: Area2D
var grabbed: bool = false
var currently_grabbed: bool = false
var poisoned: bool = false
var burning: bool = false

func _ready():
	life_tree = get_tree().get_first_node_in_group("LifeTree")
	speed = speed * randf_range(0.8, 1.2)
	current_speed = speed

	if has_node("AnimatedSprite2D"):
		sprite = get_node("AnimatedSprite2D")
	elif has_node("Sprite2D"):
		sprite = get_node("Sprite2D")

	if sprite:
		sprite.material = shader_material.duplicate()
		var material = sprite.material as ShaderMaterial
		material.set_shader_parameter("ice_tint_amount", 0.0)

func _physics_process(delta: float) -> void:
	if end == false:
		path.progress += current_speed * delta
	if path.progress_ratio >= 0.99:
		if attack_timer.is_stopped():
			attack_timer.start()
			end = true
	else:
		check_turret()
	if grabbed == true and currently_grabbed == false:
		await get_tree().create_timer(10).timeout
		grabbed = false
	if life_tree == null:
		life_tree = get_tree().get_first_node_in_group("LifeTree")

	change_rotation()

func destroy():
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(0.1).timeout
	path.queue_free()
	GlobalVariables.enemy_count -= 1

func change_rotation():
	var rot_deg = path.rotation_degrees
	if rot_deg > 160 and rot_deg < 190 or rot_deg < -160 and rot_deg > -190:
		animated_sprite_2d.flip_v = true
	else:
		animated_sprite_2d.flip_v = false

func check_turret():
	var nearest_turret = null
	var nearest_distance = 999999.0
	
	for turret in GlobalVariables.turrets:
		if turret:
			var dist = global_position.distance_to(turret.global_position)
			if dist < nearest_distance:
				nearest_distance = dist
				nearest_turret = turret
				current_turret = turret
			
	if nearest_turret: 
		if nearest_distance < attack_distance:
			if attack_timer.is_stopped():
				attacktime = randf_range(0.5, 1.5)
				attack_timer.wait_time = attacktime
				attack_timer.start()
		else:
			if !attack_timer.is_stopped():
				attack_timer.stop()
				nearest_turret = null
	
func take_damage(damage: float, attackerPlant: Area2D):
	audio.get_node("Hit").pitch_scale = randf_range(0.8, 1.0)
	audio.get_node("Hit").play()
	healthcomponent.damage(damage)
	attackerPlant.stats["damage_dealt"] += damage
	if poisoned:
		cpu_particles_2d.scale_amount_max = 0.5
		cpu_particles_2d.texture = preload("res://Assets/Particles/Skull.png")
	else:
		cpu_particles_2d.scale_amount_max = 3.0
		cpu_particles_2d.texture = null
	cpu_particles_2d.emitting = true
	if healthcomponent.health <= 0:
		if attackerPlant != null:
			attackerPlant.stats["kills"] += 1

func _on_attack_timer_timeout() -> void:
	if end:
		if life_tree and life_tree.has_method("take_damage"):
			life_tree.take_damage(sdamage)
	else:
		if current_turret and current_turret.has_method("take_damage"):
			current_speed = 0
			current_turret.take_damage(sdamage)
		walk_timer.wait_time = attacktime * 0.25
		walk_timer.start()
		
func _walk_again() -> void:
	current_speed = speed
