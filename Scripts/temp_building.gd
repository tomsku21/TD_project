extends Area2D

var tilemap: TileMapLayer
var turret: Node

func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("Grass")
	turret = get_tree().get_first_node_in_group("Turret_node")
	
func _process(delta):
	self.global_position = get_global_mouse_position()
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		var world_pos = get_global_mouse_position()
		var cell = tilemap.local_to_map(tilemap.to_local(world_pos))
		var tile_data = tilemap.get_cell_tile_data(cell)

		if tile_data and GlobalVariables.is_mouse_in_Area2D == false and GlobalVariables.cost >= 1:
			var tile_type = tile_data.get_custom_data("Place")
			
			if tile_type == true:
				GlobalVariables.cost -= 1
				var new_turret = GlobalVariables.selected_turret.instantiate()
				turret.add_child(new_turret)
				new_turret.global_position = tilemap.map_to_local(cell)
				GlobalVariables.show_circles = false
		queue_free()
