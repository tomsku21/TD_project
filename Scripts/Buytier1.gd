extends TextureButton

@export var building: PackedScene #Ghost tower that shows while placing it.
@export var item: PackedScene #The tower that this button purchases.
@export var cost: int
var ghost_node: Node #Place in tree hierarchy for ghost tower.

func _ready():
	ghost_node = get_tree().get_first_node_in_group("Ghost")
	%TDesc.text = str("")

func _process(delta):
	self.disabled = (GlobalVariables.cost < cost)

func _on_down():
	#instantiate building under cursor, that has code to stay under your pointer.
	var ghostT = building.instantiate()
	ghost_node.add_child(ghostT)
	GlobalVariables.selected_turret = item
	#GlobalVariables.show_circles = true #Doesn't look good with multiple plants

func _on_mouse_entered():
	var new_plant = item.instantiate()
	cost = new_plant.cost
	%cost.text = str("Cost: ", cost)
	%TDesc.text = new_plant.description
	
func _on_mouse_exit():
	%cost.text = str("")
	%TDesc.text = str("")
