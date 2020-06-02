extends Control

var id = 0

signal selection_changed(id, checked)

func _ready():
	$CheckBox.connect("toggled", self, '_on_toggle')

func init(id_arg, text):
	id = id_arg
	$Label.text = text

func _on_toggle(pressed):
	emit_signal("selection_changed", id, pressed)
