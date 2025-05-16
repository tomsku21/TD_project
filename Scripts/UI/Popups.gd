extends Control
@export var Upgrades: Array[Node] #Feels like a dumb way to do this, but should work
var lasttower: AnimatedSprite2D

func _enter_tree():
	%Build1stats.hide()

func hideBuildInfo():
	%Build1stats.hide()

func showBuildInfo(sizing, content):
	if !content == null:
		lasttower = content
		%Sell.tower = lasttower
		setcontent(content)
		setupgrades(content)
		var finalpos = sizing.get_origin()
		%Build1stats.position = finalpos
		%Build1stats.show()
		%Upgrades.show()
		check_overlap(%UpPopup)

func setupgrades(content):
	for i in Upgrades.size():
		if content.upgrades[i] != null:
			Upgrades[i].plant = content.upgrades[i]
			Upgrades[i].current_plant = lasttower
			Upgrades[i].set_stats()
			Upgrades[i].show()
		else:
			Upgrades[i].hide()
		

func setcontent(content):
	%Name.text = content.title
	%HealthBar.max_value = content.healthcomponent.MAX_HEALTH
	%HealthBar.value = content.healthcomponent.health
	#doing this through if elses doesn't feel great, but works without problems, no need to fix
	if content.stats.has("Damage"):
		%Dmg.text = str("Damage: ", content.stats["Damage"])
	elif content.stats.has("Healing"):
		%Dmg.text = str("Healing: ", content.stats["Healing"])
	elif content.stats.has("Income"):
		%Dmg.text = str("Income: ", content.stats["Income"])
	
	%AtkSpeed.text = str("ATKSpeed: ", content.stats["Atk Speed"])
	if content.stats.has("Kills"):
		%Kills.text = str("Kills: ", content.stats["Kills"])
	elif content.stats.has("Health Restored"):
		%Kills.text = str("Health Restored: ", content.stats["Health Restored"])
	elif content.stats.has("Money Made"):
		%Kills.text = str("Money Made: ", content.stats["Money Made"])
	%BuildPopup.show()
	%UpPopup.hide()
	%SellPopup.hide()



#The middle manager.
func upgrade():
	lasttower.upgrade()

func setupDescription(content):
	%UDesc.text = str(content.description)
	#This does not feel good, make better if there is a way.
	if content.stats.has("Damage"):
		%UDmg.text = str("Damage: ", content.stats["Damage"])
	elif content.stats.has("Healing"):
		%UDmg.text = str("Healing: ", content.stats["Healing"])
	elif content.stats.has("Income"):
		%UDmg.text = str("Income: ", content.stats["Income"])
	%UAtkSpeed.text = str("ATKSpeed: ", content.stats["Atk Speed"])
	%UCost.text = str("Costs: ", content.cost)
	%URequirement.text = str(content.upgrade, ": ", content.cur_req, "/", content.requirement)
	%URequirement.visible = content.requirement
	lasttower.clicked = false
	%BuildPopup.hide()
	%SellPopup.hide()
	%UpPopup.show()
	var dimensions = lasttower.get_global_transform_with_canvas()
	var finalpos = dimensions.get_origin()
	%Build1stats.position = finalpos

func sellDescription():
	%SName.text = lasttower.title
	%SCost.text = str("Cost: ", round(lasttower.cost * 0.75))
	lasttower.clicked = false
	%BuildPopup.hide()
	%UpPopup.hide()
	%SellPopup.show()
	var dimensions = lasttower.get_global_transform_with_canvas()
	var finalpos = dimensions.get_origin()
	%Build1stats.position = finalpos

func returnDesc():
	lasttower.clicked = true
	lasttower.hovered = false
	GlobalVariables.is_mouse_in_Area2D = false

func check_overlap(panel):
	var screen_rect = get_viewport_rect()
	var panel_rect = panel.get_global_rect()
	var overlap_bottom = 0
	overlap_bottom = panel_rect.position.y + panel_rect.size.y - screen_rect.size.y
	print("screen size: ", screen_rect, " panel size: ", panel_rect)
	print("overlap", overlap_bottom)
