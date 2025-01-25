extends CharacterBody2D

@export var nav_region:NavigationRegion2D
@export var patrol_route: PatrolRoute
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var nav_region_id:RID
var current_target:int = 0
var speed_max:float = 500
var patrol_route_points: PackedVector2Array
var reverse_route: bool = false
var current_safe_velocity: Vector2
var stuck_cooldown: float = 1


func _ready() -> void:
	var _agent_rid: RID = NavigationServer2D.agent_create()
	navigation_agent_2d.velocity_computed.connect(_safe_velocity_computed)
	
	nav_region_id = nav_region.get_region_rid()
	patrol_route_points = patrol_route.get_points()
	if patrol_route_points.size() < 2:
		printerr("Patrol Route too tiny you nincompoop")
		return
	await get_tree().physics_frame

	navigation_agent_2d.set_target_position(patrol_route_points[0])
	pass


func _physics_process(delta: float) -> void:
	#print(nav_region_id)
	move_and_slide()
	
	var stuck = current_safe_velocity.length() < 10
	if stuck && stuck_cooldown < 0:
		stuck_cooldown = 1
		
	var next_pos = navigation_agent_2d.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed_max 
	
	if global_position.distance_to(next_pos) < navigation_agent_2d.path_desired_distance || (stuck && stuck_cooldown == 1):
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

	stuck_cooldown -= delta	
	navigation_agent_2d.velocity = velocity
	
	pass

func _process(_delta: float) -> void:
	if Input.is_action_pressed("speed_up"):
		speed_max = 500
	else:
		speed_max = 100
		
		
func _safe_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	current_safe_velocity = safe_velocity
	
