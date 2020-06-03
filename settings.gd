extends Node

var score_file = "user://highscore.save"
var settings_file = "user://settings.save"
var enable_sound = true
var enable_music = true

var circles_per_level = 5

var color_schemes = {
	"NEON1": {
		'background': Color8(50, 50, 70),
		'player_body': Color8(203, 255, 0),
		'player_trail': Color8(204, 0, 255),
		'circle_fill': Color8(255, 0, 110), 
		'circle_static': Color8(0, 255, 102),
		'circle_limited': Color8(204, 0, 255)
	},
	"NEON2": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(246, 255, 0),
		'player_trail': Color8(255, 255, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(151, 255, 48),
		'circle_limited': Color8(127, 0, 255)
	},
	"NEON3": {
		'background': Color8(76, 84, 95),
		'player_body': Color8(255, 0, 187),
		'player_trail': Color8(255, 148, 0),
		'circle_fill': Color8(255, 148, 0),
		'circle_static': Color8(170, 255, 0),
		'circle_limited': Color8(204, 0, 255)
	}
}

var theme = color_schemes["NEON1"]

static func rand_weighted(weights):
	var sum = 0
	for weight in weights:
		sum += weight
	var num = rand_range(0, sum)
	for i in weights.size():
		if num < weights[i]:
			return i
		num -= weights[i]
		
var admob = null
#var real_ads = false
#var banner_top = false
## Fill these from your AdMob account:
#var ad_banner_id = ""
#var ad_interstitial_id = ""
var enable_ads = true setget set_enable_ads
var interstitial_rate = 0.2
	
#func _ready():
#	load_settings()
#	if Engine.has_singleton("AdMob"):
#		admob = Engine.get_singleton("AdMob")
#		admob.initWithContentRating(real_ads, get_instance_id(), true, false, "G")
#		admob.loadBanner(ad_banner_id, banner_top)
#		admob.loadInterstitial(ad_interstitial_id)
		
#func show_ad_banner():
#	if admob and enable_ads:
#		admob.showBanner()
#
#func hide_ad_banner():
#	if admob:
#		admob.hideBanner()
#
#func show_ad_interstitial():
#	if admob and enable_ads:
#		if randf() < interstitial_rate:
#			admob.showInterstitial()
#		else:
#			show_ad_banner()
#
#func _on_interstitial_close():
#	if admob and enable_ads:
#		show_ad_banner()
		
func set_enable_ads(value):
	enable_ads = value
	if enable_ads:
		admob.show_banner()
	if !enable_ads:
		admob.hide_banner()
	save_settings()
		
func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_sound)
	f.store_var(enable_music)
	f.store_var(enable_ads)
	f.close()
	
func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		enable_sound = f.get_var()
		enable_music = f.get_var()
		self.enable_ads = f.get_var()
		f.close()
