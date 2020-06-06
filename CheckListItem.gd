extends Control

var id = 0

signal selection_changed(id, checked)
signal selection_entered(id)
signal selection_exited(id)

func _ready():
	$CheckBox.connect("toggled", self, '_on_toggle')
	$CheckBox.connect("mouse_entered", self, '_on_mouse_enter')
	$CheckBox.connect("mouse_exited", self, '_on_mouse_exit')

func init(id_arg, text, color, number):
	id = id_arg
	$Label.text = text + " (" + str(number) + ")"
	$Label.modulate = color

func _on_toggle(pressed):
	emit_signal("selection_changed", id, pressed)
	if not pressed:
		emit_signal("selection_exited", id)

func _on_mouse_enter():
	if $CheckBox.pressed:
		emit_signal("selection_entered", id)

func _on_mouse_exit():
	emit_signal("selection_exited", id)

func set_checked(checked):
	$CheckBox.pressed = checked
