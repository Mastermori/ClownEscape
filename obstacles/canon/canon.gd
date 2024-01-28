extends Node3D

const ANIM_LENGTH: float = 1
const ANIM_SHOOT_POS: float = .84

@export var projectile_scene: PackedScene
@export var push_strength: float = 40
@export var ball_liftetime: float = 5
@export var ball_bounciness: float = .8
@export var fire_interval: float = 2 :
	set(val):
		fire_interval = val
		if fire_interval < ANIM_LENGTH:
			animation_speed = ANIM_LENGTH / fire_interval
## Will use fire interval as initial delay if <= 0
@export var initial_delay: float = 0
@export var fire_strength: float = 20
@export var direction: Vector3 = Vector3(0, .5, 1)

var animation_speed: float = 1 :
	set(val):
		animation_speed = val
		if not is_node_ready():
			return
		$Canon/AnimationPlayer.speed_scale = val

@onready var shot_position = $ShotPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(fire_interval if initial_delay <= 0 else initial_delay)

func shoot():
	shoot_in(direction, fire_strength)
	Global.play_sound_at(preload("res://obstacles/canon/Cannon.ogg"), position)
	if fire_interval != -1:
		$Timer.start(fire_interval)
	Global.play_sound_at(preload("res://obstacles/canon/Cannon.ogg"), global_position)
	

func shoot_in(direction: Vector3, force: float):
	var projectile := projectile_scene.instantiate() as RigidBody3D
	projectile.position = shot_position.position
	projectile.push_strength = push_strength
	projectile.linear_velocity = direction.rotated(Vector3(0, 1, 0), rotation.y).normalized() * force
	projectile.physics_material_override.bounce = ball_bounciness
	projectile.lifetime = ball_liftetime
	add_child(projectile)

func _process(delta):
	var time_left: float = $Timer.time_left
	var shoot_anim_pos := ANIM_SHOOT_POS / animation_speed
	if not $Canon/AnimationPlayer.is_playing() and time_left < shoot_anim_pos:
		$Canon/AnimationPlayer.play("Cannon Animation")
		$Canon/AnimationPlayer.seek(shoot_anim_pos - time_left)


func _on_animation_player_animation_finished(anim_name):
	pass
