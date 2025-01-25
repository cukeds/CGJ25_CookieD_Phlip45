extends CharacterBody2D

@export var nav_region:NavigationRegion2D
@export var patrol_route: PatrolRoute
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var nav_region_id:RID
var current_target:int = 0
var speed_max:float = 500
var patrol_route_points: PackedVector2Array
var reverse_route: bool = false

func _ready() -> void:
	nav_region_id = nav_region.get_region_rid()
	patrol_route_points = patrol_route.get_points()
	if patrol_route_points.size() < 2:
		printerr("Patrol Route too tiny you nincompoop")
		return
	await get_tree().physics_frame

	navigation_agent_2d.set_target_position(patrol_route_points[0])
	pass

func _physics_process(_delta: float) -> void:
	#print(nav_region_id)
	var next_pos = navigation_agent_2d.get_next_path_position()
	velocity = Vector2(global_position.direction_to(next_pos).x*speed_max,global_position.direction_to(next_pos).y*speed_max)
	move_and_slide()
	if global_position.distance_to(next_pos) < 10:
		if reverse_route:
			current_target = (current_target - 1) % patrol_route_points.size()
			print(current_target)
			if current_target < 0 && !patrol_route.closed:
				reverse_route = !reverse_route
				current_target = 1
		else:
			current_target = (current_target + 1) % patrol_route_points.size()
			if current_target == 0 && !patrol_route.closed:
				reverse_route = !reverse_route
				current_target = patrol_route_points.size() - 2
				
		navigation_agent_2d.set_target_position(patrol_route_points[current_target])
		pass

func _process(_delta: float) -> void:
	if Input.is_action_pressed("speed_up"):
		speed_max = 500
	else:
		speed_max = 100
