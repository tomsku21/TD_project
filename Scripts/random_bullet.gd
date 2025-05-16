extends Area2D
var target
var gun: Marker2D
@export var speed: float = 500
var damage: int
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if target:
		var direction = gun.global_position.direction_to(target.global_position)
		position += direction * speed * delta
		self.look_at(target.global_position)
	else:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.tower == target:
		if is_instance_valid(target) and target.has_method("take_damage"):
			target.take_damage(damage)
			sprite_2d.visible = false
			await get_tree().create_timer(1).timeout
			queue_free()
