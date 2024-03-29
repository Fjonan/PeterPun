extends CharacterBody2D
class_name Enemy 

var splatter = preload("res://scenes/effects/splatter.tscn")

@export var speed = 5
@export var health = 2

@onready var player = get_node("/root/Main/Player/CharacterBody2D")

const BLOOD_PARTICLES = preload("res://scenes/effects/blood_particles.tscn")

var state = "moving"

var _position_last_frame := Vector2()
var _cardinal_direction = null

var player_position
var target_position
var motion = Vector2(0,0)

func _ready() -> void:
	GlobalSignals.connect("difficulty_increased", Callable(self, "handle_difficulty_increased"))
	
func _physics_process(delta: float) -> void:
	motion = position.direction_to(player.position) * speed
	set_velocity(motion)
	move_and_slide()
	play_animation(_getMovementDirection())

func _getMovementDirection() -> int:
	var _dir = 0
	var motion = position - _position_last_frame
	if motion.length() > 0.0001:
		_dir = int(4.0 * (motion.rotated(PI / 4.0).angle() + PI) / TAU)
	_position_last_frame = position
	return _dir
	
func play_animation(dir): 
	if state == "idle":
		$AnimatedSprite2D.play("idle")
		
	if state == "moving":
		if dir == 2: #east
			$AnimatedSprite2D.play("right")
		if dir == 0: #west
			$AnimatedSprite2D.play("left")
		if dir == 1: #north
			$AnimatedSprite2D.play("idle")
		if dir == 3: #south
			$AnimatedSprite2D.play("idle")

func handle_hit(amount: int):
	health -= amount
	Input.start_joy_vibration(0,1,1,0.1)
	spawn_particles()
	
	if (health == 0): die(true)

func die(local: bool = false):
	if (!local): spawn_particles()
	GlobalSignals.emit_signal("killed")
	spawn_splatter()
	queue_free()

#TODO: Create impact manager for this if time
func spawn_particles(): 
	var particles = BLOOD_PARTICLES.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.start_emitting()

func set_difficulty(difficulty: int):
	handle_difficulty_increased(difficulty)

func handle_difficulty_increased(new_difficulty: int):
	var new_speed = speed + new_difficulty
	speed = clamp(new_speed, speed, 300)


func spawn_splatter():
	var splatter_instance = splatter.instantiate()
	splatter_instance.global_position = self.global_position
	get_parent().add_child(splatter_instance)

################### 
# OLD PROMT STUFF #
###################

#func init_prompt() -> void:
#	prompt_text = PromptList.get_prompt()
#	prompt.parse_bbcode(set_center_tags(prompt_text))

#func get_prompt() -> String:
#	return prompt_text

#func set_next_character(next_character_index: int):
#	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
#	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
#	var red_text = ""

#	if next_character_index != prompt_text.length():
#		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()

#	prompt.parse_bbcode(set_center_tags(blue_text + green_text + red_text))

#func set_center_tags(string_to_center: String):
#	return "[center]" + string_to_center + "[/center]"

#func get_bbcode_color_tag(color: Color) -> String:
#	return "[color=#" + color.to_html(false) + "]"

#func get_bbcode_end_color_tag() -> String:
#	return "[/color]"
