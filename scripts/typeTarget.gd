extends Node

@export var blue = Color("#4682b4")
@export var green = Color("#639765")
@export var red = Color("#a65455")

@export var speed = 0.5


@onready var prompt_label = $RichTextLabel
@onready var prompt_text = prompt_label.text
@onready var prompt_unchanged = prompt_label.text


func _ready() -> void:
	init_prompt()


func init_prompt() -> void:
	prompt_unchanged = PromptList.get_prompt()
	prompt_label.parse_bbcode(prompt_unchanged)


func get_prompt() -> String:
	return prompt_unchanged.to_upper()


func set_next_character(next_character_index: int):
	var fuel = 1000
	var speed = 0
	
	var blue_text = get_bbcode_color_tag(blue) + prompt_unchanged.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_unchanged.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""

	if next_character_index != prompt_unchanged.length():
		red_text = get_bbcode_color_tag(red) + prompt_unchanged.substr(next_character_index + 1, prompt_unchanged.length() - next_character_index + 1) + get_bbcode_end_color_tag()

	prompt_label.parse_bbcode(blue_text + green_text + red_text)



func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"


func get_bbcode_end_color_tag() -> String:
	return "[/color]"
