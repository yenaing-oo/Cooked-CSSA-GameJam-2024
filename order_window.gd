extends Node3D

@onready var game_manager: Node = %GameManager
@onready var orderTimer: Timer = $OrderTimer
@onready var graceTimer: Timer = $GraceTimer
@onready var difficultyTimer: Timer = $DifficultyTimer
@onready var loadingBar: Sprite3D = $loadingBar
@onready var loadingBarFilling: Sprite3D = $loadingBar/loadingBarFilling

@export var easyMinGraceTime = 7.0
@export var easyMaxGraceTime = 30.0
@export var hardMinGraceTime = 1.0
@export var hardMaxGraceTime = 15.0
@export var veryHardMinGraceTime = 1.0
@export var veryHardMaxGraceTime = 13.0
@export var easyOrderWaitingTime = 15.0
@export var hardOrderWaitingTime = 10.0
@export var timeBeforeHardDifficulty = 120.0
@export var timeBeforeVeryHardDifficulty = 300 #This amount of seconds AFTER it becomes 'hard'
@export var max_orders = 3

const GRACE_PEROID = 5 #The time before an order first shows up

var main_scene
var minGraceTime = easyMinGraceTime
var maxGraceTime = easyMaxGraceTime
var orderWaitingTime = easyOrderWaitingTime
var order = false
var loadingBarFillingOffset
var hard = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_process_input(true)
	graceTimer.wait_time = GRACE_PEROID
	graceTimer.start()
	difficultyTimer.wait_time = timeBeforeHardDifficulty
	difficultyTimer.start()
	main_scene = get_parent()
	loadingBarFillingOffset = loadingBarFilling.position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if order:
		#Do the loading bar thing if there's an order
		var time_elapsed = orderWaitingTime - orderTimer.time_left
		var time_fraction = time_elapsed / orderWaitingTime
		loadingBar.visible = true
		loadingBarFilling.scale = Vector3(time_fraction, 1, 1)
		loadingBarFilling.position = Vector3((1-time_fraction) * loadingBarFillingOffset, 0, 0)

#stops order timer, generates a random timer for grace period
func start_grace_timer():
	orderTimer.stop()
	var grace_period = randf_range(minGraceTime, maxGraceTime)
	graceTimer.wait_time = grace_period
	graceTimer.start()
	
#stops grace timer, start order timer
func start_order_timer():
	graceTimer.stop()
	orderTimer.wait_time = orderWaitingTime
	orderTimer.start()
	order = true
	
func _on_grace_timer_timeout() -> void:
	start_order_timer()

#failed to grab order, lose score and start grace timer
func _on_order_timer_timeout() -> void:
	hide_loading_bar()
	main_scene.lose_rating()
	start_grace_timer()
	
#turn up the difficulty a bit if they go for over a minute
func _on_difficulty_timer_timeout() -> void:
	difficultyTimer.stop()
	if not hard:
		minGraceTime = hardMinGraceTime
		maxGraceTime = hardMaxGraceTime
		orderWaitingTime = hardOrderWaitingTime
		difficultyTimer.wait_time = timeBeforeVeryHardDifficulty
		difficultyTimer.start()
	else:
		minGraceTime = veryHardMinGraceTime
		maxGraceTime = veryHardMaxGraceTime

#The player grabs the order if available, start the grace timer and increase order number
func take_order():
	if order and game_manager.order < max_orders:
		hide_loading_bar()
		game_manager.increaseOrder() #increases the order count in the order variable in main
		start_grace_timer()

func hide_loading_bar():
	order = false
	loadingBar.visible = false
