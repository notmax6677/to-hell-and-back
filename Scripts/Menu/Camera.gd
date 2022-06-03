extends Camera2D

# get screen nodes
onready var screen1 = get_node('../Screen1')
onready var screen2 = get_node('../Screen2')
onready var screen3 = get_node('../Screen3')
onready var screen4 = get_node('../Screen4')

onready var lore_screen = get_node('../Screen4/Lore/Screen')

onready var guide_screen1 = get_node('../Screen4/Guide/GuideScreens/Screen1')
onready var guide_screen2 = get_node('../Screen4/Guide/GuideScreens/Screen2')
onready var guide_screen3 = get_node('../Screen4/Guide/GuideScreens/Screen3')


# goto screen
var goto_screen = 1

# goto position
var goto_position = position

# screen 4 background color
var s4_col = Color(0.07, 0.13, 0.25)

var current_col = Color(Color(0.34, 0.35, 0.38, 1))

# speed reducer for cam movement
var speed_reducer = 10

# speed reducer for color shift
var col_speed_reducer = 8

# looking at lore
var looking_at_lore = false

# looking at guide
var looking_at_guide = false
# guide screen
var guide_screen = 1


# variable thats enabled when converting/moving to another scene
var converting_scenes = false

# convert scene node, use it to glide to its position while converting scenes
onready var convert_scene_pos = get_node('../Screen4/ConvertScenePos')

func _process(delta):
	if converting_scenes == false:
		# set goto position based on goto_screen variable
		if goto_screen == 1:
			goto_position = screen1.position
		elif goto_screen == 2:
			goto_position = screen2.position
		elif goto_screen == 3:
			goto_position = screen3.position
		elif goto_screen == 4:
			if looking_at_lore == true:
				goto_position = lore_screen.position
			elif looking_at_guide == true:
				if guide_screen == 1:
					goto_position = guide_screen1.position
				elif guide_screen == 2:
					goto_position = guide_screen2.position
				elif guide_screen == 3:
					goto_position = guide_screen3.position
			else:
				goto_position = screen4.position
			
			# change background color to
			current_col.r += (s4_col.r - current_col.r)/col_speed_reducer
			current_col.g += (s4_col.g - current_col.g)/col_speed_reducer
			current_col.b += (s4_col.b - current_col.b)/col_speed_reducer
			
			# update background's color
			VisualServer.set_default_clear_color(current_col)
	else:
		# if converting scenes is true, then move to convert scene position, this is used for a 
		# clean transition between scenes so it feels and looks nice
		goto_position = convert_scene_pos.position
	
	# move to goto position
	position += (Vector2(goto_position.x, goto_position.y) - position)/speed_reducer


func _on_MoveTimer_timeout():
	goto_screen += 1 # add 1 to goto screen variable every time
	
	# if hit last goto screen
	if goto_screen == 4:
		$MoveTimer.stop() # stop timer


# button that leads to lore screen
func _on_LoreButton_button_up():
	looking_at_lore = true # set looking_at_lore to true
	$ClickSound.play()


# back button on lore screen pressed
func _on_LoreBackButton_button_up():
	looking_at_lore = false # disable looking_at_lore
	$ClickSound.play()


func _on_GuideButton_button_up():
	looking_at_guide = true
	$ClickSound.play()


func _on_BackButton_button_up():
	looking_at_guide = false
	$ClickSound.play()

func _on_NextScreen1Button_button_up():
	guide_screen = 2
	$ClickSound.play()


func _on_Screen2BackButton_button_up():
	guide_screen = 1
	$ClickSound.play()


func _on_Screen3BackButton_button_up():
	guide_screen = 2
	$ClickSound.play()


func _on_NextButton_button_up():
	guide_screen = 3
	$ClickSound.play()
