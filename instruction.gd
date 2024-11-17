extends CanvasLayer

# List of instructions to display in order
var instructions: Array = [
	"Welcome to the game!",
	"Press W to move forward.",
	"Press S to move backward.",
	"Avoid enemies to stay alive.",
	"Use the spacebar to jump."
]

# Index to track the current instruction
var current_index: int = 0
var is_typing: bool = false  # Prevent overlapping typing

# Typing effect settings
@export var char_delay: float = 0.05  # Time per character (in seconds)
@export var line_delay: float = 1.0   # Time between lines (in seconds)

# References to Label and TypingSound
@onready var label: Label = $Label
@onready var typing_sound: AudioStreamPlayer = $TypingSound

# Preload the typing sound (use .wav for better performance)
@onready var typing_sound_stream = preload("res://typing-sound.mp3")

func _ready() -> void:
	# Assign the preloaded sound to the AudioStreamPlayer
	typing_sound.stream = typing_sound_stream
	
	# Style the Label's text (set text color to black)
	label.add_theme_color_override("font_color", Color(0, 0, 0))  # Black color
	label.text = ""  # Clear the Label at the start
	
	# Start displaying the instructions step by step
	show_next_instruction()

# Function to show the next instruction in order
func show_next_instruction() -> void:
	if current_index < instructions.size() and not is_typing:
		is_typing = true
		await type_instruction(instructions[current_index])  # Type the current instruction
		current_index += 1  # Move to the next instruction
		is_typing = false
		await get_tree().create_timer(line_delay).timeout  # Wait before the next line
		show_next_instruction()  # Show the next instruction
	elif current_index >= instructions.size():
		# Once all instructions are displayed, optionally add a final message
		label.text += "\nAll instructions displayed."

# Function to type text character by character
func type_instruction(instruction: String) -> void:
	var temp_text = label.text  # Preserve existing text in the Label
	for i in range(instruction.length()):
		# Play the typing sound
		if typing_sound.is_playing():
			typing_sound.stop()  # Stop any overlapping sound
		typing_sound.play()
		
		# Add the next character to the Label
		label.text = temp_text + instruction.substr(0, i + 1)
		await get_tree().create_timer(char_delay).timeout  # Wait before typing the next character
	label.text += "\n"  # Add a newline after completing the line
