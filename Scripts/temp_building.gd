extends Area2D

var tilemap: TileMapLayer
var turret: Node
func _ready() -> void:
	tilemap = get_node("/root/Main/TileMap/Grass")
	turret = get_node("/root/Main/Turrets")
func _process(delta):
	self.global_position = get_global_mouse_position()

func _input(event):
	if Input.is_action_just_pressed("click"):
		var world_pos = get_global_mouse_position()
		var cell = tilemap.local_to_map(tilemap.to_local(world_pos))
		var tile_data = tilemap.get_cell_tile_data(cell)

		if tile_data and GlobalVariables.is_mouse_in_Area2D == false:
			var tile_type = tile_data.get_custom_data("Testi")
			
			if tile_type == true:
				var new_turret = GlobalVariables.selected_turret.instantiate()
				turret.add_child(new_turret)
				new_turret.global_position = tilemap.map_to_local(cell)
		queue_free()
