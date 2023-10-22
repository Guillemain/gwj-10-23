extends Node2D

@onready var anim : AnimatedSprite2D = $Renderer/KeyFrames/Anim
@export var state : PlayerState
@export var looker : Node2D

@export var angle_max := PI/3
@export var angle_min := -PI/3
var defined_scale = 1.0
var _toogle_harvest := false

func set_keyframe_mode(value:bool):

	reset_particule()
	for child in $Renderer/KeyFrames.get_children():
		child.visible = false
	$Renderer/KeyFrames/Anim.visible = not(value)
#	$Renderer/KeyFrames.visible = value
#	$Renderer/Puppet.visible = not(value)

func reset_particule():
	for child in $FX.get_children():
		child.visible = false

#### Anim func ###

func play_idle():
	set_keyframe_mode(false)
	anim.play("default")

func play_run():
	set_keyframe_mode(false)
	anim.play("run")

func play_harvest():
	set_keyframe_mode(true)
	_toogle_harvest = not(_toogle_harvest)
	if(_toogle_harvest):
		$Renderer/KeyFrames/HarvestA.visible = true
	else:
		$Renderer/KeyFrames/HarvestB.visible = true

func play_gotveg():
	print("got veg")
	set_keyframe_mode(false)
	anim.play("win")
	
func play_spell():
	set_keyframe_mode(false)
#	$Renderer/KeyFrames/Spell.visible = true
	#anim.play("spell")

func play_impulse():
	$Renderer.scale = Vector2(defined_scale*1.5,defined_scale*0.5)
	var tween = get_tree().create_tween()
	tween.tween_property($Renderer, "scale", Vector2.ONE * defined_scale, 0.5).set_trans(Tween.TRANS_ELASTIC)
# Called when the node enters the scene tree for the first time.
func _ready():
	if(state):
		state.start_idle.connect(play_idle)
		state.start_moving.connect(play_run)
		state.start_spells.connect(play_spell)
		state.start_harvest.connect(play_harvest)
		state.start_gotveg.connect(play_gotveg)
	$"..".receive_impulse.connect(play_impulse)
	defined_scale = $Renderer.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if not(looker == null):
		var angle = looker.rotation
		
#		
		if(cos(angle)<-0.001):
			angle = angle - PI
			scale.x = -1
		else : 
			scale.x = 1.0 
		angle = fmod(angle,PI+PI)
		if(angle<0):
			angle = angle + PI + PI
		if(angle<0):
			print("NTM")
		angle = fmod(angle+PI,PI+PI)
		
#		if(angle<PI):
#			angle = clampf(angle,PI/1.5,PI/2+PI/1.5)
#		else:
#			angle = clampf(angle,PI/1.5+PI,PI/2+PI/1.5+PI)
#		print(angle-PI)
		rotation =  clampf((angle-PI)*0.5,-PI/1.5,PI/1.5)#clampf(abs(angle),0.0001,0.78)*sign(angle+0.00001)
		
#		angle = fmod(angle,PI+PI)
#		if(angle<PI):
#			rotation = clampf(angle,0,angle_max)
#		else:
#			rotation = clampf(angle,PI+PI+angle_min,PI+PI)

