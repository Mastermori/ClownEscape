extends Control


func _ready():
	Global.ui.set_fog_strength(.2)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
