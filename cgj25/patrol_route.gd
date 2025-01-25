extends Line2D

class_name PatrolRoute

@export var show_line:bool = false

func _ready() -> void:
	if show_line:
		default_color = "#D00"
