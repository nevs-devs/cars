extends Node2D

const check_list_item = preload("res://CheckListItem.tscn")
const AxisOptions = ['wastage', 'cylinder', 'cubic_capacity', 'ps', 'weight', 'acceleration', 'year_of_construction']
const AxisOptionCoefficients = {
	'wastage': 1.609/3.785,
	'cylinder': 1,
	'cubic_capacity': 16.387,
	'ps': 1,
	'weight': 0.4536,
	'acceleration': 1,
	'year_of_construction': 1
}
const SelectOptions = ['producer', 'origin']

var SelectionColors = []
var cars = []
var x_id = 0
var y_id = 1
var select_id = 0
var selection_toggles = []
var selections = []
var enable_refresh = true
var current_data_points = []
var current_cars = []

var LIMITS = {
	'wastage': [0.0, 15.0, 1.0, 1, 'km/l'],
	'cylinder': [1.0, 10.0, 1.0, 1, ''],
	'cubic_capacity': [14000.0, 130000.0, 10000.0, 2, 'ccm'],
	'ps': [20.0, 260.0, 20.0, 1, ''],
	'weight': [200.0, 1200.0, 100.0, 2, 'kg'],
	'acceleration': [4.0, 28.0, 2.0, 1, 's'],
	'year_of_construction': [66.0, 86.0, 1.0, 1, '']
}

func car_from_line(line):
	var properties = line.split('\t')
	if len(properties) != 10:
		return null
	
	var car = {
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
	for key in car:
		if key in AxisOptions:
			if car[key] == 'NA':
				car[key] = null
			else:
				car[key] = float(car[key]) * AxisOptionCoefficients[key]
		elif car[key] == 'NA':
			car[key] = null
	return car

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
	for key in AxisOptions:
		var max_value = cars[0][key]
		var min_value = cars[0][key]
		for car in cars:
			var value = car[key]
			if value == null:
				continue
			max_value = max(max_value, value)
			min_value = min(min_value, value)
		print('min ', key, ': ', min_value)
		print('max ', key, ': ', max_value)

func _on_x_axis_changed(id):
	x_id = id
	$XAxisChooser.text = Localization.car_properties[AxisOptions[id]]
	refresh_chart()

func _on_y_axis_changed(id):
	y_id = id
	$YAxisChooser.text = Localization.car_properties[AxisOptions[id]]
	refresh_chart()

func refresh_chart():
	if not enable_refresh:
		return
	var data = []
	var x_option = AxisOptions[x_id]
	var y_option = AxisOptions[y_id]
	current_cars.clear()
	current_cars.clear()
	for car in cars:
		var selection_option = SelectOptions[select_id]
		var select_index = selections.find(car[selection_option])
		if not selection_toggles[select_index]:
			continue
		var color = SelectionColors[select_index]
		var x = car[x_option]
		var y = car[y_option]
		if x == null or y == null:
			continue
		data.append([x, y, color, car])
		current_cars.append(car)

	current_data_points = $Chart.draw_chart(
		LIMITS[x_option][0],
		LIMITS[x_option][1],
		LIMITS[x_option][2],
		LIMITS[x_option][3],
		LIMITS[y_option][0],
		LIMITS[y_option][1],
		LIMITS[y_option][2],
		LIMITS[y_option][3],
		data,
		x_option,
		y_option,
		LIMITS[x_option][4],
		LIMITS[y_option][4]
	)

func _on_select_changed(id):
	select_id = id
	refresh_select()

func get_unique_values(key):
	var values = {}
	for car in cars:
		if car[key] in values:
			values[car[key]] += 1
		else:
			values[car[key]] = 1
	return values

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func select_all():
	enable_refresh = false
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.set_checked(true)
	enable_refresh = true
	refresh_chart()

func select_none():
	enable_refresh = false
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.set_checked(false)
	enable_refresh = true
	refresh_chart()

func refresh_select():
	$SelectButton.text = Localization.car_properties[SelectOptions[select_id]]
	$XAxisChooser.text = Localization.car_properties[AxisOptions[x_id]]
	$YAxisChooser.text = Localization.car_properties[AxisOptions[y_id]]
	delete_children($ScrollContainer/VBoxContainer)
	var values = get_unique_values(SelectOptions[select_id])
	var values_keys = values.keys()
	values_keys.sort()
	var index = 0
	selection_toggles = []
	selections = []
	for value in values_keys:
		selection_toggles.append(true)
		selections.append(value)
		var item = check_list_item.instance()
		item.init(index, value, SelectionColors[index], values[value])
		$ScrollContainer/VBoxContainer.add_child(item)
		index += 1
		item.connect("selection_changed", self, "_on_selection_changed")
		item.connect("selection_entered", self, "_on_selection_entered")
		item.connect("selection_exited", self, "_on_selection_exited")
	refresh_chart()

func _on_selection_entered(id):
	var selection_name = SelectOptions[select_id]
	var current_selection = selections[id]

	for index in range(len(current_cars)):
		var current_car = current_cars[index]
		var current_data_point = current_data_points[index]

		current_data_point.set_hovered(current_car[selection_name] == current_selection)

func _on_selection_exited(_id):
	for current_data_point in current_data_points:
		current_data_point.set_hovered(true)

func _on_selection_changed(id, pressed):
	selection_toggles[id] = pressed
	refresh_chart()

func add_options():
	var index = 0
	for option in AxisOptions:
		$XAxisChooser.get_popup().add_item(Localization.car_properties[option], index)
		$YAxisChooser.get_popup().add_item(Localization.car_properties[option], index)
		index += 1
	$XAxisChooser.get_popup().connect('id_pressed', self, '_on_x_axis_changed')
	$YAxisChooser.get_popup().connect('id_pressed', self, '_on_y_axis_changed')

	index = 0
	for option in SelectOptions:
		$SelectButton.get_popup().add_item(Localization.car_properties[option], index)
		index += 1

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		$CarDescription.visible = false

func _ready():
	# some random colors
	SelectionColors.append(Color.red)
	SelectionColors.append(Color.blue)
	SelectionColors.append(Color.green)

	for _i in range(30):
		SelectionColors.append(Color(randf()*0.8, randf()*0.8, randf()*0.8, 1.0))

	read_cars()
	add_options()
	refresh_select()
	refresh_chart()
	$SelectButton.get_popup().connect('id_pressed', self, '_on_select_changed')
