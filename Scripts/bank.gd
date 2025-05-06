extends HBoxContainer


func _process(delta):
	$BankM.text = str(GlobalVariables.cost, " $")
	
