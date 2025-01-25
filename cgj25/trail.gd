extends Line2D

@export var trail_leaver: Node2D
@export var max_length: int = 50
@export var max_scale: float = 1

@onready var splotch_template: Sprite2D = $SplotchTemplate
var splotch_holder:Node2D
var points_pointer:int = 0
var cooldown_max:float  = 0.05
var cooldown:float  = 0.0

func _ready() -> void:
	splotch_holder = Node2D.new()
	for i in max_length:
		add_point(trail_leaver.position)

func _process(delta: float) -> void:
	cooldown -= delta
	if cooldown > 0:
		return
	cooldown = cooldown_max
	points_pointer = (points_pointer + 1) % max_length
	points[points_pointer] = trail_leaver.position
		
	recalc_points()
	
func recalc_points():
	var length:int = points.size()
	splotch_holder.queue_free()
	splotch_holder = Node2D.new()
	for i in length:
		var index = (points_pointer + i) % max_length
		var new_splotch:Sprite2D = splotch_template.duplicate()
		new_splotch.scale = Vector2.ONE * (1 - posmod(points_pointer - i,max_length) / float(length)) * max_scale
		new_splotch.position = points[i]
		new_splotch.visible = true
		new_splotch.self_modulate.b += 1 - new_splotch.scale.y
		new_splotch.self_modulate.g += 1 - new_splotch.scale.y
		
		#new_splotch.rotate(randf_range(-PI,PI))
		splotch_holder.add_child(new_splotch)
	add_child(splotch_holder)
