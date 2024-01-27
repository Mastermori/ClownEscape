extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8
const MOUSE_SENSITIVITY = 0.005
const ACCELERATION = 15.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var camera = null

func _ready():
	camera = $Camera3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION * delta)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("collide_with_player"):
			collision.get_collider().collide_with_player(self, collision)



func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(90), deg_to_rad(90))
		
