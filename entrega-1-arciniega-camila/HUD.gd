extends CanvasLayer

signal start_game  #Tells Main node the button has been pressed.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	
func update_score(score): #called by Main everytime score changes
		$ScoreLabel.text = str(score)
	
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()

