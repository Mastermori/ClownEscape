extends Control

@onready var value_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/MouseSens/HBoxContainer/ValueLabel



func _ready() -> void:
	value_label.text = str(preload("res://game_settings/settings/Mouse/Sensitivity.tres").current)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_slider_value_changed(value: float) -> void:
	value_label.text = str(value)
