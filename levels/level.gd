class_name Level
extends Node3D


@onready var sounds = $Sounds


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.level = self

