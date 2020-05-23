extends Node2D


var cars = []


class Car:
	var model
	var producer
	var wastage
	var cylinder
	var cubic_capacity
	var ps
	var weight
	var acceleration
	var year_of_construction
	var origin

	func _init(model_arg, producer_arg, wastage_arg, cylinder_arg, cubic_capacity_arg, ps_arg, weight_arg, acceleration_arg, year_of_construction_arg, origin_arg):
		self.model = model_arg
		self.producer = producer_arg
		if wastage_arg == 'NA':
			self.wastage = null
		else:
			self.wastage = float(wastage_arg)
		self.cylinder = int(cylinder_arg)
		self.cubic_capacity = float(cubic_capacity_arg)
		if ps_arg == 'NA':
			self.ps = null
		else:
			self.ps = float(ps_arg)
		self.weight = float(weight_arg)
		self.acceleration = float(acceleration_arg)
		self.year_of_construction = int(year_of_construction_arg)
		self.origin = origin_arg

	func _to_string():
		return 'Car (' +\
		'model: ' + model +\
		'; producer: ' + producer +\
		'; wastage: ' + str(wastage) +\
		'; cylinder: ' + str(cylinder) +\
		'; cubic_capacity: ' + str(cubic_capacity) +\
		'; ps: ' + str(ps) +\
		'; weight: ' + str(weight) +\
		'; acceleration: ' + str(acceleration) +\
		'; year_of_construction: ' + str(year_of_construction) +\
		'; origin: ' + origin +\
		')'

func car_from_line(line):
	var properties = line.split('\t')
	if len(properties) != 10:
		return null
	return Car.new(
		properties[0], properties[1], properties[2], properties[3], properties[4],
		properties[5], properties[6], properties[7], properties[8], properties[9]
	)

func read_cars():
	var file = File.new()
	if file.open("./dataset.csv", File.READ) != 0:
		print('Could not open dataset.csv')
		return
	var content = file.get_as_text()
	var lines = content.split('\n')
	var index = 0
	for line in lines:
		if index >= 2:
			var car = car_from_line(line)
			if car != null:
				cars.append(car)
		index += 1
	file.close()

func _ready():
	read_cars()
	var minimum = null
	var maximum = null
	for car in cars:
		var value = car.wastage
		if value == null:
			continue
		if minimum == null or minimum > value:
			minimum = value
		if maximum == null or maximum < value:
			maximum = value
			if not maximum is float:
				print(car)
	print(minimum)
	print(maximum)
