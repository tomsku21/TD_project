extends Control
var lasttower: PackedScene

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
		#lasttower = content
		

func setcontent(content):
	%HealthBar.max_value = content.healthcomponent.MAX_HEALTH
	%HealthBar.value = content.healthcomponent.health
	%Dmg.text = str("DMG: ", content.sdamage)
	%AtkSpeed.text = str("ATKSpeed: ", content.atk_speed)
	%Kills.text = str("Kills: ", content.kills)
	

#func upgrade(newtower):
	#lasttower.upgrade(newtower)

func setDescription(desc):
	%Desc.text = str(desc)
