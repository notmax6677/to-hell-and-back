extends KinematicBody2D

# movement variables
var movement = Vector2.ZERO
var max_movement = Vector2(150, 200)

var ground_direction = Vector2.UP # defaults to down (either 0 or 1)
var gravity = 10

var jump_force = 25
var min_jump_force = 100
var jumping = false

var speed = 0.5

# world variables
var moving_worlds = false
var rebound = 10

# life/death variables
var dead = false
var health = 10 # start w 10
var invincible = false

# other variables
var height_from_floor = 0

# beginning controller
onready var begin = get_node('../../Begin')

# get camera node for shaking effect
onready var camera = get_node('../../Camera')

# death menu instance
const death_menu = preload('res://Scenes/Game/UI/DeathMenu.tscn')

func _process(delta):
	if begin.side != 'none':
		# add gravity and move towards the ground
		if movement.y < max_movement.y or movement.y > -max_movement.y:
			movement.y += gravity * -ground_direction.y
		else:
			movement.y = max_movement.y # if movement speed surpassed max movement, then set to max
		
		# jumping
		
		var started_jump = false
		
		# if on floor
		if is_on_floor():
			movement.y = 0 # set to 0 if on floor and not jumping
			jumping = true # set eligibility to jump
			
		# jumping, the longer you hold space the higher you jump
		if Input.is_action_pressed('ui_space') and jumping == true and movement.y < max_movement.y and movement.y > -max_movement.y and not is_on_ceiling() and dead == false:
			if is_on_floor():
				movement.y = min_jump_force * ground_direction.y
			else:
				movement.y += jump_force * ground_direction.y
		else:
			jumping = false
		
		# rebound if hit ceiling, but with 10x less force, it looks more natural
		if is_on_ceiling():
			movement.y = -movement.y/10
		
		# if alive
		if dead == false:
			# increase speed
			if movement.x < max_movement.x:
				movement.x += speed
		else:
			if movement.x > 0:
				movement.x -= speed
		
		# break blocks function call if not moving thru worlds
		if not moving_worlds:
			break_blocks()
		
		# set the height from the floor
		if ground_direction.y == 1: # heaven
			height_from_floor = position.y - 30 - $CollisionShape.shape.extents.y
		elif ground_direction.y == -1: # hell
			height_from_floor = position.y + 30 + $CollisionShape.shape.extents.y
		
		# for every 1000 pixels travelled, add 10 to the max speed
		max_movement.x = 150 + int(position.x/1000)*10
		
		# death
		if health <= 0 and dead == false:
			die()
		
		# apply movement
		move_and_slide(movement, ground_direction)



# starts a process that toggles the player to the other world
func start_switch_worlds():
	moving_worlds = true # enable moving worlds
	
	layers = 2 # set layer to 2 (nothing in it)


func end_switch_worlds():
	moving_worlds = false
	
	movement.y = rebound * ground_direction.y # set small rebound distance that stretches
	
	ground_direction.y = -ground_direction.y # reverse the ground direction, again, back to the original
	
	layers = 1 # set layer back
	
	# if switched to hell world (upside down)
	if ground_direction.y == 1:
		$Sprite.flip_v = true # flip vertically
		$CollisionShape.position.y = -0.5 # move collision shape to fit sprite
		$ThresholdFinder.position.y = -1
	
	# if switched to heaven world (not upside down)
	elif ground_direction.y == -1:
		$Sprite.flip_v = false # flip back to normal
		$CollisionShape.position.y = 0.5 # move collision shape for sprite
		$ThresholdFinder.position.y = 0

# call this when health is below or equal to 0
func die():
	dead = true
	
	# create instance of death menu
	var dm = death_menu.instance()
	
	# add instance to tree as a child
	camera.add_child(dm)
	
	# play death sound effect
	$DeathSound.play()

# check for overlapping blocks and break them, then remove life
func break_blocks():
	# boolean later used to determine whether to remove life or not
	var broke_blocks = false # default is false
	
	# get overlapping bodies
	var bodies = $ThresholdFinder.get_overlapping_bodies()
	
	# iterate thru bodies
	for i in range(bodies.size()):
		# get parent of single body
		var parent = bodies[i].get_parent()
		
		# if body is a block
		if 'Block' in parent.name:
			parent.destroy() # call destroy function of block
			broke_blocks = true # set broke_blocks to true
	
	# if a block was broken
	if broke_blocks == true:
		camera.shake()
		# if not invincible yet
		if invincible == false:
			$InvincibilityTimer.start()
			invincible = true
			health -= 0.5 # remove half a life


func _on_InvincibilityTimer_timeout():
	invincible = false
