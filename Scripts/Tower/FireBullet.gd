extends Area2D

var target
var gun: Marker2D
var speed: float = 600
var damage: float = 20
var splash_radius: float = 64.0

@onready var sprite_2d: Sprite2D = $Sprite2D
func _ready() -> void:
	scale = Vector2(0,0)

func _physics_process(delta: float) -> void:
	if target:
		var direction = gun.global_position.direction_to(target.global_position)
		position += direction * speed * delta
		look_at(global_position + direction)
		scale += Vector2(15, 15) * delta
		scale.x = clamp(scale.x, 0.0, 1.0)
		scale.y = clamp(scale.y, 0.0, 1.0)
	else:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		print(get_parent())
		#await target.take_damage(damage, get_parent())
		apply_splash_damage()
		sprite_2d.visible = false
		await get_tree().create_timer(0.5).timeout
		queue_free()

func apply_splash_damage():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= splash_radius:
			if enemy.burn.has_method("FireDebuff"):
				enemy.burn.FireDebuff(damage, get_parent())
