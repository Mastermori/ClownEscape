extends Area3D

#@export var cooldown: float = 10000000
@export var is_toggled: bool = false
#@export var remaining_cooldown: float = 0

signal switch_toggled
signal switch_off
signal switch_on

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#remaining_cooldown -= delta


func reset():
	is_toggled = false

func _on_body_entered(body):
	#if remaining_cooldown > 0:
	#	return
	
	if is_toggled:
		return
		
	#remaining_cooldown = cooldown
	$CPressureplate/AnimationPlayer.play("default")
	Global.play_sound_at(preload("res://obstacles/Switch/Click.ogg"), position, 0.0, 20.0)
	print("toggled")
	is_toggled = not is_toggled
	emit_signal("switch_toggled")
	if is_toggled:
		emit_signal("switch_on")
	else:
		emit_signal("switch_off")
