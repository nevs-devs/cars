extends Node2D

onready var car_preview = get_node("/root/Main/CarPreview")
onready var car_description = get_node("/root/Main/CarDescription")
const MODULATE_SPEED = 4.0
const MIN_MODULATE = 0.2

var car
var x_value
var y_value
var x_option
var y_option
var x_metric
var y_metric
var color: Color
var white_fade = 0.0
var hovered = true

func init(car_arg, color_arg, x_value_arg, y_value_arg, x_option_arg, y_option_arg, x_metric_arg, y_metric_arg):
	car = car_arg
	color = color_arg
	x_value = x_value_arg
	y_value = y_value_arg
	x_option = x_option_arg
	y_option = y_option_arg
	x_metric = x_metric_arg
	y_metric = y_metric_arg
	$Sprite.modulate = color

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		car_description.set_data(car)
		car_description.visible = true
		car_preview.visible = false
		if global_position.y > 540:
			car_description.position = global_position - Vector2(0, 125)
			car_description.show_bottom_pin()
		else:
			car_description.position = global_position + Vector2(0, 125)
			car_description.show_top_pin()


func _on_Area2D_mouse_entered():
	if car_description.visible: return
	
	car_preview.set_data(x_option, x_value, y_option, y_value, x_metric, y_metric, car['model'], car['producer'])
	car_preview.visible = true
	if global_position.y > 540:
		car_preview.position = global_position - Vector2(0, 100)
		car_preview.show_bottom_pin()
	else:
		car_preview.position = global_position + Vector2(0, 100)
		car_preview.show_top_pin()
func _on_Area2D_mouse_exited():
	car_preview.visible = false

func _process(delta):
	if hovered:
		white_fade = max(0.0, white_fade - (delta*MODULATE_SPEED))
		$Sprite.z_index = 2
	else:
		white_fade = min(1.0-MIN_MODULATE, white_fade + (delta*MODULATE_SPEED))
		$Sprite.z_index = 1
	$Sprite.modulate = color.linear_interpolate(Color.white, white_fade)

func set_hovered(hov):
	hovered = hov
