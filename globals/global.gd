extends Node


var player: Player
var level: Level


func play_sound_at(sound: AudioStream, position: Vector3, max_distance = 0.0, volume: float = 0.0, pitch: float = 1.0):
	var audio_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audio_player.stream = sound
	audio_player.autoplay = true
	audio_player.volume_db = volume
	audio_player.pitch_scale = pitch
	audio_player.max_distance = max_distance
	audio_player.finished.connect(audio_player.queue_free)
	level.sounds.add_child(audio_player)
	return audio_player
