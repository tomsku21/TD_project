extends Panel
@export var cost: int = 1
var ghost_node: Node


func _ready():
	ghost_node = get_tree().get_first_node_in_group("Ghost")

func _on_click(button):
	print(button)
	#if GlobalVariables.cost >= cost:
		##instantiate building under cursor, that has code to stay under your pointer.
		#var ghostT = button.building.instantiate()
		#ghost_node.add_child(ghostT)
		#GlobalVariables.selected_turret = button.item

func _on_mouse_entered():
	%TDesc.text = %Biyt1.description
