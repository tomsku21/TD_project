extends Area2D
@onready var turret_scene: = preload("res://Scenes/building/turret.tscn")
@onready var ghost: Node = $"../Ghost"
@export var is_used: bool = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		if GlobalVariables.has_turret:
			if get_child_count() < 2:
				var turret = turret_scene.instantiate()
				add_child(turret)
				turret.global_position = global_position
				GlobalVariables.has_turret = false
				is_used = true
				for c in ghost.get_children():
					c.queue_free()
			else:
				print("Has turret all ready")


func _on_mouse_entered() -> void:
	if GlobalVariables.has_turret and not is_used:
		if get_child_count() < 2:
			var turret = turret_scene.instantiate()
			ghost.add_child(turret)
			turret.global_position = global_position
		else:
			print("Has turret all ready")


func _on_mouse_exited() -> void:
	if GlobalVariables.has_turret:
		for child in ghost.get_children():
			if child.is_in_group("Turret"):
				child.queue_free()
				
				
func _process(delta: float) -> void:
	for child in get_children():
		if not child.is_in_group("Turret"):
			is_used = false
