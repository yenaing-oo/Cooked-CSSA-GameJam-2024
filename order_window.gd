extends Node3D

#countdown timer for taking orders.
const TAKE_ORDER_TIMER = 11

var currRating = 5

var time = TAKE_ORDER_TIMER

@onready var timer: Label3D = $Timer/timer


func _ready() -> void:
	$Timer.start()
	print("Rating: " + str(currRating))



func _on_timer_timeout() -> void:
	time = time - 1
	timer.text = str(time)
	if(time == 0):
		currRating = currRating-1
		print("Rating: " + str(currRating))
		time = TAKE_ORDER_TIMER
