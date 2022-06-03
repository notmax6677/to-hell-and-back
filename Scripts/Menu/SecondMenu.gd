extends Node2D

# speed reducer for camera
var cam_speed_reducer = 20

# speed reducer for menu screen to slide in
var move_speed_reducer = 10

# pressed start variable
var pressed_start = false

func _ready():
	$MainMenuClickSound.play()

func _process(delta):
	if pressed_start == true:
		# move to goto position
		$Camera.position += ($Screen/ConvertScenePos.position - $Camera.position)/cam_speed_reducer
	
	# slide menu screen in
	$Screen.position += (Vector2.ZERO - $Screen.position)/move_speed_reducer


# quit button lifted
func _on_QuitButton_button_up():
	get_tree().quit() # get the tree and quit

# start button lifted
func _on_StartButton_button_up():
	$Screen/StartTimer.start()
	$MainMenuClickSound.play()
	pressed_start = true


func _on_StartTimer_timeout():
	get_tree().change_scene('res://Scenes/Game/World.tscn')
