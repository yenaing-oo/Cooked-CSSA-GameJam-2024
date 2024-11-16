extends Node3D

const COOKING_TIME = 5
const BURNING_TIME = 5

var cooking = false
var cooked = false
var burning = false
var cooking_start_time
var burning_start_time
var loading_bar
var loading_bar_front
var loading_bar_front_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_bar = $LoadingBar
	loading_bar_front = $LoadingBar/LoadingBarFront
	loading_bar_front_offset = loading_bar_front.position.x
	
	start_cooking() #THIS FUNCTION SHOULD BE CALLED BY THE PLAYER NOT HERE, just for testing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cooking:
		update_cooking_timer()
	elif burning:
		update_burning_timer()

func start_cooking():
	cooking_start_time = Time.get_unix_time_from_system()
	cooking = true
	loading_bar.visible = true
	
#Moves the loading bar forward to show the cooking progress
func update_cooking_timer():
	var time_elapsed = Time.get_unix_time_from_system() - cooking_start_time
	var time_fraction = time_elapsed / COOKING_TIME
	
	if time_elapsed >= COOKING_TIME:
		cooking = false
		cooked = true
		burning_start_time = Time.get_unix_time_from_system()
		print("Cooking Finished!")
		burning = true
		
	else:
		loading_bar_front.scale = Vector3(time_fraction, 1, 1)
		loading_bar_front.position = Vector3((1-time_fraction) * loading_bar_front_offset, 0, 0)

#Just have the food burn after the timer goes off
func update_burning_timer():
	var time_elapsed = Time.get_unix_time_from_system() - burning_start_time
	
	if time_elapsed >= BURNING_TIME:
		print("Food Burnt!")
		burning = false
		cooked = false
		reset_loading_bar()

#Used by the player to reset the station, only returns true if the food was cooked (not burnt)
func grab_cooked_food() -> bool:
	var output = false
	
	if cooked:
		reset_loading_bar()
	return output	

func reset_loading_bar():
	loading_bar.visible = 0
	loading_bar_front.scale = Vector3(0.001, 1, 1)
	loading_bar_front.position = Vector3(loading_bar_front_offset, 0, 0)
