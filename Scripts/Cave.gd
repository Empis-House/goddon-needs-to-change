extends Area2D

var direction = -1
var push_speed = 30

func _on_Cave_body_entered(body: KinematicBody2D)-> void:
	if body and body.is_in_group("monster"):
		if int(get_tree().current_scene.name) < 9:
			get_tree().change_scene("res://Scenes/Level_"+str(int(get_tree().current_scene.name)+1)+".tscn")
		else:
			get_tree().change_scene("res://Scenes/EndMenu.tscn")
	elif body and body.is_in_group("block"):
		print("block entered")
		body.pushed = false
		body.remove_from_group("block")
