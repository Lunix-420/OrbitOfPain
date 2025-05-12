extends CharacterBody2D

const MAX_SPEED = 300
const MAX_STRAVE_SPEED = 100
const ACCELERATION = 500.0
const STRAVE_ACCELERATION = 300.0
const ROTATION_SPEED = 10.0
const FRICTION = 1000

var speed = 0.00
var strave_speed = 0.00

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

	# Move Strave
	if Input.is_action_pressed("move_left"):
		strave_speed += STRAVE_ACCELERATION * delta;
	elif Input.is_action_pressed("move_right"):
		strave_speed -= STRAVE_ACCELERATION * delta;
	else:
		if strave_speed > 0:
			strave_speed = max(strave_speed - FRICTION * delta, 0)  # Gradually slow down
		elif strave_speed < 0:
			strave_speed = min(strave_speed + FRICTION * delta, 0)  # Prevent reversing direction too fast
	position += -transform.x * strave_speed * delta
	
	
	if Input.is_action_pressed("move_turn_ccw"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("move_turn_cw"):
		rotation += -ROTATION_SPEED * delta
	

	move_and_slide()
