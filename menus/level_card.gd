@tool
extends PanelContainer

@export var level_name: String :
	set(val):
		level_name = val
		if is_node_ready():
			%Label.text = val
@export var level_scene: PackedScene

func _ready():
	level_name = level_name

func _on_gui_input(event):
	if Engine.is_editor_hint():
		return
	if not event is InputEventMouseButton:
		return
	if not event.is_pressed():
		return
	if not level_scene:
		return
	Global.in_menu = false
	Global.change_level(level_scene)
