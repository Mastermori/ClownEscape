extends Area3D

@export var toggleable: bool = false
@export var initial_toggle_state: bool = false
@export var toggle_delay: float = 0

signal switch_toggled
signal switch_off
signal switch_on

var is_toggled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if toggleable and initial_toggle_state:
		toggle_button()

func _on_body_entered(body):
	if not toggleable and is_toggled:
		return
	if not $Timer.is_stopped():
		return
	
	Global.play_sound_at(preload("res://obstacles/button/Click.ogg"), position, 0.0, 20.0)
	
	if toggle_delay > 0:
		$Timer.start(toggle_delay)
	else:
		toggle_button()

func toggle_button():
	switch_toggled.emit()
	is_toggled = not is_toggled
	if is_toggled:
		$GameReadyPressurePlate/AnimationPlayer.play("Springplate_004Action")
		switch_on.emit()
	else:
		$GameReadyPressurePlate/AnimationPlayer.play_backwards("Springplate_004Action")
		switch_off.emit()
