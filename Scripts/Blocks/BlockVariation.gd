extends AnimatedSprite

# this script sets the random variation for both heaven and hell blocks

var rng = RandomNumberGenerator.new() # create random number generator

var tip


func _ready():
	rng.randomize() # randomize seed
	
	# only do tip stuff if its a hellblock
	if 'HellBlock' in get_node('..').name:
		tip = get_node('../TipSprite') # tip that will also be modified randomly
		tip.frame = int(rng.randf_range(0, 8)) # randomize tip frame
	
	frame = int(rng.randf_range(0, 8)) # randomize frame for block itself
	
	rotation_degrees = int(rng.randf_range(0, 4)) * 90 # randomize rotation for more variety (either 0, 90, 180, 270, 360)
	
	flip_h = bool(int(rng.randf_range(0, 1))) # randomize horizontal flip variation
