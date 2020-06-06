extends Node2D

func str_and_round(f, digits=1):
	var s = str(f)
	var dot_pos = s.find_last('.')
	if dot_pos != -1:
		if digits == 0:
			digits = -1
		s.erase(dot_pos + 1 + digits, 100)
	return s

func set_data(car):
	$Panel/CarName.text = car['model']
	$Panel/WeightVal.text = str_and_round(car['weight']) + ' lbs'
	$Panel/ConsumptionVal.text = str_and_round(car['wastage']) + ' Miles/Galloon'
	$Panel/HorsePowerVal.text = str_and_round(car['ps']) + ' PS'
	$Panel/YearOfConstructionVal.text = str(car['year_of_construction'])
	$Panel/CylinderVal.text = str(car['cylinder']) + ' Cylinder'
	$Panel/CubicCapacityVal.text = str_and_round(car['cubic_capacity']) + ' cubic inches'
	$Panel/AccelerationVal.text = str_and_round(car['acceleration']) + ' seconds'
	$Panel/OriginVal.text = car['origin']
