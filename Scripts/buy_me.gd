extends TextureButton
@export var cost: int = 1
@export var building: PackedScene
@export var ghost_node: Node
@export var item: PackedScene

func _on_click():
	print("clicked?")
	if GlobalVariables.cost >= cost:
		#instantiate building under cursor, that has code to stay under your pointer.
		var ghostT = building.instantiate()
		ghost_node.add_child(ghostT)
		GlobalVariables.selected_turret = item
