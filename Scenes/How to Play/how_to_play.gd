extends Control


@onready var colorRect := $ColorRect
@onready var vBox := $VBoxContainer

var screen_X : int
var screen_Y : int
var scale_factor_x
var scale_factor_y

func _ready():
	setScreen()

func setScreen():
	getWindowSize()

	getScaleFactor()

	setColorRectSize()
	setColorRectPosition()

	setVBoxSize()
	setVBoxPosition()

func getWindowSize():
	# Might need to swap to DisplayServer.screen_get_size()
	screen_X = DisplayServer.window_get_size().x
	screen_Y = DisplayServer.window_get_size().y

func getScaleFactor():
	var base_factor = 2
	var base_resolution_x = 1918
	var base_resolution_y = 1078
	
	# May need to change around after testing on other monitors
	scale_factor_x = base_factor * (float(screen_X) / base_resolution_x)
	scale_factor_y =  base_factor * (float(screen_Y)/ base_resolution_y)


func setColorRectSize():
	colorRect.size = Vector2i(screen_X, screen_Y)

func setColorRectPosition():
	var position_X := 0 
	var position_Y := 0 
	
	colorRect.position = Vector2i(position_X, position_Y)

func setVBoxSize():
	vBox.scale = Vector2(scale_factor_x,scale_factor_y)

func setVBoxPosition():
	var position_X : float = screen_X / 2.0
	var position_Y : float = screen_Y / 2.0

	var size_x_offset = vBox.size.x * vBox.scale.x  / 2
	position_X = position_X - size_x_offset

	var size_y_offset = vBox.size.y * vBox.scale.y / 2
	position_Y = position_Y - size_y_offset

	vBox.position = Vector2i(position_X, position_Y)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
