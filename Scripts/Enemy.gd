extends CharacterBody2D
@onready var path: PathFollow2D = $".."
@onready var attack_timer: Timer = $AttackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthcomponent: HealthComponent = %HealthComponent
@onready var health_bar: ProgressBar = %HealthBar

@export var speed: int = 2
@export var health: int = 15
@export var sdamage: int = 10

var attack_distance: float = 50.0
var current_turret = null
var old_speed: int
var slow_speed: int = 20


func _physics_process(delta: float) -> void:
	check_turret()
	change_rotation()
	path.progress += speed * delta
	if path.progress_ratio >= 0.99:
		destroy()

func destroy():
	path.queue_free()
	GlobalVariables.enemy_count -= 1
	GlobalVariables.player_hp -= sdamage

func change_rotation():
	if path.rotation_degrees > 160 and path.rotation_degrees < 190:
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
			
	if nearest_turret and nearest_distance < attack_distance:
		if old_speed == 0: old_speed = speed
		speed = slow_speed
		if attack_timer.is_stopped():
			attack_timer.start()
	else:
		if old_speed != 0: 
			speed = old_speed
			old_speed = 0
	
func take_damage(damage: int):
	healthcomponent.damage(damage)

func _on_attack_timer_timeout() -> void:
	if current_turret and current_turret.has_method("take_damage"):
		current_turret.take_damage(sdamage)
