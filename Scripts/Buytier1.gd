extends TextureButton

@export var building: PackedScene
@export var item: PackedScene
@export var cost: int
var ghost_node: Node


func _ready():
	ghost_node = get_tree().get_first_node_in_group("Ghost")
	%TDesc.text = str("")

func _on_down():
	if GlobalVariables.cost >= cost:
		#instantiate building under cursor, that has code to stay under your pointer.
		var ghostT = building.instantiate()
		ghost_node.add_child(ghostT)
		GlobalVariables.selected_turret = item
		GlobalVariables.show_circles = true

func _on_mouse_entered():
	var new_plant = item.instantiate()
	cost = new_plant.cost
	%TDesc.text = new_plant.description
	
func _on_mouse_exit():
	%TDesc.text = str("")
