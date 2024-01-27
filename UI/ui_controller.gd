extends Control


@export var _default_fade_timer: float = 5.0
var fade_timer = 10

@onready var clown_commentary = $ClownCommentary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	fade_timer -= delta
	if fade_timer <= 0:
		clown_commentary.visible = false
	elif fade_timer < _default_fade_timer / 2:
		clown_commentary.modulate.a = fade_timer * 2 / _default_fade_timer
	
	
func display_text(text: String, fade: float = _default_fade_timer):
	clown_commentary.visible = true
	clown_commentary.text = "[center]" + text
	fade_timer = fade

func play_fade():
	var anim_player = $ColorRect3/AnimationPlayer
	if not anim_player.is_playing():
		anim_player.play("Fade")
