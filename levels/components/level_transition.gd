extends Area3D

@export var next_level: PackedScene


func _ready():
	if not next_level:
		print("Warning: level transition has no next level")

func _on_body_entered(body):
	if not is_instance_valid(next_level):
		return
	if body is Player:
		Global.change_level(next_level)
