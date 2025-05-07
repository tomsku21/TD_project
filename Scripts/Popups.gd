extends Control

func hideBuildInfo():
	%Buildingstats.hide()

func showBuildInfo(sizing, content):
	if !content == null:
		setcontent(content)
		var finalpos = sizing.get_origin()
		%Buildingstats.position = finalpos
		%Buildingstats.show()
		

func setcontent(content):
	%Desc.text = str("")
	%HealthBar.max_value = content.healthcomponent.MAX_HEALTH
	%HealthBar.value = content.healthcomponent.health
	%Dmg.text = str("DMG: ", content.sdamage)
	%AtkSpeed.text = str("ATKSpeed: ", content.atk_speed)
	%Kills.text = str("Kills: ", content.kills)
	
