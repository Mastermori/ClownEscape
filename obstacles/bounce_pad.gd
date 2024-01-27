extends StaticBody3D

# The speed at which the platform will propell a player away
@export var bounce_velocity = 15.0
# The time in seconds before the platform will bounce a player again
# Do NOT set to values close to or below 0 as multiple collisions may occur
@export var cooldown = 1.0
# The countdown till the platform can propell the player again
var countdown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown = move_toward(countdown, 0, delta)

# Called by the player object when a collision with the platform has been detected.
func collide_with_player(player, collision):
	if countdown > 0:
		return
	player.velocity += collision.get_normal() * bounce_velocity
	countdown = cooldown
