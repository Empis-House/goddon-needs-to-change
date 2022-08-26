extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var globalVars = get_node("/root/GlobalVars")

var speed = 50
var gravity = 15
var motion = Vector2()

var power = 0    # 0=nothing, 1=strenght, 2=fly, 3=spikes


export var push_speed = 25

var direction = 1 #1 = right, -1 = left

func _physics_process(_delta):
	motion.y += gravity
	
	
	if power == 2:
		animatedSprite.animation = "fly"
		motion.y = 0
		if $RayCast2D_Up.is_colliding():
			var box = $RayCast2D_Up.get_collider()
			if box and (box.is_in_group("map") or box.is_in_group("block")):
				$RayCast2D_Up.scale.y *= -1
				$RayCast2D_Up.position.x *= -1
				animatedSprite.scale.x *= -1
				direction *= -1
	
	elif power == 1:
		if $RayCast2D_Up.is_colliding():
			var box = $RayCast2D_Up.get_collider()
			if box and box.is_in_group("block"):
				box.pushed = true
				box.velocity.x = direction * push_speed
			elif box and box.is_in_group("map"):
				$RayCast2D_Up.scale.y *= -1
				$RayCast2D_Up.position.x *= -1
				animatedSprite.scale.x *= -1
				direction *= -1
		else:
			animatedSprite.animation = "strengthWalk"
	elif power == 3:
		animatedSprite.animation = "spikes"
		if $RayCast2D_Up.is_colliding():
			var box = $RayCast2D_Up.get_collider()
			if box and box.is_in_group("block"):
				box.queue_free()
			elif box and box.is_in_group("map"):
				$RayCast2D_Up.scale.y *= -1
				$RayCast2D_Up.position.x *= -1
				animatedSprite.scale.x *= -1
				direction *= -1
		elif $RayCast2D_Down.is_colliding():
			var box = $RayCast2D_Down.get_collider()
			if box and box.is_in_group("block"):
				box.queue_free()
		else:
			animatedSprite.animation = "spikes"
	elif power == 0:
		if motion.x != 0:
			animatedSprite.animation = "walk"
		else:
			animatedSprite.animation = "default"
		if $RayCast2D_Up.is_colliding():
			var box = $RayCast2D_Up.get_collider()
			if box and (box.is_in_group("map") or box.is_in_group("block")):
				$RayCast2D_Up.scale.y *= -1
				$RayCast2D_Up.position.x *= -1
				animatedSprite.scale.x *= -1
				direction *= -1
	if globalVars.start:
		motion.x = speed * direction
		
	

	motion = move_and_slide(motion)
