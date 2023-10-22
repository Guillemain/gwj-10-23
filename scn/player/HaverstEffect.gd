extends Node2D



const carotte = preload("res://scn/props/veg_sprite/carotte.tscn")
const champi = preload("res://scn/props/veg_sprite/champi.tscn")
const champibis = preload("res://scn/props/veg_sprite/champibis.tscn")
const radis = preload("res://scn/props/veg_sprite/radis.tscn")
const oignon = preload("res://scn/props/veg_sprite/oignon.tscn")

@export var is_human := false

@onready var spritedic = {
	veg.vegtype.carotte : carotte,
	veg.vegtype.radis : radis,
	veg.vegtype.oignon : oignon,
	veg.vegtype.champi : champi,
	veg.vegtype.champi_bis : champibis
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_harvest(typesprite):
	var nodeeffect : Node2D = (spritedic[typesprite].instantiate())
	get_parent().get_parent().add_child(nodeeffect)
	nodeeffect.global_position = global_position
	var tween = create_tween()
	if(is_human):
		tween.tween_property(nodeeffect,"global_position",Vector2(600,0),0.3).finished.connect(nodeeffect.queue_free)
	else:
		tween.tween_property(nodeeffect,"global_position",Vector2(600,600),0.3).finished.connect(nodeeffect.queue_free)
