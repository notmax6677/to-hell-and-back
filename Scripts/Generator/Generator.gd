extends Node2D

# chunk length is 16 tiles
# 16*12 = 192

# instances of objects
const fabric_instance = preload('res://Scenes/Game/Objects/Fabric.tscn')
const heaven_ground_instance = preload('res://Scenes/Game/Objects/HeavenGround.tscn')
const hell_ground_instance = preload('res://Scenes/Game/Objects/HellGround.tscn')
const platform_instance = preload('res://Scenes/Game/Objects/Platform.tscn')

const world_sw = preload('res://Scenes/Game/Objects/WorldSwitcher.tscn')

const killer_block_instance = preload('res://Scenes/Game/Objects/KillerBlock.tscn')

# random number generator
var rng = RandomNumberGenerator.new()

# get player body node
onready var player_body = get_node('../Player/Body')

# create chunk length of fabric
func create_fabric(x):
	# loop 16 times
	for i in range(16):
		var local_fabric = fabric_instance.instance() # create copy of instance
		
		local_fabric.name = 'fabric' + str($Fabrics.get_child_count()) # set unique name
		
		local_fabric.position = Vector2(x*192+i*12, 0) # set position
		
		$Fabrics.add_child(local_fabric) # add child to tree


# create chunk of heaven ground
func create_heaven_ground(x):
	# loop 16 times
	for i in range(16):
		var local_hvn_gr = heaven_ground_instance.instance() # create copy of instance
		
		local_hvn_gr.name = 'hvn_gr' + str($HeavenGrounds.get_child_count()) # set unique name
		
		local_hvn_gr.position = Vector2(x*192+i*12, -30) # set position
		
		$HeavenGrounds.add_child(local_hvn_gr) # add child to tree


# create chunk of hell ground 
func create_hell_ground(x):
	# loop 16 times
	for i in range(16):
		var local_hl_gr = hell_ground_instance.instance() # create copy of instance
		
		local_hl_gr.name = 'hl_gr' + str($HellGrounds.get_child_count()) # set unique name
		
		local_hl_gr.position = Vector2(x*192+i*12, 30) # set position
		
		$HellGrounds.add_child(local_hl_gr) # add child to tree

# creates a heaven chunk
func create_heaven_chunk(x):
	# create ground
	create_heaven_ground(x)
	
	# if in heaven
	if player_body.ground_direction.y == -1:
		# life of generation algorithm (2 - 4)
		var life = int(rng.randf_range(2, 4.9))
		
		# create local position vector2 to work with
		var local_pos = Vector2(x*192, -30)
		
		# iterate through life ammount
		for i in range(life):
			# valid positions for platforms are -42, -54, -66, etc
			
			# move local_pos.y up two tiles
			local_pos.y -= int(rng.randf_range(1, 2.5))*12
			
			# move platform forward random amount of spaces
			local_pos.x += int(rng.randf_range(1, 3.9))*24
			
			# create local instance
			var local_plat = platform_instance.instance()
			
			# set local platform instance's position
			local_plat.position = Vector2(local_pos.x, local_pos.y)
			
			# add platform to tree
			$HeavenPlatforms.add_child(local_plat)
			
			# in platform object, generate it's children
			local_plat.create('heaven')

# creates a heaven chunk
func create_hell_chunk(x):
	# create ground
	create_hell_ground(x)
	
	# if in hell
	if player_body.ground_direction.y == 1:
		# life of generation algorithm (2 - 4)
		var life = int(rng.randf_range(2, 4.9))
		
		# create local position vector2 to work with
		var local_pos = Vector2(x*192, 42)
		
		# iterate through life ammount
		for i in range(life):
			# valid positions for platforms are 42, 54, 66, etc
			
			# move local_pos.y up two tiles
			local_pos.y += int(rng.randf_range(1, 2))*24
			
			# move platform forward random amount of spaces
			local_pos.x += int(rng.randf_range(3, 5.9))*24
			
			# create local instance
			var local_plat = platform_instance.instance()
			
			# set local platform instance's position
			local_plat.position = Vector2(local_pos.x, local_pos.y)
			
			# add platform to tree
			$HellPlatforms.add_child(local_plat)
			
			# in platform object, generate it's children
			local_plat.create('hell')
		
		# chance of creating a single killer block (1/8)
		var killer_block_chance = rng.randf_range(0, 8)
		
		# if less than 1
		if killer_block_chance <= 1:
			var local_instance = killer_block_instance.instance()
			
			local_instance.position = Vector2(x*192 + rng.randf_range(0, 12)*12, 42)
			
			$KillerBlocks.add_child(local_instance)

# creates a world switcher at the given location
func create_world_switcher(x, y):
	# create an instance of world switcher
	var local_instance = world_sw.instance()
	
	# set position
	local_instance.position = Vector2(x, y)
	
	$WorldSwitchers.add_child(local_instance)

# create a full chunk
func create_chunk(x):
	create_fabric(x)
	create_hell_chunk(x)
	create_heaven_chunk(x)
	
	# chance of creating world switcher (1/8)
	var create_ws = rng.randf_range(0, 8)
	
	# if valid
	if create_ws <= 1:
		# random x position within chunk
		var xpos = x*192 + rng.randf_range(1, 32)*6
		
		# random y position within chunk, also based on ground direction
		var ypos = (30 + rng.randf_range(1, 16)*6) * player_body.ground_direction.y
		
		create_world_switcher(xpos, ypos)

func create_empty(x):
	create_fabric(x)
	create_heaven_ground(x)
	create_hell_ground(x)

# create five chunks at once
func create_sector(x):
	create_chunk(x)
	create_chunk(x+1)
	create_chunk(x+2)
	create_chunk(x+3)
	create_chunk(x+4)

# function that wraps everything up and generates the beginning of the world
func gen_world():
	create_empty(-1)
	create_empty(0)
	create_empty(1)
	create_empty(2)
	create_empty(3)
	create_empty(4)
	create_empty(5)

# Clean the fabrics and grounds from the previous 4 chunks, cus they're not needed anymore, optimization !!
func clean():
	# get children of fabrics and grounds
	var fabric_children = $Fabrics.get_children()
	var hv_gr_children = $HeavenGrounds.get_children()
	var hl_gr_children = $HellGrounds.get_children()
	
	# iterate through the first 64 items (last 4 chunks)
	for i in range(60):
		# delete the indexed objects
		fabric_children[i].queue_free()
		hv_gr_children[i].queue_free()
		hl_gr_children[i].queue_free()

# in ready function, randomize seed and run GenWorld()
func _ready():
	rng.randomize()
	gen_world()
