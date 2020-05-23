extends Node2D

const axis_label = preload("res://AxisLabel.tscn")
const CANVAS_SIZE: int = 500
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
			draw_chart(0, 100, 10, 2, 23, 49, 1, 2, [[]])
			i+=1
		else:
			draw_chart(0, 200, 10, 4, 0.2, 0.8, 0.05, 2, [[]])
		
func draw_chart(x_min: float, x_max: float, x_step: float, x_label_every: int, y_min: float, y_max: float, y_step: float, y_label_every: int, data: Array):
	if len(labels) > 0:
		for l in labels:
			l.queue_free()
		labels.clear()
			
	cols = (x_max - y_min) / x_step
	rows = (y_max - y_min) / y_step
	cell_size = CANVAS_SIZE / max(rows, cols)
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
	
	update()

func _draw():
	for c in range(cols + 1):
		draw_line(Vector2(c * cell_size, 0), Vector2(c * cell_size, rows * cell_size), Color(1, 1, 1, 0.1), 1.0)
	for r in range(rows + 1):
		draw_line(Vector2(0, r * cell_size), Vector2(cols * cell_size, r * cell_size), Color(1, 1, 1, 0.1), 1.0)

