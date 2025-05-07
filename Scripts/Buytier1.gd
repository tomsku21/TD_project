extends TextureButton

@export var description: String
@export var building: PackedScene
@export var item: PackedScene
@export var cost: int = 1
var ghost_node: Node


func _ready():
	ghost_node = get_tree().get_first_node_in_group("Ghost")

func _on_down():
	if GlobalVariables.cost >= cost:
		#instantiate building under cursor, that has code to stay under your pointer.
		var ghostT = building.instantiate()
		ghost_node.add_child(ghostT)
		GlobalVariables.selected_turret = item

func _on_mouse_entered():
	%TDesc.text = description
	
func _on_mouse_exit():
	%TDesc.text = str("")
