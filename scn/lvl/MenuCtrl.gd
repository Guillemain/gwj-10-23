extends Control

func gotoscn(scnname="res://scn/lvl/menu.tscn"):
	GlobalNode.gotoscn(scnname)

func _on_buttonreplay_pressed():
	get_tree().reload_current_scene()


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(1,-((100-value)/100)* 80)


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(2,-((100-value)/100)* 80)
