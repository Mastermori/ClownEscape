extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CPressureplate/AnimationPlayer.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	$CPressureplate/AnimationPlayer.play("default")
