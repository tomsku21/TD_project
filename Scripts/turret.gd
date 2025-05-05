extends Area2D
@onready var attack_timer: Timer = $AttackTimer
@onready var marker_2d: Marker2D = $Marker2D
@export var bullet: PackedScene
var health: int = 100
var damage: int = 10
var enemies: Array[Node2D] = []
func _ready() -> void:
	GlobalVariables.turrets.append(self)

func take_damage(damgae: int):
	health -= damgae
	if health <= 0:
		queue_free()
		GlobalVariables.turrets.erase(self)


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
		if is_instance_valid(target) and target.has_method("take_damage"):
			target.take_damage(damage)
	
