extends Node


var player: Player
var level: Level
var ui: UIController


func player_died():
	player.is_dead = true
	ui.play_death_fade()


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var ui_layer := preload("res://globals/ui_layer.tscn").instantiate()
	add_child(ui_layer)
	ui = ui_layer.get_child(0)

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
