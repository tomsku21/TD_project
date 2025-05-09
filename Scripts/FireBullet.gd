extends Area2D

var target
var gun: Marker2D
var speed: float = 500
var damage: float = 20
var splash_radius: float = 64.0

@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if target:
		var direction = gun.global_position.direction_to(target.global_position)
		position += direction * speed * delta
	else:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		print(get_parent())
		target.take_damage(damage, get_parent())
		apply_splash_damage()
		sprite_2d.visible = false
		await get_tree().create_timer(0.5).timeout
		queue_free()

func apply_splash_damage():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= splash_radius:
			if enemy.has_method("FireDebuff"):
				enemy.FireDebuff(damage, get_parent())
