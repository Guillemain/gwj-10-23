extends Node
class_name InputHandler
## InputHandler
##
## This script handle player input and convert them to signals.
## Those inputs can also be spoofed by calling appropriate functions


# are we charging right now
# moving caculation
var isMoving : bool = false

## === Multiplayer handling
enum ECurrentInputProvider {PLAYER1, PLAYER2, BOTH, SPOOF_ONLY}
## Listen to this player input 
@export var inputProvider : ECurrentInputProvider = ECurrentInputProvider.PLAYER1

@export var disableStandardInput : bool = false :
	set(value):
		disableStandardInput = value
		if disableStandardInput:
			# Reset charging var
			moveEnded.emit()
			isMoving = false
# === Inputs Signals
## Emitted when a axtion is requested
signal actionRequested()
## Emitted when a move is requested
signal moveRequested(dir : Vector2)
signal iscurrentlyMoving()
## Emitted when a move started
signal moveStarted()
signal moveEnded()

func _ready():
	if(inputProvider == ECurrentInputProvider.SPOOF_ONLY):
		disableInput(true)

## Check all inputs to send appropriate signals
func _process(_delta):
	if disableStandardInput:
		return
	## check guard
	if Input.is_action_just_pressed(getAction("action")):
		actionRequested.emit()
	
	
	## check move
	var moveVector := Vector2(Input.get_axis(getAction("left"), getAction("right")),
	 Input.get_axis(getAction("up"), getAction("down")))
	if (moveVector != Vector2.ZERO):
		moveRequested.emit(moveVector.normalized())
		iscurrentlyMoving.emit()
		if not isMoving:
			moveStarted.emit()
			isMoving = true
	elif isMoving:
		moveEnded.emit()
		isMoving = false


## Function used to spoof a input signal
func spoofInput(inputName : String, value):
	match inputName:
		"move":
			moveRequested.emit(value)
		"setMove":
			if value:
				moveStarted.emit()
			else:
				moveEnded.emit()
		"action":
			actionRequested.emit()


## Map given action for each player and return the new action string
func getAction(actionName : String):
	match inputProvider:
		ECurrentInputProvider.BOTH:
			return actionName
		ECurrentInputProvider.PLAYER1:
			return "p1_" + actionName
		ECurrentInputProvider.PLAYER2:
			return "p2_" + actionName
		ECurrentInputProvider.SPOOF_ONLY:
			return "no_action"


func disableInput(status : bool):
	disableStandardInput = status
