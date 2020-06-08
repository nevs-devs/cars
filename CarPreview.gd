extends Node2D

func str_and_round(f, digits=1):
	var s = str(f)
	var dot_pos = s.find_last('.')
	if dot_pos != -1:
		if digits == 0:
			digits = -1
		s.erase(dot_pos + 1 + digits, 100)
	return s

func set_data(label1, val1, label2, val2, metric1, metric2, model_name, producer):
	$Panel/Label1.text = Localization.car_properties[label1] + ":"
	if val1 is float:
		val1 = str_and_round(val1)
	if val2 is float:
		val2 = str_and_round(val2)
	$Panel/Val1.text = str(val1) + ' ' + metric1
	$Panel/Label2.text = Localization.car_properties[label2] + ":"
	$Panel/Val2.text = str(val2) + ' ' + metric2
	$Panel/CarName.text = producer.capitalize() + ' ' + model_name.capitalize()

func show_bottom_pin() -> void:
	$TopTip.visible = false
	$BottomTip.visible = true
	
func show_top_pin() -> void:
	$TopTip.visible = true
	$BottomTip.visible = false
