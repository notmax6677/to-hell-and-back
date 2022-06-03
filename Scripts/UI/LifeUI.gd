extends Node2D

onready var player_body = get_node('../../../Player/Body')

var rng = RandomNumberGenerator.new()

func _process(delta):
	# get player health
	var health = player_body.health
	
	# iterate thru 10 hearts
	for i in range(10):
		# get individual heart
		var heart = get_node('../LifeUI/LifeHeart'+str(i+1))
		
		# if indexed heart is less than health
		if i+1 < health:
			heart.frame = 0 # full
		# health has .5 and the heart is on the one that would have been full
		elif i+0.5 == health:
			heart.frame = 1 # half
		# if heart is more than health
		elif i+1 > health:
			heart.frame = 2 # empty
	
	# if player is in invincible mode make the hearts rainbow
	if player_body.invincible == true and player_body.dead == false:
		modulate.r = rng.randf_range(0, 1)
		modulate.g = rng.randf_range(0, 1)
		modulate.b = rng.randf_range(0, 1)
	else:
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
