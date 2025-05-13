extends Area2D
var target
var gun: Marker2D
var speed: float = 500
var damage_dealt: float
var damage: float
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if target:
		var direction = gun.global_position.direction_to(target.global_position)
		position += direction * speed * delta
	else:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body == target:
		if is_instance_valid(target) and target.has_method("take_damage"):
			target.take_damage(damage, get_parent())
			damage_dealt += damage
			sprite_2d.visible = false
			await get_tree().create_timer(1).timeout #the purpose of this wait?
			queue_free()
