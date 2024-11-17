extends Node3D

var rating = 5

@onready var pausemenu: Control = %Pause
var paused = false




var stars = []
var flashing = false # Indicates if the stars are currently flashing

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
	if rating <= 0:
		return
	stars[rating].visible = false
	
	# Start flashing if only 2 or fewer stars remain
	if rating <= 2 and not flashing:
		start_flashing_stars()
		
func start_flashing_stars():
	flashing = true
	var timer = Timer.new()
	timer.wait_time = 0.5 # Flash every 0.5 seconds
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_flash_stars"))
	add_child(timer)
	timer.start()

func _flash_stars():
	if rating <= 2:
		# Alternate visibility of the remaining stars
		for i in range(rating):
			stars[i].visible = not stars[i].visible
	else:
		# Stop flashing when more than 2 stars are left
		flashing = false
		$Timer.stop()
		$Timer.queue_free()
		

func pause_fun(delta):
	if Input.is_action_just_pressed("pause"):
		pass

func pause_menu():
	if paused:
		pausemenu.hide()
		Engine.time_scale = 1
	else:
		pausemenu.show()
		Engine.time_scale = 0
		
	paused = !paused
		
	
	
	
	
	
