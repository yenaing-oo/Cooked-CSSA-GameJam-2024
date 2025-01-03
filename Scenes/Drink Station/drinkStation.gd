extends Node3D

@onready var soda_one
@onready var soda_two

@export var fill_time = 5.0
@export var overflow_time = 5.0

@onready var player = get_parent().get_node("player")

class Soda:
	var node
	var fill_timer_node
	var overflow_timer_node
	var filling = false
	var overflow = false
	var loading_bar
	var loading_bar_filling_front
	var loading_bar_filling_front_offset
	var loading_bar_overfill_front
	var loading_bar_overfill_front_offset
	var audio 

func _ready() -> void:
	soda_one = Soda.new()
	soda_one.node = $sodaCup1
	soda_one.node.visible = false
	soda_one.fill_timer_node = $sodaCup1/fillTimer
	soda_one.overflow_timer_node = $sodaCup1/overflowTimer
	soda_one.loading_bar = $sodaCup1/loadingBar
	soda_one.loading_bar.visible = false
	soda_one.loading_bar_filling_front = $sodaCup1/loadingBar/loadingBarFilling
	soda_one.loading_bar_filling_front_offset = soda_one.loading_bar_filling_front.position.x
	soda_one.loading_bar_overfill_front = $sodaCup1/loadingBar/loadingBarOverflow
	soda_one.loading_bar_overfill_front_offset = soda_one.loading_bar_overfill_front.position.x
	soda_one.audio = $sodaCup1/AudioStreamPlayer

	soda_two = Soda.new()
	soda_two.node = $sodaCup2
	soda_two.node.visible = false
	soda_two.fill_timer_node = $sodaCup2/fillTimer
	soda_two.overflow_timer_node = $sodaCup2/overflowTimer
	soda_two.loading_bar = $sodaCup2/loadingBar
	soda_two.loading_bar.visible = false
	soda_two.loading_bar_filling_front = $sodaCup2/loadingBar/loadingBarFilling
	soda_two.loading_bar_filling_front_offset = soda_two.loading_bar_filling_front.position.x
	soda_two.loading_bar_overfill_front = $sodaCup2/loadingBar/loadingBarOverflow
	soda_two.loading_bar_overfill_front_offset = soda_two.loading_bar_overfill_front.position.x
	soda_two.audio = $sodaCup2/AudioStreamPlayer

func _physics_process(_delta: float) -> void:
	if (soda_one.filling):
		soda_one.loading_bar_filling_front.visible = true
		soda_one.loading_bar_overfill_front.visible = false

		var time_elapsed = fill_time - soda_one.fill_timer_node.time_left
		var time_fraction = time_elapsed / fill_time

		soda_one.loading_bar_filling_front.scale = Vector3(time_fraction, 1, 1)
		soda_one.loading_bar_filling_front.position = Vector3((1-time_fraction) * soda_one.loading_bar_filling_front_offset, 0, 0)

	elif (soda_one.overflow):
		soda_one.loading_bar_filling_front.visible = false
		soda_one.loading_bar_overfill_front.visible = true

		var time_elapsed = fill_time - soda_one.overflow_timer_node.time_left
		var time_fraction = time_elapsed / overflow_time

		soda_one.loading_bar_overfill_front.scale = Vector3(time_fraction, 1, 1)
		soda_one.loading_bar_overfill_front.position = Vector3((1-time_fraction) * soda_one.loading_bar_overfill_front_offset, 0, 0)

	if (soda_two.filling):
		soda_two.loading_bar_filling_front.visible = true
		soda_two.loading_bar_overfill_front.visible = false

		var time_elapsed = fill_time - soda_two.fill_timer_node.time_left
		var time_fraction = time_elapsed / fill_time

		soda_two.loading_bar_filling_front.scale = Vector3(time_fraction, 1, 1)
		soda_two.loading_bar_filling_front.position = Vector3((1-time_fraction) * soda_two.loading_bar_filling_front_offset, 0, 0)
	elif (soda_two.overflow):
		soda_two.loading_bar_filling_front.visible = false
		soda_two.loading_bar_overfill_front.visible = true

		var time_elapsed = fill_time - soda_two.overflow_timer_node.time_left
		var time_fraction = time_elapsed / overflow_time

		soda_two.loading_bar_overfill_front.scale = Vector3(time_fraction, 1, 1)
		soda_two.loading_bar_overfill_front.position = Vector3((1-time_fraction) * soda_two.loading_bar_overfill_front_offset, 0, 0)

