extends RigidBody2D

# The Mob randomly moves over the screen

# Called when the node enters the scene tree for the first time.
func _ready():
	# randomly choose an animation to play for random mob direction
	
	# Array of animation names - [fly, swim, walk]
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	# select random number between 0 and 2
	# randi() % array size selects int between 0 and n-1
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# mob deletion when leaving screen - uses signal from Node
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
