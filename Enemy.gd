extends KinematicBody2D

export var speed:float = 100.0
export var acceleration:float = 100.0
export var gravity:float = 10


var direction:Vector2 = Vector2.RIGHT
var velocity = Vector2.ZERO

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 0
	
	velocity = velocity.move_toward(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector2.UP)
