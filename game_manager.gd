extends Node

@onready var scorelabel: Label3D = $scorelabel
@onready var orderlabel: Label3D = $orderlabel

var score = 0
var order = 0

func add_point():
	score += 1
	scorelabel.text = str(score)
	
	print(score)


func decreaseOrder():
	if(order>0):
		order -= 1
	else: 
		order = 0
	
	orderlabel.text = str(order)
	print(order)

func increaseOrder(): #used this in the ordeerwindow to take orders
	order += 1
	
	orderlabel.text = str(order)
	
	print(order)	
