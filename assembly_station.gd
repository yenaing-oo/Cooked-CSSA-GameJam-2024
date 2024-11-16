extends Node3D

const DIRECTIONS = ["up", "down", "left", "right"]

var inMinigame = true
var sequence = []
var sequence_number = 0

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
	sequence = generate_directions(6)
	
#Generates the sequence of directions for the assembly minigame
func generate_directions(sequence_length: int) -> Array:
	
	var output = []
	for i in sequence_length:
		output.append(DIRECTIONS[randi() % DIRECTIONS.size()])
		print(output[i])
	
	return output

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
		
		#End the minigame in success if they finish the sequence
		if sequence_number >= sequence.size():
			print("Minigame Complete!")
			inMinigame = false
			
	#Incorrect, restart
	else:
		print("Incorrect Input!")
		sequence_number = 0
		sequence = generate_directions(6)
	
