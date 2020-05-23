extends Node2D

const axis_label = preload("res://AxisLabel.tscn")
const CANVAS_SIZE = 500
const YMIN = 60
const YMAX = 80
const YSTEP = 1
const XMIN = 0
const XMAX = 900
const XSTEP = 100
var cols
var rows
var cell_size

func _ready():
	rows = (YMAX - YMIN) / YSTEP
	cols = (XMAX - XMIN) / XSTEP
	cell_size = CANVAS_SIZE / max(rows, cols)
	position -= Vector2((cols * cell_size) / 2, (rows * cell_size) / 2)
	
	for c in range(cols + 1):
		var label = axis_label.instance()
		label.get_node("Label").text = str(XMIN + XSTEP * c)
		label.position = Vector2(cell_size * c, cell_size * rows + 20) 
		add_child(label)
		
	for r in range(rows + 1):
		var label = axis_label.instance()
		label.get_node("Label").text = str(YMIN + YSTEP * (rows - r))
		label.position = Vector2(-20 , cell_size * r) 
		add_child(label)

func _draw():
	for c in range(cols + 1):
		draw_line(Vector2(c * cell_size, 0), Vector2(c * cell_size, rows * cell_size), Color(1, 1, 1, 0.1), 1.0)
	for r in range(rows + 1):
		draw_line(Vector2(0, r * cell_size), Vector2(cols * cell_size, r * cell_size), Color(1, 1, 1, 0.1), 1.0)

