extends CharacterBody2D


@export var blue = Color("#4682b4")
@export var green = Color("#639765")
@export var red = Color("#a65455")

@export var speed = 0.5


@onready var prompt = $RichTextLabel
@onready var prompt_text = prompt.text

var state = "moving"

var _position_last_frame := Vector2()
var _cardinal_direction = null

func _ready() -> void:
	init_prompt()
	GlobalSignals.connect("difficulty_increased", Callable(self, "handle_difficulty_increased"))

func _physics_process(delta: float) -> void:
	global_position.x -= speed
	var motion = position - _position_last_frame
	if motion.length() > 0.0001:
		_cardinal_direction = int(4.0 * (motion.rotated(PI / 4.0).angle() + PI) / TAU)
	play_animation(_cardinal_direction)
	_position_last_frame = position
	
func play_animation(dir):
	if state == "idle":
		$AnimatedSprite2D.play("idle")
		
	if state == "moving":
		if dir == 2: #east
			print('right')
			$AnimatedSprite2D.play("right")
		if dir == 0: #west
			print('left')
			$AnimatedSprite2D.play("left")
		if dir == 1: #north
			$AnimatedSprite2D.play("idle")
		if dir == 3: #south
			$AnimatedSprite2D.play("idle")

			
			
################### 
# OLD PROMT STUFF #
###################

func init_prompt() -> void:
	prompt_text = PromptList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))

func set_difficulty(difficulty: int):
	handle_difficulty_increased(difficulty)

func handle_difficulty_increased(new_difficulty: int):
	var new_speed = speed + (0.125 * new_difficulty)
	speed = clamp(new_speed, speed, 3)


func get_prompt() -> String:
	return prompt_text


func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""

	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()

	prompt.parse_bbcode(set_center_tags(blue_text + green_text + red_text))


func set_center_tags(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"


func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"


func get_bbcode_end_color_tag() -> String:
	return "[/color]"
