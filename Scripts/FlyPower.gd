 extends Area2D

onready var globalVars = get_node("/root/GlobalVars")

var selected = false

func _on_FlyPower_body_entered(body: KinematicBody2D) -> void:
	if body and body.is_in_group("monster") and !selected:
		body.power = 2
		queue_free()
		
func _process(_delta):
	if selected and !globalVars.start:
		followMouse()
	if globalVars.reset:
		queue_free()

func followMouse():
	position = get_global_mouse_position()


func _on_FlyPower_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			selected = true
		else:
			selected = false
