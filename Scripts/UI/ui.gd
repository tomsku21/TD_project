extends CanvasLayer
@export var bankPanel: Panel
@export var buyMenuPanel: Panel
@export var animationPlayer: AnimationPlayer
@export var current_round: Label
@export var shop_buton: TextureButton
@export_category("Game Over")
@export var gameOverPanel: Panel
@export var overVBoxContainer: VBoxContainer
@export_category("Pause Menu")
@export var pausePanel: Panel
@export var vboxContainer: VBoxContainer

@export_category("Settings")
@export var settingsPanel: Panel

@export_category("Next Round")
@export var nextRoundPanel: Panel

var played = false
var in_settings: bool = false
var masterIndex: int
var musicIndex: int
var sfxIndex: int
var startGame: bool = false
var shop_hide: bool = false
func _ready() -> void:
	SignalBus.NextRound.connect(_next_round)
	masterIndex = AudioServer.get_bus_index("Master")
	musicIndex = AudioServer.get_bus_index("Music")
	sfxIndex = AudioServer.get_bus_index("SFX")
	connect_interacts()
	
	defaultPanels(false)

func _process(_delta: float) -> void:
	if current_round != null:
		current_round.text = str("Current Round: ", GlobalVariables.current_round + 1)
	else:
		push_warning("current_round Label is not assigned!")
	if GlobalVariables.in_mainMenu:
		bankPanel.visible = false
		buyMenuPanel.visible = false
	elif not GlobalVariables.in_mainMenu and startGame == false:
		bankPanel.visible = true
		buyMenuPanel.visible = true
		startGame = true
	if Input.is_action_just_pressed("Esc") and GlobalVariables.game_over == false and not GlobalVariables.in_mainMenu:
		if not animationPlayer.current_animation == "Exit" and not animationPlayer.current_animation == "Shop" and not animationPlayer.current_animation == "Shop2":
			if in_settings:
				GlobalVariables.save_game()
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
				animationPlayer.speed_scale = 5.0
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

func _on_exit_pressed() -> void:
	animationPlayer.speed_scale = 1.0
	if gameOverPanel.visible:
		animationPlayer.play("New Game")
	else:
		animationPlayer.play("Exit")
	await _wait_until_half_animation()
	vboxContainer.visible = false
	overVBoxContainer.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	await _wait_until_animation_finish()
	bankPanel.visible = false
	buyMenuPanel.visible = false
	pausePanel.visible = false
	settingsPanel.visible = false
	gameOverPanel.visible = false
	GlobalVariables.in_mainMenu = true
	startGame = false
	GlobalVariables.reset()
	GlobalVariables.game_state = false
	GlobalVariables.started = false
	shop_buton.texture_normal = preload("res://Assets/UI/ArrowDown.png")
	animationPlayer.speed_scale = 6.0
	animationPlayer.play("Shop2")
	shop_hide = false

func _on_new_game_pressed() -> void:
	if GlobalVariables.game_over:
		animationPlayer.speed_scale = 1.0
		animationPlayer.play("New Game")
		await _wait_until_half_animation()
		get_tree().reload_current_scene()
		GlobalVariables.reset()
		defaultPanels(true)
		await _wait_until_animation_finish()
		defaultPanels(false)

func defaultPanels(reset: bool) -> void:
	bankPanel.visible = true
	buyMenuPanel.visible = true
	pausePanel.visible = false
	settingsPanel.visible = false
	if reset:
		overVBoxContainer.visible = false
	else:
		gameOverPanel.visible = false
		overVBoxContainer.visible = true

func _wait_until_half_animation() -> void:
	while animationPlayer.current_animation_position < animationPlayer.current_animation_length / 2:
		await get_tree().process_frame

func _wait_until_animation_finish() -> void:
	while animationPlayer.current_animation_position < animationPlayer.current_animation_length:
		await get_tree().process_frame

func _on_resume_pressed() -> void:
	bankPanel.visible = !bankPanel.visible
	buyMenuPanel.visible = !buyMenuPanel.visible
	pausePanel.visible = !pausePanel.visible
	get_tree().paused = !get_tree().paused


func _on_settings_pressed() -> void:
	vboxContainer.visible = !vboxContainer.visible
	settingsPanel.visible = !settingsPanel.visible
	in_settings = true

func connect_interacts() -> void:
	var sliders = get_tree().get_nodes_in_group("Setting_volume")
	for slider in sliders: #connect audio sliders to value changed signal and connect their values to their respective Audioserver indexes.
		slider.value_changed.connect(_on_value_changed.bind(slider.name))
		slider.visibility_changed.connect(_on_visibility_changed.bind(slider.name, slider))

func _on_visibility_changed(_name: String, slider) -> void:
	match _name:
		"MasterVolumeS":
			slider.value = db_to_linear(AudioServer.get_bus_volume_db(masterIndex))
			print("mastervolume: ", slider.value)
		"MusicVolumeS":
			slider.value = db_to_linear(AudioServer.get_bus_volume_db(musicIndex))
		"SFXVolumeS":
			slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfxIndex))

func _on_value_changed(value: float, _name: String) -> void:
	match _name:
		"MasterVolumeS":
			AudioServer.set_bus_volume_db(masterIndex, linear_to_db(value))
			print("Change ui mastervol to: ", value)
		"MusicVolumeS":
			AudioServer.set_bus_volume_db(musicIndex, linear_to_db(value))
		"SFXVolumeS":
			AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(value))


func _on_back_pressed() -> void:
	GlobalVariables.save_game()
	vboxContainer.visible = true
	settingsPanel.visible = false
	in_settings = false

func _next_round():
	nextRoundPanel.visible = true
	animationPlayer.play("NextRound")


func _on_button_pressed() -> void:
	nextRoundPanel.visible = false
	GlobalVariables.game_state = true


func _on_shop_button_pressed() -> void:
	if not animationPlayer.is_playing():
		animationPlayer.speed_scale = 1.0
		if shop_hide:
			shop_buton.texture_normal = preload("res://Assets/UI/ArrowDown.png")
			animationPlayer.play("Shop2")
			shop_hide = false
		else:
			shop_buton.texture_normal = preload("res://Assets/UI/ArrowUp.png")
			animationPlayer.play("Shop")
			shop_hide = true


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print("Windowed")
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			print("Fullscreen")
