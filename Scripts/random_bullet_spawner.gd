extends Node
@export var markers: Array[Marker2D] = []
@export var random_bullet: PackedScene
@export var timer: Timer
@export var damage: int
var target
var selected_spawner: Marker2D

func _physics_process(_delta: float) -> void:
	if timer.is_stopped() and not GlobalVariables.turrets.is_empty():
		target = GlobalVariables.turrets.pick_random()
		timer.wait_time = randf_range(1,10)
		selected_spawner = markers.pick_random()
		timer.start()

func _on_timer_timeout() -> void:
	var bullet = random_bullet.instantiate()
	selected_spawner.add_child(bullet)
	bullet.global_position = selected_spawner.global_position
	bullet.target = target
	bullet.damage = damage
	bullet.gun = selected_spawner
