extends Node3D

@export var projectile_scene: PackedScene
@export var push_strength: float = 40
@export var fire_interval: float = 5
@export var fire_strength: float = 20
@export var direction: Vector3 = Vector3(0, .5, 1)

@onready var shot_position = $ShotPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = fire_interval
	$Timer.start()

func shoot():
	shoot_in(direction, fire_strength)

func shoot_in(direction: Vector3, force: float):
	var projectile := projectile_scene.instantiate() as RigidBody3D
	projectile.position = shot_position.position
	projectile.linear_velocity = direction.normalized() * force
	projectile.push_strength
	add_child(projectile)
