extends CharacterBody2D

const MAX_SPEED = 1000
const MAX_STRAVE_SPEED = 100
const ACCELERATION = 2000.0
const STRAVE_ACCELERATION = 1000.0
const ROTATION_SPEED = 10.0
const FRICTION = 500

var speed = 0.00
var strave_speed = 0.00

func _physics_process(delta: float) -> void:
	# Move prograde/retrograde
	if Input.is_action_pressed("move_forward") && !Input.is_action_pressed("move_backwards"):
		speed += ACCELERATION * delta;
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		$ExhaustBackLeft.emitting = true
		$ExhaustBackRight.emitting = true
		$ExhaustFront.emitting = false
	elif Input.is_action_pressed("move_backwards") && !Input.is_action_pressed("move_forward"):
		$ExhaustBackLeft.emitting = false
		$ExhaustBackRight.emitting = false
		$ExhaustFront.emitting = true
		if speed > 0:
			speed -= ACCELERATION * delta;
			speed = max(speed - FRICTION * delta, 0)
		else:
			speed -= ACCELERATION * delta;
			if speed < -MAX_SPEED/2.0:
				speed = -MAX_SPEED/2.0
			speed = min(speed + FRICTION * delta, 0)
	else:
		$ExhaustBackLeft.emitting = false
		$ExhaustBackRight.emitting = false
		$ExhaustFront.emitting = false
		if speed > 0:
			speed = max(speed - FRICTION * delta, 0)  # Gradually slow down
		elif speed < 0:
			speed = min(speed + FRICTION * delta, 0)  # Prevent reversing direction too fast
	position += -transform.y * speed * delta

	# Move Strave
	if Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		strave_speed += STRAVE_ACCELERATION * delta;
		$ExhaustSideRight.emitting = true;
		$ExhaustSideLeft.emitting = false;
	elif Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
		strave_speed -= STRAVE_ACCELERATION * delta;
		$ExhaustSideRight.emitting = false;
		$ExhaustSideLeft.emitting = true;
	else:
		$ExhaustSideLeft.emitting = false;
		$ExhaustSideRight.emitting = false;
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
