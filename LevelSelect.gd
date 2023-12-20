extends Control

var image
var puzzle_scene = "res://Main.tscn"

func _ready():
	$Image.texture = image

func _on_button_pressed():
	Global.puzzle_image = image
	get_tree().change_scene_to_file(puzzle_scene)

