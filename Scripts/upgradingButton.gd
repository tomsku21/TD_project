extends TextureButton

@export var plant: PackedScene
#put these to a dictionary
var stats : Dictionary
var description: String
var cost: int
var requirement: float
var upgrade: String
var cur_req: float
var req_dict: Dictionary
var new_plant
var current_plant
var hovered = false

func _process(delta):
	if current_plant and req_dict:
		%UProgress.max_value = requirement
		%UProgress.value = cur_req
	else:
		%UProgress.max_value = 100
		%UProgress.value = 100
	
	if hovered:
		Popups.setupDescription(self)
		if req_dict:
			cur_req = current_plant.stats[upgrade]

	if plant != null:
		if cur_req >= requirement or req_dict == null:
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


#create a stats {} dict here. way to check if certain named key exists?
func set_stats():
	new_plant = plant.instantiate()
	description = new_plant.description
	stats = new_plant.stats
	cost = new_plant.cost
	
	if new_plant.upRequirement:
		req_dict = new_plant.upRequirement
		upgrade = (req_dict.keys()[0])
		requirement = req_dict[upgrade]
		cur_req = current_plant.stats[upgrade]
	else:
		req_dict.clear()
		upgrade = ""
		requirement = 0
		cur_req = 0
	new_plant.queue_free()
		
		
		
