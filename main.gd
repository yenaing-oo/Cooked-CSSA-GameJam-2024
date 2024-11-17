extends Node3D

var rating = 5
var stars = []
var flashing = false # Indicates if the stars are currently flashing
@onready var quit_button = $GameOver/QuitButton
@onready var restart_button = $GameOver/"RestartButton"

@onready var pauseScene = $newPause
@onready var continueButton = $newPause/VBoxContainer/continueButton
@onready var howToButton = $newPause/VBoxContainer/howToPlayButton
@onready var howToPlayScene = $howToPlay
@onready var howToPlaySceneReturn = $howToPlay/Button
@onready var paused = false
@onready var masterAudio = AudioServer.get_bus_index("Master")

@onready var timescaleValue = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	for star in $Stars.get_children():
		stars.append(star)
	if quit_button:
		quit_button.connect("pressed", self.quit_game)
	if restart_button:
		restart_button.connect("pressed", self.restart_game)
	if continueButton:
		continueButton.connect("pressed", continueGame)
	if howToButton:
		howToButton.connect("pressed", showHowToPlay)
	if howToPlaySceneReturn:
		howToPlaySceneReturn.connect("pressed", showPause)

func showHowToPlay():
	pauseScene.visible = false
	howToPlayScene.visible = true

func showPause():
	howToPlayScene.visible = false
	pauseScene.visible = true

func continueGame():
	paused = false
	checkPauseState()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if !howToPlayScene.is_visible_in_tree():
			pauseScene.visible = true
			paused = true
			checkPauseState()

func checkPauseState():
	if paused:
		Engine.time_scale = 0
	elif !paused:
		pauseScene.visible = false
		Engine.time_scale = timescaleValue

func lose_rating():
	rating -= 1
	if rating <= 0:
		AudioServer.set_bus_mute(masterAudio, true)
		$GameOver.visible = true
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

func quit_game():
	get_tree().quit()

func restart_game():
	AudioServer.set_bus_mute(masterAudio, false)
	# Reload the current scene
	var current_scene = get_tree().current_scene
	if current_scene:
		$GameOver.visible = false
		get_tree().reload_current_scene()
