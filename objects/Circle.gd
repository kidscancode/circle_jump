extends Area2D

signal full_orbit

onready var orbit_position = $Pivot/OrbitPosition
onready var move_tween = $MoveTween

enum MODES {STATIC, LIMITED}

var radius = 120
var rotation_speed = 4
var mode = MODES.STATIC
var move_range = 0
var move_speed = 2.0
var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var jumper = null

func init(_position, level=1):
	var _mode = settings.rand_weighted([10, level-1])
	set_mode(_mode)
	position = _position
	var move_chance = clamp(level-10, 0, 9) / 10.0
	if randf() < move_chance:
		move_range = max(25, 100 * rand_range(0.75, 1.25) * move_chance) * pow(-1, randi() % 2)
		move_speed = max(2.5 - ceil(level/5) * 0.25, 0.75)
	var small_chance = min(0.9, max(0, (level-10) / 20.0))
	if randf() < small_chance:
		radius = max(50, radius - level * rand_range(0.75, 1.25))
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material = $Sprite.material
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius - 25
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius
	rotation_speed *= pow(-1, randi() % 2)
	set_tween()

func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
			color = settings.theme["circle_static"]
		MODES.LIMITED:
			$Label.text = str(num_orbits)
			$Label.show()
			color = settings.theme["circle_limited"]
	$Sprite.material.set_shader_param("color", color)
			
func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if jumper:
		check_orbits()
		update()

func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits += 1
		emit_signal("full_orbit")
		if mode == MODES.LIMITED:
			if settings.enable_sound:
				$Beep.play()
			$Label.text = str(num_orbits - current_orbits)
			if current_orbits >= num_orbits:
				jumper.die()
				jumper = null
				implode()
		orbit_start = $Pivot.rotation
		
func implode():
	jumper = null
	$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func capture(target):
	current_orbits = 0
	jumper = target
	$AnimationPlayer.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation
		
func _draw():
	if mode != MODES.LIMITED:
		return
	if jumper:
		var r = ((radius * 0.5) / num_orbits) * (1 + current_orbits)
		draw_circle_arc_poly(Vector2.ZERO, r, orbit_start + PI/2,
							$Pivot.rotation + PI/2, settings.theme["circle_fill"])
												
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func set_tween(object=null, key=null):
	if move_range == 0:
		return
	move_range *= -1
	move_tween.interpolate_property(self, "position:x",
				position.x, position.x + move_range,
				move_speed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()

