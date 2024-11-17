extends Node3D

const COOKING_TIME = 5
const BURNING_TIME = 5

var cooking = false
var cooked = false
var burning = false
var cooking_start_time
var burning_start_time
var loading_bar
var loading_bar_cooking
var loading_bar_cooking_offset
var loading_bar_burnt
var loading_bar_burnt_offset
var burger_raw
var burger_cooked

@onready var player = get_parent().get_node("player")

@onready var audio_stream_player_3d: AudioStreamPlayer = $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_bar = $LoadingBar
	loading_bar_cooking = $LoadingBar/LoadingBarCooking
	loading_bar_cooking_offset = loading_bar_cooking.position.x
	loading_bar_burnt = $LoadingBar/LoadingBarBurnt
	loading_bar_burnt_offset = loading_bar_burnt.position.x
	burger_raw = $BurgerPattyRaw
	burger_cooked = $BurgerPattyCooked

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cooking:
		update_cooking_timer()
	elif burning:
		update_burning_timer()

func start_cooking():
	if not (cooking or burning):
		cooking_start_time = Time.get_unix_time_from_system()
		cooking = true
		loading_bar.visible = true
		burger_raw.visible = true
		audio_stream_player_3d.play()
	
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
		burger_raw.visible = false
		burger_cooked.visible = true
		
	else:
		loading_bar_burnt.visible = false
		loading_bar_cooking.visible = true
		loading_bar_cooking.scale = Vector3(time_fraction, 1, 1)
		loading_bar_cooking.position = Vector3((1-time_fraction) * loading_bar_cooking_offset, 0, 0)

#Just have the food burn after the timer goes off
func update_burning_timer():
	var time_elapsed = Time.get_unix_time_from_system() - burning_start_time
	var time_fraction = time_elapsed / BURNING_TIME

	if time_elapsed >= BURNING_TIME:
		print("Food Burnt!")
		burning = false
		cooked = false
		burger_cooked.visible = false
		reset_loading_bar()
	else:
		loading_bar_cooking.visible = false
		loading_bar_burnt.visible = true
		loading_bar_burnt.scale = Vector3(time_fraction, 1, 1)
		loading_bar_burnt.position = Vector3((1-time_fraction) * loading_bar_burnt_offset, 0, 0)

#Used by the player to reset the station, only returns true if the food was cooked (not burnt)
func grab_cooked_food() -> bool:
	var output = false
	
	if cooked and not player.carrying_burger:
		cooked = false
		burger_cooked.visible = false
		reset_loading_bar()
		output = true
		
	return output

func reset_loading_bar():
	cooking = false
	burning = false
	loading_bar.visible = 0
	loading_bar_cooking.visible = false
	loading_bar_cooking.scale = Vector3(0.001, 1, 1)
	loading_bar_cooking.position = Vector3(loading_bar_cooking_offset, 0, 0)

	loading_bar_burnt.visible = false
	loading_bar_burnt.scale = Vector3(0.001, 1, 1)
	loading_bar_burnt.position = Vector3(loading_bar_burnt_offset, 0, 0)
	
	audio_stream_player_3d.stop()
