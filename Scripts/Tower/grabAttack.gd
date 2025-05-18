extends Area2D
class_name GrabberRange

@export var tower: Node2D = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not body in tower.enemies:
		tower.enemies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body in tower.enemies:
		tower.enemies.erase(body)
