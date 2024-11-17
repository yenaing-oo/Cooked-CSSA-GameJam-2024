extends Node3D

var rating = 5

var stars = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	for star in $Stars.get_children():
		stars.append(star)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func lose_rating():
	rating -= 1
	stars[rating].visible = false
	print(rating)
	
