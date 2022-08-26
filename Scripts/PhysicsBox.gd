extends KinematicBody2D

var gravity = 30
var pushed = false

var velocity = Vector2.ZERO
var friction = 0.96

func _physics_process(_delta):
	if pushed:
		velocity.y += gravity 
		velocity.x *= friction
		velocity = move_and_slide(velocity)
