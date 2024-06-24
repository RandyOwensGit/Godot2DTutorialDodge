extends Node

# allows choosing mob scene to be instanced
@export var mob_scene: PackedScene

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Play Menu Music
	$MenuMusic.play()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Hit signal emitted from Player node but handled in Main Script
# Player was hit - GAME OVER
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# Update HUD
	$HUD.show_game_over()
	
	# End Game Music & Play Death Sound 
	$GameMusic.stop()
	$DeathSound.play()
	
	# One second timer
	await get_tree().create_timer(2.0).timeout
	$MenuMusic.play()

# Game Setup
func new_game():
	print("Hello?")
	
	score = 0
	$MobTimer.wait_time = 0.7
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	# Updating HUD
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# remove all mobs from scene
	get_tree().call_group("mobs", "queue_free")
	
	# Change to GameMusic from MenuMusic
	$MenuMusic.stop()
	$GameMusic.play()
	

func _on_score_timer_timeout():
	score += 1
	
	# Update HUD
	$HUD.update_score(score)
	
	# Changing Mob Timer spawns depending on player score
	if score + 1 > 5:
		$MobTimer.wait_time = 0.6
	if score + 1 > 10: 
		$MobTimer.wait_time = 0.5
	if score + 1 > 20:
		$MobTimer.wait_time = 0.4
	if score + 1 > 30: 
		$MobTimer.wait_time = 0.3
	if score + 1 > 35: 
		$MobTimer.wait_time = 0.25
	if score + 1 > 40: 
		$MobTimer.wait_time = 0.20
	if score + 1 > 45: 
		$MobTimer.wait_time = 0.175
	if score + 1 > 55: 
		$MobTimer.wait_time = 0.15
	if score + 1 > 70: 
		$MobTimer.wait_time = 0.10
	if score + 1 > 70: 
		$MobTimer.wait_time = 0.05

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# Create a Mob at a random location and set mob in motion
func _on_mob_timer_timeout():
	# Create a new instance of the Mob Scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D node - MobPath
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perdendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)
	
