extends ParallaxLayer
@export var cloud_speed := -10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.motion_offset.x += cloud_speed * delta
