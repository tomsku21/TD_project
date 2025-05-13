extends TextureButton

@export var plant: PackedScene
#put these to a dictionary
var description: String
var DMGText: String
var damage: float
var atk_speed: float
var cost: int
var requirement: float
var upgrade: String
var cur_req: float
var new_plant
var current_plant
var hovered

func _process(delta):
	if current_plant and new_plant.upRequirement:
		%UProgress.max_value = requirement
		%UProgress.value = cur_req
	else:
		%UProgress.max_value = 100
		%UProgress.value = 100
	
	if hovered:
		Popups.setupDescription(self)
		if new_plant.upRequirement:
			cur_req = current_plant.stats[upgrade]

	if plant != null:
		if cur_req >= requirement or new_plant.upRequirement == null:
			self.disabled = (GlobalVariables.cost < cost)
		else:
			self.disabled = true

func _on_click():
	GlobalVariables.cost -= cost
	GlobalVariables.selected_turret = plant
	Popups.upgrade()

func _on_mouse_entered():
	#Popups.setupDescription(self)
	hovered = true
	

func _on_mouse_exited():
	hovered = false
	Popups.returnDesc()


func set_stats():
	new_plant = plant.instantiate()
	description = new_plant.description
	DMGText = new_plant.DMGText
	damage = new_plant.stats["sdamage"]
	atk_speed = new_plant.stats["atk_speed"]
	cost = new_plant.cost
	if new_plant.upRequirement:
		upgrade = (new_plant.upRequirement.keys()[0])
		requirement = new_plant.upRequirement[upgrade]
		cur_req = current_plant.stats[upgrade]
		
		
		
