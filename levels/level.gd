class_name Level
extends Node3D


@onready var sounds = $Sounds
@onready var spawn_position = $SpawnPosition


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.level = self
	spawn_position.global_position = $Player.global_position

func reset_player():
	Global.player.global_position = spawn_position.global_position
