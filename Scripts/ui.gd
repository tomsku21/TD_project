extends CanvasLayer
@export var bankPanel: Panel
@export var buyMenuPanel: Panel
@export var pausePanel: Panel
@export var gameOverPanel: Panel
@export var animationPlayer: AnimationPlayer
var played = false
func _ready() -> void:
	bankPanel.visible = true
	buyMenuPanel.visible = true
	pausePanel.visible = false
	gameOverPanel.visible = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc") and GlobalVariables.game_over == false:
		bankPanel.visible = !bankPanel.visible
		buyMenuPanel.visible = !buyMenuPanel.visible
		pausePanel.visible = !pausePanel.visible
		get_tree().paused = !get_tree().paused
	if GlobalVariables.game_over == true:
		bankPanel.visible = false
		buyMenuPanel.visible = false
		pausePanel.visible = false
		gameOverPanel.visible = true
		if !played:
			animationPlayer.play("Game Over")
			played = true


func _on_new_game_pressed() -> void:
	if GlobalVariables.game_over:
		get_tree().reload_current_scene()
		GlobalVariables.reset()
