extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_following():
	$WinPanel/Win.play("loop")

func _on_round_manager_gamesucced():
	$HUD.visible = false
	$WinPanel.visible = true
	$WinPanel/Win.play("default")
	$WinPanel/Win.animation_finished.connect(play_following)
	


func _on_round_manager_gamelost():
	$HUD.visible = false
	$WinPanel.visible = false
	$LostPanel.visible = true

func gotoscn(scnname="res://scn/lvl/menu.tscn"):
	GlobalNode.gotoscn(scnname)

func _on_buttonreplay_pressed():
	get_tree().reload_current_scene()
#	print("replay")
#	GlobalNode.gotoscn("res://scn/lvl/menu.tscn")
