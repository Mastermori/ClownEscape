extends Area3D


@export_multiline var text: String
#@export var display_time: float = 2.5
@export var overwrite_all_text: bool = false


func _ready():
	if get_hash() in Global.seen_text_triggers:
		queue_free()
		return

func get_hash() -> int:
	return hash(self.get_path()) + hash(text)

func _on_body_entered(body):
	if body is Player:
		if overwrite_all_text:
			Global.overwrite_text(text)
		else:
			Global.queue_text(text)
		Global.seen_text_triggers.append(get_hash())
		queue_free()
