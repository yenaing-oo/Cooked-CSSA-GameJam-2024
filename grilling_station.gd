extends Node3D

const COOKING_TIME = 5
const TIMER_ANCHOR = Vector3(0, 0.8, 0)

var cooking = false
var cooking_start_time
var loading_bar
var loading_bar_front
var loading_bar_front_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_bar = $LoadingBar
	loading_bar_front = $LoadingBar/LoadingBarFront
	loading_bar_front_offset = loading_bar_front.position.x
	start_cooking()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cooking:
		update_timer()

func start_cooking():
	cooking_start_time = Time.get_unix_time_from_system()
	cooking = true
	loading_bar.visible = true
	
func update_timer():
	var time_elapsed = Time.get_unix_time_from_system() - cooking_start_time
	var time_fraction = time_elapsed / COOKING_TIME
	
	#print(time_fraction)
	if time_elapsed >= COOKING_TIME:
		cooking = false
		print("Cooking Finished!")
	else:
		loading_bar_front.scale = Vector3(time_fraction, 1, 1)
		loading_bar_front.position = Vector3((1-time_fraction) * loading_bar_front_offset, 0, 0)
