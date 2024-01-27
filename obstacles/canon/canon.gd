extends Node3D

@export var projectile_scene: PackedScene
@export var push_strength: float = 40
@export var fire_interval: float = 2
## Will use fire interval as initial delay if <= 0
@export var initial_delay: float = 0
@export var fire_strength: float = 20
@export var direction: Vector3 = Vector3(0, .5, 1)

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
	projectile.linear_velocity = direction.normalized() * force
	projectile.push_strength
	add_child(projectile)
