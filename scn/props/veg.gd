extends Area2D
class_name veg
enum vegtype {carotte,radis,champi,champi_bis,oignon}

@export var busy = false 
@export var action_requiered = 5

@export var vegsprite : vegtype = vegtype.carotte


@onready var spritedic = {
	vegtype.carotte : $render/carotte,
	vegtype.radis : $render/radis,
	vegtype.oignon : $render/oignon,
	vegtype.champi : $render/champi,
	vegtype.champi_bis : $render/champi_bis
}

# Called when the node enters the scene tree for the first time.
func _ready():
	spritedic[vegsprite].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take():
	action_requiered -= 1
	if action_requiered > 0:
		spritedic[vegsprite].position.y -= 5
		return false
	else :
		return true

