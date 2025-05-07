extends Control
var lasttower: Area2D

func _enter_tree():
	%Build1stats.hide()
	%Desc.text = str("")

func hideBuildInfo():
	%Build1stats.hide()

func showBuildInfo(sizing, content):
	if !content == null:
		setcontent(content)
		var finalpos = sizing.get_origin()
		%Build1stats.position = finalpos
		%Build1stats.show()
		lasttower = content
		

func setcontent(content):
	%Desc.hide()
	%HealthBar.max_value = content.healthcomponent.MAX_HEALTH
	%HealthBar.value = content.healthcomponent.health
	%HealthBar.show()
	%Dmg.text = str("DMG: ", content.sdamage)
	%AtkSpeed.text = str("ATKSpeed: ", content.atk_speed)
	%Kills.text = str("Kills: ", content.kills)
	%Kills.show()
	

#func upgrade(newtower):
	#lasttower.upgrade(newtower)

func setupDescription(content):
	%Desc.text = str(content.description)
	%Desc.show()
	%Dmg.text = str("DMG: ", content.damage)
	%AtkSpeed.text = str("AtkSpeed: ", content.atk_speed)
	%HealthBar.hide()
	%Kills.hide()
	lasttower.clicked = false

func returnDesc():
	lasttower.clicked = true
