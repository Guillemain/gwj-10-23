extends Area2D
class_name Spell
@export var force := 2500.0

func spell():
	for collider in get_overlapping_bodies():
		if(collider.has_method("add_impulse")):
			#var direction = Vector2(cos(get_parent().rotation),sin(get_parent().rotation))
			var direction := Vector2(cos(get_parent().rotation),sin(get_parent().rotation)) + ((collider.position - get_parent().get_parent().position) as Vector2).normalized()
#			collider.position = global_position
			direction = direction * 0.5
			collider.add_impulse(direction * force)
			
		else:
			print("no contact")
	var node_anm  := get_node("PushAnimA") as AnimatedSprite2D
	$PushAnimA/DeadLeaves.restart()
	if(node_anm != null):
		(node_anm.play("default"))
	else:
		print("pas normal")
