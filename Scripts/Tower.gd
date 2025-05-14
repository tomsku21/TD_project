extends Area2D
class_name Tower
@onready var attack_timer: Timer = $AttackTimer
@onready var marker_2d: Marker2D = $Marker2D
@onready var healthcomponent: HealthComponent = %HealthComponent
@onready var ARange: Sprite2D = $RangeMarker
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var bullet: PackedScene

@export_category("Upgrade info")
@export var upgrades: Array[PackedScene] #Iconi mukaan pakettiin jotenkin maybe >.>
@export var upRequirement: Dictionary #Null if no extra requirements

@export_category("Tower Stats")
@export var stats: Dictionary = {"sdamage" : 10, "atk_speed" : 1.0, "damage_taken" : 0.0, "damage_dealt" : 0.0, "kills" : 0}
#@export var sdamage: float = 10 #self damage, "s" to not mix with taken damage from enemies
#@export var atk_speed: float
@export var cost: int
@export var title: String #Name of tower
@export var description: String
@export var DMGText: String
@export var max_health: float = 1000.0

var turret
var clicked: bool = false #for popups
var hovered: bool = false #more for popups
#var damage_taken: float
#var damage_dealt: float

#var kills: int #spawned bullets increase this

var enemies: Array[Node2D] = []

func _ready() -> void:
	turret = get_tree().get_first_node_in_group("Turret_node")
	GlobalVariables.turrets.append(self)
	%AttackTimer.wait_time = stats["atk_speed"]
	$Button.grab_focus()

func _process(_delta):
	if turret == null:
		turret = get_tree().get_first_node_in_group("Turret_node")
	if clicked:
		ARange.visible = true
		Popups.showBuildInfo(get_global_transform_with_canvas(), self)
	else:
		ARange.visible = false
	
	if Input.is_action_just_released("click") and !hovered and clicked:
		if $Button.has_focus():
			$Button.release_focus()
		else:
			_on_focus_exited()
	if !GlobalVariables.is_mouse_in_Area2D and hovered: #For when you upgrade a building
		print("get unhovered nerd")
		hovered = false

func take_damage(damage: float):
	healthcomponent.damage(damage)
	stats["damage_taken"] += damage
	cpu_particles_2d.emitting = true


func destroy():
	cpu_particles_2d.emitting = true
	GlobalVariables.turrets.erase(self)
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not body in enemies:
		enemies.append(body)
		if attack_timer.is_stopped():
			attack_timer.start()

func _on_body_exited(body: Node2D) -> void:
	if body in enemies:
		enemies.erase(body)
		if enemies.is_empty():
			attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	pass
	

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
		healer.stats["health_restored"] += restoration

##Ui/popups stuff from here on. Could probably be it's own node- "UI handler" if the project were larger
func _on_mouse_entered() -> void:
	#circle.visible = true
	#print("mouse entered")
	GlobalVariables.is_mouse_in_Area2D = true
	hovered = true


func _on_mouse_exited() -> void:
	#circle.visible = false
	if _check_mouseover(): #Ductape fix for exiting when hovering over button
		GlobalVariables.is_mouse_in_Area2D = false
		hovered = false
	else:
		#print("mouse was still over button, ignore")
		pass

func _on_focus_entered():
	clicked = true
	hovered = true

func _on_focus_exited():
	print("focus exited?")
	clicked = false
	Popups.hideBuildInfo()

#Simple for loop to check if mouse is hovering over a turret. Doing this way so that the code can check other turrets also.
func _check_mouseover():
	var turretarea = get_tree().get_nodes_in_group("Turretarea")
	for x in turretarea:
		if x.get_global_rect().has_point(get_global_mouse_position()):
			return false
		else:
			continue
	return true
	
