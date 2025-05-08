extends TextureButton

@export var plant: PackedScene
var description: String
var damage: int
var atk_speed: float
var cost: int

func _on_click():
	if GlobalVariables.cost >= cost and plant != null:
		GlobalVariables.cost -= cost
		GlobalVariables.selected_turret = plant
		Popups.upgrade()

func _on_mouse_entered():
	set_stats()
	Popups.setupDescription(self)

func _on_mouse_exited():
	Popups.returnDesc()

func set_stats():
	var new_plant = plant.instantiate()
	description = new_plant.description
	damage = new_plant.sdamage
	atk_speed = new_plant.atk_speed
	cost = new_plant.cost
