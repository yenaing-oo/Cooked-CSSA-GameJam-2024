extends Node3D

var rating = 5

var order = 0 #keeps count of the orders

var stars = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	for star in $Stars.get_children():
		stars.append(star)


func setWindowSize() -> void:
	var windowWidth := 1152
	var windowHeight := 648

	get_window().size.x = windowWidth
	get_window().size.y = windowHeight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		setWindowSize()
		setWindowPositionCenter()

func setWindowPositionCenter() -> void:
	var center_screen := DisplayServer.screen_get_position() + DisplayServer.screen_get_size() /2 
	var window_size := get_window().get_size_with_decorations()
	var new_window_position := center_screen - window_size /2
	get_window().set_position(new_window_position)

func lose_rating():
	rating -= 1
	stars[rating].visible = false
		
	


func decreaseOrder():
	if(order>0):
		order -= 1
	else: 
		order = 0	

func increaseOrder(): #used this in the ordeerwindow to take orders
	order += 1
