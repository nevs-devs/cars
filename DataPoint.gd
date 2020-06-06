extends Node2D

onready var car_preview = get_node("/root/Main/CarPreview")
onready var car_description = get_node("/root/Main/CarDescription")

var car

func init(car_arg):
	car = car_arg

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		car_description.visible = true
		if global_position.y > 540:
			car_description.position = global_position - Vector2(0, 125)
		else:
			car_description.position = global_position + Vector2(0, 125)


func _on_Area2D_mouse_entered():
	car_preview.visible = true
	if global_position.y > 540:
		car_preview.position = global_position - Vector2(0, 90)
	else:
		car_preview.position = global_position + Vector2(0, 90)

func _on_Area2D_mouse_exited():
	car_preview.visible = false
