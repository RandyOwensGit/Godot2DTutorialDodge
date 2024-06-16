extends Area2D

# Custom SIGNAL that the player object "sends out" when its "hit"
signal hit

# Member Variables
@export var speed = 400 # How fast the player moves (pixels/sec)

var screen_size # Game Window Size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # get size of the game window
	
	# Player hidden when game starts
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # Player's CONSTANT movement vector
	
	# Check actions pressed
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	# normalize velocity so that two key movements are not double speed because of two presses at once
	# $ is the same as get_node() and works as a shortcut for direct child nodes
	# $ is the relative path
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# updating player position
	# delta is 'frame length' - that way if frame times change then it stays consistent 
	position += velocity * delta 
	
	# Clamping is restricting a value to a certain range. IE: keeping the player on the game screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Changing animation direction for walking right/left
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
		# Changing animation direction for going up/down
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	

func _on_body_entered(body):
	hide() # Player disappears after being hit
	hit.emit()
	
	# Must be deferred as we can't change physics properties on a physics callback
	# Disables the player collision (player is dead)
	$CollisionShape2D.set_deferred("disabled", true)

# Function that resets player when starting new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false









