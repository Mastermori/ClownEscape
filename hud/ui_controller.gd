class_name UIController
extends Control

@export var fade_time: float = 2.5
@export var display_time: float = 2.5

var text_queue: Array[String] = []

@onready var clown_commentary = $ClownCommentary
@onready var fade_timer = $FadeTimer
@onready var display_timer = $DisplayTimer
@onready var death_rect = $DeathRect
@onready var anim_player = $DeathRect/AnimationPlayer
@onready var fog_material := $FogOverlay.material as ShaderMaterial


func _ready():
	display_timer.timeout.connect(end_display)
	fade_timer.timeout.connect(hide_text)

func _process(delta):
	if not fade_timer.is_stopped():
		clown_commentary.modulate.a = fade_timer.time_left / fade_timer.wait_time

func hide_text():
	clown_commentary.visible = false

func end_display():
	var next_text = text_queue.pop_front()
	if not next_text:
		fade_timer.start(fade_time)
		return
	display_text(next_text)

func overwrite_text(text: String, custom_display_time: float = 0):
	text_queue.clear()
	display_text(text, custom_display_time)


func update_timer_display(text: String):
	$TimeDeathDisplay.text = text


func queue_text(text: String):
	text_queue.append(text)
	if not clown_commentary.visible or not fade_timer.is_stopped():
		display_text(text_queue.pop_front())

func display_text(text: String, custom_display_time: float = 0):
	clown_commentary.visible = true
	clown_commentary.modulate.a = 1
	clown_commentary.text = "[center]" + text
	display_timer.start(display_time if custom_display_time <= 0 else custom_display_time)

func play_death_fade():
	if not anim_player.is_playing():
		anim_player.play("fade")
		await anim_player.animation_finished
		Global.level.reset_player()

func play_fade_in():
		anim_player.play("fade", -1, -2.0, true)
	
func play_fade_out():
		anim_player.play("fade", -1, 2.0, false)

## Must be a value between 1.0 and 2.0. Will be clamped
func set_fog_strength(strength: float):
	strength = clamp(strength, 0.0, 2.0)
	fog_material.set_shader_parameter("strength", strength)
	
	var alpha_value = remap(strength, 0.0, 2.0, .2, 1)
	fog_material.set_shader_parameter("alpha", alpha_value)
