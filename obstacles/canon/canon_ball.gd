extends RigidBody3D

var push_strength: float = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	$Smoothing.teleport()

func _on_body_entered(body):
	if body is Player:
		var player := body as Player
		player.velocity += (player.global_position - global_position).normalized() * push_strength
