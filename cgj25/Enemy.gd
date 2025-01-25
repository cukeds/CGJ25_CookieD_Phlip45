extends CharacterBody2D

@export var path_points: Array[Marker2D]
@export var nav_region:NavigationRegion2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var marker_parent = $Markers
var nav_region_id:RID
var current_target:int = 0
var speed_max:float = 500

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
	velocity = Vector2(global_position.direction_to(next_pos).x*speed_max,global_position.direction_to(next_pos).y*speed_max)
	move_and_slide()
	if global_position.distance_to(next_pos) < 10:
		current_target = (current_target + 1) % path_points.size()
		navigation_agent_2d.set_target_position(path_points[current_target].position)
		pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("speed_up"):
		speed_max = 500
	else:
		speed_max = 100
	if Input.is_action_just_pressed("add_point"):
		# Generate a random point within a certain range
		var random_point = Vector2(
			randi() % 400 - 200,  # Adjust the range as needed
			randi() % 400 - 200
		)
		var marker = Marker2D.new()
		marker.global_position = random_point
		if marker_parent:
			marker_parent.add_child(marker)
		else:
			add_child(marker)
		
		path_points.append(marker)

		# If the path_points array was empty, set the new target
		if path_points.size() == 1:
			navigation_agent_2d.set_target_position(random_point)
