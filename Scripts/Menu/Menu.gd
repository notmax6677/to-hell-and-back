extends Node2D


# quit button lifted
func _on_QuitButton_button_up():
	get_tree().quit() # get the tree and quit

# start button lifted
func _on_StartButton_button_up():
	$Screen4/StartTimer.start()
	$Camera/MainMenuClickSound.play()
	$Camera.converting_scenes = true


func _on_StartTimer_timeout():
	get_tree().change_scene('res://Scenes/Game/World.tscn')
