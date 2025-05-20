extends AnimatedSprite2D
class_name Tower
@export_category("Components")
@export var attack_timer: Timer
@export var marker_2d: Marker2D
@export var healthcomponent: HealthComponent
@export var ARange: Sprite2D
@export var cpu_particles_2d: CPUParticles2D
@export var upgrade_cpu_2d: CPUParticles2D
@export var plantimg: Texture #for dropshadow
@export var bullet_sprite: Texture
@export var bullet_sprite_rotation: float
@export var bullet_scale: float
@export var range_indicator: Sprite2D

@export_category("Upgrade info")
@export var upgrades: Array[PackedScene] #Iconi mukaan pakettiin jotenkin maybe >.>
@export var upRequirement: Dictionary #Null if no extra requirements

@export_category("Tower Stats")
@export var stats: Dictionary = {"Damage" : 10.0, "Atk Speed" : 1.0, "Damage Taken" : 0.0, "Damage Dealt" : 0.0, "Kills" : 0, "Regeneration" : 0.0, "Regen Time": 1.0, "Rounds Survived": 0}
@export var cost: int
@export var title: String #Name of tower
@export var description: String
@export var max_health: float = 1000.0

var turret
var clicked: bool = false #for popups
var hovered: bool = false #more for popups
var up_forgiveness : bool = true #haha...
var tilemap: TileMapLayer
var cell: Vector2i

var enemies: Array[Node2D] = []

func _ready() -> void:
	SignalBus.NextRound.connect(_next_round)
	tilemap = get_tree().get_first_node_in_group("Tile_data")
	stats = stats.duplicate()
	turret = get_tree().get_first_node_in_group("Turret_node")
	GlobalVariables.turrets.append(self)
	%AttackTimer.wait_time = stats["Atk Speed"]
	%RegenTimer.wait_time = stats["Regen Time"]
	$Button.grab_focus()
	_tower_borders_check.call_deferred(false)

func _process(_delta):
	if turret == null:
		turret = get_tree().get_first_node_in_group("Turret_node")
	if clicked:
		ARange.visible = true
		Popups.showBuildInfo(get_global_transform_with_canvas(), self)
	else:
		ARange.visible = false
	
	if Input.is_action_just_released("click"):
		if !hovered and clicked and !up_forgiveness:
			if $Button.has_focus():
				$Button.release_focus()
			else:
				_on_focus_exited()
		if up_forgiveness and !hovered:
			up_forgiveness = false

	for i in upgrades:
		if i != null:
			var new_plant = i.instantiate()
			if new_plant.upRequirement:
				var req_dict = new_plant.upRequirement
				var upgrade_ = (req_dict.keys()[0])
				var requirement = req_dict[upgrade_]
				var cur_req = stats[upgrade_]
				if cur_req >= requirement or req_dict == null:
					upgrade_cpu_2d.emitting = true
			new_plant.queue_free()

func take_damage(damage: float):
	healthcomponent.damage(damage)
	stats["Damage Taken"] += damage
	cpu_particles_2d.emitting = true

func sell():
	GlobalVariables.cost += round(cost * 0.75)
	destroy()

func destroy():
	cpu_particles_2d.emitting = true
	GlobalVariables.turrets.erase(self)
	await get_tree().create_timer(0.1).timeout
	_tower_borders_check(true)
	queue_free()

func _next_round():
	stats["Rounds Survived"] += 1

func _on_attack_timer_timeout() -> void:
	pass

func _on_regen_timer_timeout() -> void:
	if healthcomponent.health < healthcomponent.MAX_HEALTH:
		healthcomponent.shader_handler(false)
		healthcomponent.health += stats["Regeneration"]

func upgrade():
	var new_plant = GlobalVariables.selected_turret.instantiate()
	turret.add_child(new_plant)
	new_plant.global_position = global_position
	$Button.release_focus()
	queue_free()
	GlobalVariables.turrets.erase(self)

func Heal(restoration, healer):
	if healthcomponent.health < healthcomponent.MAX_HEALTH:
		healthcomponent.health += restoration
		healthcomponent.shader_handler(false)
		healer.stats["Health Restored"] += restoration
		return true
	else:
		return false

##Ui/popups stuff from here on. Could probably be it's own node- "UI handler" if the project were larger
func _on_mouse_entered() -> void:
	hovered = true
	print("mouse entered")


func _on_mouse_exited() -> void:
	hovered = false
	print("mouse exited")

func _on_focus_entered():
	clicked = true
	#hovered = true

func _on_focus_exited():
	print("focus exited?")
	clicked = false
	Popups.hideBuildInfo()


#improve this later
func _tower_borders_check(change: bool):
	var tile
	if change:
		tile = 7
	else:
		tile = 8
	cell = tilemap.local_to_map(tilemap.to_local(global_position))
	var borders: Dictionary
	borders["current_pos"] = cell
	borders["bottom_right"] = cell + Vector2i(1, 0)
	borders["bottom_left"] = cell + Vector2i(-1, 0)
	borders["top_right"] = cell + Vector2i(1, -1)
	borders["top_middle"] = cell + Vector2i(0, -1)
	borders["top_left"] = cell + Vector2i(-1, -1)
	for i in borders:
		print(i, borders.get(i))
		var tile_data = tilemap.get_cell_tile_data(borders.get(i))
		#print("tile data before:", tile_data)
		tilemap.set_cell(borders.get(i), 0, Vector2i(tile, 5))
		#print("tile", tile)
		tile_data = tilemap.get_cell_tile_data(borders.get(i))
		#print("tile data after:", tile_data)
		continue
