extends TextureButton

@export var new_tower: PackedScene
@export var description: String
@export var damage: int
@export var atk_speed: float


func _on_mouse_entered():
	Popups.setupDescription(self)

func _on_mouse_exited():
	Popups.returnDesc()
