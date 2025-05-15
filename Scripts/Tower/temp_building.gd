extends Area2D

@export var dropshadow_good: Texture
@export var dropshadow_bad: Texture

var tilemap: TileMapLayer
var turret: Node
var cell
var spriteobtained: bool
var new_turret

func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("Tile_data")
	turret = get_tree().get_first_node_in_group("Turret_node")
	
func _process(_delta):
	if _check_tile_validity(): #and GlobalVariables.is_mouse_in_Area2D == false:
		%Shadow.texture = dropshadow_good
	else:
		%Shadow.texture = dropshadow_bad
	self.global_position = tilemap.map_to_local(cell)
	if !spriteobtained and GlobalVariables.selected_turret != null:
		new_turret = GlobalVariables.selected_turret.instantiate()
		%Sprite2D.texture = new_turret.plantimg
		spriteobtained = true
		print(new_turret.plantimg)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		if _check_tile_validity() and GlobalVariables.cost >= 1:#GlobalVariables.is_mouse_in_Area2D == false and :
			#var new_turret = GlobalVariables.selected_turret.instantiate()
			GlobalVariables.cost -= new_turret.cost
			turret.add_child(new_turret)
			new_turret.global_position = tilemap.map_to_local(cell)
			GlobalVariables.show_circles = false
		GlobalVariables.show_circles = false
		queue_free()

func _check_tile_validity():
		var world_pos = get_global_mouse_position()
		cell = tilemap.local_to_map(tilemap.to_local(world_pos)) #update to check right and left tiles also....
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data:
			#var tile_type = tile_data.get_custom_data("Place")
			return _tower_borders_check(cell)
		return false

#improve this later
func _tower_borders_check(cell):
	var borders: Dictionary
	borders["bottom_right"] = cell + Vector2i(1, 0)
	borders["bottom_left"] = cell + Vector2i(-1, 0)
	borders["top_right"] = cell + Vector2i(1, -1)
	borders["top_left"] = cell + Vector2i(-1, -1)
	for i in borders:
		var tile_data = tilemap.get_cell_tile_data(borders.get(i))
		if tile_data:
			if tile_data.get_custom_data("Place"):
				continue
			return false
		return false
	return true
