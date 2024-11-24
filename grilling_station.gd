extends Node3D

const COOKING_TIME = 5
const BURNING_TIME = 5

var cooking = false
var cooked = false
var burning = false
var loading_bar
var loading_bar_cooking
var loading_bar_cooking_offset
var loading_bar_burnt
var loading_bar_burnt_offset
var burger_raw
var burger_cooked

@onready var player = get_parent().get_node("player")
@onready var audio_stream_player_3d: AudioStreamPlayer = $AudioStreamPlayer3D
@onready var cook_timer: Timer = $CookTimer
@onready var burn_timer: Timer = $BurnTimer


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
		cooking = true
		loading_bar.visible = true
		burger_raw.visible = true
		cook_timer.wait_time = COOKING_TIME
		cook_timer.start()
		audio_stream_player_3d.play()
	
#Moves the loading bar forward to show the cooking progress
func update_cooking_timer():
	var time_elapsed = COOKING_TIME - cook_timer.time_left
	var time_fraction = time_elapsed / COOKING_TIME
	
	loading_bar_burnt.visible = false
	loading_bar_cooking.visible = true
	loading_bar_cooking.scale = Vector3(time_fraction, 1, 1)
	loading_bar_cooking.position = Vector3((1-time_fraction) * loading_bar_cooking_offset, 0, 0)

#Just have the food burn after the timer goes off
func update_burning_timer():
	var time_elapsed = BURNING_TIME - burn_timer.time_left
	var time_fraction = time_elapsed / BURNING_TIME

	loading_bar_cooking.visible = false
	loading_bar_burnt.visible = true
	loading_bar_burnt.scale = Vector3(time_fraction, 1, 1)
	loading_bar_burnt.position = Vector3((1-time_fraction) * loading_bar_burnt_offset, 0, 0)

#Used by the player to reset the station, only returns true if the food was cooked (not burnt)
func grab_cooked_food() -> bool:
	var output = false
	
	if cooked and not player.carrying_burger:
		cook_timer.stop()
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


func _on_cook_timer_timeout() -> void:
	cook_timer.stop()
	cooking = false
	cooked = true
	print("Cooking Finished!")
	burning = true
	burger_raw.visible = false
	burger_cooked.visible = true
	burn_timer.wait_time = BURNING_TIME
	burn_timer.start()


func _on_burn_timer_timeout() -> void:
	burn_timer.stop()
	print("Food Burnt!")
	burning = false
	cooked = false
	burger_cooked.visible = false
	reset_loading_bar()
