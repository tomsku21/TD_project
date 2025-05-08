extends CharacterBody2D
@onready var path: PathFollow2D = $".."
@onready var walk_timer: Timer = $WalkTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthcomponent: HealthComponent = %HealthComponent
#@onready var health_bar: ProgressBar = %HealthBar
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

@export var speed: float = 2.0
@export var max_health: int = 15
@export var sdamage: int = 10

var current_speed: float
var attack_distance: float = 50.0
var current_turret = null
var attacktime: float
var life_tree: Area2D

func _ready():
	life_tree = get_tree().get_first_node_in_group("LifeTree")
	speed = speed * randf_range(0.8, 1.2)
	current_speed = speed

func _physics_process(delta: float) -> void:
	check_turret()
	change_rotation()
	path.progress += current_speed * delta
	if path.progress_ratio >= 0.99:
		if life_tree and life_tree.has_method("take_damage"):
			life_tree.take_damage(sdamage)
			cpu_particles_2d.emitting = true
			await get_tree().create_timer(0.1).timeout
		destroy()

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
	
func take_damage(damage: int):
	healthcomponent.damage(damage)
	cpu_particles_2d.emitting = true
	if healthcomponent.health <= 0:
		return true

func _on_attack_timer_timeout() -> void:
	if current_turret and current_turret.has_method("take_damage"):
		#ideally start an animation, where at the end it shoots a projectile/attacks.
		#even without animations, needs a short stop for attack.
		current_speed = 0
		current_turret.take_damage(sdamage)
	walk_timer.wait_time = attacktime * 0.25
	walk_timer.start()
		
func _walk_again() -> void:
	current_speed = speed
