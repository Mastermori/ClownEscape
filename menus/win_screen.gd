extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ui.set_fog_strength(.2)
	Global.ui.get_node("UserInterfaces").visible = true
	Global.timer_finished = true
	Global.ui.play_fade_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_menu_button_pressed():
	Global.ui.get_node("UserInterfaces").visible = false
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
