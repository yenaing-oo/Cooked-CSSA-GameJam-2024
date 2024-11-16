extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = -9.8  # Gravity force (default Earth gravity)
const INTERACTION_DISTANCE = 2.0  # Distance threshold for interaction

@onready var assembly_station = get_parent().get_node("AssemblyStation")  # Reference to AssemblyStation node in the main scene

func _physics_process(delta: float) -> void:
	# Get the input direction from the player.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Get the camera's forward and right directions, ignoring vertical orientation.
	var camera_transform := get_viewport().get_camera_3d().global_transform.basis
	var forward := camera_transform.z.normalized()  # Invert forward to match desired behavior
	var right := camera_transform.x.normalized()

	# Calculate the direction relative to the camera.
	var direction := (input_dir.x * right + input_dir.y * forward).normalized()

	if direction:
		# Set velocity based on the calculated direction.
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var rotated_direction := Vector3(-direction.z, 0, direction.x)

		# Rotate the player to face the movement direction
		look_at(global_transform.origin + rotated_direction, Vector3.UP)  # Make player face the direction of movement
	else:
		# Gradually stop movement when no input is given.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Apply gravity and move the character
	velocity.y += GRAVITY * delta
	move_and_slide()

	# Check for interaction with the AssemblyStation
	check_interaction()

func check_interaction() -> void:
	if assembly_station and global_transform.origin.distance_to(assembly_station.global_transform.origin) <= INTERACTION_DISTANCE:
		if Input.is_action_pressed("use"):
			print("Use station")
			assembly_station.start_minigame()  # Or any method to start the interaction in AssemblyStation
