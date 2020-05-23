extends Node2D

const AxisOptions = ['wastage', 'cylinder', 'cubic_capacity', 'ps', 'weight', 'acceleration', 'year_of_construction']
var cars = []
var x_id = 0
var y_id = 1



var LIMITS = {
	'wastage': [4.0, 30.0, 2.0, 1],
	'cylinder': [1.0, 10.0, 1.0, 1],
	'cubic_capacity': [1000.0, 8000.0, 500.0, 1],
	'ps': [20.0, 260.0, 20.0, 1],
	'weight': [700.0, 2400.0, 100.0, 1],
	'acceleration': [6.0, 28.0, 2.0, 1],
	'year_of_construction': [66.0, 86.0, 1.0, 1]
}

func car_from_line(line):
	var properties = line.split('\t')
	if len(properties) != 10:
		return null
	return {
		'model': properties[0],
		'producer': properties[1],
		'wastage': properties[2],
		'cylinder': properties[3],
		'cubic_capacity': properties[4],
		'ps': properties[5],
		'weight': properties[6],
		'acceleration': properties[7],
		'year_of_construction': properties[8],
		'origin': properties[9],
	}

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
	x_id = id
	refresh_chart()

func _on_y_axis_changed(id):
	y_id = id
	refresh_chart()

func refresh_chart():
	var data = []
	var x_option = AxisOptions[x_id]
	var y_option = AxisOptions[y_id]
	for car in cars:
		data.append([car[x_option], car[y_option]])

	$Chart.draw_chart(
		LIMITS[x_option][0],
		LIMITS[x_option][1],
		LIMITS[x_option][2],
		LIMITS[x_option][3],
		LIMITS[y_option][0],
		LIMITS[y_option][1],
		LIMITS[y_option][2],
		LIMITS[y_option][3],
		data
	)

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
