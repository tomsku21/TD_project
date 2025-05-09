extends TextureButton

@export var plant: PackedScene
var description: String
var damage: float
var atk_speed: float
var cost: int
var requirement: float
var new_plant

func _process(delta):
	if plant != null:
		self.disabled = (GlobalVariables.cost < cost)

func _on_click():
	#var dictionary_key = (new_plant.upRequirement.keys()[0])
	#thisisdumb(dictionary_key)
	GlobalVariables.cost -= cost
	GlobalVariables.selected_turret = plant
	Popups.upgrade()

func _on_mouse_entered():
	set_stats()
	Popups.setupDescription(self)

func _on_mouse_exited():
	Popups.returnDesc()

func set_stats():
	new_plant = plant.instantiate()
	description = new_plant.description
	damage = new_plant.sdamage
	atk_speed = new_plant.atk_speed
	cost = new_plant.cost
