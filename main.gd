extends Node3D

var rating = 5

var stars = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	for star in $Stars.get_children():
		stars.append(star)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		setWindowSize()
		setWindowPositionCenter()

func setWindowSize() -> void:
	var windowWidth := 1152
	var windowHeight := 648

	get_window().size.x = windowWidth
	get_window().size.y = windowHeight

func setWindowPositionCenter() -> void:
	var center_screen := DisplayServer.screen_get_position() + DisplayServer.screen_get_size() /2 
	var window_size := get_window().get_size_with_decorations()
	var new_window_position := center_screen - window_size /2
	get_window().set_position(new_window_position)

func lose_rating():
	rating -= 1
	stars[rating].visible = false
	print(rating)
	
