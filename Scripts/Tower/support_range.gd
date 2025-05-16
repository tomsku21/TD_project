extends Area2D
class_name Heal_Range_Component

@export var tower: Node2D
var towers: Array[AnimatedSprite2D] = []

func _on_area_entered(area: Area2D) -> void:
	if not is_in_group("MoneyMaker") and not area.tower in towers:
		print("tower entered heal zone")
		towers.append(area.tower)
		if tower.attack_timer.is_stopped():
			tower.attack_timer.start()

func _on_area_exited(area: Area2D) -> void:
	if area.tower in towers:
		print("tower left area?")
		towers.erase(area.tower)
		if towers.is_empty():
			tower.attack_timer.stop()
