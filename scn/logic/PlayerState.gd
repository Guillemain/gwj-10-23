extends Node
class_name PlayerState

## Agent mandatory
@export var player : Player 
@export var inputhandler : InputHandler

# special gameplay
@export var taker : Harvest_Area
@export var human_team := true
## State param
@export var can_move = true
@export var can_spell = true
@export var cooldown_spell := 0.1
@export var spell_duration := 0.3
@export var cooldown_gotveg := 0.2
@export var backimpulse_spell := 100.0

# Behaviour
enum EState {IDLE, MOVE, SPELLS, HARVEST, GOTVEG}
var current_state = EState.IDLE
# params

@export var speed = 200.0
@export var speedfactor := {
	EState.IDLE : 0.0,
	EState.MOVE : 1.0,
	EState.SPELLS : 0.0,
	EState.HARVEST : 0.0,
	EState.GOTVEG : 0.0
}
## State to few to make a real state machine

signal start_moving
signal stop_moving

signal start_spells
signal stop_spells

signal start_harvest
signal stop_harvest

signal start_idle
signal stop_idle

signal start_gotveg
signal stop_gotveg

# func
func move(desired_dir : Vector2):
	if(current_state == EState.IDLE) and (desired_dir.length_squared() > 0.1):
		current_state = EState.MOVE
		stop_idle.emit()
		start_moving.emit()
		
	player.set_target_velocity(desired_dir.normalized() * speed * speedfactor[current_state])
	
func start_move():
	if(current_state == EState.HARVEST):
		await get_tree().physics_frame
		await get_tree().physics_frame
		
		current_state = EState.MOVE
		stop_harvest.emit()
		start_moving.emit()
		
func set_move():
	player.set_target_velocity(Vector2.ZERO)
	if(current_state == EState.MOVE):
		current_state = EState.IDLE
		start_idle.emit()
		stop_moving.emit()

func reset_spell():
	can_spell = true

func end_spelling():
	current_state = EState.IDLE
	get_tree().create_timer(cooldown_spell).timeout.connect(reset_spell)
	stop_spells.emit()
	start_idle.emit()
	stop_moving.emit()
	
func end_gotveg():
	current_state = EState.IDLE
	stop_gotveg.emit()
	start_idle.emit()
	stop_moving.emit()
	
func end_harvest():
	current_state = EState.IDLE
	stop_harvest.emit()
	start_idle.emit()
	stop_moving.emit()

func do_action():
#	print(current_state)
	if (current_state == EState.HARVEST) :
		if(taker.taking != null):
			var result = taker.taking.take()
			start_harvest.emit()
			if(result):
				$"../HaverstEffect".play_harvest(taker.taking.vegsprite)
				taker.taking.queue_free()
				taker.taking = null
				current_state = EState.GOTVEG
				stop_harvest.emit()
				stop_moving.emit()
				start_gotveg.emit()
				
				get_tree().create_timer(cooldown_gotveg).timeout.connect(end_gotveg)
		else: 
			print("Error the thing disapear")
			taker.taking = null
			current_state = EState.IDLE
			start_idle.emit()
			stop_moving.emit()
			
	elif(can_spell) and (current_state != EState.GOTVEG):
		can_spell=false
		current_state = EState.SPELLS
		start_spells.emit()
		stop_moving.emit()
		var direction_knockback = $"../LookAt".rotation
#		$"..".add_impulse(Vector2(cos(direction_knockback),sin(direction_knockback))*-1*backimpulse_spell,false)
		get_tree().create_timer(spell_duration).timeout.connect(end_spelling)
		get_tree().get_first_node_in_group("camera").make_screen_shake()
		
func snap_to(pos : Vector2):
	
	if(current_state == EState.IDLE):
		player.position = pos
	if (taker != null) and (taker.taking != null):
		current_state = EState.HARVEST
		start_harvest.emit()
		stop_moving.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	inputhandler.moveRequested.connect(move)
	inputhandler.moveEnded.connect(set_move)
	inputhandler.moveStarted.connect(start_move)
	inputhandler.actionRequested.connect(do_action)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_harvest_area_havest_lost():
	if (current_state == EState.HARVEST) :
		end_harvest()
