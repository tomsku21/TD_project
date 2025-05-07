extends Area2D
@onready var attack_timer: Timer = $AttackTimer
@onready var marker_2d: Marker2D = $Marker2D
@onready var healthcomponent: HealthComponent = %HealthComponent
@onready var circle: Sprite2D = $Circle
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var bullet: PackedScene
@export var upgrades: Array[PackedScene] #Iconi mukaan pakettiin jotenkin maybe >.>


var turret
var clicked: bool = false #for popups
var hovered: bool = false #more for popups
var damage_taken: int
var damage_dealt: int
var atk_speed: float
var kills: int #spawned bullets increase this
@export var sdamage: int = 10 #self damage, "s" to not mix with taken damage from enemies
var enemies: Array[Node2D] = []

func _ready() -> void:
	
	turret = get_tree().get_first_node_in_group("Turret_node")
	GlobalVariables.turrets.append(self)
	atk_speed = %AttackTimer.wait_time
	$Button.grab_focus()

func _process(delta):
	if GlobalVariables.show_circles:
		circle.visible = true
	elif clicked:
		circle.visible = true
		Popups.showBuildInfo(get_global_transform_with_canvas(), self)
	else:
		circle.visible = false
	
	if Input.is_action_just_released("click") and !hovered:
		if $Button.has_focus():
			$Button.release_focus()
		else:
			_on_focus_exited()

func take_damage(damage: int):
	healthcomponent.damage(damage)
	damage_taken += damage
	cpu_particles_2d.emitting = true


func destroy():
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(0.1).timeout
	queue_free()
	GlobalVariables.turrets.erase(self)

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
	if not enemies.is_empty():
		$Shoot.pitch_scale = randf_range(0.9, 1.2)
		$Shoot.play()
		var target = enemies[0]
		var new_bullet = bullet.instantiate()
		add_child(new_bullet)
		new_bullet.gun = marker_2d
		new_bullet.target = target
		new_bullet.damage = sdamage
	

func upgrade():
	var new_plant = GlobalVariables.selected_turret.instantiate()
	turret.add_child(new_plant)
	new_plant.global_position = global_position
	$Button.release_focus()
	queue_free()

##Ui/popups stuff from here on. Could probably be it's own node- "UI handler" if the project were larger
func _on_mouse_entered() -> void:
	#circle.visible = true
	GlobalVariables.is_mouse_in_Area2D = true
	hovered = true


func _on_mouse_exited() -> void:
	#circle.visible = false
	GlobalVariables.is_mouse_in_Area2D = false
	hovered = false

func _on_focus_entered():
	clicked = true
	hovered = true

func _on_focus_exited():
	print("focus released")
	clicked = false
	Popups.hideBuildInfo()
