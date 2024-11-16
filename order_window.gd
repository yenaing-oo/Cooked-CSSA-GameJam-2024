extends Node3D


const ORDER_WINDOW_TIME = 11

@onready var timer: Label3D = $timer

var rating = 5

var time = ORDER_WINDOW_TIME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	$Timer.start()
	print(rating)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_timer_timeout() -> void:
	time = time -1
	if(time == 0):	
		rating = rating -1
		print(rating)	
		time = ORDER_WINDOW_TIME
	
	timer.text = str(time)
	
func _input(ev):
	if(Input.is_key_pressed(KEY_E)):
		time = ORDER_WINDOW_TIME
#		TODO: take order 
