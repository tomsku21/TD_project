extends Area2D
var target
var gun: Marker2D
var speed: float = 500
var damage_dealt: int
var damage: int
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if target:
		var direction = gun.global_position.direction_to(target.global_position)
		position += direction * speed * delta
	else:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == target:
		if is_instance_valid(target) and target.has_method("take_damage"):
			var status = target.take_damage(damage)
			#damage_dealt += damage
			sprite_2d.visible = false
			await get_tree().create_timer(1).timeout
			queue_free()
