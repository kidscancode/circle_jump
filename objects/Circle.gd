extends Area2D

onready var orbit_position = $Pivot/OrbitPosition

var radius = 100
var rotation_speed = PI

func _ready():
	init()
	
func init(_radius=radius):
	radius = _radius
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	
func _process(delta):
	$Pivot.rotation += rotation_speed * delta