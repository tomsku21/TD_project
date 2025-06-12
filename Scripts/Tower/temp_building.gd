extends Area2D

@export var dropshadow_good: Texture
@export var dropshadow_bad: Texture
@export var range_marker: Sprite2D

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
		range_marker.scale = new_turret.range_indicator.scale
		%Sprite2D.texture = new_turret.plantimg
		spriteobtained = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if _check_tile_validity() and GlobalVariables.cost >= 1:
			GlobalVariables.cost -= new_turret.cost
			turret.add_child(new_turret)
			new_turret.global_position = tilemap.map_to_local(cell)
		if Input.is_action_pressed("Multibuy"):
			new_turret = GlobalVariables.selected_turret.instantiate()
		else:
			queue_free()
			Ui.on_shop_button_pressed()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		queue_free()
		Ui.on_shop_button_pressed()

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
	for x in range(-1, 2):
		for y in range(-1 ,2):
			var border = cell + Vector2i(x, y)
			var tile_data = tilemap.get_cell_tile_data(border)
			if tile_data:
				if tile_data.get_custom_data("Place"):
					continue
				return false
			return false
	return true
