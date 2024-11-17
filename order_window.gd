extends Node3D


const ORDER_WINDOW_TIME = 11

@onready var timer: Label3D = $timer

var rating = 5
var main_scene


var time = ORDER_WINDOW_TIME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	$Timer.start()
	main_scene = get_parent()


func _on_timer_timeout() -> void:
	time = time -1
	if(time == 0):	
		#rating = rating -1
		#print(rating)	
		main_scene.lose_rating()
		time = ORDER_WINDOW_TIME
	
	timer.text = str(time)
	
func take_order():
		time = ORDER_WINDOW_TIME
		main_scene.increaseOrder() #increases the order count in the order variable in main
