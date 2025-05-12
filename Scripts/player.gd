extends Camera2D

@export var SPEED: float = 300.0
var zoom_level: float = 1.645

func _ready() -> void:
	zoom = Vector2(zoom_level, zoom_level)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()

	var new_position = position + direction * SPEED * delta

	var viewport_size = get_viewport_rect().size / zoom
	new_position.x = clamp(new_position.x, limit_left + viewport_size.x / 2, limit_right - viewport_size.x / 2)
	new_position.y = clamp(new_position.y, limit_top + viewport_size.y / 2, limit_bottom - viewport_size.y / 2)

	position = new_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_level -= 0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_level += 0.1

		zoom_level = clamp(zoom_level, 1.0, 3.0)

		zoom = Vector2(zoom_level, zoom_level)
