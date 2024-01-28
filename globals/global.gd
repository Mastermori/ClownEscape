extends Node


var player: Player
var level: Level
var ui: UIController

var total_run_timer: float = 0.0
var total_run_deaths: int = 0
var break_times: Dictionary = {}
var current_level_timer: float = 0.0
var current_level_deaths: int = 0
var paused: bool = false

func player_died():
	player.is_dead = true
	total_run_deaths += 1
	current_level_deaths += 1
	ui.play_death_fade()


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var ui_layer := preload("res://globals/ui_layer.tscn").instantiate()
	add_child(ui_layer)
	ui = ui_layer.get_child(0)


func _process(delta):
	if paused:
		return
	total_run_timer += delta
	current_level_timer += delta
	var millis = fmod(total_run_timer, 1) * 100
	var seconds = fmod(total_run_timer, 60)
	var minutes = total_run_timer / 60
	var text = "%02d:%02d:%02d   ⏲️\n%d   🤡" % [minutes, seconds, millis, total_run_deaths]
	ui.update_timer_display(text)
	
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
	if not level.level_name == "":
		break_times[level.level_name] = [current_level_timer, total_run_timer, current_level_deaths, total_run_deaths]
	current_level_timer = 0.0
	current_level_deaths = 0
	ui.play_fade_out()
	await ui.anim_player.animation_finished
	get_tree().change_scene_to_packed.call_deferred(new_level)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED)

func queue_text(text: String):
	ui.queue_text(text)
	print(ui)

func overwrite_text(text: String):
	ui.overwrite_text(text)
