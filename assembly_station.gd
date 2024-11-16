extends Node3D

const SEQUENCE_LENGTH = 6
const DIRECTIONS = ["up", "down", "left", "right"]
const ARROW_SCALE = Vector3(0.03, 0.03, 0.03)
const ARROW_ANCHOR = Vector3(0, 0.8, 0)

var inMinigame = true
var sequence = [] 		#The current sequence of directions for the minigame
var sequence_number = 0	#The index of the direction the player has to press next
var drawn_arrows = [] 	#The Sprite3D arrows that are currently drawn, keep track to erase later

#A dictionary of the texture for each direction
var arrow_textures = {
	"up": preload("res://assets/textures/up_arrow.png"),
	"down": preload("res://assets/textures/down_arrow.png"),
	"left": preload("res://assets/textures/left_arrow.png"),
	"right": preload("res://assets/textures/right_arrow.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	start_minigame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_minigame():
	inMinigame = true
	sequence_number = 0
	sequence = generate_directions(SEQUENCE_LENGTH)
	draw_arrows(sequence)
	
#Creates Sprite3Ds with the correct texture above the Station
func draw_arrows(sequence: Array):
	#first clear the old arrows
	clear_arrows()
	
	#Create all the arrows
	for i in range(sequence.size()):
		var arrow = Sprite3D.new()
		arrow.texture = arrow_textures.get(sequence[i])
		
		var xPos = ARROW_ANCHOR.x - sequence.size()/2.0 + i + 0.5
		arrow.position = ARROW_ANCHOR + Vector3(xPos * 0.4, 0, 0)
		arrow.scale = ARROW_SCALE
		add_child(arrow)
		drawn_arrows.append(arrow)
		
func clear_arrows():
	for arrow in drawn_arrows:
		arrow.queue_free()
	drawn_arrows = []

#Generates the sequence of directions for the assembly minigame
func generate_directions(sequence_length: int) -> Array:
	
	var output = []
	for i in sequence_length:
		output.append(DIRECTIONS[randi() % DIRECTIONS.size()])
		print(output[i])
	
	return output

#Watch for input (if they're currently in the minigame)
func _input(event: InputEvent) -> void:
	if inMinigame:
		if event.is_action_pressed("up"):
			check_input("up")
		if event.is_action_pressed("down"):
			check_input("down")
		if event.is_action_pressed("left"):
			check_input("left")
		if event.is_action_pressed("right"):
			check_input("right")
			
#Checks if the player inputted the correct direction
func check_input(input: String):
	#Correct, continue minigame
	if sequence[sequence_number] == input:
		print("Correct Input!")
		sequence_number += 1
		
		var new_sequence = []
		for i in range(sequence.size() - sequence_number):
			new_sequence.append(sequence[sequence_number+i])
		draw_arrows(new_sequence)
		
		#End the minigame in success if they finish the sequence
		if sequence_number >= sequence.size():
			print("Minigame Complete!")
			inMinigame = false
			clear_arrows()
			
	#Incorrect, restart
	else:
		print("Incorrect Input!")
		sequence_number = 0
		sequence = generate_directions(6)
		draw_arrows(sequence)
	
