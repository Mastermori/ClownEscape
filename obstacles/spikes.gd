extends Area3D



func _on_body_entered(body):
	Global.level.reset_player()
