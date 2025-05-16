extends TextureButton
var tower: Node2D
var hovered: bool

func on_pressed():
	tower.sell()

func _process(_delta):
	if hovered:
		Popups.sellDescription()

func _on_mouse_entered():
	hovered = true
	

func _on_mouse_exited():
	hovered = false
	Popups.returnDesc()
