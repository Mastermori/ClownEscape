class_name UIController
extends Control

@export var fade_time: float = 2.5
@export var display_time: float = 2.5

var text_queue: Array[String] = []

@onready var clown_commentary = $ClownCommentary
@onready var fade_timer = $FadeTimer
@onready var display_timer = $DisplayTimer
@onready var anim_player = $DeathRect/AnimationPlayer


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

func queue_text(text: String):
	text_queue.append(text)
	if not clown_commentary.visible:
		display_text(text_queue.pop_front())

func display_text(text: String, custom_display_time: float = 0):
	clown_commentary.visible = true
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
