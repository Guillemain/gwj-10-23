extends Area2D
class_name  Harvest_Area

var taking : Node2D 

# Signal emited when close to a Object of Intention
signal close_to(pos : Vector2) #

signal havest_lost

func reset_search():
	if (len(get_overlapping_areas())>0):
		var first_area = get_overlapping_areas()[0]
		if (first_area.has_method("take")):
			taking = first_area
		close_to.emit(first_area.position)
	else:
		taking = null

func rechek_takeing():
	if (has_overlapping_areas()):
		for val in get_overlapping_areas():
			if val == taking:
				return true
		return false
	else :
		return false

func _on_area_exited(area):
	if not(rechek_takeing()):
		havest_lost.emit()
