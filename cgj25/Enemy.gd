extends CharacterBody2D

@export var path_points: Array[Marker2D]
@export var nav_region:NavigationRegion2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var nav_region_id:RID
var current_target:int = 0


func _ready() -> void:
	nav_region_id = nav_region.get_region_rid()
	if path_points.size() <= 0:
		printerr("FORGOT TO SET PATHS")
		return
	await get_tree().physics_frame

	navigation_agent_2d.set_target_position(path_points[0].position)
	pass

func _physics_process(delta: float) -> void:
	#print(nav_region_id)
	var next_pos = navigation_agent_2d.get_next_path_position()
	velocity = Vector2(global_position.direction_to(next_pos).x*100,global_position.direction_to(next_pos).y*100)
	move_and_slide()
	if global_position.distance_to(next_pos) < 10:
		current_target = (current_target + 1) % path_points.size()
		navigation_agent_2d.set_target_position(path_points[current_target].position)
		pass
