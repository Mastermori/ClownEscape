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
@export var is_enabled: bool = true
@export var disable_auto_rotation: bool = false

var countdown = 0

@onready var jump_direction := %JumpDirection as Marker3D

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
	#var direction = collision.get_normal()
	var direction: Vector3 = (jump_direction.global_position - global_position).normalized()
	if direction.y < .9 and not disable_auto_rotation and Input.is_action_pressed("jump"):
		var player_dir: Vector3 = player.get_global_transform().basis.z
		var y_rot := player_dir.signed_angle_to(-Vector3(direction.x, 0, direction.z), Vector3(0, 1, 0))
		if abs(y_rot) > PI/4.0:
			lerp_camera(player, y_rot)
	player.velocity = (direction + bounce_direction_correction).normalized() * bounce_velocity
	countdown = cooldown
	$CJumpPad/AnimationPlayer.play("default")
	Global.play_sound_at(preload("res://player/Boing.ogg"), position)

func lerp_camera(player: Player, y_rot: float) -> void:
	player.lock_camera(true)
	var tween := create_tween().set_loops(15)
	tween.tween_callback(player.rotate_y.bind(y_rot / 15.0)).set_delay(.01)
	tween.finished.connect(player.lock_camera.bind(false))

func toggle_jump_pad():
	is_enabled = not is_enabled
