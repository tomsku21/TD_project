extends HBoxContainer


func _process(_delta):
	$BankM.text = str(GlobalVariables.cost, " $")
	
