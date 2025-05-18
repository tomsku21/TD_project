extends Tower
@export var grabbed: Array = []
var path
@export var attacking : bool = false
var atk_ready : bool = false

func _enter_tree() -> void:
	atk_ready = true

func _physics_process(_delta):
	if atk_ready and !enemies.is_empty():
		attacking = true
		atk_ready = false

func _on_attack_timer_timeout() -> void:
	atk_ready = true


func _attack() -> void:
	if not enemies.is_empty() and grabbed.is_empty() and enemies[0].grabbed == false:
		var target = enemies[0].get_parent()
		path = target.get_child(0).path
		path.remove_child(target)
		grabbed.append(target)
		target.get_child(0).grabbed = true
		target.get_child(0).currently_grabbed = true
		await get_tree().create_timer(10).timeout
		attack_timer.start()
		print("attack timer started")
		var restored_enemy = grabbed.pop_front()
		path.add_child(restored_enemy)
		target.get_child(0).take_damage(stats["Damage"], self)
		target.get_child(0).currently_grabbed = false
	else:
		print("doh you missed!")
		attack_timer.start()
