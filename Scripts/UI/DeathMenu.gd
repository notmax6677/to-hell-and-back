extends Node2D

# goto position when spawned
var goto_pos = Vector2(0, 144)

# speed reducer for slide-in
var slide_speed_reducer = 4

func _process(delta):
	position += (goto_pos - position)/slide_speed_reducer


func _on_MenuButton_button_up():
	VisualServer.set_default_clear_color(Color(0.07, 0.13, 0.25)) # set back to the blue-ish color
	get_tree().change_scene('res://Scenes/SecondMenu.tscn')


func _on_RespawnButton_button_up():
	VisualServer.set_default_clear_color(Color(0.07, 0.13, 0.25)) # set back to the blue-ish color
	get_tree().change_scene('res://Scenes/Game/SecondWorld.tscn')
