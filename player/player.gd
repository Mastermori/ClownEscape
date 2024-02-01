class_name Player
extends CharacterBody3D


const SPEED = 5.0
#const JUMP_VELOCITY = 8.0
const MOUSE_SENSITIVITY = 0.0025
const ACCELERATION = 15.0
const FLOORED_ACCELERATION = 60.0
const DASH_COOLDOWN_DURATION = .5
const DASH_VELOCITY = 15.0

const SENSITIVITY = preload("res://game_settings/settings/Mouse/Sensitivity.tres")

@export var jump_height: float = 2.0
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_fall: float = 0.43
@export var koyote_time_frame: float = .1

@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var dash_cooldown: float = 0.0
var dash_charged: bool = true

var camera_locked: bool = false
var debug_disable_gravity: bool = false

# Whether the player should make walking sounds.
var is_walking: bool = false
var is_falling: bool = false
var is_dead: bool = false

@onready var camera = %Camera3D
@onready var koyote_timer = $KoyoteTimer

func _ready():
	Global.player = self
	$StepsPlayer.is_active_player = true

func _physics_process(delta):
	if is_dead:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)
		move_and_slide()
		_special_collisions()
		return
	
	var acceleration = FLOORED_ACCELERATION
	# Add the gravity.
	if not is_on_floor():
		acceleration = ACCELERATION
		velocity.y += _get_gravity() * delta
	else:
		dash_charged = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and ((is_on_floor() or not koyote_timer.is_stopped()) or debug_disable_gravity):
		koyote_timer.stop()
		if debug_disable_gravity:
			position.y += jump_velocity
		else:
			velocity.y = jump_velocity
		Global.play_sound_at(preload("res://player/Boing.ogg"), position)
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	
	# Handle dash
	if dash_cooldown > 0:
		dash_cooldown -= delta
	elif Input.is_action_pressed("dash") and dash_charged:
		dash_charged = false
		dash_cooldown = DASH_COOLDOWN_DURATION
		Global.play_sound_at(preload("res://player/Woosh.ogg"), position)
		# We can use one of these two transforms. The camera transform would dash EXACTLY where we are looking.
		# However it needs to be limited since it can otherwise be used to fly.
		# The vanilla transform only accelerates horizontally but can thus be used much more freely.
		#velocity -= camera.global_transform.basis.z * DASH_VELOCITY
		var dash_velocity = -transform.basis.z * DASH_VELOCITY
		velocity.x = dash_velocity.x
		velocity.z = dash_velocity.z
	
	# Here we finally process the movement. We use move_and_slide since we want to slide along surfaces.
	# Additionally it allows for easy detection of whether we are grounded.
	# We must still loop over all the collisions since some objects inflict additional bounces upon us.
	# Theoretically we might be afflicted by multiple bounces at once, making them cancel each other out.
	# But that's something that'll probably never happen so we take the faster approach. No writing new code.
	move_and_slide()
	_special_collisions()
	
	if position.y < -10:
		Global.player_died()
	
	if position.y < 5 and is_falling:
		Global.ui.set_fog_strength(2 - (global_position.y + 10) * .15)
	else:
		Global.ui.set_fog_strength(0)
	
	if not is_on_floor() and not is_falling:
		is_falling = true
		koyote_timer.start(koyote_time_frame)
	if is_falling and is_on_floor():
		is_falling = false


func _special_collisions():
	for i in get_slide_collision_count():
		var collision: KinematicCollision3D = get_slide_collision(i)
		if collision.get_collider().has_method("collide_with_player"):
			collision.get_collider().collide_with_player(self, collision)

func get_jump_velocity(height: float):
	return sqrt(height * abs(jump_gravity) * 2.0)

func _get_gravity():
	if debug_disable_gravity:
		return 0
	if velocity.y > 0:
		return jump_gravity
	else:
		return fall_gravity

func lock_camera(val: bool) -> void:
	camera_locked = val

func _input(event):
	if camera_locked:
		return
	# Processing mouse movement here.
	# We only want to look around while the mouse is "captured" inside godot.
	# We rotate the character around the Y axis only since we do not want to flip ourselves upside down.
	# The camera is rotated between looking straight up or straight down.
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY * SENSITIVITY.current)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY * SENSITIVITY.current)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(90), deg_to_rad(90))

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_gravity"):
		debug_disable_gravity = not debug_disable_gravity
		velocity.y = 0
