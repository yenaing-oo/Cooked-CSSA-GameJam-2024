extends Control

func resume():
	get_tree().paused = false

func paused():
	get_tree().paused = true

func esc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused: 
		paused()
		
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()	

 


func _on_continue_pressed() -> void:
	resume()
	
func _on_quit_pressed() -> void:
	get_tree().quit()
