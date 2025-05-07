extends TextureButton

@export var new_tower: PackedScene
@export var description: String
@export var damage: int
@export var atk_speed: float
@export var cost: int

func _on_click():
	if GlobalVariables.cost >= cost and new_tower != null:
		GlobalVariables.cost -= cost
		GlobalVariables.selected_turret = new_tower
		Popups.upgrade()

func _on_mouse_entered():
	Popups.setupDescription(self)

func _on_mouse_exited():
	Popups.returnDesc()
