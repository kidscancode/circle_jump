extends CanvasLayer

var score = 0

func _ready():
	$Message.rect_pivot_offset = $Message.rect_size / 2
	
func show_message(text):
	$Message.text = text
	$MessageAnimation.play("show_message")
	
func hide():
	$ScoreBox.hide()
	$BonusBox.hide()
	$StartTip.hide()
	
func show():
	$ScoreBox.show()
	$BonusBox.show()
	$StartTip.show()
	
func update_score(score, value):
	if value > 0 and $StartTip.visible:
		$StartTip.hide()
	$Tween.interpolate_property(self, "score", score,
			value, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$ScoreAnimation.play("score")
#	$ScoreBox/HBoxContainer/Score.text = str(value)

func update_bonus(value):
	$BonusBox/Bonus.text = str(value) + "x"
	if value > 1:
		$BonusAnimation.play("bonus")

func _on_Tween_tween_step(object, key, elapsed, value):
	$ScoreBox/HBoxContainer/Score.text = str(int(value))
