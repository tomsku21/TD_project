extends Tower


@export var fire_bullet_scene: PackedScene # Assign FireBullet.tscn in the editor
@export var animation: AnimatedSprite2D
@export var attack_frame: int
func _ready() -> void:
	super._ready() # Call parent Tower's _ready to initialize common tower properties
	# Ensure attack timer is set up with exported atk_speed
	%AttackTimer.wait_time = atk_speed

func _on_attack_timer_timeout() -> void:
	if not enemies.is_empty():
		var target = enemies[0]
		if target.global_position.x > global_position.x:
			animation.flip_h = false
		else:
			animation.flip_h = true
		shoot(target)
	
func shoot(target: Node2D) -> void:
	if fire_bullet_scene and target:
		animation.play("Attack")
		while animation.frame != attack_frame:
			await animation.frame_changed
		$Shoot.pitch_scale = randf_range(0.9, 1.2)
		$Shoot.play()
		var fire_bullet = fire_bullet_scene.instantiate()
		add_child(fire_bullet)
		fire_bullet.target = target
		fire_bullet.gun = marker_2d # Assuming Marker2D is used as the gun position, adjust if named differently
		fire_bullet.damage = sdamage # Use tower's exported sdamage for fire_bullet damage
		fire_bullet.splash_radius = 64.0 # Match Firebullet.gd's splash radius, adjustable via export if needed
		await get_tree().create_timer(0.1).timeout
		animation.play("Idle")
