extends CharacterBody2D

@export var speed = 200
@export var friction = 0.5
@export var acceleration = 0.25

var player_state = "idle"

func _physics_process(delta):
	var direction = get_input()
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		player_state = "moving"
	else:
		player_state = "idle"
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	move_and_slide()
	play_animation(direction)
	
func play_animation(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
		
	if player_state == "moving":
		if dir.x == 1:
			$AnimatedSprite2D.play("e_walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("w_walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("s_walk")
		if dir.y == -1:
			$AnimatedSprite2D.play("n_walk")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
		input.x += 1
	if Input.is_action_pressed('ui_left'):
		input.x -= 1
	if Input.is_action_pressed('ui_down'):
		input.y += 1
	if Input.is_action_pressed('ui_up'):
		input.y -= 1
	return input
			
func player():
	pass

