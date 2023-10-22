extends CharacterBody2D
class_name Player


signal receive_impulse
@export var should_look := true

var velocity_target : Vector2
var old_velocity_target := Vector2.ZERO
var impulse_vector := Vector2.ZERO
var canmove := true

func add_impulse(impusle : Vector2,emits=true):
	impulse_vector = impusle 
	var tween = get_tree().create_tween()
	tween.tween_property(self,"impulse_vector",Vector2.ZERO,0.4).set_ease(Tween.EASE_OUT)
	if(emits):
		receive_impulse.emit()
	
func set_target_velocity(vel : Vector2):
	velocity_target = vel

func _physics_process(delta):
	## TODO process for acc 
	if(velocity.length_squared()<velocity_target.length_squared()):
		old_velocity_target = old_velocity_target.lerp(velocity_target,delta*20)
	else:
		old_velocity_target = old_velocity_target.lerp(velocity_target,delta*40)
	velocity = old_velocity_target + impulse_vector
	move_and_slide()
	if(should_look):
		
		$LookAt.look_at(position+old_velocity_target)


## Auto created? WTF ???
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()
