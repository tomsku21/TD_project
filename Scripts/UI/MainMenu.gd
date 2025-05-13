extends Node

var masterIndex: int
var musicIndex: int
var sfxIndex: int

func _ready():
	%MainMenu.visible = true
	%Settings.visible = false
	setup_volumes()
	register_interacts()


func setup_volumes():
	masterIndex = AudioServer.get_bus_index("Master")
	musicIndex = AudioServer.get_bus_index("Music")
	sfxIndex = AudioServer.get_bus_index("SFX")


func register_interacts():
	var buttons = get_tree().get_nodes_in_group("main_menu")
	for button in buttons:
		print("registering button: ", button.name)
		button.pressed.connect(_on_button_pressed.bind(button.name))
	var sliders = get_tree().get_nodes_in_group("Volumer")
	for slider in sliders: #connect audio sliders to value changed signal and connect their values to their respective Audioserver indexes.
		slider.value_changed.connect(_on_value_changed.bind(slider.name))
		match slider.name:
			"MasterVolumeS":
				slider.value = db_to_linear(AudioServer.get_bus_volume_db(masterIndex))
			"MusicVolumeS":
				slider.value = db_to_linear(AudioServer.get_bus_volume_db(musicIndex))
			"SFXVolumeS":
				slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfxIndex))

func _on_button_pressed(_name):
	match _name:
		"Back":
			#change to happen through animations.
			%Settings.visible = false
			%MainMenu.visible = true
		"Start":
			#Change later to open stage select panel, if you make multiple layouts, 
			#otherwise just push player to main scene.
			get_tree().change_scene_to_file("res://Scenes/Main.tscn")
			GlobalVariables.in_mainMenu = false
			GlobalVariables.game_state = true
		"Options":
			%Settings.visible = true
			%MainMenu.visible = false
		"Quit":
			#Add confirmation maybe?
			get_tree().quit()

func _on_value_changed(value, _name) -> void:
	match _name:
		"MasterVolumeS":
			AudioServer.set_bus_volume_db(masterIndex, linear_to_db(value))
		"MusicVolumeS":
			AudioServer.set_bus_volume_db(musicIndex, linear_to_db(value))
		"SFXVolumeS":
			AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(value))
