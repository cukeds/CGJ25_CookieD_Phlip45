extends CharacterBody2D

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animation_tree: AnimationTree = $AnimationTree

@export var max_speed = 100.0
const acc = 10.0


func _physics_process(delta):
	# Get the input direction
	var input_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	# Calculate velocity based on input and max_speed
	velocity = input_direction * max_speed

	# Decelerate smoothly if there's no input
	if input_direction == Vector2.ZERO:
		velocity.x = move_toward(velocity.x, 0, 10*delta)
		velocity.y = move_toward(velocity.y, 0, 10*delta)

	navigation_agent_2d.velocity = velocity
	
	if velocity != Vector2.ZERO: 
		animation_tree["parameters/StateMachine/Movement/blend_position"] = velocity
	# Apply movement
	position+=velocity * delta
