extends Camera2D

var t := 0.0
@export var powerness := 2.0
var is_shaking := false
# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_viewport_rect().size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t -= delta
	position = Vector2.ZERO
	if (t>0.0):
		position = Vector2(randf(),randf())*powerness
	
#	t += delta
#	position = Vector2(cos(t*0.1)+sin(t*0.5),cos(t*0.3)+sin(t*0.2+0.2))*10.0

func make_screen_shake(duration := 0.1):
	t = duration


