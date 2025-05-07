extends Panel
@export var cost: int = 1
@export var building: PackedScene
var ghost_node: Node
@export var item: PackedScene

func _ready():
	ghost_node = get_tree().get_first_node_in_group("Ghost")

func _on_click():
	print("clicked?")
	if GlobalVariables.cost >= cost:
		#instantiate building under cursor, that has code to stay under your pointer.
		var ghostT = building.instantiate()
		ghost_node.add_child(ghostT)
		GlobalVariables.selected_turret = item
		


func _on_mouse_entered():
	pass # Replace with function body.
