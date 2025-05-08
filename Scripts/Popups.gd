extends Control
@export var Upgrades: Array[Node] #Feels like a dumb way to do this, but should work
var lasttower: Area2D

func _enter_tree():
	%Build1stats.hide()
	%Desc.text = str("")

func hideBuildInfo():
	%Build1stats.hide()

func showBuildInfo(sizing, content):
	if !content == null:
		setcontent(content)
		setupgrades(content)
		var finalpos = sizing.get_origin()
		%Build1stats.position = finalpos
		%Build1stats.show()
		lasttower = content
		%Upgrades.show()

func setupgrades(content):
	for i in Upgrades.size():
		if content.upgrades[i] != null:
			Upgrades[i].new_tower = content.upgrades[i]
			Upgrades[i].show()
		else:
			Upgrades[i].hide()
		

func setcontent(content):
	%Desc.hide()
	%HealthBar.max_value = content.healthcomponent.MAX_HEALTH
	%HealthBar.value = content.healthcomponent.health
	%HealthBar.show()
	%Dmg.text = str("DMG: ", content.sdamage)
	%AtkSpeed.text = str("ATKSpeed: ", content.atk_speed)
	%Kills.text = str("Kills: ", content.kills)
	%Kills.show()
	%Cost.hide()


#The middle manager.
func upgrade():
	lasttower.upgrade()

func setupDescription(content):
	%Desc.text = str(content.description)
	%Desc.show()
	%Dmg.text = str("DMG: ", content.damage)
	%AtkSpeed.text = str("AtkSpeed: ", content.atk_speed)
	%HealthBar.hide()
	%Kills.hide()
	%Cost.text = str("Costs: ", content.cost)
	%Cost.show()
	lasttower.clicked = false

func returnDesc():
	lasttower.clicked = true
