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
	$MainMenuLayer/TitleLabel.text = text
	$MainMenuLayer/TitleLabel.show()
	$MainMenuLayer/MessageTimer.start()

# Player Loss Process
# Shows "Game Over" for 2 seconds and then return to title screen
func show_game_over():
	show_message("Game Over")
	
	# Wait until MessageTimer has counted down 
	await $MainMenuLayer/MessageTimer.timeout
	
	$MainMenuLayer/TitleLabel.text = "Dodge the Creeps!"
	$MainMenuLayer/TitleLabel.show()
	
	# Make a one-shot timer and wait for it to finish
	# Show Start button on main screen after short pause
	await get_tree().create_timer(1.0).timeout
	$MainMenuLayer/StartButton.show()
	$MainMenuLayer/SettingsButton.show()
	$MainMenuLayer/LeaderboardButton.show()

# Score Update function
func update_score(score):
	$ScoreLabel.text = str(score)

# Hide start button & start game
func _on_start_button_pressed():
	$MainMenuLayer/StartButton.hide()
	$MainMenuLayer/SettingsButton.hide()
	$MainMenuLayer/LeaderboardButton.hide()
	print("Just before start game emit call")
	start_game.emit()

# hide message
func _on_message_timer_timeout():
	$MainMenuLayer/TitleLabel.hide()

# Go to settings screen
func _on_settings_button_pressed():
	$ScoreLabel.hide()
	$MainMenuLayer.hide()
	$SettingsMenuLayer.show()

# Return Button on Menu
func _on_return_button_pressed():
	$LeaderboardLayer.hide()
	$SettingsMenuLayer.hide()
	$MainMenuLayer.show()
	$ScoreLabel.show()

func _on_leaderboard_button_pressed():
	$MainMenuLayer.hide()
	
	display_user_highscores()
	$LeaderboardLayer.show()
	
	# Check if player doesnt have a current score from previous game
	# Dont allow player to submit a new score
	if $ScoreLabel.text == "0":
		$LeaderboardLayer/AddScoreButton.hide()
		

## Add users current score to their leaderboard
## Only works if it is in the top 10 scores
## Calls seperate function to update score display list
func _on_add_score_button_pressed():
	var scoreToBeSaved = int($ScoreLabel.text)
	
	# Open File
	var save_file = "res://data/savefile.save"
	var file = FileAccess.open(save_file, FileAccess.WRITE_READ)
	
	# Check if file exists
	# Loop through to get all score values in an Array
	var scoresArray = []
	var lineIndex = 0
	if FileAccess.file_exists(save_file):
		while not file.eof_reached():
			var lineContent = file.get_line()
			
			if lineContent.length() > 1:
				lineIndex += 1
				scoresArray.append(int(lineContent))
				
			
		
	
	# Close File - Reopen later - easy way to reset cursor to beginning of file
	file.close()
	
	print("Array Before adding User score:::::")
	print(scoresArray)
	
	# Populate array until it has 10 values
	while scoresArray.size() < 10:
		scoresArray.append(0)
	
	# Sort Array descending
	scoresArray.sort()
	scoresArray.reverse()
	
	# Loop through array to update player highscore
	var i = 0
	for score in scoresArray:
		
		# Check if current player score is greater
		if scoreToBeSaved >= score:
			# Insert current player score into this index
			# GDScript automatically reindex's the rest of the Array
			scoresArray.insert(i, scoreToBeSaved)
			
			# Remove last index if size of Array is greater then 10
			if scoresArray.size() > 10:
				scoresArray.remove_at(scoresArray.size() - 1)
			
			# Get out of loop if value gets put into list
			break
			
		# Track index increment
		i += 1
		
	
	# Update the scores file with array values
	file = FileAccess.open(save_file, FileAccess.WRITE)
	
	# Loop over array & add each to a new line in file
	for score in scoresArray:
		file.store_line(str(score))
	
	# Close File
	file.close()
	
	display_user_highscores()
	

# Builds the highscores display UI
func display_user_highscores():
	# File path
	var save_file = "res://data/savefile.save"
	
	# Check if file exists
	if not FileAccess.file_exists(save_file):
		$LeaderboardLayer/PlayerHighscoresLabel.text = ""
		return
	
	# Open file
	var file = FileAccess.open(save_file, FileAccess.READ)
	
	# Loop to get everything in file
	var highscoresArray = []
	while not file.eof_reached():
		highscoresArray.append(int(file.get_line()))
	
	# Add every value to be displayed. Avoid any missing values by excluding 0
	var highscoresString = ""
	for score in highscoresArray:
		if score != 0:
			highscoresString += str(score) + "\n"
	
	# Display String to the ui label
	$LeaderboardLayer/PlayerHighscoresLabel.text = highscoresString
