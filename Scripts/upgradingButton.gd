extends TextureButton

@export var plant: PackedScene
var description: String
var damage: float
var atk_speed: float
var cost: int
var requirement: float
var upgrade: String
var cur_req: float
var new_plant

func _process(delta):
	if plant != null:
		self.disabled = (GlobalVariables.cost < cost)
		

func _on_click():
	GlobalVariables.cost -= cost
	GlobalVariables.selected_turret = plant
	Popups.upgrade()

func _on_mouse_entered():
	Popups.setupDescription(self)

func _on_mouse_exited():
	Popups.returnDesc()

func set_stats():
	new_plant = plant.instantiate()
	description = new_plant.description
	damage = new_plant.sdamage
	atk_speed = new_plant.atk_speed
	cost = new_plant.cost
	#if new_plant.upRequirement:
		#upgrade = (new_plant.upRequirement.keys()[0])
		#requirement = new_plant.upRequirement[upgrade]
		#cur_req = new_plant.str_to_var(upgrade)
		
		
		
