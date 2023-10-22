extends Polygon2D

class_name  FakeFixPoly

@export var frame_rate = 10 # in frame per frame :) 

@export var img_a : Texture2D

@export var img_b : Texture2D

@export var img_c : Texture2D

var _currentframe := 0
var _current_img = 0
var frames
# Called when the node enters the scene tree for the first time.
func _ready():
	frames = [img_a,img_b,img_c]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_currentframe += 1 
	if not(_currentframe % frame_rate):
		_current_img = (_current_img+1) % 3
		texture = frames[_current_img]
