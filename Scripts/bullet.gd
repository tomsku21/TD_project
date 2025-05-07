extends Area2D
var target
var gun: Marker2D
var speed: float = 500
var damage_dealt: int
var damage: int
func _physics_process(delta: float) -> void:
	if target:
		var direction = gun.global_position.direction_to(target.global_position)
		position += direction * speed * delta
	else:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)
		damage_dealt += damage
		queue_free()
