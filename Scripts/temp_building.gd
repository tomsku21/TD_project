extends Area2D


func _update():
	self.global_position == get_viewport().get_mouse_position()

func _on_input_event(event):
	if Input.is_action_just_pressed("click"):
		queue_free()
