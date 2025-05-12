extends CharacterBody2D

const MAX_SPEED = 300
const ACCELERATION = 500.0
const ROTATION_SPEED = 5.0
const FRICTION = 1000

var speed = 0.00

func _physics_process(delta: float) -> void:
	# Move prograde/retrograde
	if Input.is_action_pressed("move_forward"):
		speed += ACCELERATION * delta;
	elif Input.is_action_pressed("move_backwards"):
		if speed > 0:
			speed -= ACCELERATION * delta * 2;
		else:
			speed -= ACCELERATION * delta;
	else:
		if speed > 0:
			speed = max(speed - FRICTION * delta, 0)  # Gradually slow down
		elif speed < 0:
			speed = min(speed + FRICTION * delta, 0)  # Prevent reversing direction too fast
	position += -transform.y * speed * delta

	
	if Input.is_action_pressed("move_left"):
		position += -transform.x * MAX_SPEED * delta
	if Input.is_action_pressed("move_right"):
		position += transform.x * MAX_SPEED * delta
	if Input.is_action_pressed("move_turn_ccw"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("move_turn_cw"):
		rotation += -ROTATION_SPEED * delta
	

	move_and_slide()
