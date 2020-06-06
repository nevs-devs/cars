extends Node2D

func set_data(label1, val1, label2, val2, metric1, metric2, model_name):
	$Panel/Label1.text = label1
	$Panel/Val1.text = str(val1) + ' ' + metric1
	$Panel/Label2.text = label2
	$Panel/Val2.text = str(val2) + ' ' + metric2
	$Panel/CarName.text = model_name
