extends Node3D

#countdown timer for taking orders.
const TAKE_ORDER_TIMER = 11


var time = TAKE_ORDER_TIMER

@onready var timer: Label3D = $Timer/timer

func _ready() -> void:
	$Timer.start()



func _on_timer_timeout() -> void:
	time = time - 1
	timer.text = str(time)
	if(time == 0):
		time = TAKE_ORDER_TIMER
