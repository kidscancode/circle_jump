extends Node

signal start_game

var sound_buttons = {true: preload("res://assets/images/buttons/audioOn.png"),
					false: preload("res://assets/images/buttons/audioOff.png")}
var music_buttons = {true: preload("res://assets/images/buttons/musicOn.png"),
					false: preload("res://assets/images/buttons/musicOff.png")}
					
var current_screen = null

func _ready():
	register_buttons()
	change_screen($TitleScreen)
	
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
		match button.name:
			"Ads":
				if settings.enable_ads:
					button.text = "Disable Ads"
				else:
					button.text = "Enable Ads"
			"Sound":
				button.texture_normal = sound_buttons[settings.enable_sound]
			"Music":
				button.texture_normal = music_buttons[settings.enable_music]

func _on_button_pressed(button):
	if settings.enable_sound:
		$Click.play()
	match button.name:
		"About":
			change_screen($AboutScreen)
		"Ads":
			settings.enable_ads = !settings.enable_ads
			if settings.enable_ads:
				button.text = "Disable Ads"
			else:
				button.text = "Enable Ads"
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("start_game")
		"Settings":
			change_screen($SettingsScreen)
		"Sound":
			settings.enable_sound = !settings.enable_sound
			button.texture_normal = sound_buttons[settings.enable_sound]
			settings.save_settings()
		"Music":
			settings.enable_music = !settings.enable_music
			button.texture_normal = music_buttons[settings.enable_music]
			settings.save_settings()

func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")

func game_over(score, highscore):
	var score_box = $GameOverScreen/MarginContainer/VBoxContainer/Scores
	score_box.get_node("Score").text = "Score: %s" % score
	score_box.get_node("Best").text = "Best: %s" % highscore
	change_screen($GameOverScreen)
	
	
	
