extends Node2D


func havest_human():
	$"../UI/HUD/Node2D/AnimationPlayer".play("fever")
	
func harvest_IA():
	$"../UI/HUD/Node2D/AnimationPlayer".play("lost")


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../UI/HUD/Node2D/AnimationPlayer".play("fever")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
