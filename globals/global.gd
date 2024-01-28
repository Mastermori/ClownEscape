extends Node


var player: Player
var level: Level
var ui: UIController

var total_run_timer: float = 0.0
var total_run_deaths: int = 0
var break_times: Dictionary = {}
var current_level_timer: float = 0.0
var current_level_deaths: int = 0
var timer_finished: bool = false

var in_menu: bool = false

var sounds = []

var seen_text_triggers = []

func player_died():
	if not player.is_dead:
		total_run_deaths += 1
		current_level_deaths += 1
		for i in randi_range(1, 5):
			play_laugh_track()
		ui.play_death_fade()
	player.is_dead = true
	player.velocity.y = 0

func play_laugh_track(num: int = randi_range(0, 21)):
	await get_tree().create_timer(randf_range(0, 1.5)).timeout
	play_fixed_sound(sounds[num])

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var ui_layer := preload("res://globals/ui_layer.tscn").instantiate()
	add_child(ui_layer)
	ui = ui_layer.get_child(0)
	
	for i in 22:
		sounds.append(load("res://laughs/lol%d.ogg" % [i]))


func _process(delta):
	if get_tree().paused:
		return
	if not timer_finished:
		total_run_timer += delta
		current_level_timer += delta
	var millis = fmod(total_run_timer, 1) * 100
	var seconds = fmod(total_run_timer, 60)
	var minutes = total_run_timer / 60
	var text = "%02d:%02d:%02d   ⏲️\n%d   🤡" % [minutes, seconds, millis, total_run_deaths]
	ui.update_timer_display(text)

func play_fixed_sound(sound: AudioStream):
	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_player.stream = sound
	audio_player.autoplay = true
	audio_player.position = Vector2(randf_range(-50, 50), 0)
	audio_player.pitch_scale = 0.25 + randf() + randf()
	audio_player.finished.connect(audio_player.queue_free)
	ui.sounds.add_child((audio_player))
	return audio_player

func play_sound_at(sound: AudioStream, position: Vector3, max_distance = 0.0, volume: float = 0.0, pitch: float = 1.0):
	var audio_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audio_player.stream = sound
	audio_player.position = position
	audio_player.autoplay = true
	audio_player.volume_db = volume
	audio_player.pitch_scale = pitch
	audio_player.max_distance = max_distance
	audio_player.finished.connect(audio_player.queue_free)
	level.sounds.add_child(audio_player)
	return audio_player

func change_level(new_level: PackedScene):
	if not level:
		total_run_deaths = 0
		total_run_timer = -1.0
	elif not level.level_name == "":
		break_times[level.level_name] = [current_level_timer, total_run_timer, current_level_deaths, total_run_deaths]
		
	current_level_timer = 0.0
	current_level_deaths = 0
	ui.play_fade_out()
	await ui.anim_player.animation_finished
	get_tree().change_scene_to_packed.call_deferred(new_level)

func _unhandled_input(event):
	if in_menu:
		return
	if event.is_action_pressed("pause"):
		ui.get_node("MarginContainer").visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("mouse_capture"):
		ui.get_node("MarginContainer").visible = false
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func queue_text(text: String):
	ui.queue_text(text)

func overwrite_text(text: String):
	ui.overwrite_text(text)