func create_soda() -> void:
	# Check if soda_one is not visible
	if (!soda_one.node.is_visible_in_tree()):
		print("Activating soda_one")
		# Activate soda_one
		soda_one.node.visible = true
		soda_one.loading_bar.visible = true

		soda_one.fill_timer_node.wait_time = fill_time
		soda_one.overflow_timer_node.wait_time = overflow_time
		soda_one.fill_timer_node.start()

		soda_one.filling = true
		soda_one.audio.play()

	# If soda_one is visible and active, then activate soda_two
	elif (soda_one.node.is_visible_in_tree() and !soda_two.node.is_visible_in_tree()):
		print("Activating soda_two")
		soda_two.node.visible = true
		soda_two.loading_bar.visible = true

		soda_two.fill_timer_node.wait_time = fill_time
		soda_two.overflow_timer_node.wait_time = overflow_time
		soda_two.fill_timer_node.start()

		soda_two.filling = true
		soda_two.audio.play()

func _soda_timeout(extra_arg_0: String) -> void:
	if (extra_arg_0 == "soda_one"):
		soda_one.filling = false
		soda_one.overflow = true
		soda_one.overflow_timer_node.start()

	elif (extra_arg_0 == "soda_two"):
		soda_two.filling = false
		soda_two.overflow = true
		soda_two.overflow_timer_node.start()

func pick_up_soda() -> bool:
	if player.carrying_drink:
		return false
	
	var cup_picked_up = oldest_cup()

	if cup_picked_up == null:
		return false

	# Check if the selected cup is still filling
	if cup_picked_up == soda_one and soda_one.filling:
		print("Cannot pick up soda_one; it's still filling.")
		return false
	elif cup_picked_up == soda_two and soda_two.filling:
		print("Cannot pick up soda_two; it's still filling.")
		return false
	
	# Proceed to pick up the cup
	cup_picked_up.node.visible = false
	cup_picked_up.fill_timer_node.stop()
	cup_picked_up.overflow_timer_node.stop()
	print("Picked up:", cup_picked_up.node.name)
	
	return true

func oldest_cup() -> Soda:
	var oldest_soda_cup = null
	var cup_one_time = null
	var cup_two_time = null

	if (soda_one.node.is_visible_in_tree()):
		if (soda_one.overflow_timer_node.is_stopped()):
			cup_one_time = soda_one.fill_timer_node.time_left + overflow_time
		else: 
			cup_one_time = soda_one.overflow_timer_node.time_left
	if (soda_two.node.is_visible_in_tree()):
		if (soda_two.overflow_timer_node.is_stopped()):
			cup_two_time = soda_two.fill_timer_node.time_left + overflow_time
		else: 
			cup_two_time = soda_two.overflow_timer_node.time_left

	if cup_one_time ==  null:
		if cup_two_time == null:
			return null
		oldest_soda_cup = soda_two
		return oldest_soda_cup
	elif cup_two_time == null:
		if cup_one_time == null:
			return
		oldest_soda_cup = soda_one
		return oldest_soda_cup

	if cup_one_time < cup_two_time:
		oldest_soda_cup = soda_one
	if cup_two_time < cup_one_time:
		oldest_soda_cup = soda_two
	
	return oldest_soda_cup

func _soda_overflow_timeout(extra_arg_0: String) -> void:
	if extra_arg_0 == "soda_one":
		soda_one.overflow = false
		soda_one.node.visible = false
	elif extra_arg_0 == "soda_two":
		soda_one.overflow = false
		soda_two.node.visible = false
