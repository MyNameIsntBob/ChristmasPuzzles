extends Node2D


var images = [
	preload("res://Images/ChristmasMarket.jpg"),
	preload("res://Images/ChristmasMeeting.jpg"),
	preload("res://Images/MaryChristmas.jpg"),
	preload("res://Images/Reindeer.jpg"),
	preload("res://Images/Santa.jpg"),
	preload("res://Images/SantasWorkshop.jpg"),
]

@export var level_select_holder : GridContainer

var level_select = preload("res://LevelSelect.tscn")
func _ready():
	for image in images:
		var new_level = level_select.instantiate()
		new_level.image = image
		level_select_holder.add_child(new_level)

func _on_check_box_toggled(toggled_on: bool):
	Global.easy_mode = toggled_on
