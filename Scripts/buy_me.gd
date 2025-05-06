extends TextureButton
@export var cost: int = 1
@export var building: PackedScene

func _on_click():
	print("clicked?")
	if GlobalVariables.cost >= cost:
		#instantiate building under cursor, that has code to stay under your pointer.
		var ghostT = building.instantiate()
		add_child(ghostT)
