extends Node
class_name RoundManager
signal endround

signal harvested
signal failed

signal gamelost
signal gamesucced


@export var n_allow_failed := 3

var current_error := 0
var remaining_veg := -1
var harvested_veg := 0
var total_veg := 0

func harvest_veg():
	remaining_veg -= 1
	if(remaining_veg<=0):
		print("end of the game")
		if(current_error<n_allow_failed):
			emit_signal("gamesucced")
		
		
func harvest_human():
	harvested_veg += 1
	harvested.emit()
	update_text()
	
func lost():
	current_error += 1 
	failed.emit()
	if(current_error>=n_allow_failed):
		print("gameover")
		emit_signal("gamelost")
	update_text()
	
func update_text():
	($"../UI/HUD/havested" as Label).text = "Havested: "+str(harvested_veg)+"/"+str(total_veg-current_error)
	$"../UI/HUD/Lost".text = "Lost: "+str(current_error)+"/"+str(n_allow_failed)
	if(current_error>=2):
		$"../UI/HUD/Lost".add_theme_color_override("font_color",Color.FIREBRICK)
# Called when the node enters the scene tree for the first time.

func _ready():
	remaining_veg = len(get_tree().get_nodes_in_group("veg"))
	total_veg = remaining_veg
	update_text()
	for veg in get_tree().get_nodes_in_group("veg"):
		veg.tree_exiting.connect(harvest_veg)
	for human in get_tree().get_nodes_in_group("human"):
		var playe_state : PlayerState = (human).get_node("PlayerState")
		playe_state.start_gotveg.connect($"../FX_manager".havest_human)
		playe_state.start_gotveg.connect(harvest_human)
	for ia in get_tree().get_nodes_in_group("cpu"):
		var playe_state : PlayerState = (ia).get_node("PlayerState")
		playe_state.start_gotveg.connect($"../FX_manager".harvest_IA)
		playe_state.start_gotveg.connect(lost)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
