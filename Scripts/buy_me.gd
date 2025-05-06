extends Area2D
@export var cost: int = 1
@export var building: PackedScene

func _on_input_event(event):
	if Input.is_action_just_pressed("click"):
		if GlobalVariables.money >= cost:
			#instantiate building under cursor, that has code to stay under your pointer.
			var ghostT = building.instantiate()
			add_child(ghostT)
