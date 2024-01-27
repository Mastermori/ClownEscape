extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8.0
const MOUSE_SENSITIVITY = 0.005
const ACCELERATION = 15.0
const DASH_COOLDOWN_DURATION = 1.0
const DASH_VELOCITY = 15.0

var camera = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var dash_cooldown = 0.0
var dash_charged = true

# Whether the player should make walking sounds.
var is_walking = false

func _ready():
	camera = $Camera3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		dash_charged = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)
	
	
	
	# Handle dash
	if dash_cooldown > 0:
		dash_cooldown -= delta
	elif Input.is_action_pressed("dash") and dash_charged:
		dash_charged = false
		dash_cooldown = DASH_COOLDOWN_DURATION
		# We can use one of these two transforms. The camera transform would dash EXACTLY where we are looking.
		# However it needs to be limited since it can otherwise be used to fly.
		# The vanilla transform only accelerates horizontally but can thus be used much more freely.
		velocity -= camera.global_transform.basis.z * DASH_VELOCITY
		#velocity -= transform.basis.z * DASH_VELOCITY
	
	# Here we finally process the movement. We use move_and_slide since we want to slide along surfaces.
	# Additionally it allows for easy detection of whether we are grounded.
	# We must still loop over all the collisions since some objects inflict additional bounces upon us.
	# Theoretically we might be afflicted by multiple bounces at once, making them cancel each other out.
	# But that's something that'll probably never happen so we take the faster approach. No writing new code.
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("collide_with_player"):
			collision.get_collider().collide_with_player(self, collision)



func _input(event):
	# Processing mouse movement here.
	# We only want to look around while the mouse is "captured" inside godot.
	# We rotate the character around the Y axis only since we do not want to flip ourselves upside down.
	# The camera is rotated between looking straight up or straight down.
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(90), deg_to_rad(90))
