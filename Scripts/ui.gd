extends CanvasLayer
@export var bankPanel: Panel
@export var buyMenuPanel: Panel
@export var gameOverPanel: Panel
@export var animationPlayer: AnimationPlayer

@export_category("Pause Menu")
@export var pausePanel: Panel
@export var vboxContainer: VBoxContainer

@export_category("Settings")
@export var settingsPanel: Panel
@export var masterVolumeSlider: Slider
@export var musicVolumeSlider: Slider
@export var sfxVolumeSlider: Slider
var played = false
var in_settings: bool = false
var masterIndex: int
var musicIndex: int
var sfxIndex: int

func _ready() -> void:
	masterIndex = AudioServer.get_bus_index("Master")
	musicIndex = AudioServer.get_bus_index("Music")
	sfxIndex = AudioServer.get_bus_index("SFX")
	
	masterVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(masterIndex))
	musicVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(musicIndex))
	sfxVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(sfxIndex))
	bankPanel.visible = true
	buyMenuPanel.visible = true
	pausePanel.visible = false
	gameOverPanel.visible = false
	settingsPanel.visible = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc") and GlobalVariables.game_over == false:
		if in_settings:
			vboxContainer.visible = true
			settingsPanel.visible = false
			in_settings = false
		else:
			bankPanel.visible = !bankPanel.visible
			buyMenuPanel.visible = !buyMenuPanel.visible
			vboxContainer.visible = true
			settingsPanel.visible = false
			pausePanel.visible = !pausePanel.visible
			get_tree().paused = !get_tree().paused
			animationPlayer.speed_scale = 2.0
			if animationPlayer.is_playing():
				animationPlayer.stop()
				animationPlayer.play("PauseMenu")
			else:
				animationPlayer.play("PauseMenu")

	if GlobalVariables.game_over == true:
		bankPanel.visible = false
		buyMenuPanel.visible = false
		pausePanel.visible = false
		gameOverPanel.visible = true
		animationPlayer.speed_scale = 1.0
		if !played:
			animationPlayer.play("Game Over")
			played = true


func _on_new_game_pressed() -> void:
	if GlobalVariables.game_over:
		get_tree().reload_current_scene()
		GlobalVariables.reset()


func _on_resume_pressed() -> void:
	bankPanel.visible = !bankPanel.visible
	buyMenuPanel.visible = !buyMenuPanel.visible
	pausePanel.visible = !pausePanel.visible
	get_tree().paused = !get_tree().paused


func _on_settings_pressed() -> void:
	vboxContainer.visible = !vboxContainer.visible
	settingsPanel.visible = !settingsPanel.visible
	in_settings = true


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterIndex, linear_to_db(value))


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(musicIndex, linear_to_db(value))


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(value))
