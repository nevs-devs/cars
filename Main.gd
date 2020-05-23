extends Node2D


var cars = []
const AxisOptions = ['wastage', 'cylinder', 'cubic_capacity', 'ps', 'weight', 'acceleration', 'year_of_construction']

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

var LIMITS = {
	'wastage': [4.0, 30.0, 2.0],
	'cylinder': [1.0, 10.0, 1.0],
	'cubic_capacity': [1000.0, 8000.0, 500.0],
	'ps': [20.0, 260.0, 20.0],
	'weight': [700.0, 2400.0, 100.0],
	'acceleration': [6.0, 28.0, 2.0],
	'year_of_construction': [66.0, 86.0, 1.0]
}

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
	if file.open("./dataset.tsv", File.READ) != 0:
		print('Could not open dataset.tsv')
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

func _on_x_axis_changed(id):
	print(id)

func _on_y_axis_changed(id):
	print(id)

func add_options():
	var index = 0
	for option in AxisOptions:
		$XAxisChooser.get_popup().add_item(option, index)
		$YAxisChooser.get_popup().add_item(option, index)
		index += 1
	$XAxisChooser.get_popup().connect('id_pressed', self, '_on_x_axis_changed')
	$YAxisChooser.get_popup().connect('id_pressed', self, '_on_y_axis_changed')

func _ready():
	read_cars()
	add_options()
