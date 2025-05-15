extends Area2D
class_name HitboxComponent

@export var tower: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not body in tower.enemies:
		tower.enemies.append(body)
		if tower.attack_timer.is_stopped():
			tower.attack_timer.start()

func _on_body_exited(body: Node2D) -> void:
	if body in tower.enemies:
		tower.enemies.erase(body)
		if tower.enemies.is_empty():
			tower.attack_timer.stop()
