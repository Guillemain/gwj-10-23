extends Node

var target : Node2D

@onready var inputhandler : InputHandler = $"../InputHandler"
@onready var state : PlayerState =  $"../PlayerState"

var _is_busy := false
var ctne := false
var human : Node2D
func is_moving():
	return (state.current_state == PlayerState.EState.MOVE)

func is_idling():
	return (state.current_state == PlayerState.EState.IDLE)

# Called when the node enters the scene tree for the first time.
func _ready():
	human = get_tree().get_first_node_in_group("human")
#	state.stop_gotveg.connect(thinking)
	state.start_harvest.connect(takeThing)
	state.stop_harvest.connect(thinking)
	state.stop_gotveg.connect(thinking)
	get_neighbour()
	thinking()
	
func get_neighbour():
	var veg := get_tree().get_nodes_in_group("player")
	if (len(veg)<=1):
		return []
	var selfidx = 0
	var idx = 0
	for val in veg:
		if get_parent() == val:
			selfidx = idx
		idx += 1
	veg.remove_at(selfidx)
	return veg


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var veg := get_tree().get_nodes_in_group("veg")
#	if (len(veg)>0):
#		target = veg[0]

func move_to_target():
	if(_is_busy):
		return
	_is_busy = true
	ctne = true
	if ((state.current_state == PlayerState.EState.HARVEST) or (state.current_state == PlayerState.EState.GOTVEG)):
		return
	while (target != null) and ctne and (is_idling() or is_moving()):
		var tangancial = (human.position-get_parent().position as Vector2).normalized().orthogonal()*0.2
		
		inputhandler.spoofInput("move",(target.position - get_parent().position).normalized()+tangancial)
		inputhandler.spoofInput("setMove",true)
		ctne = ((target.position - get_parent().position) as Vector2).length_squared() > 90
		if (get_tree() == null):
			return
		await get_tree().physics_frame
	inputhandler.spoofInput("move",Vector2.ZERO)
	inputhandler.spoofInput("setMove",false)
	_is_busy = false

func takeThing():
	await get_tree().create_timer(0.65).timeout
	if (state.current_state == PlayerState.EState.HARVEST):
		inputhandler.spoofInput("action",null)
		
func thinking():
	if (get_tree() == null):
		return
	await get_tree().physics_frame
	if (get_tree() == null):
		return
	await get_tree().physics_frame
	# choose target :
	var veg := get_tree().get_nodes_in_group("veg")

	var playerl = get_neighbour()
	
	if (len(veg)>0):
		var best_score := 10000000000.0
		for v in veg:
			var score = (get_parent().position - v.position).length()
			for p in playerl:
				score -= (playerl[0].position - v.position).length()*2.0
			score -= (human.position - v.position).length()*0.2
			if (score < best_score):
				target = v
				best_score = score
	if(target != null) and is_idling():
		move_to_target()
#
#	if(state.current_state == PlayerState.EState.HARVEST):
#		takeThing()


func _on_thinktic_timeout():
	ctne = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	if not(_is_busy):
		thinking()
