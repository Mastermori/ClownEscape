extends Area3D

#@export var cooldown: float = 10000000
@export var is_toggled: bool = false
@export var toggle_timer: float = 0
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
	
	is_toggled = false
	Global.play_sound_at(preload("res://obstacles/button/Click.ogg"), position, 0.0, 20.0)
	$GameReadyPressurePlate/AnimationPlayer.play("default")
	
	if toggle_timer > 0:	
		$Timer.wait_time = toggle_timer
		$Timer.start()
	else:
		toggle_button()
		
func toggle_button():
	#remaining_cooldown = cooldown
	emit_signal("switch_toggled")
	if is_toggled:
		emit_signal("switch_on")
	else:
		emit_signal("switch_off")
