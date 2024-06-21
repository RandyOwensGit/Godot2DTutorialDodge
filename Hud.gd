extends CanvasLayer

# Notifies Main node that Start button pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# "Get Ready" Message display
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# Player Loss Process
# Shows "Game Over" for 2 seconds and then return to title screen
func show_game_over():
	show_message("Game Over")
	
	# Wait until MessageTimer has counted down 
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	# Make a one-shot timer and wait for it to finish
	# Show Start button on main screen after short pause
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

# Score Update function
func update_score(score):
	$ScoreLabel.text = str(score)

# Hide start button & start game
func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

# hide message
func _on_message_timer_timeout():
	$Message.hide()

func _on_h_slider_value_changed(value):
	pass # Replace with function body.
