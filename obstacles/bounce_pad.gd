extends StaticBody3D

const BOUNCE_VELOCITY = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func collide_with_player(player, collision):
	player.velocity += collision.get_normal() * BOUNCE_VELOCITY
