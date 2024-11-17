extends Node

@onready var scorelabel: Label3D = $scorelabel

var score = 0

func add_point():
	score += 1
	scorelabel.text = str(score)
	
	print(score)
