extends Node2D

const axis_label = preload("res://AxisLabel.tscn")
const data_point = preload("res://DataPoint.tscn")
const GRID_SIZE: Vector2 = Vector2(1250, 850)
var cols: int = 0
var rows: int = 0
var cell_size: float
var i = 0
var initial_pos : Vector2
var labels : Array
var points : Array

func _ready():
	initial_pos = position

func draw_chart(x_min: float, x_max: float, x_step: float, x_label_every: int, y_min: float, y_max: float, y_step: float, y_label_every: int, data: Array):
	for l in labels:
		l.queue_free()
	for p in points:
		p.queue_free()
	
	points.clear()
	labels.clear()
			
	var x_diff = x_max - x_min
	var y_diff = y_max - y_min
	cols = x_diff / x_step
	rows = y_diff / y_step
	
	cell_size = min((GRID_SIZE.x - 40) / cols, (GRID_SIZE.y - 40) / rows)
	
		
	var width = cols * cell_size
	var height = rows * cell_size
	position = initial_pos - Vector2((cols * cell_size) / 2, (rows * cell_size) / 2)
	
	for c in range(cols + 1):
		if c % x_label_every == 0:
			var label = axis_label.instance()
			label.get_node("Label").text = str(x_min + x_step * c)
			label.position = Vector2(cell_size * c, cell_size * rows + 20)
			labels.append(label)
			add_child(label)
		
	for r in range(rows + 1):
		if r % y_label_every == 0:
			var label = axis_label.instance()
			label.get_node("Label").text = str(y_min + y_step * (rows - r))
			label.position = Vector2(-20 , cell_size * r)
			labels.append(label)
			add_child(label)
	
	var data_points = []
	
	for d in data:
		var point = data_point.instance()
		point.init(data[3])
		point.get_node("Sprite").modulate = d[2]
		var rel_x = width - (x_max - d[0]) / x_diff * width
		var rel_y = (y_max - d[1]) / y_diff * height
		point.position = Vector2(rel_x, rel_y)
		points.append(point)
		add_child(point)
		data_points.append(point)
	
	update()

	return data_points

func _draw():
	for c in range(cols + 1):
		if c == 0:
			draw_line(Vector2(c * cell_size, 0), Vector2(c * cell_size, rows * cell_size), Color("010101"), 1.2)
		else:
			draw_line(Vector2(c * cell_size, 0), Vector2(c * cell_size, rows * cell_size), Color("40010101"), 1.0)
	for r in range(rows + 1):
		if r == rows:
			draw_line(Vector2(0, r * cell_size), Vector2(cols * cell_size, r * cell_size), Color("010101"), 1.2)
		else:
			draw_line(Vector2(0, r * cell_size), Vector2(cols * cell_size, r * cell_size), Color("40010101"), 1.0)
