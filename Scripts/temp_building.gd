extends Area2D
@export var turret_scene: PackedScene
func _process(delta):
	self.global_position = get_global_mouse_position()

func _input(event):
	if Input.is_action_just_pressed("click"):
		queue_free()
