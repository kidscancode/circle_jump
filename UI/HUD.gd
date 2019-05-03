extends CanvasLayer

func show_message(text):
	$Message.text = text
	$AnimationPlayer.play("show_message")
	
func hide():
	$ScoreBox.hide()
	
func show():
	$ScoreBox.show()
	
func update_score(value):
	$ScoreBox/HBoxContainer/Score.text = str(value)