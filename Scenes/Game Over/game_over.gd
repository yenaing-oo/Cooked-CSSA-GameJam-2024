extends Control

@onready var textureRect := $TextureRect
@onready var hBox := $HBoxContainer

var screen_X : int
var screen_Y : int
var scale_factor_x
var scale_factor_y

func _ready():
	get_tree().get_root().size_changed.connect(setScreen)
	setScreen()

func setScreen():
	getWindowSize()

	getScaleFactor()

	setTextureRectSize()
	setTextureRectPosition()

	setHBoxSize()
	setHBoxPosition()

func getWindowSize():
	screen_X = DisplayServer.window_get_size().x
	screen_Y = DisplayServer.window_get_size().y

func getScaleFactor():
	var base_factor = 4
	var base_resolution_x = 2880
	var base_resolution_y = 1800
	
	scale_factor_x = base_factor * (float(screen_X) / base_resolution_x )
	scale_factor_y =  base_factor * (float(screen_Y) / base_resolution_y)

func setTextureRectSize():
	textureRect.size = Vector2i(screen_X, screen_Y)

func setTextureRectPosition():
	var position_X := 0 
	var position_Y := 0 
	
	textureRect.position = Vector2i(position_X, position_Y)

func setHBoxSize():
	hBox.scale = Vector2(scale_factor_x,scale_factor_y)

func setHBoxPosition():
	var position_X : float = screen_X - (screen_X / 5)
	var position_Y : float = screen_Y - (screen_Y / 5)

	var size_x_offset = hBox.size.x * hBox.scale.x  / 2
	position_X = position_X - size_x_offset

	var size_y_offset = hBox.size.y * hBox.scale.y / 2
	position_Y = position_Y - size_y_offset

	hBox.position = Vector2i(position_X, position_Y)