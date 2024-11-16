extends CharacterBody3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	# Get the input direction from the player.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Get the camera's forward and right directions, ignoring vertical orientation.
	var camera_transform := get_viewport().get_camera_3d().global_transform.basis
	var forward := -camera_transform.z.normalized()  # Invert forward to fix movement direction
	var right := camera_transform.x.normalized()
	
	# Calculate the direction relative to the camera.
	var direction := (input_dir.x * right - input_dir.y * forward).normalized()  # Subtract forward for correct up/down behavior

	if direction:
		# Set velocity based on the calculated direction.
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Rotate the character to face the movement direction.
		look_at(global_transform.origin + direction, Vector3.UP)
	else:
		# Gradually stop movement when no input is given.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move the character.
	move_and_slide()
