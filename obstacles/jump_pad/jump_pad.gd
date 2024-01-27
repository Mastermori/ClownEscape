extends StaticBody3D

# The speed at which the platform will propell a player away
@export var bounce_height: float = 15.0
@export var bounce_direction_correction: Vector3 = Vector3.ZERO
# The time in seconds before the platform will bounce a player again
# Do NOT set to values close to or below 0 as multiple collisions may occur
@export var cooldown: float = 1.0
## Set this to limit with which collision normal the pad bounces
@export var collision_normal: Vector3
# The countdown till the platform can propell the player again
var countdown = 0
@export var is_enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown = move_toward(countdown, 0, delta)

# Called by the player object when a collision with the platform has been detected.
func collide_with_player(player: Player, collision: KinematicCollision3D):
	if not is_enabled:
		return
	if countdown > 0 or (collision_normal and not collision_normal.is_equal_approx(collision.get_normal())):
		return
	player.dash_charged = true
	var bounce_velocity = player.get_jump_velocity(bounce_height)
	player.velocity += (collision.get_normal() + bounce_direction_correction).normalized() * bounce_velocity
	countdown = cooldown
	$CJumpPad/AnimationPlayer.play("default")
	Global.play_sound_at(preload("res://player/Boing.ogg"), position)
	
	
	
func toggle_jump_pad():
	is_enabled = not is_enabled
