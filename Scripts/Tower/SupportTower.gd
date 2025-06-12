extends AnimatedSprite2D
class_name SupportTower
@export_category("Components")
@export var attack_timer: Timer
@export var marker_2d: Marker2D
@export var healthcomponent: HealthComponent
@export var ARange: Sprite2D
@export var cpu_particles_2d: CPUParticles2D
@export var upgrade_cpu_2d: CPUParticles2D
@export var plantimg: Texture #for dropshadow

@export_category("Upgrade info")
@export var upgrades: Array[PackedScene] #Iconi mukaan pakettiin jotenkin maybe >.>
@export var upRequirement: Dictionary #Null if no extra requirements

@export_category("Tower Stats")
@export var stats: Dictionary = {"Atk Speed" : 1.0, "Damage Taken" : 0.0, "Rounds Survived" : 0}

@export var cost: int
@export var title: String
@export var description: String
@export var DMGText: String
@export var max_health: float = 500.0

var turret
var clicked: bool = false #for popups
var hovered: bool = false #more for popups
var up_forgiveness: bool = true
var data_layer: TileMapLayer
var land_layer: TileMapLayer
var cell: Vector2i

var towers: Array[Area2D] = []
func _ready() -> void:
	stats["Rounds Survived"] = 0
	SignalBus.NextRound.connect(_next_round)
	data_layer = get_tree().get_first_node_in_group("Tile_data")
	land_layer = get_tree().get_first_node_in_group("TowerArea")
	stats = stats.duplicate()
	turret = get_tree().get_first_node_in_group("Turret_node")
	GlobalVariables.turrets.append(self)
	%AttackTimer.wait_time = stats["Atk Speed"]
	$Button.grab_focus()
	_tower_borders_check.call_deferred(true)
	


func _process(_delta):
	if GlobalVariables.show_circles:
		ARange.visible = true
	elif clicked:
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
	if is_in_group("MoneyMaker") and attack_timer.is_stopped() and GlobalVariables.game_state:
		attack_timer.start()
		
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

func take_damage(damage: int):
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
	_tower_borders_check.call_deferred(false)
	queue_free()

#func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Turret") and not is_in_group("MoneyMaker") and not area in towers:
		#towers.append(area)
		#if attack_timer.is_stopped():
			#attack_timer.start()
#
#func _on_area_exited(area: Area2D) -> void:
	#if area in towers:
		#print("tower left area?")
		#towers.erase(area)
		#if towers.is_empty():
			#attack_timer.stop()

func _next_round():
	stats["Rounds Survived"] += 1

func upgrade():
	var new_plant = GlobalVariables.selected_turret.instantiate()
	turret.add_child(new_plant)
	new_plant.global_position = global_position
	$Button.release_focus()
	queue_free()
	GlobalVariables.turrets.erase(self)

func Heal(restoration, healer):
	if healthcomponent.health < healthcomponent.MAX_HEALTH and not is_in_group("Healer"):
		healthcomponent.health += restoration
		healthcomponent.shader_handler(false)
		healer.stats["Health Restored"] += restoration
		return true
	else:
		return false

##Ui/popups stuff from here on. Could probably be it's own node- "UI handler" if the project were larger
func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false


func _on_focus_entered():
	clicked = true
	#hovered = true

func _on_focus_exited():
	print("focus exited?")
	clicked = false
	Popups.hideBuildInfo()


	
func _tower_borders_check(change: bool):
	var tile
	var cells : Array[Vector2i]
	if change:
		tile = 8
	else:
		tile = 7
	var data_cell = data_layer.local_to_map(data_layer.to_local(global_position))
	var land_cell = land_layer.local_to_map(land_layer.to_local(global_position))
	for x in range(-1, 2):
		for y in range(-1 ,2):
			var data_border = data_cell + Vector2i(x, y)
			var land_border = land_cell + Vector2i(x, y)
			data_layer.set_cell(data_border, 0, Vector2i(tile, 5))
			if change:
				cells.append(land_border)
				print("cell added to list")
			continue
	if change:
		print("cells changed?")
		land_layer.set_cells_terrain_connect(cells, 0, 0)
