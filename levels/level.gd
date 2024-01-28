class_name Level
extends Node3D

## 
@export var level_name: String = ""
@onready var sounds = $Sounds
@onready var spawn_position = $SpawnPosition


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.level = self
	spawn_position.global_position = $Player.global_position
	spawn_position.rotation = $Player.rotation
	Global.ui.play_fade_in()
	await Global.ui.anim_player.animation_finished

func reset_player():
	get_tree().change_scene_to_file(scene_file_path)
