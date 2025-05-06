extends Area2D


func _process(delta):
	self.global_position = get_viewport().get_mouse_position()

func _input(event):
	if Input.is_action_just_pressed("click"):
		queue_free()
