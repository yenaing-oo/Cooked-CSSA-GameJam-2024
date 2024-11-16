extends CharacterBody2D

var speed = 200  # Adjust this value to change movement speed

# Reference to the Camera2D node
@onready var camera = $Camera2D

func _ready():
	# Enable the camera to follow the player
	camera.enabled = true

func _physics_process(delta):
	var input_vector = Vector2()
	
	# Check for left and right movement inputs
	if Input.is_action_pressed("right"):
		input_vector.x += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1

	# Normalize and scale the input vector by speed
	input_vector = input_vector.normalized() * speed
	velocity = input_vector
	move_and_slide()
