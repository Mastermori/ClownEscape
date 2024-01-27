extends AudioStreamPlayer3D


@export var STEP_DISTANCE = 50.0
@onready var player = $".."

var distance_till_active = STEP_DISTANCE
var is_active_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_active_player:
		return
	
	distance_till_active -= player.velocity.length()
	if distance_till_active <= 0 and player.is_on_floor():
		distance_till_active = STEP_DISTANCE
		is_active_player = false
		play()
		

func _on_steps_player_finished():
	is_active_player = true
		
