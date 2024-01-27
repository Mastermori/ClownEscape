@tool
class_name Platform
extends Node3D

@export var fix_position: bool :
	set(val):
		if val:
			var child = get_child(0)
			child.position = -child.get_child(0).position * child.scale.y
