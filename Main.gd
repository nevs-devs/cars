extends Node2D


func _ready():
	var file = File.new()
	if file.open("./dataset.csv", File.READ) != 0:
		print('Could not open dataset.csv')
		return
	for line in file.get_line():
		print(line)
