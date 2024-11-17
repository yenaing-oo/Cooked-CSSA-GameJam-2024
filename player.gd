extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = -9.8  # Gravity force (default Earth gravity)
const INTERACTION_DISTANCE = 2.0  # Distance threshold for interaction

@onready var assembly_station = get_parent().get_node("AssemblyStation")  # Reference to AssemblyStation node in the main scene
@onready var grilling_station = get_parent().get_node("GrillingStation")
@onready var drink_station = get_parent().get_node("DrinkStation")
@onready var order_window = get_parent().get_node("OrderWindow")



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
	if Input.is_action_just_pressed("interact"):
		if assembly_station and global_transform.origin.distance_to(assembly_station.global_transform.origin) <= INTERACTION_DISTANCE:
			print("Use assembly station")
			assembly_station.start_minigame()
		elif drink_station and global_transform.origin.distance_to(drink_station.global_transform.origin) <= INTERACTION_DISTANCE:
			print("Drinks being created...")
			drink_station.create_soda()
		elif grilling_station and global_transform.origin.distance_to(grilling_station.global_transform.origin) <= INTERACTION_DISTANCE:
			print("Begin cooking...")
			grilling_station.start_cooking()
		elif order_window and global_transform.origin.distance_to(order_window.global_transform.origin) <= INTERACTION_DISTANCE:
			print("Took order.")
			order_window.take_order()
	elif Input.is_action_just_pressed("pick_up"):
		if drink_station and global_transform.origin.distance_to(drink_station.global_transform.origin) <= INTERACTION_DISTANCE:
			print("Drink picked up")
			drink_station.pick_up_soda()
		elif grilling_station and global_transform.origin.distance_to(grilling_station.global_transform.origin) <= INTERACTION_DISTANCE:
			print("Food picked up")
			grilling_station.grab_cooked_food()

		
