extends Area2D

onready var orbit_position = $Pivot/OrbitPosition

enum MODES {STATIC, LIMITED}

var radius = 100
var rotation_speed = PI
var mode = MODES.STATIC
var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var jumper = null

func init(_position, _radius=radius, _mode=MODES.LIMITED):
	set_mode(_mode)
	position = _position
	radius = _radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)

func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			current_orbits = num_orbits
			$Label.text = str(current_orbits)
			$Label.show()
			
func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		update()

func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits -= 1
		$Label.text = str(current_orbits)
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = $Pivot.rotation
		
func implode():
	$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func capture(target):
	jumper = target
	$AnimationPlayer.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation
		
func _draw():
	if jumper:
		var r = ((radius - 10) / num_orbits) * (1 + num_orbits - current_orbits)
		draw_circle_arc_poly(Vector2.ZERO, r, orbit_start + PI/2,
							$Pivot.rotation + PI/2, Color(1, 0, 0))
												
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
	