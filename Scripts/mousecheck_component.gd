extends Area2D

var hovering: bool

func _process(_delta):
	if hovering:
		GlobalVariables.is_mouse_in_Area2D = true
		if _check_mouseover(): #monitor the specs hungryness of this bit
			hovering = false
			GlobalVariables.is_mouse_in_Area2D = false

func _on_mouse_entered(_shape) -> void:
	hovering = true
	print("mouse entered")

func _check_mouseover():
	var turretarea = get_tree().get_nodes_in_group("Turretarea")
	for x in turretarea:
		if x.get_global_rect().has_point(get_global_mouse_position()):
			return false
		else:
			continue
	return true
