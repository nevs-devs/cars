extends Node2D

const axis_label = preload("res://AxisLabel.tscn")
const data_point = preload("res://DataPoint.tscn")
const GRID_SIZE: int = 500
var cols: int = 0
var rows: int = 0
var cell_size: float
var i = 0
var initial_pos : Vector2
var labels : Array

func _ready():
	initial_pos = position

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if i == 0:
			draw_chart(0, 100, 10, 2, 23, 49, 1, 2, [[10, 25]])
			i+=1
		else:
			draw_chart(17, 18, 0.05, 4, 0.2, 0.8, 0.05, 2, [[17.2, 0.3]])
		
func draw_chart(x_min: float, x_max: float, x_step: float, x_label_every: int, y_min: float, y_max: float, y_step: float, y_label_every: int, data: Array):
	if len(labels) > 0:
		for l in labels:
			l.queue_free()
		labels.clear()
			
	var x_diff = x_max - x_min
	var y_diff = y_max - y_min
	cols = x_diff / x_step
	rows = y_diff / y_step
	cell_size = GRID_SIZE / max(rows, cols)
	var width = cols * cell_size
	var height = rows * cell_size
	position = initial_pos - Vector2((cols * cell_size) / 2, (rows * cell_size) / 2)
	
	for c in range(cols + 1):
		if c % 2 == 0:
			var label = axis_label.instance()
			label.get_node("Label").text = str(x_min + x_step * c)
			label.position = Vector2(cell_size * c, cell_size * rows + 20)
			labels.append(label)
			add_child(label)
		
	for r in range(rows + 1):
		if r % 2 == 0:
			var label = axis_label.instance()
			label.get_node("Label").text = str(y_min + y_step * (rows - r))
			label.position = Vector2(-20 , cell_size * r)
			labels.append(label)
			add_child(label)
	
	
	for d in data:
		var point = data_point.instance()
		var rel_x = width - (x_max - d[0]) / x_diff * width
		var rel_y = (y_max - d[1]) / y_diff * height
		point.position = Vector2(rel_x, rel_y)
		add_child(point)
	
	update()

func _draw():
	for c in range(cols + 1):
		draw_line(Vector2(c * cell_size, 0), Vector2(c * cell_size, rows * cell_size), Color(1, 1, 1, 0.1), 1.0)
	for r in range(rows + 1):
		draw_line(Vector2(0, r * cell_size), Vector2(cols * cell_size, r * cell_size), Color(1, 1, 1, 0.1), 1.0)

