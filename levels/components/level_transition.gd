extends Area3D

@export var next_level: PackedScene


func _on_body_entered(body):
	if not is_instance_valid(next_level):
		return
	if body is Player:
		Global.change_level(next_level)
