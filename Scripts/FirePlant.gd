extends Tower

@export var Attack_effect: CPUParticles2D
@export var fire_bullet_scene: PackedScene # Assign FireBullet.tscn in the editor

func _ready() -> void:
	super._ready() # Call parent Tower's _ready to initialize common tower properties
	# Ensure attack timer is set up with exported atk_speed
	%AttackTimer.wait_time = atk_speed

func _on_attack_timer_timeout() -> void:
	if not enemies.is_empty():
		$Shoot.pitch_scale = randf_range(0.9, 1.2)
		$Shoot.play()
		if Attack_effect:
			Attack_effect.emitting = true
		var target = enemies[0]
		shoot(target)

func shoot(target: Node2D) -> void:
	if fire_bullet_scene and target:
		var fire_bullet = fire_bullet_scene.instantiate()
		add_child(fire_bullet)
		fire_bullet.target = target
		fire_bullet.gun = marker_2d # Assuming Marker2D is used as the gun position, adjust if named differently
		fire_bullet.damage = sdamage # Use tower's exported sdamage for fire_bullet damage
		fire_bullet.splash_radius = 64.0 # Match Firebullet.gd's splash radius, adjustable via export if needed
