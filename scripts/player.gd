extends CharacterBody2D

const MAX_SPEED = 500
const MAX_STRAVE_SPEED = 250
const ACCELERATION = 2000.0
const STRAVE_ACCELERATION = 1000.0
const ROTATION_SPEED = 10.0
const FRICTION = 500

var speed = 0.0
var strave_speed = 0.0

func _physics_process(delta: float) -> void:
	handle_forward_backward_motion(delta)
	handle_sideward_motion(delta)
	handle_rotation(delta)
	handle_shooting(delta)
	move_and_slide()


func handle_forward_backward_motion(delta: float) -> void:
	if Input.is_action_pressed("move_forward") and not Input.is_action_pressed("move_backwards"):
		speed += ACCELERATION * delta
		speed = min(speed, MAX_SPEED)
		$ExhaustBackLeft.emitting = true
		$ExhaustBackRight.emitting = true
		$ExhaustFront.emitting = false
	elif Input.is_action_pressed("move_backwards") and not Input.is_action_pressed("move_forward"):
		$ExhaustBackLeft.emitting = false
		$ExhaustBackRight.emitting = false
		$ExhaustFront.emitting = true
		if speed > 0:
			speed = max(speed - ACCELERATION * delta, 0)
		else:
			speed -= ACCELERATION * delta
			speed = max(speed, -MAX_SPEED / 2.0)
		speed = min(speed + FRICTION * delta, 0) if speed < 0 else speed
	else:
		$ExhaustBackLeft.emitting = false
		$ExhaustBackRight.emitting = false
		$ExhaustFront.emitting = false
		if speed > 0:
			speed = max(speed - FRICTION * delta, 0)
		elif speed < 0:
			speed = min(speed + FRICTION * delta, 0)
	position += -transform.y * speed * delta


func handle_sideward_motion(delta: float) -> void:
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		strave_speed += STRAVE_ACCELERATION * delta
		strave_speed = min(strave_speed, MAX_STRAVE_SPEED)
		$ExhaustSideRight.emitting = true
		$ExhaustSideLeft.emitting = false
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		strave_speed -= STRAVE_ACCELERATION * delta
		strave_speed = max(strave_speed, -MAX_STRAVE_SPEED)
		$ExhaustSideRight.emitting = false
		$ExhaustSideLeft.emitting = true
	else:
		$ExhaustSideLeft.emitting = false
		$ExhaustSideRight.emitting = false
		if strave_speed > 0:
			strave_speed = max(strave_speed - FRICTION * delta, 0)
		elif strave_speed < 0:
			strave_speed = min(strave_speed + FRICTION * delta, 0)
	position += -transform.x * strave_speed * delta


func handle_rotation(delta: float) -> void:
	if Input.is_action_pressed("move_turn_ccw"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("move_turn_cw"):
		rotation -= ROTATION_SPEED * delta

func handle_shooting(delta: float) -> void:
	if Input.is_action_just_pressed("action_shoot"):
		var shooter = get_node("Shooter")
		var plasma = preload("res://scenes/Plasma.tscn").instantiate()
		plasma.rotation = rotation
		plasma.position = shooter.global_position
		plasma.set("init_speed", speed)
		get_tree().current_scene.add_child(plasma)
