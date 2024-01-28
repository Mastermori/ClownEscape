extends Control

@export var first_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ui.set_fog_strength(.2)
	Global.in_menu = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	Global.in_menu = false
	Global.change_level(first_level)


func _on_level_select_button_pressed():
	get_tree().change_scene_to_file("res://menus/level_select_menu.tscn")
